<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>编辑选课</title>
    <base href="${pageContext.request.contextPath}/">
    <link rel="stylesheet" href="css/pintuer.css">
    <link rel="stylesheet" href="css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="js/jquery.js"></script>
    <script src="js/pintuer.js"></script>
    <style>
        .panel {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.1);
            margin: 20px;
            overflow: hidden;
        }

        .panel-head {
            background: linear-gradient(120deg, #2c3e50, #3498db);
            color: white;
            padding: 15px 20px;
            border-radius: 8px 8px 0 0;
        }

        .panel-head strong {
            font-size: 18px;
        }

        .panel-body {
            padding: 30px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            transition: all 0.3s;
        }

        .form-control:focus {
            border-color: #3498db;
            box-shadow: 0 0 5px rgba(52,152,219,0.3);
        }

        .btn {
            padding: 10px 25px;
            font-size: 15px;
            border-radius: 4px;
            transition: all 0.3s;
            cursor: pointer;
            margin-right: 10px;
        }

        .btn-primary {
            background: #3498db;
            color: white;
            border: none;
        }

        .btn-default {
            background: #f1f2f6;
            color: #333;
            border: 1px solid #ddd;
        }

        .btn-primary:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }

        .btn-default:hover {
            background: #e9ebef;
            transform: translateY(-2px);
        }
    </style>

    <script>
        $(function () {
            // 获取URL参数
            var scid = getUrlParam('scid');
            if (!scid) {
                alert('参数错误');
                location.href = 'listStudentCourse.jsp';
                return;
            }
            
            // 设置SCID值
            $('#scid').val(scid);
            
            // 直接获取选课详情
            $.ajax({
                url: 'StudentCourseServlet',
                method: 'GET',
                data: {
                    methodName: 'getStudentCourseJson',
                    scid: scid
                },
                dataType: 'text',  // 使用text而不是json，手动解析
                success: function(data) {
                    console.log("选课详情数据：", data);
                    
                    try {
                        // 确保数据是字符串
                        if (typeof data !== 'string') {
                            data = JSON.stringify(data);
                        }
                        
                        var currentCourse = JSON.parse(data);
                        console.log("解析后的选课详情：", currentCourse);
                        
                        // 显示选课时间
                        if (currentCourse.selectTime) {
                            $('#selectTime').val(currentCourse.selectTime);
                        }
                        
                        // 加载学生列表和课程列表
                        loadStudentList(currentCourse.student.sid);
                        loadCourseList(currentCourse.course.cid);
                        
                    } catch (e) {
                        console.error("解析选课详情失败:", e, data);
                        // 尝试加载未选中的列表
                        loadStudentList(0);
                        loadCourseList(0);
                    }
                },
                error: function(xhr, status, error) {
                    console.error("获取选课详情失败:", error);
                    // 失败时仍然加载列表
                    loadStudentList(0);
                    loadCourseList(0);
                }
            });

            // 提交表单
            $('#submitBtn').click(function () {
                var sid = $('#studentId').val();
                var cid = $('#courseId').val();
                var scid = $('#scid').val();

                if (!sid || !cid) {
                    alert('请填写完整信息');
                    return;
                }

                $.post('StudentCourseServlet', {
                    methodName: 'updateStudentCourse',
                    scid: scid,
                    sid: sid,
                    cid: cid
                }, function (data) {
                    if (data == '1') {
                        alert('修改成功');
                        location.href = 'listStudentCourse.jsp';
                    } else {
                        alert('修改失败');
                    }
                });
            });

            // 取消按钮
            $('#cancelBtn').click(function () {
                location.href = 'listStudentCourse.jsp';
            });
        });

        // 获取URL参数的工具函数
        function getUrlParam(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
            var r = window.location.search.substr(1).match(reg);
            if (r != null) return decodeURIComponent(r[2]);
            return null;
        }

        // 加载学生列表
        function loadStudentList(selectedSid) {
            $.ajax({
                url: 'StudentServlet',
                method: 'GET',
                data: { methodName: 'getAllStudents' },
                dataType: 'text',
                success: function (data) {
                    console.log("学生数据：", data);
                    console.log("学生数据类型：", typeof data);
                    
                    try {
                        // 确保数据是字符串
                        if (typeof data !== 'string') {
                            data = JSON.stringify(data);
                        }
                        
                        var students = JSON.parse(data);
                        var studentSelect = $('#studentId');
                        
                        studentSelect.empty().append('<option value="">--请选择学生--</option>');
                        for (var i = 0; i < students.length; i++) {
                            var selected = (students[i].sid == selectedSid) ? 'selected' : '';
                            studentSelect.append('<option value="' + students[i].sid + '" ' + selected + '>' + students[i].sname + '</option>');
                        }
                    } catch (e) {
                        console.error("解析学生数据失败:", e, data);
                        alert("加载学生数据失败");
                    }
                },
                error: function(xhr, status, error) {
                    console.error("加载学生列表请求失败:", error);
                    alert("无法加载学生列表");
                }
            });
        }

        // 加载课程列表
        function loadCourseList(selectedCid) {
            $.ajax({
                url: 'CourseServlet',
                method: 'GET',
                data: { methodName: 'getAllCourses' },
                dataType: 'text',
                success: function (data) {
                    console.log("课程数据：", data);
                    console.log("课程数据类型：", typeof data);
                    
                    try {
                        // 确保数据是字符串
                        if (typeof data !== 'string') {
                            data = JSON.stringify(data);
                        }
                        
                        var courses = JSON.parse(data);
                        var courseSelect = $('#courseId');
                        
                        courseSelect.empty().append('<option value="">--请选择课程--</option>');
                        for (var i = 0; i < courses.length; i++) {
                            var selected = (courses[i].cid == selectedCid) ? 'selected' : '';
                            courseSelect.append('<option value="' + courses[i].cid + '" ' + selected + '>' + courses[i].cname + '</option>');
                        }
                    } catch (e) {
                        console.error("解析课程数据失败:", e, data);
                        alert("加载课程数据失败");
                    }
                },
                error: function(xhr, status, error) {
                    console.error("加载课程列表请求失败:", error);
                    alert("无法加载课程列表");
                }
            });
        }
    </script>
</head>
<body>
<div class="panel">
    <div class="panel-head">
        <strong><i class="fas fa-edit"></i> 编辑选课</strong>
    </div>
    <div class="panel-body">
        <form id="editForm" method="post">
            <input type="hidden" id="scid" value="${studentCourse.scid}">

            <div class="form-group">
                <label class="form-label">学生</label>
                <select class="form-control" id="studentId" name="studentId">
                    <option value="">--请选择学生--</option>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">课程</label>
                <select class="form-control" id="courseId" name="courseId">
                    <option value="">--请选择课程--</option>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">选课时间</label>
                <input type="text" class="form-control" id="selectTime" disabled>
                <small class="text-muted">选课时间不可修改</small>
            </div>

            <div class="form-group" style="margin-top: 30px; text-align: center;">
                <button type="button" class="btn btn-primary" id="submitBtn">
                    <i class="fas fa-save"></i> 保存修改
                </button>
                <button type="button" class="btn btn-default" id="cancelBtn">
                    <i class="fas fa-times"></i> 取消
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
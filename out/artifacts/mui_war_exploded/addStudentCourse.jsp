<%--
  Created by IntelliJ IDEA.
  User: 支全亮
  Date: 2025/3/13
  Time: 0:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>学生选课</title>
    <base href="${pageContext.request.contextPath}/">
    <link rel="stylesheet" href="css/pintuer.css">
    <link rel="stylesheet" href="css/admin.css">
    <script src="js/jquery.js"></script>
    <script src="js/pintuer.js"></script>

    <script>
        $(function () {
            console.log("加载选课页面...");
            
            // 加载学生列表
            $.ajax({
                url: 'StudentServlet',
                method: 'GET',
                data: { methodName: 'getAllStudents' },
                dataType: 'text',
                success: function (data) {
                    console.log("学生数据：", data);
                    console.log("数据类型：", typeof data);
                    
                    try {
                        // 确保数据是字符串
                        if (typeof data !== 'string') {
                            data = JSON.stringify(data);
                        }
                        
                        var students = JSON.parse(data);
                        var studentSelect = $('#studentId');
                        studentSelect.empty().append('<option value="">--请选择学生--</option>');
                        for (var i = 0; i < students.length; i++) {
                            studentSelect.append('<option value="' + students[i].sid + '">' + students[i].sname + '</option>');
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

            // 加载课程列表
            $.ajax({
                url: 'CourseServlet',
                method: 'GET',
                data: { methodName: 'getAllCourses' },
                dataType: 'text',
                success: function (data) {
                    console.log("课程数据：", data);
                    console.log("数据类型：", typeof data);
                    
                    try {
                        // 确保数据是字符串
                        if (typeof data !== 'string') {
                            data = JSON.stringify(data);
                        }
                        
                        var courses = JSON.parse(data);
                        var courseSelect = $('#courseId');
                        courseSelect.empty().append('<option value="">--请选择课程--</option>');
                        for (var i = 0; i < courses.length; i++) {
                            courseSelect.append('<option value="' + courses[i].cid + '">' + courses[i].cname + '</option>');
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

            $('#submitBtn').click(function () {
                var sid = $('#studentId').val();
                var cid = $('#courseId').val();

                if (!sid || !cid) {
                    alert('请填写完整信息');
                    return;
                }

                $.post('StudentCourseServlet', {
                    methodName: 'addStudentCourse',
                    sid: sid,
                    cid: cid
                }, function (data) {
                    if (data == '1') {
                        alert('选课成功');
                        location.href = 'listStudentCourse.jsp';
                    } else {
                        alert('选课失败');
                    }
                });
            });
        });
    </script>
</head>
<body>
<div class="panel admin-panel">
    <div class="panel-head"><strong><span class="icon-pencil-square-o"></span>学生选课</strong></div>
    <div class="body-content">
        <form method="post" class="form-x" action="">
            <div class="form-group">
                <div class="label">
                    <label>学生：</label>
                </div>
                <div class="field">
                    <select class="input" name="studentId" id="studentId" style="width:30%">
                        <option value="">--请选择学生--</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label>课程：</label>
                </div>
                <div class="field">
                    <select class="input" name="courseId" id="courseId" style="width:30%">
                        <option value="">--请选择课程--</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label></label>
                </div>
                <div class="field">
                    <button class="button bg-main icon-check-square-o" id="submitBtn" type="button"> 提交</button>
                </div>
            </div>
        </form>
    </div>
</div>
</body>
</html>

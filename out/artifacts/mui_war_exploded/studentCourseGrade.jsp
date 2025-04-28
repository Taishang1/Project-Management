<%--
  Created by IntelliJ IDEA.
  User: 支全亮
  Date: 2025/3/13
  Time: 0:15
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
    <title>学生选课成绩</title>
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
        
        .table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-bottom: 0;
        }
        
        .table th {
            background: #f4f6f9;
            color: #2c3e50;
            font-weight: 600;
            padding: 15px;
            text-align: left;
            border-bottom: 2px solid #e9ecef;
        }
        
        .table td {
            padding: 15px;
            border-bottom: 1px solid #eee;
            vertical-align: middle;
        }
        
        .table tr:hover td {
            background: #f8f9fa;
        }
        
        .btn-view {
            padding: 6px 12px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            text-decoration: none;
        }
        
        .btn-view:hover {
            background: #2980b9;
            transform: translateY(-2px);
            color: white;
        }
        
        .empty-message {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
            font-size: 16px;
        }
        
        .loading {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: rgba(0,0,0,0.7);
            color: white;
            padding: 20px 40px;
            border-radius: 8px;
            display: none;
            z-index: 1000;
        }
        
        .debug-info {
            font-size: 12px;
            color: #999;
            margin-top: 10px;
            font-style: italic;
            padding: 10px;
            border-top: 1px solid #eee;
        }
    </style>

    <script>
        $(function () {
            var sid = '<%= request.getParameter("sid") %>';
            console.log("加载学生ID:", sid);
            
            if (sid) {
                // 添加加载动画
                $(document).ajaxStart(function() {
                    $('.loading').show();
                }).ajaxStop(function() {
                    $('.loading').hide();
                });
                
                loadStudentCourses(sid);
            } else {
                alert('未提供学生ID');
                location.href = 'listStudent.jsp';
            }
        });

        function loadStudentCourses(sid) {
            $.ajax({
                url: 'StudentCourseServlet',
                data: { methodName: 'getStudentCourses', sid: sid },
                method: 'GET',
                dataType: 'text',
                success: function(data) {
                    console.log("接收到的原始数据:", data);
                    console.log("数据类型:", typeof data);
                    console.log("数据长度:", data ? data.length : 0);
                    
                    if (!data || data.trim() === '') {
                        console.log("服务器返回空数据");
                        displayEmptyMessage();
                        return;
                    }
                    
                    try {
                        // 尝试解析数据
                        var studentCourses;
                        if (typeof data === 'string') {
                            if (data.trim() === '[]') {
                                console.log("服务器返回空数组");
                                displayEmptyMessage();
                                return;
                            }
                            
                            studentCourses = JSON.parse(data);
                            console.log("解析后的数据:", studentCourses);
                        } else {
                            studentCourses = data;
                        }
                        
                        displayStudentCourses(studentCourses);
                    } catch (e) {
                        console.error("解析数据失败:", e);
                        $('#debug-info').html('解析数据失败: ' + e.message + '<br>原始数据: ' + data);
                        displayEmptyMessage("数据解析失败，请联系管理员");
                    }
                },
                error: function(xhr, status, error) {
                    console.error("请求失败:", error);
                    console.error("状态:", status);
                    console.error("响应文本:", xhr.responseText);
                    $('#debug-info').html('请求失败: ' + error);
                    displayEmptyMessage("加载数据失败: " + error);
                }
            });
        }

        function displayStudentCourses(studentCourses) {
            var tbody = $('#studentCourseList tbody');
            tbody.empty();
            
            if (!studentCourses || studentCourses.length === 0) {
                displayEmptyMessage();
                return;
            }
            
            for (var i = 0; i < studentCourses.length; i++) {
                var sc = studentCourses[i];
                console.log("处理记录:", sc);
                
                // 安全地获取属性
                var studentId = getNestedProperty(sc, 'student.sid') || getNestedProperty(sc, 'sid');
                var studentName = getNestedProperty(sc, 'student.sname') || getNestedProperty(sc, 'sname') || '未知学生';
                var courseId = getNestedProperty(sc, 'course.cid') || getNestedProperty(sc, 'cid');
                var courseName = getNestedProperty(sc, 'course.cname') || getNestedProperty(sc, 'cname') || '未知课程';
                var selectTime = sc.selectTime || '';
                
                tbody.append(
                    '<tr>' +
                    '<td>' + studentId + ' - ' + studentName + '</td>' +
                    '<td>' + courseId + ' - ' + courseName + '</td>' +
                    '<td>' + selectTime + '</td>' +
                    '<td>' +
                    '<a href="javascript:void(0)" class="btn-view" onclick="viewGrade(' + studentId + ', ' + courseId + ')">' +
                    '<i class="fas fa-eye"></i> 查看成绩</a>' +
                    '</td>' +
                    '</tr>'
                );
            }
        }
        
        // 安全地获取嵌套属性
        function getNestedProperty(obj, path) {
            if (!obj) return null;
            
            const properties = path.split('.');
            let value = obj;
            
            for (let prop of properties) {
                // 检查是否存在获取器方法
                const getterMethod = 'get' + prop.charAt(0).toUpperCase() + prop.slice(1);
                
                if (typeof value[getterMethod] === 'function') {
                    value = value[getterMethod]();
                } else if (value[prop] !== undefined) {
                    value = value[prop];
                } else {
                    return null;
                }
            }
            
            return value;
        }
        
        function displayEmptyMessage(message) {
            var tbody = $('#studentCourseList tbody');
            tbody.empty();
            tbody.append('<tr><td colspan="4" class="empty-message">' + 
                (message || '该学生没有选课记录') + '</td></tr>');
        }

        function viewGrade(sid, cid) {
            location.href = 'studentCourseGradeDetail.jsp?sid=' + sid + '&cid=' + cid;
        }
    </script>
</head>
<body>
<div class="panel">
    <div class="panel-head">
        <strong><i class="fas fa-graduation-cap"></i> 学生选课成绩</strong>
    </div>
    <table class="table table-hover text-center" id="studentCourseList">
        <thead>
        <tr>
            <th width="30%">学生信息</th>
            <th width="30%">课程信息</th>
            <th width="20%">选课时间</th>
            <th width="20%">操作</th>
        </tr>
        </thead>
        <tbody>
            <tr>
                <td colspan="4" class="text-center">加载中...</td>
            </tr>
        </tbody>
    </table>
    <div id="debug-info" class="debug-info"></div>
</div>

<div class="loading">
    <i class="fas fa-spinner fa-spin"></i> 加载中...
</div>
</body>
</html>

<%--
  Created by IntelliJ IDEA.
  User: 支全亮
  Date: 2025/3/13
  Time: 0:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bkty.entity.Course" %>
<%@ page import="com.bkty.service.CourseService" %>
<%@ page import="com.bkty.service.impl.CourseServiceImpl" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>编辑课程</title>
    <base href="${pageContext.request.contextPath}/">
    <link rel="stylesheet" href="css/pintuer.css">
    <link rel="stylesheet" href="css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="js/jquery.js"></script>
    <script src="js/pintuer.js"></script>

    <style>
    .admin-panel {
        background: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 12px rgba(0,0,0,0.1);
        margin: 20px;
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
    
    .body-content {
        padding: 30px;
    }
    
    .form-group {
        margin-bottom: 25px;
    }
    
    .label {
        font-size: 15px;
        color: #333;
        margin-bottom: 8px;
    }
    
    .input {
        border: 1px solid #ddd;
        border-radius: 4px;
        padding: 8px 12px;
        transition: all 0.3s;
    }
    
    .input:focus {
        border-color: #3498db;
        box-shadow: 0 0 5px rgba(52,152,219,0.3);
    }
    
    textarea.input {
        resize: vertical;
        min-height: 120px;
    }
    
    .button {
        padding: 10px 25px;
        font-size: 15px;
        border-radius: 4px;
        transition: all 0.3s;
    }
    
    .bg-main {
        background: #3498db;
        color: white;
        border: none;
    }
    
    .bg-main:hover {
        background: #2980b9;
        transform: translateY(-2px);
    }
    
    .tips {
        color: #666;
        font-size: 13px;
        margin-top: 5px;
    }
    </style>

    <script>
        $(function () {
            var cid = '<%= request.getParameter("cid") %>';
            if (cid && cid != 'null') {
                $.get('CourseServlet', { methodName: 'getCourseById', cid: cid }, function (data) {
                    var course = JSON.parse(data);
                    $('#cname').val(course.cname);
                    $('#description').val(course.description);
                });
            }

            $('#submitBtn').click(function () {
                var cid = '<%= request.getParameter("cid") %>';
                var cname = $('#cname').val();
                var description = $('#description').val();

                if (!cname) {
                    alert('请输入课程名称');
                    return;
                }

                $.post('CourseServlet', {
                    methodName: 'updateCourse',
                    cid: cid,
                    cname: cname,
                    description: description
                }, function (data) {
                    if (data == '1') {
                        alert('更新成功');
                        location.href = 'listCourse.jsp';
                    } else {
                        alert('更新失败');
                    }
                });
            });
        });
    </script>
</head>
<body>
<div class="panel admin-panel">
    <div class="panel-head">
        <strong><i class="fas fa-edit"></i> 编辑课程</strong>
    </div>
    <div class="body-content">
        <form method="post" class="form-x" action="">
            <div class="form-group">
                <div class="label">
                    <label><i class="fas fa-book"></i> 课程名称</label>
                </div>
                <div class="field">
                    <input type="text" class="input" name="cname" id="cname" value="" style="width:100%"/>
                    <div class="tips"></div>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label><i class="fas fa-info-circle"></i> 课程描述</label>
                </div>
                <div class="field">
                    <textarea class="input" name="description" id="description" style="width:100%"
                        placeholder="请输入课程描述..."></textarea>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label></label>
                </div>
                <div class="field">
                    <button class="button bg-main" id="submitBtn" type="button">
                        <i class="fas fa-save"></i> 保存修改
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>
</body>
</html>

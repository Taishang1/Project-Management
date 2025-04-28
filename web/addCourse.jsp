<%--
  Created by IntelliJ IDEA.
  User: 支全亮
  Date: 2025/3/13
  Time: 0:13
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
    <title>添加课程</title>
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
            display: flex;
            justify-content: space-between;
            align-items: center;
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
            width: 100%;
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
            margin-right: 10px;
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
        
        .bg-back {
            background: #95a5a6;
            color: white;
            border: none;
        }
        
        .bg-back:hover {
            background: #7f8c8d;
            transform: translateY(-2px);
        }
        
        .button i {
            margin-right: 5px;
        }
        
        .tips {
            color: #666;
            font-size: 13px;
            margin-top: 5px;
        }
    </style>

    <script>
        $(function () {
            $('#submitBtn').click(function () {
                var cname = $('#cname').val();
                var description = $('#description').val();

                if (!cname) {
                    alert('请输入课程名称');
                    return;
                }

                $.post('CourseServlet', {
                    methodName: 'addCourse',
                    cname: cname,
                    description: description
                }, function (data) {
                    if (data == '1') {
                        if(confirm('添加成功！是否返回课程列表？')) {
                            location.href = 'listCourse.jsp';
                        }
                    } else {
                        alert('添加失败');
                    }
                });
            });
        });
    </script>
</head>
<body>
<div class="panel">
    <div class="panel-head">
        <strong><i class="fas fa-plus-circle"></i> 添加课程</strong>
        <button class="button bg-back" onclick="location.href='listCourse.jsp'">
            <i class="fas fa-arrow-left"></i> 返回列表
        </button>
    </div>
    <div class="body-content">
        <form method="post" class="form-x" action="">
            <div class="form-group">
                <div class="label">
                    <label><i class="fas fa-book"></i> 课程名称：</label>
                </div>
                <div class="field">
                    <input type="text" class="input" name="cname" id="cname" placeholder="请输入课程名称"/>
                    <div class="tips">请输入课程的完整名称</div>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label><i class="fas fa-info-circle"></i> 课程描述：</label>
                </div>
                <div class="field">
                    <textarea class="input" name="description" id="description" 
                              placeholder="请输入课程描述..."></textarea>
                    <div class="tips">详细描述课程的主要内容、目标等信息</div>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label></label>
                </div>
                <div class="field">
                    <button class="button bg-main" id="submitBtn" type="button">
                        <i class="fas fa-save"></i> 保存课程
                    </button>
                    <button class="button bg-back" type="button" onclick="location.href='listCourse.jsp'">
                        <i class="fas fa-times"></i> 取消
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>
</body>
</html>
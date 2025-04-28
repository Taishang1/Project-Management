<%--
  Created by IntelliJ IDEA.
  User: 支全亮
  Date: 2025/3/12
  Time: 23:52
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
    <title>添加通知公告</title>
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
            padding: 20px;
            border-radius: 8px 8px 0 0;
        }
        
        .panel-head strong {
            font-size: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .form-container {
            padding: 30px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            display: block;
            color: #2c3e50;
            font-weight: 500;
            margin-bottom: 8px;
        }
        
        .form-input {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .form-input:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 2px rgba(52,152,219,0.2);
            outline: none;
        }
        
        textarea.form-input {
            min-height: 150px;
            resize: vertical;
        }
        
        .btn-container {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 30px;
        }
        
        .btn {
            padding: 10px 25px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
            border: none;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-primary {
            background: #3498db;
            color: white;
        }
        
        .btn-primary:hover {
            background: #2980b9;
        }
        
        .btn-default {
            background: #95a5a6;
            color: white;
        }
        
        .btn-default:hover {
            background: #7f8c8d;
        }
        
        .error-message {
            color: #e74c3c;
            font-size: 13px;
            margin-top: 5px;
            display: none;
        }
    </style>

    <script>
        $(function() {
            $('#announcementForm').submit(function(e) {
                e.preventDefault();
                
                // 表单验证
                var title = $('#title').val().trim();
                var content = $('#content').val().trim();
                
                $('.error-message').hide();
                
                if (!title) {
                    $('#titleError').show();
                    return;
                }
                
                if (!content) {
                    $('#contentError').show();
                    return;
                }
                
                // 获取当前时间
                var now = new Date();
                
                var formData = {
                    method: 'addAnnouncement',
                    title: title,
                    content: content,
                    publishDate: now.toISOString(),
                    publisher: '${sessionScope.username}'
                };
                
                $.ajax({
                    url: 'AnnouncementServlet',
                    method: 'POST',
                    data: formData,
                    success: function(response) {
                        if (response == '1') {
                            alert('添加成功');
                            location.href = 'listAnnouncement.jsp';
                        } else {
                            alert('添加失败，请稍后重试');
                        }
                    },
                    error: function() {
                        alert('添加失败，请稍后重试');
                    }
                });
            });
            
            // 返回按钮事件
            $('#backBtn').click(function() {
                history.back();
            });
        });
    </script>
</head>
<body>
    <div class="panel">
        <div class="panel-head">
            <strong>
                <i class="fas fa-bullhorn"></i>
                添加通知公告
            </strong>
        </div>
        
        <div class="form-container">
            <form id="announcementForm" method="post">
                <div class="form-group">
                    <label class="form-label" for="title">
                        <i class="fas fa-heading"></i> 
                        公告标题
                    </label>
                    <input type="text" id="title" name="title" class="form-input" 
                           placeholder="请输入公告标题">
                    <div id="titleError" class="error-message">
                        请输入公告标题
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label" for="content">
                        <i class="fas fa-file-alt"></i> 
                        公告内容
                    </label>
                    <textarea id="content" name="content" class="form-input" 
                              placeholder="请输入公告内容"></textarea>
                    <div id="contentError" class="error-message">
                        请输入公告内容
                    </div>
                </div>
                
                <div class="btn-container">
                    <button type="button" class="btn btn-default" id="backBtn">
                        <i class="fas fa-arrow-left"></i>
                        返回
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i>
                        保存
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>

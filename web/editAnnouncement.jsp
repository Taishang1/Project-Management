<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>编辑公告</title>
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
            padding: 20px;
        }
        
        .panel-head {
            background: linear-gradient(120deg, #2c3e50, #3498db);
            color: white;
            padding: 15px 20px;
            border-radius: 8px 8px 0 0;
            margin: -20px -20px 20px -20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .label {
            display: block;
            margin-bottom: 8px;
            color: #2c3e50;
            font-weight: 500;
        }
        
        .field input[type="text"],
        .field textarea {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            transition: all 0.3s;
            resize: vertical;
        }
        
        .field textarea {
            min-height: 150px;
        }
        
        .field input[type="text"]:focus,
        .field textarea:focus {
            border-color: #3498db;
            box-shadow: 0 0 5px rgba(52,152,219,0.3);
        }
        
        .btn {
            padding: 8px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
            border: none;
            margin-right: 10px;
        }
        
        .btn-primary {
            background: #3498db;
            color: white;
        }
        
        .btn-primary:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }
        
        .btn-default {
            background: #95a5a6;
            color: white;
        }
        
        .btn-default:hover {
            background: #7f8c8d;
            transform: translateY(-2px);
        }
        
        .button-group {
            margin-top: 30px;
            display: flex;
            justify-content: flex-start;
            align-items: center;
        }
    </style>

    <script>
        $(function () {
            var anid = '<%= request.getParameter("anid") %>';
            if (anid && anid != 'null') {
                $.ajax({
                    url: 'AnnouncementServlet',
                    method: 'GET',
                    data: { method: 'getAnnouncementById', anid: anid },
                    dataType: 'json',
                    success: function (data) {
                        console.log("接收到的公告数据:", data);
                        if (typeof data === 'string') {
                            try {
                                data = JSON.parse(data);
                            } catch (e) {
                                console.error("解析JSON失败:", e);
                            }
                        }
                        $('#title').val(data.title);
                        $('#content').val(data.content);
                        $('#publisher').val(data.publisher);
                    },
                    error: function(xhr, status, error) {
                        console.error("请求失败:", error);
                        alert("获取公告数据失败，请刷新页面重试");
                    }
                });
            }

            // 提交表單
            $('#submitBtn').click(function () {
                var title = $('#title').val();
                var content = $('#content').val();
                var publisher = $('#publisher').val();

                if (!title || !content || !publisher) {
                    alert('請填寫完整信息');
                    return;
                }

                $.ajax({
                    url: 'AnnouncementServlet',
                    method: 'POST',
                    data: {
                        method: 'updateAnnouncement',
                        anid: anid,
                        title: title,
                        content: content,
                        publisher: publisher
                    },
                    success: function (data) {
                        if (data == '1') {
                            alert('更新成功');
                            location.href = 'listAnnouncement.jsp';
                        } else {
                            alert('更新失敗');
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("提交失败:", error);
                        alert("更新公告失败，请重试");
                    }
                });
            });

            // 返回按鈕
            $('#backBtn').click(function() {
                location.href = 'listAnnouncement.jsp';
            });
        });
    </script>
</head>
<body>
<div class="panel">
    <div class="panel-head">
        <strong><i class="fas fa-edit"></i> 编辑公告</strong>
    </div>
    <div class="body-content">
        <form method="post" class="form-x" action="">
            <div class="form-group">
                <div class="label">
                    <label>标题：</label>
                </div>
                <div class="field">
                    <input type="text" name="title" id="title" placeholder="请输入公告标题"/>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label>內容：</label>
                </div>
                <div class="field">
                    <textarea name="content" id="content" placeholder="请輸入公告內容"></textarea>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label>发布人</label>
                </div>
                <div class="field">
                    <input type="text" name="publisher" id="publisher" placeholder="请输入发布人"/>
                </div>
            </div>
            <div class="button-group">
                <button class="btn btn-primary" id="submitBtn" type="button">
                    <i class="fas fa-save"></i> 保存
                </button>
                <button class="btn btn-default" id="backBtn" type="button">
                    <i class="fas fa-arrow-left"></i> 返回
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
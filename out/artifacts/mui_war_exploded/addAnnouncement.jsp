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
    <script src="js/jquery.js"></script>
    <script src="js/pintuer.js"></script>

    <script>
        $(function () {
            // 提交表单
            $('#submitBtn').click(function () {
                var title = $('#title').val();
                var content = $('#content').val();
                var publisher = $('#publisher').val();

                if (!title || !content || !publisher) {
                    alert('请填写完整信息');
                    return;
                }

                $.post('AnnouncementServlet', {
                    methodName: 'addAnnouncement',
                    title: title,
                    content: content,
                    publisher: publisher
                }, function (data) {
                    if (data == '1') {
                        alert('添加成功');
                        location.href = 'listAnnouncement.jsp';
                    } else {
                        alert('添加失败');
                    }
                });
            });
        });
    </script>
</head>
<body>
<div class="panel admin-panel">
    <div class="panel-head"><strong><span class="icon-pencil-square-o"></span>添加通知公告</strong></div>
    <div class="body-content">
        <form method="post" class="form-x" action="">
            <div class="form-group">
                <div class="label">
                    <label>标题：</label>
                </div>
                <div class="field">
                    <input type="text" class="input" name="title" id="title" value="" style="width:70%"/>
                    <div class="tips"></div>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label>内容：</label>
                </div>
                <div class="field">
                    <textarea class="input" name="content" id="content" style="height:120px; width:70%"></textarea>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label>发布人：</label>
                </div>
                <div class="field">
                    <input type="text" class="input" name="publisher" id="publisher" value="" style="width:30%"/>
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
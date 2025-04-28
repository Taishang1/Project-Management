<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>修改班级信息</title>
    <base href="${pageContext.request.contextPath}/">
    <link rel="stylesheet" href="css/pintuer.css">
    <link rel="stylesheet" href="css/admin.css">
    <script src="js/jquery.js"></script>
    <script src="js/pintuer.js"></script>
    <style>
        .form-x .form-group .label {
            width: 120px;
        }
        .form-x .form-group .field {
            margin-left: 120px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .card {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin: 20px;
            padding: 20px;
        }
        .card-header {
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
            margin-bottom: 20px;
            font-size: 18px;
            font-weight: bold;
            color: #333;
        }
        .button {
            padding: 8px 20px;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .button-primary {
            background: #2196F3;
            color: white;
            border: none;
        }
        .button-primary:hover {
            background: #1976D2;
        }
        .button-back {
            background: #f5f5f5;
            color: #333;
            border: 1px solid #ddd;
            margin-right: 10px;
        }
        .button-back:hover {
            background: #e0e0e0;
        }
        .form-control {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            transition: border-color 0.3s;
        }
        .form-control:focus {
            border-color: #2196F3;
            outline: none;
        }
    </style>
</head>
<body>
<div class="card">
    <div class="card-header">
        <i class="icon-edit"></i> 修改班级信息
    </div>
    <form method="post" class="form-x" id="updateForm">
        <input type="hidden" id="cid" name="cid" value="${param.cid}">
        
        <div class="form-group">
            <div class="label">
                <label>班级名称：</label>
            </div>
            <div class="field">
                <input type="text" class="form-control" id="cname" name="cname" required />
            </div>
        </div>
        
        <div class="form-group">
            <div class="label">
                <label>班主任：</label>
            </div>
            <div class="field">
                <input type="text" class="form-control" id="cteacher" name="cteacher" required />
            </div>
        </div>
        
        <div class="form-group">
            <div class="label">
                <label>备注：</label>
            </div>
            <div class="field">
                <textarea class="form-control" id="remark" name="remark" rows="3"></textarea>
            </div>
        </div>
        
        <div class="form-group">
            <div class="label">
                <label></label>
            </div>
            <div class="field">
                <button class="button button-back" type="button" onclick="history.back()">返回</button>
                <button class="button button-primary" type="submit">提交</button>
            </div>
        </div>
    </form>
</div>

<script>
$(function() {
    // 页面加载时获取班级信息
    var cid = $('#cid').val();
    console.log("当前班级ID:", cid);
    
    $.ajax({
        url: 'ClazzServlet',
        type: 'POST',
        data: {
            methodName: 'getClazzById',
            cid: cid
        },
        dataType: 'json',
        contentType: 'application/x-www-form-urlencoded;charset=UTF-8',
        success: function(data) {
            try {
                console.log("接收到的数据:", data);
                var clazz = (typeof data === 'string') ? JSON.parse(data) : data;
                console.log("解析后的班级数据:", clazz);
                if (!clazz) {
                    throw new Error("班级数据为空");
                }
                $('#cname').val(clazz.cname);
                $('#cteacher').val(clazz.cteacher);
                $('#remark').val(clazz.remark || '');
                console.log("数据填充完成");
            } catch(e) {
                console.error('解析班级数据失败:', e);
                console.error('原始数据:', data);
                alert('获取班级信息失败');
            }
        },
        error: function(xhr, status, error) {
            console.error("AJAX请求失败:", status, error);
            console.error("错误详情:", xhr.responseText);
            console.error("状态码:", xhr.status);
            console.error("状态文本:", xhr.statusText);
            alert('获取班级信息失败');
        }
    });

    // 表单提交
    $('#updateForm').submit(function(e) {
        e.preventDefault();
        
        $.ajax({
            url: 'ClazzServlet',
            type: 'POST',
            data: {
                methodName: 'updateClazz',
                cid: $('#cid').val(),
                cname: $('#cname').val(),
                cteacher: $('#cteacher').val(),
                remark: $('#remark').val()
            },
            success: function(data) {
                if (data === 'true') {
                    alert('修改成功！');
                    location.href = 'listClazz.jsp';
                } else {
                    alert('修改失败！');
                }
            },
            error: function() {
                alert('修改失败！');
            }
        });
    });
});
</script>
</body>
</html>
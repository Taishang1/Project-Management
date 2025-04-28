<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>添加班级</title>
    <base href="${pageContext.request.contextPath}/">
    <link rel="stylesheet" href="css/pintuer.css">
    <link rel="stylesheet" href="css/admin.css">
    <link rel="stylesheet" href="css/style.css">
    <script src="js/jquery.js"></script>
    <script src="js/pintuer.js"></script>
</head>
<body>
<div class="card">
    <div class="card-header">
        <i class="fas fa-users"></i> 添加班级
    </div>
    <div class="card-body">
        <form method="post" class="form-x" action="">
            <div class="form-group">
                <div class="label">
                    <label>班级名称：</label>
                </div>
                <div class="field">
                    <input type="text" class="input" name="cname" id="cname" placeholder="请输入班级名称" />
                </div>
            </div>

            <div class="form-group">
                <div class="label">
                    <label>班主任：</label>
                </div>
                <div class="field">
                    <input type="text" class="input" name="cteacher" id="cteacher" placeholder="请输入班主任姓名" />
                </div>
            </div>

            <div class="form-group">
                <div class="label">
                    <label>备注：</label>
                </div>
                <div class="field">
                    <textarea class="input" name="remark" id="remark" rows="3" placeholder="请输入备注信息"></textarea>
                </div>
            </div>

            <div class="form-button">
                <button class="button bg-main" type="button" onclick="saveClazz()">
                    <i class="fas fa-save"></i> 保存
                </button>
                <button class="button bg-default" type="button" onclick="history.back()">
                    <i class="fas fa-arrow-left"></i> 返回
                </button>
            </div>
        </form>
    </div>
</div>

<script>
function saveClazz() {
    var formData = {
        methodName: 'addClazz',
        cname: $('#cname').val().trim(),
        cteacher: $('#cteacher').val().trim(),
        remark: $('#remark').val().trim()
    };

    // 表单验证
    if(!formData.cname) {
        alert('请输入班级名称');
        return;
    }
    if(!formData.cteacher) {
        alert('请输入班主任姓名');
        return;
    }

    $.ajax({
        url: 'ClazzServlet',
        type: 'POST',
        data: formData,
        success: function(response) {
            if(response == '1') {
                alert('添加成功！');
                // 清空表单
                $('#cname').val('');
                $('#cteacher').val('');
                $('#remark').val('');
            } else {
                alert('添加失败！请检查输入数据是否正确。');
            }
        },
        error: function() {
            alert('服务器错误，请稍后重试');
        }
    });
}
</script>

<style>
.card {
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
    margin: 20px auto;
    max-width: 800px;
    padding: 20px;
}

.card-header {
    padding: 15px 20px;
    border-bottom: 2px solid #2196F3;
    font-size: 20px;
    font-weight: bold;
    color: #2196F3;
    margin-bottom: 30px;
}

.card-header i {
    margin-right: 10px;
}

.form-group {
    margin-bottom: 25px;
}

.form-group .label {
    float: left;
    width: 120px;
    text-align: right;
    padding: 8px 15px;
    font-weight: bold;
    color: #333;
}

.form-group .field {
    margin-left: 150px;
}

.input {
    width: 100%;
    padding: 10px 15px;
    border: 1px solid #ddd;
    border-radius: 4px;
    transition: all 0.3s;
    font-size: 14px;
}

.input:focus {
    border-color: #2196F3;
    box-shadow: 0 0 5px rgba(33, 150, 243, 0.3);
}

.input::placeholder {
    color: #999;
}

textarea.input {
    min-height: 100px;
    resize: vertical;
}

.form-button {
    margin-top: 40px;
    text-align: center;
    padding-top: 20px;
    border-top: 1px solid #eee;
}

.form-button .button {
    padding: 12px 30px;
    font-size: 16px;
    border-radius: 4px;
    cursor: pointer;
    transition: all 0.3s;
    margin: 0 10px;
}

.bg-main {
    background: #2196F3;
    color: white;
    border: none;
}

.bg-main:hover {
    background: #1976D2;
}

.bg-default {
    background: #f8f9fa;
    color: #333;
    border: 1px solid #ddd;
}

.bg-default:hover {
    background: #e9ecef;
}
</style>
</body>
</html>
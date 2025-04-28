<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>添加学生</title>
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
        <i class="fas fa-user-plus"></i> 添加学生
    </div>
    <div class="card-body">
        <form method="post" class="form-x" action="">
            <div class="form-group">
                <div class="label">
                    <label>姓名：</label>
                </div>
                <div class="field">
                    <input type="text" class="input" name="sname" placeholder="请输入学生姓名" />
                </div>
            </div>

            <div class="form-group">
                <div class="label">
                    <label>性别：</label>
                </div>
                <div class="field">
                    <div class="button-group radio">
                        <label class="button active">
                            <input name="sex" value="男" type="radio" checked> 男
                        </label>
                        <label class="button">
                            <input name="sex" value="女" type="radio"> 女
                        </label>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <div class="label">
                    <label>爱好：</label>
                </div>
                <div class="field">
                    <div class="button-group checkbox">
                        <label class="button">
                            <input name="hobby" value="抽烟" type="checkbox"> 抽烟
                        </label>
                        <label class="button">
                            <input name="hobby" value="喝酒" type="checkbox"> 喝酒
                        </label>
                        <label class="button">
                            <input name="hobby" value="烫头" type="checkbox"> 烫头
                        </label>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <div class="label">
                    <label>出生日期：</label>
                </div>
                <div class="field">
                    <input type="date" class="input" name="birthdate" />
                </div>
            </div>

            <div class="form-group">
                <div class="label">
                    <label>手机号：</label>
                </div>
                <div class="field">
                    <input type="text" class="input" name="phone" placeholder="请输入手机号" />
                </div>
            </div>

            <div class="form-group">
                <div class="label">
                    <label>所在班级：</label>
                </div>
                <div class="field">
                    <select class="input" name="cid">
                        <option value="">--请选择--</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <div class="label">
                    <label>备注：</label>
                </div>
                <div class="field">
                    <textarea class="input" name="reamrk" rows="3" placeholder="请输入备注信息"></textarea>
                </div>
            </div>

            <div class="form-button">
                <button class="button bg-main" id="btn" type="submit">
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
$(function(){
    // 加载班级数据
    $.ajax({
        url: 'ClazzServlet',
        type: 'GET',
        data: {methodName:'getAll'},
        dataType: 'json', // Explicitly parse as JSON
        success: function(clazzList) {
            try {
                var select = $('select[name="cid"]');
                select.html('<option value="">--请选择--</option>'); // Reset options
                
                if (Array.isArray(clazzList)) {
                    clazzList.forEach(function(clazz) {
                        select.append('<option value="' + clazz.cid + '">' + clazz.cname + '</option>');
                    });
                    console.log('班级数据加载成功:', clazzList);
                } else {
                    console.error('返回的班级数据不是数组');
                }
            } catch(e) {
                console.error('处理班级数据失败:', e);
                alert('加载班级数据失败，请刷新页面重试');
            }
        },
        error: function(xhr, status, error) {
            console.error('请求班级数据失败:', status, error);
            console.error('错误详情:', xhr.responseText);
            alert('加载班级数据失败，请刷新页面重试');
        }
    });

    // 表单提交
    $('#btn').click(function(e){
        e.preventDefault();
        
        // 表单验证
        var sname = $('input[name="sname"]').val().trim();
        if(!sname) {
            alert('请输入学生姓名');
            return;
        }
        
        var phone = $('input[name="phone"]').val().trim();
        if(!phone) {
            alert('请输入手机号');
            return;
        }
        
        var birthdate = $('input[name="birthdate"]').val();
        if(!birthdate) {
            alert('请选择出生日期');
            return;
        }
        
        var cid = $('select[name="cid"]').val();
        if(!cid) {
            alert('请选择班级');
            return;
        }

        // 收集表单数据
        var formData = {
            methodName: 'addStudent',
            sname: sname,
            sex: $('input[name="sex"]:checked').val(),
            birthdate: birthdate,
            hobby: $('input[name="hobby"]:checked').map(function() {
                return this.value;
            }).get().join(','),
            phone: phone,
            cid: cid,
            reamrk: $('textarea[name="reamrk"]').val().trim()
        };

        console.log('提交的数据:', formData);

        // 提交表单
        $.ajax({
            url: 'StudentServlet',
            type: 'POST',
            data: formData,
            success: function(data) {
                console.log('服务器响应:', data);
                if(data == '1') {
                    alert('添加成功！');
                    location.href = 'listStudent.jsp';
                } else {
                    alert('添加失败！请检查输入数据是否正确。');
                }
            },
            error: function(xhr, status, error) {
                console.error('提交失败:', status, error);
                console.error('错误详情:', xhr.responseText);
                alert('系统错误，请稍后重试');
            }
        });
    });
});
</script>

<style>
.card {
    background: #fff;
    border-radius: 5px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    margin: 20px;
}

.card-header {
    padding: 15px 20px;
    border-bottom: 1px solid #eee;
    font-size: 18px;
    font-weight: bold;
}

.card-header i {
    margin-right: 10px;
    color: #2196F3;
}

.card-body {
    padding: 20px;
}

.form-group {
    margin-bottom: 20px;
}

.form-group .label {
    margin-bottom: 5px;
}

.form-group .field {
    position: relative;
}

.input {
    width: 100%;
    padding: 8px 12px;
    border: 1px solid #ddd;
    border-radius: 4px;
    transition: border-color 0.3s;
}

.input:focus {
    border-color: #2196F3;
    outline: none;
}

.button-group {
    display: flex;
    gap: 10px;
}

.button-group label.button {
    flex: 1;
    text-align: center;
    padding: 8px;
    border: 1px solid #ddd;
    border-radius: 4px;
    cursor: pointer;
    transition: all 0.3s;
}

.button-group label.button:hover {
    background: #f5f5f5;
}

.button-group label.button.active {
    background: #2196F3;
    color: white;
    border-color: #2196F3;
}

.form-button {
    margin-top: 30px;
    text-align: center;
}

.form-button .button {
    margin: 0 10px;
    padding: 10px 30px;
}

.bg-main {
    background: #2196F3;
    color: white;
}

.bg-default {
    background: #f5f5f5;
    color: #666;
}
</style>
</body>
</html>
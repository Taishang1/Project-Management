<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>编辑学生</title>
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
        <i class="fas fa-user-edit"></i> 编辑学生信息
    </div>
    <div class="card-body">
        <form method="post" class="form-x" action="">
            <input type="hidden" name="sid" value="${student.sid}">
            
            <div class="form-group">
                <div class="label">
                    <label>姓名：</label>
                </div>
                <div class="field">
                    <input type="text" class="input" name="sname" value="${student.sname}" />
                </div>
            </div>

            <div class="form-group">
                <div class="label">
                    <label>性别：</label>
                </div>
                <div class="field">
                    <div class="button-group radio">
                        <label class="button ${student.sex == '男' ? 'active' : ''}">
                            <input name="sex" value="男" type="radio" ${student.sex == '男' ? 'checked' : ''}> 男
                        </label>
                        <label class="button ${student.sex == '女' ? 'active' : ''}">
                            <input name="sex" value="女" type="radio" ${student.sex == '女' ? 'checked' : ''}> 女
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
                            <input name="hobby" value="抽烟" type="checkbox" ${student.hobby.contains('抽烟') ? 'checked' : ''}> 抽烟
                        </label>
                        <label class="button">
                            <input name="hobby" value="喝酒" type="checkbox" ${student.hobby.contains('喝酒') ? 'checked' : ''}> 喝酒
                        </label>
                        <label class="button">
                            <input name="hobby" value="烫头" type="checkbox" ${student.hobby.contains('烫头') ? 'checked' : ''}> 烫头
                        </label>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <div class="label">
                    <label>出生日期：</label>
                </div>
                <div class="field">
                    <input type="date" class="input" name="birthdate" value="${birthdayStr}" />
                </div>
            </div>

            <div class="form-group">
                <div class="label">
                    <label>手机号：</label>
                </div>
                <div class="field">
                    <input type="text" class="input" name="phone" value="${student.phone}" />
                </div>
            </div>

            <div class="form-group">
                <div class="label">
                    <label>所在班级：</label>
                </div>
                <div class="field">
                    <select class="input" name="cid">
                        <c:forEach items="${clazzList}" var="clazz">
                            <option value="${clazz.cid}" ${student.cid == clazz.cid ? 'selected' : ''}>
                                ${clazz.cname}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <div class="label">
                    <label>备注：</label>
                </div>
                <div class="field">
                    <textarea class="input" name="reamrk" rows="3">${student.reamrk}</textarea>
                </div>
            </div>

            <div class="form-button">
                <button class="button bg-main" type="button" onclick="updateStudent()">
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
function updateStudent() {
    var formData = {
        methodName: 'updateStudent',
        sid: $('input[name="sid"]').val(),
        sname: $('input[name="sname"]').val().trim(),
        sex: $('input[name="sex"]:checked').val(),
        birthdate: $('input[name="birthdate"]').val(),
        hobby: $('input[name="hobby"]:checked').map(function() {
            return this.value;
        }).get().join(','),
        phone: $('input[name="phone"]').val().trim(),
        cid: $('select[name="cid"]').val(),
        reamrk: $('textarea[name="reamrk"]').val().trim()
    };

    // 表单验证
    if(!formData.sname) {
        alert('请输入学生姓名');
        return;
    }
    if(!formData.phone) {
        alert('请输入手机号');
        return;
    }
    if(!formData.birthdate) {
        alert('请选择出生日期');
        return;
    }
    if(!formData.cid) {
        alert('请选择班级');
        return;
    }

    $.ajax({
        url: 'StudentServlet',
        type: 'POST',
        data: formData,
        success: function(response) {
            if(response == '1') {
                alert('更新成功！');
                history.back();
            } else {
                alert('更新失败！请检查输入数据是否正确。');
            }
        },
        error: function() {
            alert('服务器错误');
        }
    });
}

// 单选框样式
$('.button-group.radio .button').click(function() {
    $(this).addClass('active').siblings().removeClass('active');
});

// 复选框样式
$('.button-group.checkbox .button').click(function() {
    $(this).toggleClass('active');
});
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

.button-group {
    display: flex;
    gap: 15px;
}

.button-group label.button {
    flex: 1;
    text-align: center;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 4px;
    cursor: pointer;
    transition: all 0.3s;
    background: #f8f9fa;
}

.button-group label.button:hover {
    background: #e9ecef;
}

.button-group label.button.active {
    background: #2196F3;
    color: white;
    border-color: #2196F3;
}

.button-group.checkbox label.button {
    flex: 0 0 auto;
    padding: 8px 20px;
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

select.input {
    height: 40px;
    background: #fff;
}

textarea.input {
    min-height: 100px;
    resize: vertical;
}
</style>
</body>
</html>
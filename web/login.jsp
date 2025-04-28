<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>登录/注册</title>
    <base href="${pageContext.request.contextPath}/">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="js/jquery.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            min-height: 100vh;
            background: url('images/bg.jpg') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .container {
            width: 400px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }

        .form-container {
            padding: 40px;
        }

        .title {
            font-size: 2em;
            color: #333;
            text-align: center;
            margin-bottom: 30px;
            font-weight: 600;
        }

        .input-group {
            position: relative;
            margin-bottom: 30px;
        }

        .input-group input {
            width: 100%;
            padding: 15px 20px;
            outline: none;
            border: 1px solid #ddd;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s;
        }

        .input-group input:focus {
            border-color: #2196F3;
            box-shadow: 0 0 10px rgba(33, 150, 243, 0.3);
        }

        .input-group i {
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: #666;
        }

        .verify-group {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .verify-group input {
            flex: 1;
        }

        .verify-group img {
            height: 48px;
            border-radius: 8px;
            cursor: pointer;
        }

        .btn {
            width: 100%;
            padding: 15px;
            background: #2196F3;
            border: none;
            border-radius: 10px;
            color: white;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
            margin-bottom: 20px;
        }

        .btn:hover {
            background: #1976D2;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(33, 150, 243, 0.4);
        }

        .switch-form {
            text-align: center;
            color: #666;
        }

        .switch-form a {
            color: #2196F3;
            text-decoration: none;
            font-weight: 600;
            margin-left: 5px;
        }

        .switch-form a:hover {
            text-decoration: underline;
        }

        /* 添加动画效果 */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .form-container {
            animation: fadeIn 0.5s ease-out;
        }

        /* 错误提示样式 */
        .error-message {
            color: #ff3860;
            font-size: 14px;
            margin-top: 5px;
            display: none;
        }

        /* 头像上传相关样式 */
        .upload-group {
            margin: 20px 0;
            text-align: center;
        }

        .upload-preview {
            margin-bottom: 15px;
        }

        .upload-preview img {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            border: 2px solid #3498db;
            object-fit: cover;
        }

        .upload-btn {
            background: #3498db;
            color: white;
            padding: 8px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }

        .upload-btn:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }

        .upload-btn i {
            margin-right: 5px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="form-container">
        <!-- 登录表单 -->
        <form id="loginForm" class="active">
            <h2 class="title">欢迎登录</h2>
            <div class="input-group">
                <input type="text" id="loginUkey" placeholder="用户名">
                <div class="icon">
                    <i class="fas fa-user"></i>
                </div>
            </div>
            <div class="input-group">
                <input type="password" id="loginPwd" placeholder="密码">
                <div class="icon">
                    <i class="fas fa-lock"></i>
                </div>
            </div>
            <div class="input-group verify-group">
                <input type="text" id="loginCode" placeholder="验证码" style="width: 60%;">
                <img src="RandomServlet" onclick="this.src=this.src+'?'" alt="验证码"
                     style="height: 100%; border-radius: 4px; margin-left: 10px; cursor: pointer;">
            </div>
            <button type="button" class="btn" id="loginBtn">登 录</button>
            <div class="switch-form">
                还没有账号？<a href="javascript:void(0)" id="toRegister">立即注册</a>
            </div>
        </form>

        <!-- 注册表单 -->
        <form id="registerForm" style="display: none;">
            <h2 class="title">用户注册</h2>
            <div class="input-group">
                <input type="text" id="registerUkey" placeholder="请输入账号">
                <div class="icon">
                    <i class="fas fa-user"></i>
                </div>
            </div>
            <div class="input-group">
                <input type="password" id="registerPwd" placeholder="请输入密码">
                <div class="icon">
                    <i class="fas fa-lock"></i>
                </div>
            </div>
            <div class="input-group">
                <input type="password" id="confirmPwd" placeholder="请确认密码">
                <div class="icon">
                    <i class="fas fa-lock"></i>
                </div>
            </div>
            <div class="input-group upload-group">
                <div class="upload-preview">
                    <img id="preview-img" src="images/default-avatar.png" alt="头像预览">
                </div>
                <button type="button" class="upload-btn" onclick="document.getElementById('head').click()">
                    <i class="fas fa-camera"></i> 选择头像
                </button>
                <input type="file" id="head" name="head" accept="image/*" style="display: none;">
            </div>
            <button type="button" class="btn" id="registerBtn">注 册</button>
            <div class="switch-form">
                已有账号？<a href="javascript:void(0)" id="toLogin">返回登录</a>
            </div>
        </form>
    </div>
</div>

<script>
    $(function() {
        // 切换登录和注册表单
        $('#toRegister').click(function(){
            $('#loginForm').hide();
            $('#registerForm').show();
        });

        $('#toLogin').click(function(){
            $('#registerForm').hide();
            $('#loginForm').show();
        });

        // 头像预览功能
        $('#head').change(function(e) {
            var file = e.target.files[0];
            if (file) {
                if (!file.type.match('image.*')) {
                    alert('请选择图片文件！');
                    return;
                }
                if (file.size > 2 * 1024 * 1024) {
                    alert('图片大小不能超过 2MB！');
                    return;
                }
                var reader = new FileReader();
                reader.onload = function(e) {
                    $('#preview-img').attr('src', e.target.result);
                }
                reader.readAsDataURL(file);
            }
        });

        // 注册表单提交
        $('#registerBtn').click(function(){
            var ukey = $('#registerUkey').val();
            var pwd = $('#registerPwd').val();
            var confirmPwd = $('#confirmPwd').val();
            var head = $('#head')[0].files[0];

            if(!ukey || !pwd || !confirmPwd){
                alert('请填写完整信息');
                return;
            }

            if(pwd !== confirmPwd){
                alert('两次输入的密码不一致');
                return;
            }

            if(!head) {
                alert('请选择头像');
                return;
            }

            var formData = new FormData();
            formData.append('ukey', ukey);
            formData.append('pwd', pwd);
            formData.append('head', head);

            $.ajax({
                url: 'RegisterServlet',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function(data){
                    if(data == '1'){
                        alert('注册成功，请登录');
                        $('#registerForm').hide();
                        $('#loginForm').show();
                    }else{
                        alert('注册失败');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('注册错误:', error);
                    alert('注册失败，请稍后重试');
                }
            });
        });

        // 登录表单提交
        $('#loginBtn').click(function(){
            var ukey = $('#loginUkey').val();
            var pwd = $('#loginPwd').val();
            var code = $('#loginCode').val();

            if(!ukey || !pwd || !code){
                alert('请填写完整信息');
                return;
            }

            $.post('LoginServlet', {ukey: ukey, pwd: pwd, code: code}, function(data){
                if(data == '0'){
                    alert('验证码不正确!');
                }else if(data == '1'){
                    alert('用户名或密码错误！');
                }else{
                    location.href = 'index.jsp';
                }
            });
        });
    });
</script>
</body>
</html>
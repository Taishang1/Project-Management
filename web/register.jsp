<div class="form">
    <h2>注册新账号</h2>
    <form id="registerForm" enctype="multipart/form-data">
        <div class="input-group">
            <input type="text" id="ukey" name="ukey" placeholder="用户名">
            <div class="icon">
                <i class="fas fa-user"></i>
            </div>
        </div>
        <div class="input-group">
            <input type="password" id="pwd" name="pwd" placeholder="密码">
            <div class="icon">
                <i class="fas fa-lock"></i>
            </div>
        </div>
        <div class="input-group upload-group">
            <div class="upload-preview">
                <img id="preview-img" src="images/default-avatar.png" alt="头像预览">
            </div>
            <div class="upload-btn-wrapper">
                <button type="button" class="upload-btn" onclick="document.getElementById('head').click()">
                    <i class="fas fa-camera"></i> 选择头像
                </button>
                <input type="file" id="head" name="head" accept="image/*" style="display: none;">
            </div>
        </div>
        <div class="input-group verify-group">
            <input type="text" id="code" name="code" placeholder="验证码">
            <img src="RandomServlet" onclick="this.src=this.src+'?'" alt="验证码">
        </div>
        <button type="submit" class="btn">注册</button>
        <div class="switch-form">
            已有账号？<a href="javascript:;" onclick="switchForm('login')">立即登录</a>
        </div>
    </form>
</div>

<style>
.upload-group {
    margin: 20px 0;
    text-align: center;
}

.upload-preview {
    margin-bottom: 15px;
}

.upload-preview img {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    border: 3px solid #3498db;
    object-fit: cover;
    transition: all 0.3s;
}

.upload-btn-wrapper {
    position: relative;
    display: inline-block;
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

<script>
$(function() {
    // 头像预览功能
    $('#head').change(function(e) {
        var file = e.target.files[0];
        if (file) {
            // 验证文件类型
            if (!file.type.match('image.*')) {
                alert('请选择图片文件！');
                return;
            }
            // 验证文件大小（最大 2MB）
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

    $('#registerForm').submit(function(e) {
        e.preventDefault();
        
        var formData = new FormData(this);
        
        // 验证表单
        var ukey = $('#ukey').val();
        var pwd = $('#pwd').val();
        var head = $('#head').val();
        
        if (!ukey || !pwd) {
            alert('请填写用户名和密码');
            return;
        }
        
        if (!head) {
            alert('请选择头像');
            return;
        }

        $.ajax({
            url: 'RegisterServlet',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function(data) {
                if(data == '1') {
                    alert('注册成功，请登录');
                    location.href = 'login.jsp';
                } else {
                    alert('注册失败');
                }
            },
            error: function(xhr, status, error) {
                console.error('注册错误:', error);
                alert('注册失败，请稍后重试');
            }
        });
    });
});
</script> 
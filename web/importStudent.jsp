<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>导入学生</title>
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
        }
        
        .panel-head strong {
            font-size: 18px;
        }
        
        .body-content {
            padding: 30px;
        }
        
        .file-upload {
            text-align: center;
            padding: 20px;
            border: 2px dashed #3498db;
            border-radius: 8px;
            margin: 20px 0;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .file-upload:hover {
            border-color: #2980b9;
            background: #f7f9fc;
        }
        
        .file-upload i {
            font-size: 48px;
            color: #3498db;
            margin-bottom: 10px;
        }
        
        .upload-text {
            color: #666;
            margin: 10px 0;
        }
        
        .btn {
            padding: 10px 25px;
            font-size: 15px;
            border-radius: 4px;
            transition: all 0.3s;
            background: #3498db;
            color: white;
            border: none;
            cursor: pointer;
        }
        
        .btn:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }
        
        .template-link {
            display: block;
            margin-top: 15px;
            color: #3498db;
            text-decoration: none;
        }
        
        .template-link:hover {
            color: #2980b9;
        }
        
        .import-instructions {
            background: #f8f9fa;
            border-left: 4px solid #3498db;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        
        .import-instructions h3 {
            color: #2c3e50;
            margin-top: 0;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .import-instructions ul {
            margin: 10px 0 5px;
            padding-left: 20px;
        }
        
        .import-instructions li {
            margin-bottom: 5px;
            color: #555;
        }
    </style>
</head>
<body>
<div class="panel">
    <div class="panel-head">
        <strong><i class="fas fa-file-import"></i> 导入学生信息</strong>
    </div>
    <div class="body-content">
        <div class="import-instructions">
            <h3><i class="fas fa-info-circle"></i> 导入说明</h3>
            <ul>
                <li>请下载并使用模板文件，保持表头不变</li>
                <li>编号：可选，系统会自动分配</li>
                <li>姓名：必填，学生姓名</li>
                <li>性别：必填，只能填"男"或"女"</li>
                <li>出生日期：格式为YYYY-MM-DD，如2000-01-01</li>
                <li>联系电话：必填，11位手机号码</li>
                <li>班级：必填，必须是系统中已存在的班级名称</li>
            </ul>
        </div>
        <form method="post" action="StudentServlet?method=importStudents" 
              enctype="multipart/form-data" id="uploadForm">
            <div class="file-upload" onclick="$('#excel').click();">
                <i class="fas fa-cloud-upload-alt"></i>
                <div class="upload-text">点击或拖拽Excel文件到这里上传</div>
                <div id="fileName"></div>
                <input type="file" name="excel" id="excel" accept=".xls,.xlsx" 
                       style="display: none;" onchange="showFileName()">
            </div>
            <div style="text-align: center;">
                <button type="submit" class="btn">
                    <i class="fas fa-upload"></i> 开始导入
                </button>
                <a href="template/student_template.xls" class="template-link">
                    <i class="fas fa-download"></i> 下载导入模板
                </a>
            </div>
        </form>
    </div>
</div>

<script>
function showFileName() {
    var file = document.getElementById('excel').files[0];
    if(file) {
        document.getElementById('fileName').innerHTML = '已选择: ' + file.name;
    }
}

$(function(){
    $('#uploadForm').submit(function(e){
        e.preventDefault();
        var fileInput = $('#excel')[0];
        if(!fileInput.files[0]) {
            alert('请选择Excel文件');
            return;
        }
        
        var formData = new FormData(this);
        $.ajax({
            url: $(this).attr('action'),
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function(response){
                if(response == '1') {
                    alert('导入成功');
                    location.href = 'listStudent.jsp';
                } else {
                    alert('导入失败：' + response);
                }
            },
            error: function(){
                alert('导入失败，请稍后重试');
            }
        });
    });
});
</script>
</body>
</html> 
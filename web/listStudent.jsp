<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="renderer" content="webkit">
    <title>学生列表</title>
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
        <i class="fas fa-user-graduate"></i> 学生管理
    </div>
    <div class="card-body">
        <!-- 搜索功能 -->
        <div class="search-box">
            <input type="text" id="sname" placeholder="请输入学生姓名">
            <input type="text" id="phone" placeholder="请输入联系电话">
            <button id="searchBtn"><i class="fas fa-search"></i> 搜索</button>
        </div>

        <!-- 操作按钮 -->
        <div class="action-buttons">
            <button id="addStudentBtn"><i class="fas fa-plus"></i> 添加学生</button>
            <button id="exportBtn"><i class="fas fa-download"></i> 导出Excel</button>
            <button id="importBtn"><i class="fas fa-upload"></i> 导入Excel</button>
        </div>

        <!-- 数据表格 -->
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>姓名</th>
                <th>性别</th>
                <th>出生日期</th>
                <th>联系电话</th>
                <th>班级</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody id="studentList">
            <!-- 数据将通过JavaScript动态加载 -->
            </tbody>
        </table>

        <!-- 分页 -->
        <div class="pagination" id="pagination">
            <!-- 分页按钮将通过JavaScript动态生成 -->
        </div>
    </div>
</div>

<script>
    $(function() {
        // 页面加载完成后立即加载第一页数据
        loadStudentData(1, '', '');

        // 搜索按钮点击事件
        $('#searchBtn').click(function() {
            var sname = $('#sname').val();
            var phone = $('#phone').val();
            loadStudentData(1, sname, phone);
        });

        // 添加学生按钮点击事件
        $('#addStudentBtn').click(function () {
            location.href = 'saveStudent.jsp';
        });

        // 导出Excel按钮点击事件
        $('#exportBtn').click(function () {
            var sname = $('#sname').val();
            var phone = $('#phone').val();
            window.location.href = 'StudentServlet?methodName=exportStudent&sname=' + encodeURIComponent(sname) + '&phone=' + encodeURIComponent(phone);
        });

        // 导入Excel按钮点击事件
        $('#importBtn').click(function () {
            location.href = 'importStudent.jsp';
        });
    });

    function loadStudentData(page, sname, phone) {
        // 添加加载状态显示
        $('#studentList').html('<tr><td colspan="7" class="text-center"><i class="fas fa-spinner fa-spin"></i> 数据加载中...</td></tr>');
        
        $.ajax({
            url: 'StudentServlet',
            type: 'GET',
            data: {
                methodName: 'getStudentByPage',
                index: page,
                sname: sname,
                phone: phone
            },
            dataType: 'text',
            success: function(data) {
                try {
                    var pageBean = JSON.parse(data);
                    displayStudentData(pageBean);
                } catch (e) {
                    $('#studentList').html('<tr><td colspan="7" class="empty-data"><i class="fas fa-exclamation-circle"></i>数据解析失败: ' + e.message + '</td></tr>');
                }
            },
            error: function(xhr, status, error) {
                $('#studentList').html('<tr><td colspan="7" class="empty-data"><i class="fas fa-exclamation-circle"></i>数据加载失败: ' + error + '</td></tr>');
            }
        });
    }

    function displayStudentData(pageBean) {
        var tbody = $('#studentList');
        tbody.empty();

        if (!pageBean.list || pageBean.list.length === 0) {
            tbody.append('<tr><td colspan="7" class="empty-data"><i class="fas fa-inbox"></i>暂无学生数据</td></tr>');
            return;
        }

        // 遍历学生数据并显示
        for (var i = 0; i < pageBean.list.length; i++) {
            var student = pageBean.list[i];
            
            // 处理可能为空的字段
            var sid = student.sid || '';
            var sname = student.sname || '';
            var sex = student.sex || '-';
            
            // 直接显示出生日期
            var birthday = student.birthday || '-';
            
            var phone = student.phone || '';
            var className = (student.clazz && student.clazz.cname) ? student.clazz.cname : '-';
            
            var row = '<tr>' +
                '<td>' + sid + '</td>' +
                '<td>' + sname + '</td>' +
                '<td>' + sex + '</td>' +
                '<td>' + formatDate(birthday) + '</td>' +
                '<td>' + phone + '</td>' +
                '<td>' + className + '</td>' +
                '<td>' +
                '<div class="button-group">' +
                '<a class="button border-blue" href="javascript:void(0)" onclick="editStudent(' + sid + ')">' +
                '<i class="fas fa-edit"></i> 编辑' +
                '</a>' +
                '<a class="button border-red" href="javascript:void(0)" onclick="deleteStudent(' + sid + ')">' +
                '<i class="fas fa-trash"></i> 删除' +
                '</a>' +
                '<a class="button border-green" href="studentCourseGrade.jsp?sid=' + sid + '">' +
                '<i class="fas fa-graduation-cap"></i> 查看成绩' +
                '</a>' +
                '</div>' +
                '</td>' +
                '</tr>';
            
            tbody.append(row);
        }

        // 更新分页按钮
        updatePagination(pageBean);
    }

    function updatePagination(pageBean) {
        var pagination = $('#pagination');
        pagination.empty();
        
        // 检查所有可能的分页属性
        var totalPages = pageBean.totalPage || pageBean.totalPageCount || pageBean.totalPages || 0;
        var currentPage = pageBean.index || pageBean.currentPage || 1;
        
        if (totalPages > 1) {
            for (var i = 1; i <= totalPages; i++) {
                var button = $('<button class="button"></button>')
                    .text(i)
                    .attr('onclick', 'loadStudentData(' + i + ', $("#sname").val(), $("#phone").val())');
                
                if (i == currentPage) {
                    button.addClass('bg-main');
                }
                
                pagination.append(button);
            }
        }
    }

    function editStudent(sid) {
        location.href = 'StudentServlet?methodName=getStudentById&sid=' + sid;
    }

    function deleteStudent(sid) {
        if (confirm('确定要删除该学生吗？')) {
            $.get('StudentServlet', { methodName: 'deleteStudent', sid: sid }, function (data) {
                if (data == '1') {
                    alert('删除成功');
                    loadStudentData(1, $('#sname').val(), $('#phone').val());
                } else {
                    alert('删除失败');
                }
            });
        }
    }

    // 格式化日期显示
    function formatDate(dateStr) {
        if (!dateStr) return '-';
        return dateStr.split(' ')[0]; // 只显示日期部分，去掉时间
    }
</script>

<style>
    /* 添加新的样式，与其他页面保持一致 */
    .card {
        background: #fff;
        border-radius: 5px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        margin-bottom: 20px;
    }
    
    .card-header {
        padding: 15px 20px;
        border-bottom: 1px solid #eee;
        font-size: 18px;
        font-weight: bold;
        display: flex;
        align-items: center;
    }
    
    .card-header i {
        margin-right: 10px;
        color: #2196F3;
    }
    
    .card-body {
        padding: 20px;
    }
    
    .search-box {
        display: flex;
        margin-bottom: 20px;
    }
    
    .search-box input {
        flex: 1;
        padding: 8px 12px;
        border: 1px solid #ddd;
        border-radius: 4px;
        margin-right: 10px;
    }
    
    .search-box button {
        background: #2196F3;
        color: white;
        border: none;
        padding: 8px 15px;
        border-radius: 4px;
        cursor: pointer;
    }
    
    .action-buttons {
        margin-bottom: 20px;
        display: flex;
        gap: 10px;
    }
    
    .action-buttons button {
        background: #2196F3;
        color: white;
        border: none;
        padding: 8px 15px;
        border-radius: 4px;
        cursor: pointer;
        display: flex;
        align-items: center;
    }
    
    .action-buttons button i {
        margin-right: 5px;
    }
    
    table {
        width: 100%;
        border-collapse: collapse;
    }
    
    table th, table td {
        padding: 12px 15px;
        text-align: left;
        border-bottom: 1px solid #eee;
        color: #333; /* Adding darker text color for better readability */
    }
    
    table th {
        background-color: #f8f9fa;
        font-weight: 600;
        color: #000000;
        text-shadow: 0 0 0 #000;
    }
    
    .button-group {
        display: flex;
        gap: 5px;
    }
    
    .button {
        padding: 5px 10px;
        border-radius: 3px;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        font-size: 14px;
    }
    
    .button i {
        margin-right: 5px;
    }
    
    .border-blue {
        border: 1px solid #2196F3;
        color: #2196F3;
    }
    
    .border-red {
        border: 1px solid #f44336;
        color: #f44336;
    }
    
    .border-green {
        border: 1px solid #4CAF50;
        color: #4CAF50;
    }
    
    .pagination {
        margin-top: 20px;
        display: flex;
        gap: 5px;
        flex-wrap: wrap; /* 允许按钮换行 */
    }
    
    .pagination button {
        padding: 5px 10px;
        border: 1px solid #ddd;
        background: white;
        cursor: pointer;
        border-radius: 3px;
        margin: 2px; /* 添加一些外边距 */
    }
    
    .pagination button.bg-main {
        background: #2196F3;
        color: white;
        border-color: #2196F3;
    }
    
    .empty-data {
        text-align: center;
        padding: 20px;
        color: #999;
    }
    
    .empty-data i {
        margin-right: 5px;
    }
</style>
</body>
</html>
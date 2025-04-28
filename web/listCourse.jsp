<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>课程管理</title>
    <base href="${pageContext.request.contextPath}/">
    <link rel="stylesheet" href="css/pintuer.css">
    <link rel="stylesheet" href="css/admin.css">
    <script src="js/jquery.js"></script>
    <script src="js/pintuer.js"></script>
    <style>
        /* 自定义样式 */
        .card {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            overflow: hidden;
        }

        .card-header {
            background: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            font-weight: 600;
            color: #333;
        }

        .card-body {
            padding: 20px;
        }

        .search-box {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }

        .search-box input {
            flex: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            margin-right: 10px;
        }

        .search-box button {
            padding: 10px 20px;
            background: #2196F3;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .action-buttons {
            margin-bottom: 20px;
        }

        .action-buttons button {
            padding: 10px 20px;
            background: #2196F3;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-right: 10px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        table th, table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        table th {
            background: #f8f9fa;
            font-weight: 600;
        }

        table tr:hover {
            background: #f1f2f6;
        }

        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }

        .pagination button {
            padding: 8px 15px;
            margin: 0 5px;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
            cursor: pointer;
        }

        .pagination button.active {
            background: #2196F3;
            color: white;
            border-color: #2196F3;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .search-box {
                flex-direction: column;
            }
            .search-box input {
                margin-bottom: 10px;
            }
        }

        .float-right {
            float: right;
        }

        .bg-blue {
            background: #3498db;
            color: white;
            border: none;
            padding: 6px 15px;
            border-radius: 4px;
            transition: all 0.3s;
        }

        .bg-blue:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }

        .panel-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .button i {
            margin-right: 5px;
        }
    </style>
</head>
<body>
<!-- 页面标题 -->
<div class="card">
    <div class="card-header">
        <i class="fas fa-book"></i> 课程管理
    </div>
    <div class="card-body">
        <!-- 搜索功能 -->
        <div class="search-box">
            <input type="text" id="keyword" placeholder="请输入搜索关键词">
            <button id="searchBtn"><i class="fas fa-search"></i> 搜索框</button>
        </div>

        <!-- 操作按钮 -->
        <div class="action-buttons">
            <button id="addCourseBtn"><i class="fas fa-plus"></i> 添加课程</button>
            <button id="exportBtn"><i class="fas fa-download"></i> 导出Excel</button>
            <button id="testBtn"><i class="fas fa-vial"></i> 测试获取所有课程</button>
        </div>

        <!-- 数据表格 -->
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>课程名称</th>
                <th>描述</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody id="courseList">
            <!-- 数据将通过JavaScript动态加载 -->
            </tbody>
        </table>

        <!-- 分页 -->
        <div class="pagination" id="pagination">
            <!-- 分页按钮将通过JavaScript动态生成 -->
        </div>
    </div>
</div>

<div class="panel admin-panel">
    <div class="panel-head">
        <strong><span class="icon-reorder"></span> 课程列表</strong>
        <div class="float-right">
            <button class="button bg-blue" onclick="location.href='index.jsp'">
                <i class="fas fa-home"></i> 返回首页
            </button>
        </div>
    </div>
</div>

<script>
    $(function() {
        // 页面加载完成后立即加载第一页数据
        loadCourseData(1, '');

        // 搜索按钮点击事件
        $('#searchBtn').click(function() {
            var keyword = $('#keyword').val();
            loadCourseData(1, keyword);
        });

        // 添加课程按钮点击事件
        $('#addCourseBtn').click(function () {
            location.href = 'addCourse.jsp';
        });

        // 导出Excel按钮点击事件
        $('#exportBtn').click(function () {
            var keyword = $('#keyword').val();
            window.location.href = 'CourseServlet?methodName=exportCourse&keyword=' + encodeURIComponent(keyword);
        });

        // 测试按钮点击事件
        $('#testBtn').click(function() {
            console.log('测试获取所有课程');
            $.ajax({
                url: 'CourseServlet',
                type: 'GET',
                data: {
                    methodName: 'getAllCourses'
                },
                dataType: 'json',
                success: function(data) {
                    console.log('成功获取所有课程:', data);
                    alert('成功获取 ' + data.length + ' 条课程数据');
                },
                error: function(xhr, status, error) {
                    console.error('请求失败:', status, error);
                    console.error('响应文本:', xhr.responseText);
                    alert('获取课程数据失败: ' + error);
                }
            });
        });
    });

    function loadCourseData(page, keyword) {
        console.log('开始加载课程数据: page=' + page + ', keyword=' + keyword);
        // 添加加载状态显示
        $('#courseList').html('<tr><td colspan="4" class="text-center"><i class="fas fa-spinner fa-spin"></i> 数据加载中...</td></tr>');
        
        $.ajax({
            url: 'CourseServlet',
            type: 'GET',
            data: {
                methodName: 'getCourseByPage',
                index: page,
                keyword: keyword
            },
            dataType: 'text', // 改为 text，手动解析 JSON
            success: function(data) {
                console.log('成功获取原始数据:', data);
                try {
                    var pageBean = JSON.parse(data);
                    console.log('解析后的数据:', pageBean);
                    displayCourseData(pageBean);
                } catch (e) {
                    console.error('JSON 解析错误:', e);
                    $('#courseList').html('<tr><td colspan="4" class="empty-data"><i class="fas fa-exclamation-circle"></i>数据解析失败</td></tr>');
                }
            },
            error: function(xhr, status, error) {
                console.error('请求失败:', status, error);
                console.error('响应文本:', xhr.responseText);
                console.error('状态码:', xhr.status);
                $('#courseList').html('<tr><td colspan="4" class="empty-data"><i class="fas fa-exclamation-circle"></i>数据加载失败: ' + error + '</td></tr>');
            }
        });
    }

    function displayCourseData(pageBean) {
        console.log('显示课程数据:', pageBean);
        var tbody = $('#courseList');
        tbody.empty();

        if (!pageBean.list || pageBean.list.length === 0) {
            tbody.append('<tr><td colspan="4" class="empty-data"><i class="fas fa-inbox"></i>暂无课程数据</td></tr>');
            return;
        }

        // 遍历课程数据并显示
        for (var i = 0; i < pageBean.list.length; i++) {
            var course = pageBean.list[i];
            console.log('处理课程:', course);
            
            var row = '<tr>' +
                '<td>' + course.cid + '</td>' +
                '<td>' + course.cname + '</td>' +
                '<td>' + (course.description || '-') + '</td>' +
                '<td>' +
                '<div class="button-group">' +
                '<a class="button border-blue" href="javascript:void(0)" onclick="editCourse(' + course.cid + ')">' +
                '<i class="fas fa-edit"></i> 编辑' +
                '</a>' +
                '<a class="button border-red" href="javascript:void(0)" onclick="deleteCourse(' + course.cid + ')">' +
                '<i class="fas fa-trash"></i> 删除' +
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
        
        if (pageBean.totalPage > 1) {
            for (var i = 1; i <= pageBean.totalPage; i++) {
                pagination.append(`
                    <button class="button ${i == pageBean.index ? 'bg-main' : ''}" 
                            onclick="loadCourseData(${i}, $('#keyword').val())">
                        ${i}
                    </button>
                `);
            }
        }
    }

    function editCourse(cid) {
        location.href = 'editCourse.jsp?cid=' + cid;
    }

    function deleteCourse(cid) {
        if (confirm('确定要删除该课程吗？')) {
            $.get('CourseServlet', { methodName: 'deleteCourse', cid: cid }, function (data) {
                if (data == '1') {
                    alert('删除成功');
                    loadCourseData(1);
                } else {
                    alert('删除失败');
                }
            });
        }
    }
</script>
</body>
</html>
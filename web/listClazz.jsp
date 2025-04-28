<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>班级管理</title>
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
            align-items: center;
            margin-top: 20px;
            gap: 10px;
        }

        .pagination button {
            padding: 8px 15px;
            border: 1px solid #ddd;
            background: #fff;
            color: #333;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .pagination button:hover {
            background: #f5f5f5;
        }

        .pagination button.bg-main {
            background: #2196F3;
            color: white;
            border-color: #2196F3;
        }

        .pagination button.bg-main:hover {
            background: #1976D2;
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
    </style>
</head>
<body>
<!-- 页面标题 -->
<div class="card">
    <div class="card-header">
        <i class="fas fa-users"></i> 班级管理
    </div>
    <div class="card-body">
        <!-- 搜索功能 -->
        <div class="search-box">
            <input type="text" id="searchKeyword" placeholder="请输入搜索关键词">
            <button id="searchBtn"><i class="fas fa-search"></i> 搜索</button>
        </div>

        <!-- 操作按钮 -->
        <div class="action-buttons">
            <button id="addClazzBtn"><i class="fas fa-plus"></i> 添加班级</button>
            <button id="exportBtn"><i class="fas fa-download"></i> 导出Excel</button>
        </div>

        <!-- 数据表格 -->
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>班级名称</th>
                <th>班主任</th>
                <th>备注</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody id="clazzList">
            <!-- 数据将通过JavaScript动态加载 -->
            </tbody>
        </table>

        <!-- 分页容器 -->
        <div class="pagination" id="pagination">
            <!-- 分页按钮将通过JavaScript动态生成 -->
        </div>
    </div>
</div>

<script>
    $(function () {
        // 页面加载完成后立即加载第一页数据
        loadClazzData(1);
        console.log("页面初始化加载数据");

        // 搜索框点击事件
        $('#searchBtn').click(function () {
            var keyword = $('#searchKeyword').val();
            loadClazzData(1, keyword);
        });

        // 添加班级按钮点击事件
        $('#addClazzBtn').click(function () {
            location.href = 'saveClazz.jsp';
        });

        // 导出Excel按钮点击事件
        $('#exportBtn').click(function () {
            var keyword = $('#searchKeyword').val();
            window.location.href = 'StudentServlet?methodName=exportStudent&keyword=' + encodeURIComponent(keyword);
        });
    });

    function loadClazzData(page, keyword) {
        console.log("加载数据 - 页码:", page, "关键字:", keyword);
        $.ajax({
            url: 'ClazzServlet',
            type: 'GET',
            data: {
                methodName: 'getClazzByPage',
                index: page,
                keyword: keyword || ''
            },
            success: function(data) {
                try {
                    console.log("接收到的数据:", data);
                    var pageBean = (typeof data === 'string') ? JSON.parse(data) : data;
                    console.log("解析后的pageBean:", pageBean);
                    if (!pageBean || !pageBean.list) {
                        console.error('返回的数据格式不正确');
                        $('#clazzList').html('<tr><td colspan="5" class="text-center">加载数据失败</td></tr>');
                        return;
                    }
                    displayClazzData(pageBean);
                } catch(e) {
                    console.error('解析班级数据失败:', e);
                    console.error('原始数据:', data);
                    $('#clazzList').html('<tr><td colspan="5" class="text-center">数据解析失败</td></tr>');
                }
            },
            error: function(xhr, status, error) {
                console.error("AJAX请求失败:", status, error);
                $('#clazzList').html('<tr><td colspan="5" class="text-center">请求失败</td></tr>');
            }
        });
    }

    function displayClazzData(pageBean) {
        console.log("显示数据 - pageBean:", pageBean);
        var tbody = $('#clazzList');
        tbody.empty();

        if (!pageBean.list || pageBean.list.length === 0) {
            tbody.html('<tr><td colspan="5" class="text-center">暂无数据</td></tr>');
            return;
        }

        pageBean.list.forEach(function(clazz) {
            var row = '<tr>' +
                '<td>' + clazz.cid + '</td>' +
                '<td>' + clazz.cname + '</td>' +
                '<td>' + clazz.cteacher + '</td>' +
                '<td>' + (clazz.remark || '-') + '</td>' +
                '<td>' +
                '<div class="button-group">' +
                '<a class="button border-main" href="updateClazz.jsp?cid=' + clazz.cid + '">' +
                '<i class="fas fa-edit"></i> 编辑' +
                '</a>' +
                '<a class="button border-red" href="javascript:void(0)" onclick="deleteClazz(' + clazz.cid + ')">' +
                '<i class="fas fa-trash"></i> 删除' +
                '</a>' +
                '</div>' +
                '</td>' +
                '</tr>';
            tbody.append(row);
        });

        // 更新分页
        var pagination = $('#pagination');
        pagination.empty();
        
        if (pageBean.numbers && pageBean.numbers.length > 0) {
            // 上一页
            if (pageBean.index > 1) {
                pagination.append('<button onclick="loadClazzData(' + (pageBean.index - 1) + ')" class="button">上一页</button>');
            }
            
            // 页码
            for (var i = 0; i < pageBean.numbers.length; i++) {
                var pageNum = pageBean.numbers[i];
                if (pageNum === pageBean.index) {
                    pagination.append('<button class="button bg-main">' + pageNum + '</button>');
                } else {
                    pagination.append('<button onclick="loadClazzData(' + pageNum + ')" class="button">' + pageNum + '</button>');
                }
            }
            
            // 下一页
            if (pageBean.index < pageBean.totalPage) {
                pagination.append('<button onclick="loadClazzData(' + (pageBean.index + 1) + ')" class="button">下一页</button>');
            }
        }
    }

    function updateClazz(cid) {
        window.location.href = 'updateClazz.jsp?cid=' + cid;
    }

    function deleteClazz(cid) {
        if (confirm('确定要删除该班级吗？')) {
            $.get('ClazzServlet', { methodName: 'deleteClazz', cid: cid }, function (data) {
                if (data == '1') {
                    alert('删除成功');
                    loadClazzData(1);
                } else {
                    alert('删除失败');
                }
            });
        }
    }
</script>
</body>
</html>
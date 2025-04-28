<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>通知公告列表</title>
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
            padding: 20px;
            border-radius: 8px 8px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .panel-head strong {
            font-size: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .search-box {
            background: #f8f9fa;
            padding: 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .search-input {
            flex: 1;
            max-width: 300px;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 8px 12px;
            font-size: 14px;
        }
        
        .btn {
            background: #3498db;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s;
        }
        
        .btn:hover {
            background: #2980b9;
        }
        
        .btn-delete {
            background: #e74c3c;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
            transition: all 0.3s;
        }
        
        .btn-delete:hover {
            background: #c0392b;
        }
        
        .table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin: 0;
        }
        
        .table th {
            background: #f4f6f9;
            color: #2c3e50;
            font-weight: 600;
            padding: 15px;
            text-align: left;
            border-bottom: 2px solid #e9ecef;
        }
        
        .table td {
            padding: 15px;
            border-bottom: 1px solid #eee;
            vertical-align: middle;
        }
        
        .table tr:hover td {
            background: #f8f9fa;
        }
        
        .announcement-title {
            color: #2c3e50;
            font-weight: 500;
        }
        
        .announcement-content {
            color: #666;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            max-width: 400px;
        }
        
        .announcement-date {
            color: #7f8c8d;
            font-size: 13px;
        }
        
        .loading {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: rgba(0,0,0,0.7);
            color: white;
            padding: 20px 40px;
            border-radius: 8px;
            display: none;
        }
    </style>

    <script>
        $(function () {
            loadAnnouncements();

            $('#searchBtn').click(function () {
                var keyword = $('#keyword').val();
                $.ajax({
                    url: 'AnnouncementServlet',
                    method: 'GET',
                    data: { 
                        method: 'searchAnnouncements', 
                        keyword: keyword 
                    },
                    dataType: 'json',
                    success: function(announcements) {
                        displayAnnouncements(announcements);
                    },
                    error: function(xhr, status, error) {
                        console.error("请求失败:", error);
                        alert("加载数据失败");
                    }
                });
            });

            $('#addBtn').click(function () {
                location.href = 'saveAnnouncement.jsp';
            });
        });

        function loadAnnouncements() {
            $.ajax({
                url: 'AnnouncementServlet',
                type: 'GET',
                data: {method: 'getAllAnnouncements'},
                success: function(data) {
                    console.log('收到公告数据:', data);
                    if (typeof data === 'string') {
                        try {
                            data = JSON.parse(data);
                        } catch(e) {
                            console.error('JSON解析错误:', e);
                            $('#announcementList').html('<tr><td colspan="5" class="text-center">数据解析失败</td></tr>');
                            return;
                        }
                    }
                    displayAnnouncements(data);
                },
                error: function(xhr, status, error) {
                    console.error('加载公告数据失败:', error);
                    $('#announcementList').html('<div class="alert alert-danger">加载数据失败，请稍后重试</div>');
                }
            });
        }

        function displayAnnouncements(data) {
            if (!data) {
                $('#announcementList').html('<tr><td colspan="5" class="text-center">暂无数据</td></tr>');
                return;
            }
            
            var html = '';
            
            if(data && data.length > 0) {
                data.forEach(function(item) {
                    html += '<tr>';
                    html += '<td class="announcement-title">' + (item.title || '-') + '</td>';
                    html += '<td class="announcement-content">' + (item.content || '-') + '</td>';
                    html += '<td class="announcement-date">' + formatDate(item.publishDate) + '</td>';
                    html += '<td>' + (item.publisher || '-') + '</td>';
                    html += '<td>' +
                          '<button class="btn btn-xs btn-primary" onclick="editAnnouncement(' + item.anid + ')">' +
                          '<i class="fa fa-edit"></i> 编辑</button> ' +
                          '<button class="btn btn-xs btn-danger" onclick="deleteAnnouncement(' + item.anid + ')">' +
                          '<i class="fa fa-trash"></i> 删除</button>' +
                          '</td>';
                    html += '</tr>';
                });
            } else {
                html += '<tr><td colspan="5" class="text-center">暂无公告</td></tr>';
            }
            
            $('#announcementList tbody').html(html);
        }

        function deleteAnnouncement(anid) {
            if (confirm('确定要删除该通知公告吗？此操作不可恢复。')) {
                $.get('AnnouncementServlet', {
                    method: 'deleteAnnouncement',
                    anid: anid
                }, function(data) {
                    if (data == '1') {
                        alert('删除成功');
                        loadAnnouncements();
                    } else {
                        alert('删除失败，请稍后重试');
                    }
                });
            }
        }

        function formatDate(dateStr) {
            if (!dateStr) return '-';
            try {
                let date = new Date(dateStr);
                return date.getFullYear() + '-' + 
                       padZero(date.getMonth() + 1) + '-' + 
                       padZero(date.getDate());
            } catch (e) {
                console.error('日期格式化错误:', e);
                return dateStr;
            }
        }

        function padZero(num) {
            return num < 10 ? '0' + num : num;
        }

        function editAnnouncement(anid) {
            window.location.href = 'editAnnouncement.jsp?anid=' + anid;
        }
    </script>
</head>
<body>
    <div class="panel">
        <div class="panel-head">
            <strong>
                <i class="fas fa-bullhorn"></i>
                通知公告列表
            </strong>
            <button class="btn" id="addBtn">
                <i class="fas fa-plus"></i> 
                添加公告
            </button>
        </div>

        <div class="search-box">
            <input type="text" placeholder="请输入搜索关键字" id="keyword" class="search-input"/>
            <button class="btn" id="searchBtn">
                <i class="fas fa-search"></i> 
                搜索
            </button>
        </div>

        <table class="table" id="announcementList">
            <thead>
                <tr>
                    <th width="15%">标题</th>
                    <th width="40%">内容</th>
                    <th width="15%">发布时间</th>
                    <th width="10%">发布人</th>
                    <th width="20%">操作</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td colspan="5" class="text-center">加载中...</td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="loading">
        <i class="fas fa-spinner fa-spin"></i> 
        加载中...
    </div>
</body>
</html>
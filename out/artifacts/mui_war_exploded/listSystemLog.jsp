<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>系统日志列表</title>
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
        
        .log-operation {
            color: #2c3e50;
            font-weight: 500;
        }
        
        .log-time {
            color: #7f8c8d;
            font-size: 13px;
        }
        
        .log-user {
            color: #3498db;
            font-weight: 500;
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
        $(function() {
            loadSystemLogs();

            $('#searchBtn').click(function() {
                var keyword = $('#keyword').val();
                searchSystemLogs(keyword);
            });

            $('#keyword').keypress(function(e) {
                if(e.which == 13) {
                    $('#searchBtn').click();
                }
            });
        });

        function loadSystemLogs() {
            $('.loading').show();
            $.ajax({
                url: 'SystemLogServlet',
                method: 'GET',
                data: { method: 'getAllSystemLogs' },
                dataType: 'json',
                success: function(logs) {
                    displaySystemLogs(logs);
                },
                error: function(xhr, status, error) {
                    console.error("请求失败:", error);
                    alert("加载数据失败");
                },
                complete: function() {
                    $('.loading').hide();
                }
            });
        }

        function searchSystemLogs(keyword) {
            $('.loading').show();
            $.ajax({
                url: 'SystemLogServlet',
                method: 'GET',
                data: { 
                    method: 'searchSystemLogs',
                    keyword: keyword
                },
                dataType: 'json',
                success: function(logs) {
                    displaySystemLogs(logs);
                },
                error: function(xhr, status, error) {
                    console.error("请求失败:", error);
                    alert("搜索失败");
                },
                complete: function() {
                    $('.loading').hide();
                }
            });
        }

        function displaySystemLogs(logs) {
            var tbody = $('#systemLogList tbody');
            tbody.empty();
            if (!logs || logs.length === 0) {
                tbody.append('<tr><td colspan="3" class="text-center">暂无系统日志</td></tr>');
                return;
            }
            logs.forEach(function(log) {
                tbody.append(
                    '<tr>' +
                    '<td class="log-operation">' + 
                        '<span class="module-badge">' + log.module + '</span> ' +
                        log.operation + 
                    '</td>' +
                    '<td class="log-time">' + formatDate(log.logTime) + '</td>' +
                    '<td class="log-user">用户ID: ' + log.uid + '</td>' +
                    '</tr>'
                );
            });
        }

        function formatDate(dateStr) {
            if (!dateStr) return '-';
            try {
                const date = new Date(dateStr);
                if (isNaN(date.getTime())) {
                    return dateStr;
                }
                return date.toLocaleString('zh-CN', {
                    year: 'numeric',
                    month: '2-digit',
                    day: '2-digit',
                    hour: '2-digit',
                    minute: '2-digit',
                    second: '2-digit'
                }).replace(/\//g, '-');
            } catch (e) {
                console.error('日期格式化失败:', e);
                return dateStr;
            }
        }
    </script>
</head>
<body>
    <div class="panel">
        <div class="panel-head">
            <strong>
                <i class="fas fa-history"></i>
                系统日志列表
            </strong>
        </div>

        <div class="search-box">
            <input type="text" placeholder="请输入搜索关键字" id="keyword" class="search-input"/>
            <button class="btn" id="searchBtn">
                <i class="fas fa-search"></i> 
                搜索
            </button>
        </div>

        <table class="table" id="systemLogList">
            <thead>
                <tr>
                    <th width="50%">操作内容</th>
                    <th width="25%">操作时间</th>
                    <th width="25%">操作人</th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>

    <div class="loading">
        <i class="fas fa-spinner fa-spin"></i> 
        加载中...
    </div>
</body>
</html>
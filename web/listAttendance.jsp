<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>考勤记录列表</title>
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
            min-height: calc(100vh - 40px);
            display: flex;
            flex-direction: column;
        }
        
        .panel-head {
            background: linear-gradient(120deg, #2c3e50, #3498db);
            color: white;
            padding: 20px 25px;
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
            transition: all 0.3s;
        }
        
        .search-input:focus {
            border-color: #3498db;
            box-shadow: 0 0 5px rgba(52,152,219,0.3);
        }
        
        .search-btn {
            padding: 8px 20px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .search-btn:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }
        
        .table-container {
            padding: 20px;
            flex: 1;
            overflow: auto;
        }
        
        .table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: white;
        }
        
        .table th {
            background: #f4f6f9;
            color: #2c3e50;
            font-weight: 600;
            padding: 16px;
            text-align: left;
            border-bottom: 2px solid #e9ecef;
            white-space: nowrap;
        }
        
        .table td {
            padding: 16px;
            border-bottom: 1px solid #eee;
            vertical-align: middle;
            line-height: 1.6;
        }
        
        .table tr:hover td {
            background: #f8f9fa;
        }
        
        .status-cell {
            font-weight: 500;
        }
        
        .status-present {
            color: #27ae60;
        }
        
        .status-absent {
            color: #e74c3c;
        }
        
        .status-late {
            color: #f39c12;
        }
        
        .btn-delete {
            padding: 8px 16px;
            background: #e74c3c;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 14px;
        }
        
        .btn-delete:hover {
            background: #c0392b;
            transform: translateY(-2px);
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
            z-index: 1000;
        }

        .status-badge {
            padding: 3px 8px;
            border-radius: 3px;
            font-size: 12px;
            font-weight: 500;
        }

        .table { 
            width: 100%;
            margin-bottom: 1rem;
            background-color: transparent;
        }

        .table th,
        .table td {
            padding: 0.75rem;
            vertical-align: middle;
            border-top: 1px solid #dee2e6;
            text-align: center;
        }

        .table thead th {
            vertical-align: bottom;
            border-bottom: 2px solid #dee2e6;
            background-color: #f8f9fa;
        }

        .table tbody tr:hover {
            background-color: rgba(0,0,0,.075);
        }

        .btn {
            display: inline-block;
            padding: 0.375rem 0.75rem;
            font-size: 0.875rem;
            line-height: 1.5;
            border-radius: 0.25rem;
            cursor: pointer;
            margin: 0 2px;
        }

        .btn-xs {
            padding: 0.25rem 0.4rem;
            font-size: 0.75rem;
        }

        .btn-primary {
            color: #fff;
            background-color: #007bff;
            border: 1px solid #0056b3;
        }

        .btn-danger {
            color: #fff;
            background-color: #dc3545;
            border: 1px solid #bd2130;
        }

        .text-center {
            text-align: center;
        }

        .alert {
            padding: 0.75rem 1.25rem;
            margin-bottom: 1rem;
            border: 1px solid transparent;
            border-radius: 0.25rem;
        }

        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }

        /* 考勤状态颜色 */
        .status-normal {
            color: #000000;  /* 黑色 - 正常出勤 */
        }

        .status-absent {
            color: #dc3545;  /* 红色 - 缺勤 */
        }

        .status-late {
            color: #ffc107;  /* 黄色 - 迟到 */
        }

        .status-leave {
            color: #17a2b8;  /* 蓝色 - 请假 */
        }
    </style>

    <script>
        $(function() {
            // 页面加载完成后立即加载数据
            loadAttendances();
            
            // 搜索按钮点击事件
            $('#searchBtn').click(function() {
                searchAttendances();
            });

            // 添加回车搜索功能
            $('#keyword').keypress(function(e) {
                if(e.which == 13) {
                    searchAttendances();
                }
            });
        });

        function loadAttendances() {
            $('#attendanceList').html('<div class="text-center" style="padding: 20px;"><i class="fas fa-spinner fa-spin"></i> 正在加载考勤数据...</div>');
            
            $.ajax({
                url: 'AttendanceServlet',
                type: 'GET',
                data: {
                    method: 'getAllAttendances'
                },
                success: function(data) {
                    console.log('收到考勤数据:', data);
                    if (typeof data === 'string') {
                        try {
                            data = JSON.parse(data);
                        } catch (e) {
                            console.error("JSON解析失败:", e);
                            $('#attendanceList').html('<div class="alert alert-danger">数据解析失败: ' + e.message + '</div>');
                            return;
                        }
                    }
                    
                    if (data && data.error) {
                        $('#attendanceList').html('<div class="alert alert-danger">服务器错误: ' + data.error + '</div>');
                        return;
                    }
                    
                    var html = '<table class="table table-hover">' +
                              '<thead>' +
                              '<tr>' +
                              '<th>学生姓名</th>' +
                              '<th>课程名称</th>' +
                              '<th>考勤日期</th>' +
                              '<th>考勤状态</th>' +
                              '<th>操作</th>' +
                              '</tr>' +
                              '</thead>' +
                              '<tbody>';

                    if(data && data.length > 0) {
                        data.forEach(function(item) {
                            html += '<tr>';
                            html += '<td>' + (item.studentName || item.sid || '-') + '</td>';
                            html += '<td>' + (item.courseName || item.cid || '-') + '</td>';
                            html += '<td>' + formatDate(item.attendanceDate) + '</td>';
                            html += '<td><span class="status-badge status-' + getStatusClass(item.status) + '">' + 
                                   item.status + '</span></td>';
                            html += '<td>' +
                                   '<button class="btn btn-xs btn-primary" onclick="editAttendance(' + item.aid + ')">' +
                                   '<i class="fa fa-edit"></i> 编辑</button> ' +
                                   '<button class="btn btn-xs btn-danger" onclick="deleteAttendance(' + item.aid + ')">' +
                                   '<i class="fa fa-trash"></i> 删除</button>' +
                                   '</td>';
                            html += '</tr>';
                        });
                    } else {
                        html += '<tr><td colspan="5" class="text-center">暂无考勤记录</td></tr>';
                    }
                    
                    html += '</tbody></table>';
                    $('#attendanceList').html(html);
                },
                error: function(xhr, status, error) {
                    console.error('加载考勤数据失败:', error);
                    console.error('状态码:', xhr.status);
                    console.error('响应文本:', xhr.responseText);
                    
                    var errorMsg = '加载数据失败';
                    try {
                        var response = JSON.parse(xhr.responseText);
                        if (response && response.error) {
                            errorMsg += ': ' + response.error;
                        }
                    } catch (e) {
                        errorMsg += '，请稍后重试 (' + xhr.status + ')';
                    }
                    
                    $('#attendanceList').html('<div class="alert alert-danger">' + errorMsg + '</div>');
                }
            });
        }

        function getStatusClass(status) {
            switch(status) {
                case '出勤': return 'normal';
                case '缺勤': return 'absent';
                case '迟到': return 'late';
                case '请假': return 'leave';
                default: return 'normal';
            }
        }

        function getStatusText(status) {
            return status || '未知';  // 因为数据库已经存储的是中文状态，所以直接返回
        }

        function deleteAttendance(aid) {
            if (confirm('确定要删除该考勤记录吗？此操作不可恢复。')) {
                $.get('AttendanceServlet', {
                    method: 'deleteAttendance',
                    aid: aid
                }, function(data) {
                    if (data == '1') {
                        alert('删除成功');
                        loadAttendances();
                    } else {
                        alert('删除失败，请稍后重试');
                    }
                });
            }
        }
        
        function editAttendance(aid) {
            window.location.href = 'editAttendance.jsp?aid=' + aid;
        }

        function formatDate(dateStr) {
            if (!dateStr) return '-';
            try {
                // 处理日期格式
                let date = new Date(dateStr);
                if (isNaN(date.getTime())) {
                    // 如果是 "2024-04-01" 这样的格式
                    let parts = dateStr.split('-');
                    if (parts.length === 3) {
                        return dateStr; // 已经是正确格式就直接返回
                    }
                    return dateStr;
                }
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

        // 添加搜索功能
        function searchAttendances() {
            var keyword = $('#keyword').val();
            console.log("搜索关键词:", keyword);
            
            // 如果关键词为空，则加载全部数据
            if (!keyword || keyword.trim() === '') {
                loadAttendances();
                return;
            }
            
            $.ajax({
                url: 'AttendanceServlet',
                type: 'GET',
                data: {
                    method: 'searchAttendances',
                    keyword: keyword
                },
                success: function(data) {
                    console.log('搜索结果数据:', data);
                    if (typeof data === 'string') {
                        try {
                            data = JSON.parse(data);
                        } catch (e) {
                            console.error('解析搜索结果数据失败:', e);
                            $('#attendanceList').html('<div class="alert alert-danger">数据解析失败</div>');
                            return;
                        }
                    }
                    
                    var html = '<table class="table">';
                    html += '<thead><tr>';
                    html += '<th>学生姓名</th>';
                    html += '<th>课程名称</th>';
                    html += '<th>考勤日期</th>';
                    html += '<th>考勤状态</th>';
                    html += '<th>操作</th>';
                    html += '</tr></thead>';
                    html += '<tbody>';
                    
                    if (data && data.length > 0) {
                        data.forEach(function(item) {
                            html += '<tr>';
                            html += '<td>' + (item.studentName || '未知') + '</td>';
                            html += '<td>' + (item.courseName || '未知') + '</td>';
                            html += '<td>' + formatDate(item.attendanceDate) + '</td>';
                            
                            var statusClass = getStatusClass(item.status);
                            html += '<td><span class="status-' + statusClass + '">' + getStatusText(item.status) + '</span></td>';
                            
                            html += '<td>' +
                                   '<button class="btn btn-xs btn-primary" onclick="editAttendance(' + item.aid + ')">' +
                                   '<i class="fa fa-edit"></i> 编辑</button> ' +
                                   '<button class="btn btn-xs btn-danger" onclick="deleteAttendance(' + item.aid + ')">' +
                                   '<i class="fa fa-trash"></i> 删除</button>' +
                                   '</td>';
                            html += '</tr>';
                        });
                    } else {
                        html += '<tr><td colspan="5" class="text-center">没有找到匹配的考勤记录</td></tr>';
                    }
                    
                    html += '</tbody></table>';
                    $('#attendanceList').html(html);
                },
                error: function(xhr, status, error) {
                    console.error('搜索考勤数据失败:', error);
                    $('#attendanceList').html('<div class="alert alert-danger">搜索失败，请稍后重试</div>');
                }
            });
        }
    </script>
</head>
<body>
    <div class="panel">
        <div class="panel-head">
            <strong>
                <i class="fas fa-clipboard-check"></i>
                考勤记录列表
            </strong>
            <button class="btn" id="addBtn" onclick="window.location.href='addAttendance.jsp'">
                <i class="fas fa-plus"></i> 
                添加考勤
            </button>
        </div>

        <div class="search-box">
            <input type="text" placeholder="请输入学生姓名或课程名称" id="keyword" class="search-input"/>
            <button class="search-btn" id="searchBtn">
                <i class="fas fa-search"></i> 搜索
            </button>
        </div>

        <div class="table-container">
            <table class="table" id="attendanceList">
                <thead>
                    <tr>
                        <th width="20%">学生姓名</th>
                        <th width="20%">课程名称</th>
                        <th width="20%">考勤日期</th>
                        <th width="20%">考勤状态</th>
                        <th width="20%">操作</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>

    <div class="loading">
        <i class="fas fa-spinner fa-spin"></i> 加载中...
    </div>
</body>
</html>
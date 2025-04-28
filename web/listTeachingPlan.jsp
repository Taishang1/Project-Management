<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>教学计划列表</title>
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
        
        .description-cell {
            max-width: 300px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        .description-cell:hover {
            white-space: normal;
            overflow: visible;
            background: white;
            position: relative;
            z-index: 1;
            box-shadow: 0 2px 12px rgba(0,0,0,0.1);
            border-radius: 4px;
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
        
        .date-cell {
            white-space: nowrap;
            color: #666;
        }
        
        .id-cell {
            font-family: monospace;
            color: #666;
        }
        
        .btn-add {
            padding: 10px 20px;
            background: #27ae60;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 15px;
            text-decoration: none;
        }
        
        .btn-add:hover {
            background: #2ecc71;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        .debug-info {
            font-size: 12px;
            color: #999;
            margin-top: 10px;
            font-style: italic;
            padding: 10px;
            border-top: 1px solid #eee;
        }
    </style>

    <script>
        $(function() {
            console.log("页面加载完成，开始获取教学计划数据...");
            loadTeachingPlans();
            
            // 添加加载动画
            $(document).ajaxStart(function() {
                $('.loading').show();
            }).ajaxStop(function() {
                $('.loading').hide();
            });
        });

        function loadTeachingPlans() {
            $.ajax({
                url: 'TeachingPlanServlet',
                type: 'GET',
                data: { methodName: 'getAllTeachingPlans' },
                success: function(data) {
                    console.log("教学计划数据获取成功:", data);
                    
                    // 判断返回数据类型
                    var teachingPlans;
                    if (typeof data === 'string') {
                        try {
                            teachingPlans = JSON.parse(data);
                            console.log("成功解析教学计划JSON数据");
                        } catch (e) {
                            // 尝试使用eval解析
                            try {
                                eval('teachingPlans = ' + data);
                                console.log("通过eval解析教学计划数据成功");
                            } catch (evalError) {
                                console.error("教学计划数据解析失败:", evalError);
                                $('#teachingPlanList tbody').html('<tr><td colspan="7" class="text-center">数据解析错误</td></tr>');
                                $('#debug-info').html('解析教学计划数据失败: ' + evalError.message + '<br>原始数据: ' + data);
                                return;
                            }
                        }
                    } else {
                        teachingPlans = data;
                        console.log("服务器直接返回了教学计划JavaScript对象");
                    }
                    
                    displayTeachingPlans(teachingPlans);
                },
                error: function(xhr, status, error) {
                    console.error("获取教学计划列表失败:", status, error);
                    $('#teachingPlanList tbody').html('<tr><td colspan="7" class="text-center">获取数据失败</td></tr>');
                    $('#debug-info').html('获取教学计划失败: ' + error + '<br>状态码: ' + xhr.status);
                }
            });
        }

        function displayTeachingPlans(teachingPlans) {
            var tbody = $('#teachingPlanList tbody');
            tbody.empty();
            
            if (!teachingPlans || teachingPlans.length === 0) {
                tbody.append('<tr><td colspan="7" class="text-center">暂无教学计划数据</td></tr>');
                $('#debug-info').html('没有找到教学计划数据');
                return;
            }
            
            console.log("显示教学计划数据，共" + teachingPlans.length + "条记录");
            $('#debug-info').html('成功加载' + teachingPlans.length + '条教学计划数据');
            
            teachingPlans.forEach(function(tp) {
                tbody.append(
                    '<tr>' +
                    '<td class="id-cell">' + tp.tpid + '</td>' +
                    '<td class="id-cell">' + tp.cid + '</td>' +
                    '<td class="id-cell">' + tp.tid + '</td>' +
                    '<td class="date-cell">' + formatDate(tp.startDate) + '</td>' +
                    '<td class="date-cell">' + formatDate(tp.endDate) + '</td>' +
                    '<td class="description-cell">' + (tp.description || '暂无描述') + '</td>' +
                    '<td>' +
                    '<button class="btn-delete" onclick="deleteTeachingPlan(' + tp.tpid + ')">' +
                    '<i class="fas fa-trash-alt"></i> 删除</button>' +
                    '</td>' +
                    '</tr>'
                );
            });
        }

        function deleteTeachingPlan(tpid) {
            if (confirm('确定要删除该教学计划吗？此操作不可恢复。')) {
                $.ajax({
                    url: 'TeachingPlanServlet',
                    type: 'GET',
                    data: {
                        methodName: 'deleteTeachingPlan',
                        tpid: tpid
                    },
                    success: function(data) {
                        if (data == '1') {
                            alert('删除成功');
                            loadTeachingPlans();
                        } else {
                            alert('删除失败，请稍后重试');
                        }
                    },
                    error: function() {
                        alert('删除请求失败，请检查网络连接');
                    }
                });
            }
        }

        function formatDate(dateStr) {
            if (!dateStr) return '-';
            try {
                const date = new Date(dateStr);
                if (isNaN(date.getTime())) {
                    return dateStr;
                }
                return date.toLocaleDateString('zh-CN', {
                    year: 'numeric',
                    month: '2-digit',
                    day: '2-digit'
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
                <i class="fas fa-calendar-alt"></i>
                教学计划列表
            </strong>
            <a href="addTeachingPlan.jsp" class="btn-add">
                <i class="fas fa-plus"></i> 添加教学计划
            </a>
        </div>

        <div class="table-container">
            <table class="table" id="teachingPlanList">
                <thead>
                    <tr>
                        <th width="8%">计划ID</th>
                        <th width="10%">课程ID</th>
                        <th width="10%">教师ID</th>
                        <th width="15%">开始日期</th>
                        <th width="15%">结束日期</th>
                        <th width="30%">描述</th>
                        <th width="12%">操作</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td colspan="7" class="text-center">加载中...</td>
                    </tr>
                </tbody>
            </table>
            <div id="debug-info" class="debug-info"></div>
        </div>
    </div>

    <div class="loading">
        <i class="fas fa-spinner fa-spin"></i> 加载中...
    </div>
</body>
</html>
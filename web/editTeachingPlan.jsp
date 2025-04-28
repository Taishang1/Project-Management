<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>编辑教学计划</title>
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
            padding: 20px;
        }
        
        .panel-head {
            background: linear-gradient(120deg, #2c3e50, #3498db);
            color: white;
            padding: 15px 20px;
            border-radius: 8px 8px 0 0;
            margin: -20px -20px 20px -20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .label {
            display: block;
            margin-bottom: 8px;
            color: #2c3e50;
            font-weight: 500;
        }
        
        .field input, .field textarea {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .field input:focus, .field textarea:focus {
            border-color: #3498db;
            box-shadow: 0 0 5px rgba(52,152,219,0.3);
        }
        
        .btn {
            padding: 8px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
            border: none;
            margin-right: 10px;
        }
        
        .btn-primary {
            background: #3498db;
            color: white;
        }
        
        .btn-primary:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }
        
        .btn-default {
            background: #95a5a6;
            color: white;
        }
        
        .btn-default:hover {
            background: #7f8c8d;
            transform: translateY(-2px);
        }
        
        .button-group {
            margin-top: 30px;
            display: flex;
            justify-content: flex-start;
            align-items: center;
        }
    </style>

    <script>
        $(function () {
            var tpid = '<%= request.getParameter("tpid") %>';
            console.log("正在加载教学计划ID:", tpid);
            
            if (tpid && tpid != 'null') {
                // 使用直接方式获取课程和教师数据
                console.log("尝试直接获取ID为 " + tpid + " 的教学计划数据");
                
                $.ajax({
                    url: 'TeachingPlanServlet',
                    method: 'GET',
                    data: { 
                        methodName: 'getAllTeachingPlans'
                    },
                    dataType: 'text',
                    beforeSend: function() {
                        console.log("发送请求到服务器获取所有教学计划...");
                    },
                    success: function (data) {
                        console.log("服务器响应数据:", data);
                        console.log("响应数据类型:", typeof data);
                        console.log("响应数据长度:", data.length);
                        
                        if (!data || data.trim() === '') {
                            console.error("服务器返回空响应");
                            alert("服务器返回空响应，请检查服务器日志");
                            return;
                        }

                        try {
                            // 解析所有教学计划，然后筛选出我们需要的那一个
                            var cleanData = data.trim();
                            var teachingPlans = JSON.parse(cleanData);
                            console.log("成功解析教学计划数据:", teachingPlans);
                            
                            // 在列表中查找指定ID的教学计划
                            var targetPlan = null;
                            for (var i = 0; i < teachingPlans.length; i++) {
                                if (teachingPlans[i].tpid == tpid) {
                                    targetPlan = teachingPlans[i];
                                    break;
                                }
                            }
                            
                            if (targetPlan) {
                                console.log("找到ID为 " + tpid + " 的教学计划:", targetPlan);
                                $('#cid').val(targetPlan.cid || '');
                                $('#tid').val(targetPlan.tid || '');
                                $('#start_date').val(targetPlan.startDate ? targetPlan.startDate.split(' ')[0] : '');
                                $('#end_date').val(targetPlan.endDate ? targetPlan.endDate.split(' ')[0] : '');
                                $('#description').val(targetPlan.description || '');
                            } else {
                                console.error("在结果中未找到ID为 " + tpid + " 的教学计划");
                                alert("未找到ID为 " + tpid + " 的教学计划");
                            }
                        } catch (e) {
                            console.error("JSON解析失败:", e);
                            console.error("原始数据:", data);
                            alert("加载教学计划数据失败: " + e.message + "\n请检查服务器响应格式");
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error("请求失败:", {
                            status: status,
                            error: error,
                            responseText: xhr.responseText,
                            statusText: xhr.statusText,
                            readyState: xhr.readyState
                        });
                        alert("加载教学计划数据失败: " + error + "\n状态码: " + xhr.status);
                    }
                });
            } else {
                alert("无效的教学计划ID");
                location.href = 'listTeachingPlan.jsp';
            }

            // 提交表单
            $('#submitBtn').click(function () {
                var cid = $('#cid').val();
                var tid = $('#tid').val();
                var startDate = $('#start_date').val();
                var endDate = $('#end_date').val();
                var description = $('#description').val();

                if (!cid || !tid || !startDate || !endDate) {
                    alert('请填写完整信息');
                    return;
                }

                $.ajax({
                    url: 'TeachingPlanServlet',
                    method: 'POST',
                    data: {
                        methodName: 'updateTeachingPlan',
                        tpid: tpid,
                        cid: cid,
                        tid: tid,
                        start_date: startDate,
                        end_date: endDate,
                        description: description
                    },
                    success: function (data) {
                        console.log("更新响应:", data);
                        if (data == '1') {
                            alert('更新成功');
                            location.href = 'listTeachingPlan.jsp';
                        } else {
                            alert('更新失败，服务器返回: ' + data);
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error("更新失败:", {
                            status: status,
                            error: error,
                            responseText: xhr.responseText
                        });
                        alert("更新教学计划失败: " + error);
                    }
                });
            });

            // 返回按钮
            $('#backBtn').click(function() {
                location.href = 'listTeachingPlan.jsp';
            });
        });
    </script>
</head>
<body>
<div class="panel">
    <div class="panel-head">
        <strong><i class="fas fa-edit"></i> 编辑教学计划</strong>
    </div>
    <div class="body-content">
        <form method="post" class="form-x" action="">
            <div class="form-group">
                <div class="label">
                    <label>课程ID：</label>
                </div>
                <div class="field">
                    <input type="text" name="cid" id="cid" value=""/>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label>教师ID：</label>
                </div>
                <div class="field">
                    <input type="text" name="tid" id="tid" value=""/>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label>开始日期：</label>
                </div>
                <div class="field">
                    <input type="date" name="start_date" id="start_date" value=""/>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label>结束日期：</label>
                </div>
                <div class="field">
                    <input type="date" name="end_date" id="end_date" value=""/>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label>描述：</label>
                </div>
                <div class="field">
                    <textarea name="description" id="description"></textarea>
                </div>
            </div>
            <div class="button-group">
                <button class="btn btn-primary" id="submitBtn" type="button">
                    <i class="fas fa-save"></i> 保存
                </button>
                <button class="btn btn-default" id="backBtn" type="button">
                    <i class="fas fa-arrow-left"></i> 返回
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html> 
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>添加考勤记录</title>
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
        
        .field select, .field input[type="date"] {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .field select:focus, .field input[type="date"]:focus {
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
            console.log("页面初始化 - 开始加载学生和课程数据");
            
            // 加载学生列表
            $.ajax({
                url: 'StudentServlet',
                type: 'GET',
                data: { methodName: 'getAllStudents' },
                success: function (response) {
                    console.log("学生原始数据:", response);
                    console.log("数据类型:", typeof response);
                    console.log("数据长度:", response ? response.length : 0);
                    
                    try {
                        var data;
                        if (typeof response === 'string') {
                            // 检查是否为空字符串
                            if (response.trim() === '') {
                                console.log("收到空响应");
                                alert("未能获取学生数据（空响应）");
                                return;
                            }
                            try {
                                data = JSON.parse(response);
                            } catch (e) {
                                console.error("JSON解析失败:", e);
                                console.log("尝试使用eval解析");
                                try {
                                    eval("data = " + response);
                                } catch (e2) {
                                    console.error("eval解析也失败:", e2);
                                    alert("解析学生数据失败: " + e.message);
                                    return;
                                }
                            }
                        } else {
                            data = response;
                        }
                        
                        console.log("处理后的学生数据:", data);
                        var select = $('#sid');
                        select.empty().append('<option value="">--请选择学生--</option>');
                        
                        if (data && data.length > 0) {
                            for (var i = 0; i < data.length; i++) {
                                select.append('<option value="' + data[i].sid + '">' + data[i].sname + '</option>');
                            }
                            console.log("已加载" + data.length + "个学生数据");
                        } else {
                            console.log("无学生数据或格式不正确");
                            select.append('<option value="">暂无学生数据</option>');
                        }
                    } catch (e) {
                        console.error("处理学生数据失败:", e);
                        alert("加载学生数据失败: " + e.message);
                    }
                },
                error: function (xhr, status, error) {
                    console.error("请求学生数据失败:", error);
                    console.error("状态码:", xhr.status);
                    console.error("响应文本:", xhr.responseText);
                    alert("加载学生数据失败: " + error);
                }
            });

            // 加载课程列表
            $.ajax({
                url: 'CourseServlet',
                type: 'GET',
                data: { methodName: 'getAllCourses' },
                success: function (response) {
                    console.log("课程原始数据:", response);
                    console.log("数据类型:", typeof response);
                    console.log("数据长度:", response ? response.length : 0);
                    
                    try {
                        var data;
                        if (typeof response === 'string') {
                            // 检查是否为空字符串
                            if (response.trim() === '') {
                                console.log("收到空响应");
                                alert("未能获取课程数据（空响应）");
                                return;
                            }
                            try {
                                data = JSON.parse(response);
                            } catch (e) {
                                console.error("JSON解析失败:", e);
                                console.log("尝试使用eval解析");
                                try {
                                    eval("data = " + response);
                                } catch (e2) {
                                    console.error("eval解析也失败:", e2);
                                    alert("解析课程数据失败: " + e.message);
                                    return;
                                }
                            }
                        } else {
                            data = response;
                        }
                        
                        console.log("处理后的课程数据:", data);
                        var select = $('#cid');
                        select.empty().append('<option value="">--请选择课程--</option>');
                        
                        if (data && data.length > 0) {
                            for (var i = 0; i < data.length; i++) {
                                select.append('<option value="' + data[i].cid + '">' + data[i].cname + '</option>');
                            }
                            console.log("已加载" + data.length + "个课程数据");
                        } else {
                            console.log("无课程数据或格式不正确");
                            select.append('<option value="">暂无课程数据</option>');
                        }
                    } catch (e) {
                        console.error("处理课程数据失败:", e);
                        alert("加载课程数据失败: " + e.message);
                    }
                },
                error: function (xhr, status, error) {
                    console.error("请求课程数据失败:", error);
                    console.error("状态码:", xhr.status);
                    console.error("响应文本:", xhr.responseText);
                    alert("加载课程数据失败: " + error);
                }
            });

            // 提交表单
            $('#submitBtn').click(function () {
                var sid = $('#sid').val();
                var cid = $('#cid').val();
                var attendanceDate = $('#attendance_date').val();
                var status = $('#status').val();

                if (!sid || !cid || !attendanceDate || !status) {
                    alert('请填写完整信息');
                    return;
                }

                $.ajax({
                    url: 'AttendanceServlet',
                    type: 'POST',
                    data: {
                        method: 'addAttendance',
                        sid: sid,
                        cid: cid,
                        attendance_date: attendanceDate,
                        status: status
                    },
                    success: function (data) {
                        if (data == '1') {
                            alert('添加成功');
                            location.href = 'listAttendance.jsp';
                        } else {
                            alert('添加失败');
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error("提交失败:", error);
                        alert("添加考勤失败: " + error);
                    }
                });
            });

            // 返回按钮
            $('#backBtn').click(function() {
                location.href = 'listAttendance.jsp';
            });
        });
    </script>
</head>
<body>
<div class="panel">
    <div class="panel-head">
        <strong><i class="fas fa-plus-circle"></i> 添加考勤记录</strong>
    </div>
    <div class="body-content">
        <form method="post" class="form-x" action="">
            <div class="form-group">
                <div class="label">
                    <label>学生：</label>
                </div>
                <div class="field">
                    <select name="sid" id="sid">
                        <option value="">--请选择学生--</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label>课程：</label>
                </div>
                <div class="field">
                    <select name="cid" id="cid">
                        <option value="">--请选择课程--</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label>考勤日期：</label>
                </div>
                <div class="field">
                    <input type="date" name="attendance_date" id="attendance_date" value=""/>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label>状态：</label>
                </div>
                <div class="field">
                    <select name="status" id="status">
                        <option value="出勤">出勤</option>
                        <option value="迟到">迟到</option>
                        <option value="早退">早退</option>
                        <option value="旷课">旷课</option>
                    </select>
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
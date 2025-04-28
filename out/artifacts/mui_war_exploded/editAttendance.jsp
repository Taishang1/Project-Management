<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bkty.entity.Attendance" %>
<%@ page import="com.bkty.service.AttendanceService" %>
<%@ page import="com.bkty.service.impl.AttendanceServiceImpl" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>编辑考勤记录</title>
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
        
        .input-display {
            padding: 8px 12px;
            border: 1px solid #e0e0e0;
            background-color: #f5f5f5;
            border-radius: 4px;
            min-height: 20px;
            font-size: 14px;
            color: #333;
            font-weight: 500;
        }
    </style>

    <script>
        $(document).ready(function() {
            var aid = $("#aid").val();
            
            // 调试显示传入的参数
            console.log("页面初始化 - 表单中aid值:", aid);
            
            // 更新调试显示
            $("#debug_aid").text(aid || "未获取到");
            
            // 加载考勤详情
            if (aid) {
                loadAttendanceDetails(aid);
            } else {
                alert("未找到考勤记录ID");
                window.location.href = "listAttendance.jsp";
            }
            
            // 加载考勤详情的函数
            function loadAttendanceDetails(aid) {
                console.log("正在加载考勤ID:", aid);
                $.ajax({
                    url: "AttendanceServlet",
                    type: "GET",
                    data: {
                        method: "getAttendanceById",
                        aid: aid
                    },
                    dataType: "json",
                    success: function(data) {
                        console.log("考勤详情:", data);
                        try {
                            if (typeof data === 'string') {
                                data = JSON.parse(data);
                            }
                            
                            if (data && Object.keys(data).length > 0) {
                                // 存储考勤数据到全局变量供后续使用
                                window.attendanceData = data;
                                
                                // 设置学生和课程名称为只读文本
                                $("#student_name").text(data.studentName || "未知学生");
                                $("#course_name").text(data.courseName || "未知课程");
                                
                                // 设置隐藏字段的值
                                $("#sid").val(data.sid);
                                $("#cid").val(data.cid);
                                
                                // 处理日期格式，确保只显示日期部分
                                $("#attendance_date").val(data.attendanceDate ? data.attendanceDate.split(' ')[0] : '');
                                $("#status").val(data.status);
                                
                                // 设置调试信息
                                $("#debug_aid").text(aid);
                                $("#debug_sid").text(data.sid);
                                $("#debug_cid").text(data.cid);
                                $("#debug_status").text(data.status);
                                $("#debug_date").text(data.attendanceDate);
                                
                                console.log("设置初始值: 学生=" + data.studentName + "(" + data.sid + "), 课程=" + 
                                          data.courseName + "(" + data.cid + "), 日期=" + 
                                          data.attendanceDate + ", 状态=" + data.status);
                            } else {
                                console.warn("未获取到考勤详情或数据为空");
                                alert("未找到该考勤记录或数据为空");
                                window.location.href = "listAttendance.jsp";
                            }
                        } catch (e) {
                            console.error("解析考勤详情失败:", e);
                            alert("解析考勤详情失败: " + e.message);
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("请求考勤详情失败:", error);
                        console.error("状态码:", xhr.status);
                        console.error("响应文本:", xhr.responseText);
                        alert("获取考勤详情失败：" + error);
                        window.location.href = "listAttendance.jsp";
                    }
                });
            }
            
            // 提交表单
            $("#submitBtn").click(function(e) {
                e.preventDefault();
                
                var aid = $("#aid").val();
                var sid = $("#sid").val();
                var cid = $("#cid").val();
                var attendanceDate = $("#attendance_date").val();
                var status = $("#status").val();
                
                // 更新调试信息
                $("#debug_aid").text(aid);
                $("#debug_sid").text(sid);
                $("#debug_cid").text(cid);
                $("#debug_status").text(status);
                $("#debug_date").text(attendanceDate);
                
                // 表单验证
                if (!aid || !sid || !cid) {
                    alert("考勤记录缺少必要信息");
                    return;
                }
                if (!attendanceDate) {
                    alert("请选择考勤日期");
                    return;
                }
                if (!status) {
                    alert("请选择考勤状态");
                    return;
                }
                
                // 提交到服务器
                $.ajax({
                    url: "AttendanceServlet",
                    type: "POST",
                    data: {
                        method: "updateAttendance",
                        aid: aid,
                        sid: sid,
                        cid: cid,
                        attendance_date: attendanceDate,
                        status: status
                    },
                    success: function(response) {
                        console.log("更新考勤结果:", response);
                        
                        if (response === "1") {
                            alert("更新考勤成功");
                            window.location.href = "listAttendance.jsp";
                        } else {
                            alert("更新考勤失败: " + response);
                            console.error("更新失败，服务器返回:", response);
                        }
                    },
                    error: function(xhr, status, error) {
                        alert("更新考勤失败: " + error);
                        console.error("更新考勤请求失败:", error);
                        console.error("状态码:", xhr.status);
                        console.error("响应文本:", xhr.responseText);
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
        <strong><i class="fas fa-edit"></i> 编辑考勤记录</strong>
    </div>
    <div class="body-content">
        <div class="container">
            <h2>编辑考勤</h2>
            <form id="attendanceForm" class="form-x">
                <input type="hidden" id="aid" name="aid" value="<%= request.getParameter("aid") %>">
                <input type="hidden" id="sid" name="sid" value="">
                <input type="hidden" id="cid" name="cid" value="">
                <div class="form-group">
                    <div class="label">
                        <label>学生：</label>
                    </div>
                    <div class="field">
                        <div class="input-display" id="student_name">正在加载...</div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="label">
                        <label>课程：</label>
                    </div>
                    <div class="field">
                        <div class="input-display" id="course_name">正在加载...</div>
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
                <!-- 调试信息区域 -->
                <div class="form-group" style="border-top: 1px dashed #ccc; padding-top: 15px; margin-top: 20px;">
                    <div class="label">
                        <label>调试信息：</label>
                    </div>
                    <div class="field" style="font-family: monospace; font-size: 12px; background: #f5f5f5; padding: 10px; border-radius: 4px;">
                        <div>考勤ID: <span id="debug_aid"></span></div>
                        <div>学生ID: <span id="debug_sid"></span></div>
                        <div>课程ID: <span id="debug_cid"></span></div>
                        <div>状态: <span id="debug_status"></span></div>
                        <div>日期: <span id="debug_date"></span></div>
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
</div>
</body>
</html>
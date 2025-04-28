<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>添加教学计划</title>
    <base href="${pageContext.request.contextPath}/">
    <link rel="stylesheet" href="css/pintuer.css">
    <link rel="stylesheet" href="css/admin.css">
    <script src="js/jquery.js"></script>
    <script src="js/pintuer.js"></script>

    <script>
        $(function () {
            console.log("页面加载完成, 开始获取课程和教师数据...");
            
            // 加载课程列表
            $.ajax({
                url: 'CourseServlet',
                type: 'GET',
                data: { methodName: 'getAllCourses' },
                success: function (data) {
                    console.log("课程数据获取成功:", data);
                    
                    // 判断返回数据类型
                    var courses;
                    if (typeof data === 'string') {
                        try {
                            courses = JSON.parse(data);
                            console.log("成功解析课程JSON数据");
                        } catch (e) {
                            // 尝试使用eval解析
                            try {
                                eval('courses = ' + data);
                                console.log("通过eval解析课程数据成功");
                            } catch (evalError) {
                                console.error("课程数据解析失败:", evalError);
                                $('#cid').append('<option value="">加载课程失败</option>');
                                $('#debug-info').html('加载课程数据失败: ' + evalError.message);
                                return;
                            }
                        }
                    } else {
                        courses = data;
                        console.log("服务器直接返回了课程JavaScript对象");
                    }
                    
                    var select = $('#cid');
                    select.empty().append('<option value="">--请选择课程--</option>');
                    
                    if(courses && courses.length > 0) {
                        for (var i = 0; i < courses.length; i++) {
                            select.append('<option value="' + courses[i].cid + '">' + courses[i].cname + '</option>');
                        }
                        console.log("课程下拉框填充完成, 共" + courses.length + "个课程");
                        $('#course-debug-info').html('课程列表加载成功，共' + courses.length + '个课程');
                    } else {
                        console.log("获取到的课程列表为空");
                        select.append('<option value="">暂无课程数据</option>');
                        $('#course-debug-info').html('未找到课程数据');
                    }
                },
                error: function (xhr, status, error) {
                    console.error("获取课程列表失败:", status, error);
                    $('#cid').append('<option value="">加载课程失败</option>');
                    $('#course-debug-info').html('加载课程数据失败: ' + error);
                }
            });

            // 加载教师列表
            $.ajax({
                url: 'TeacherServlet',
                type: 'GET',
                data: { methodName: 'getAllTeachers' },
                success: function (data) {
                    console.log("教师数据获取成功:", data);
                    
                    // 判断返回数据类型
                    var teachers;
                    if (typeof data === 'string') {
                        try {
                            teachers = JSON.parse(data);
                            console.log("成功解析教师JSON数据");
                        } catch (e) {
                            // 尝试使用eval解析
                            try {
                                eval('teachers = ' + data);
                                console.log("通过eval解析教师数据成功");
                            } catch (evalError) {
                                console.error("教师数据解析失败:", evalError);
                                $('#tid').append('<option value="">加载教师失败</option>');
                                $('#teacher-debug-info').html('加载教师数据失败: ' + evalError.message);
                                return;
                            }
                        }
                    } else {
                        teachers = data;
                        console.log("服务器直接返回了教师JavaScript对象");
                    }
                    
                    var select = $('#tid');
                    select.empty().append('<option value="">--请选择教师--</option>');
                    
                    if(teachers && teachers.length > 0) {
                        for (var i = 0; i < teachers.length; i++) {
                            select.append('<option value="' + teachers[i].tid + '">' + teachers[i].tname + '</option>');
                        }
                        console.log("教师下拉框填充完成, 共" + teachers.length + "个教师");
                        $('#teacher-debug-info').html('教师列表加载成功，共' + teachers.length + '个教师');
                    } else {
                        console.log("获取到的教师列表为空");
                        select.append('<option value="">暂无教师数据</option>');
                        $('#teacher-debug-info').html('未找到教师数据');
                    }
                },
                error: function (xhr, status, error) {
                    console.error("获取教师列表失败:", status, error);
                    $('#tid').append('<option value="">加载教师失败</option>');
                    $('#teacher-debug-info').html('加载教师数据失败: ' + error);
                }
            });

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

                console.log("提交教学计划数据:", {
                    methodName: 'addTeachingPlan',
                    cid: cid,
                    tid: tid,
                    startDate: startDate,
                    endDate: endDate,
                    description: description
                });

                $.ajax({
                    url: 'TeachingPlanServlet',
                    type: 'POST',
                    data: {
                        methodName: 'addTeachingPlan',
                        cid: cid,
                        tid: tid,
                        startDate: startDate,
                        endDate: endDate,
                        description: description
                    },
                    success: function (data) {
                        console.log("提交结果:", data);
                        if (data == '1') {
                            alert('添加成功');
                            location.href = 'listTeachingPlan.jsp';
                        } else {
                            alert('添加失败，请检查表单数据');
                            $('#form-debug-info').html('提交失败，服务器返回: ' + data);
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error("提交教学计划失败:", status, error);
                        alert('提交失败，请稍后重试');
                        $('#form-debug-info').html('提交出错: ' + error);
                    }
                });
            });
        });
    </script>
    
    <style>
        .panel-head {
            background: linear-gradient(120deg, #2c3e50, #3498db);
            color: white;
            padding: 15px 20px;
            border-radius: 8px 8px 0 0;
        }
        
        .panel-head strong {
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .button {
            transition: all 0.3s;
        }
        
        .button:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        .debug-info {
            font-size: 12px;
            color: #999;
            margin-top: 5px;
            font-style: italic;
        }
    </style>
</head>
<body>
<div class="panel admin-panel">
    <div class="panel-head"><strong><span class="icon-pencil-square-o"></span>添加教学计划</strong></div>
    <div class="body-content">
        <form method="post" class="form-x" action="">
            <div class="form-group">
                <div class="label">
                    <label>课程：</label>
                </div>
                <div class="field">
                    <select class="input" name="cid" id="cid" style="width:30%">
                        <option value="">--请选择课程--</option>
                    </select>
                    <div id="course-debug-info" class="debug-info"></div>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label>教师：</label>
                </div>
                <div class="field">
                    <select class="input" name="tid" id="tid" style="width:30%">
                        <option value="">--请选择教师--</option>
                    </select>
                    <div id="teacher-debug-info" class="debug-info"></div>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label>开始日期：</label>
                </div>
                <div class="field">
                    <input type="date" class="input" name="start_date" id="start_date" value="" style="width:30%"/>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label>结束日期：</label>
                </div>
                <div class="field">
                    <input type="date" class="input" name="end_date" id="end_date" value="" style="width:30%"/>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label>描述：</label>
                </div>
                <div class="field">
                    <textarea class="input" name="description" id="description" style="height:80px; width:30%"></textarea>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label></label>
                </div>
                <div class="field">
                    <button class="button bg-main icon-check-square-o" id="submitBtn" type="button"> 提交</button>
                    <div id="form-debug-info" class="debug-info"></div>
                </div>
            </div>
        </form>
    </div>
</div>
</body>
</html>
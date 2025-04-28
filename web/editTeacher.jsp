<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bkty.entity.Teacher" %>
<%@ page import="com.bkty.service.TeacherService" %>
<%@ page import="com.bkty.service.impl.TeacherServiceImpl" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>编辑教师</title>
    <base href="${pageContext.request.contextPath}/">
    <link rel="stylesheet" href="css/pintuer.css">
    <link rel="stylesheet" href="css/admin.css">
    <script src="js/jquery.js"></script>
    <script src="js/pintuer.js"></script>

    <script>
        $(function () {
            console.log("页面加载完成，开始获取班级列表...");
            var teacherId = '<%= request.getParameter("tid") %>';
            console.log("当前编辑的教师ID：", teacherId);
            
            // 加载班级列表
            $.ajax({
                url: 'ClazzServlet',
                type: 'GET',
                data: { methodName: 'getAll' },
                success: function (data) {
                    console.log("班级数据获取成功:", data);
                    
                    // 判断返回数据类型
                    var clazzes;
                    if (typeof data === 'string') {
                        // 如果是字符串，尝试解析
                        try {
                            clazzes = JSON.parse(data);
                            console.log("成功解析JSON字符串");
                        } catch (e) {
                            console.error("解析班级数据失败:", e);
                            console.log("原始响应内容:", data);
                            $('#cid').empty().append('<option value="">加载班级失败</option>');
                            $('#debug-info').html('加载班级数据失败：' + e.message);
                            return;
                        }
                    } else {
                        // 如果已经是对象，直接使用
                        clazzes = data;
                        console.log("服务器直接返回了JavaScript对象");
                    }
                    
                    var select = $('#cid');
                    select.empty().append('<option value="">--请选择班级--</option>');
                    
                    if(clazzes && clazzes.length > 0) {
                        for (var i = 0; i < clazzes.length; i++) {
                            select.append('<option value="' + clazzes[i].cid + '">' + clazzes[i].cname + '</option>');
                        }
                        console.log("班级下拉框填充完成, 共" + clazzes.length + "个班级");
                        
                        // 在加载班级列表完成后，再加载教师信息
                        if (teacherId && teacherId != 'null') {
                            loadTeacherInfo(teacherId);
                        }
                    } else {
                        console.log("获取到的班级列表为空");
                        select.append('<option value="">暂无班级数据</option>');
                        $('#debug-info').html('未找到班级数据');
                    }
                },
                error: function (xhr, status, error) {
                    console.error("获取班级列表失败:", status, error);
                    console.log("错误状态:", xhr.status);
                    console.log("错误信息:", xhr.responseText);
                    $('#cid').append('<option value="">加载班级失败</option>');
                    $('#debug-info').html('加载班级数据失败：' + error);
                }
            });

            // 提交表单
            $('#submitBtn').click(function () {
                var tid = teacherId;
                var tname = $('#tname').val();
                var sex = $('#sex').val();
                var phone = $('#phone').val();
                var email = $('#email').val();
                var cid = $('#cid').val();

                if (!tname || !sex || !phone || !email || !cid) {
                    alert('请填写完整信息');
                    return;
                }

                $.post('TeacherServlet', {
                    methodName: 'updateTeacher',
                    tid: tid,
                    tname: tname,
                    sex: sex,
                    phone: phone,
                    email: email,
                    cid: cid
                }, function (data) {
                    if (data == '1') {
                        alert('更新成功');
                        location.href = 'listTeacher.jsp';
                    } else {
                        alert('更新失败');
                    }
                });
            });
        });
        
        // 加载教师信息的独立函数
        function loadTeacherInfo(tid) {
            console.log("开始加载教师信息，ID:", tid);
            $.ajax({
                url: 'TeacherServlet',
                type: 'GET',
                data: { methodName: 'getTeacherById', tid: tid },
                success: function (teacherData) {
                    console.log("教师数据获取成功:", teacherData);
                    
                    // 判断返回数据类型
                    var teacher;
                    if (typeof teacherData === 'string') {
                        try {
                            teacher = JSON.parse(teacherData);
                            console.log("成功解析教师JSON数据");
                        } catch (e) {
                            console.error("解析教师数据失败:", e);
                            console.log("原始教师数据:", teacherData);
                            $('#debug-info').html('加载教师数据失败：' + e.message);
                            return;
                        }
                    } else {
                        teacher = teacherData;
                        console.log("服务器直接返回了教师JavaScript对象");
                    }
                    
                    if (teacher && teacher.tid) {
                        console.log("填充教师信息:", teacher);
                        $('#tname').val(teacher.tname);
                        $('#sex').val(teacher.sex);
                        $('#phone').val(teacher.phone);
                        $('#email').val(teacher.email);
                        
                        // 设置班级下拉框的值
                        console.log("设置班级值:", teacher.cid);
                        $('#cid').val(teacher.cid);
                        
                        // 检查班级是否正确设置
                        setTimeout(function() {
                            var selectedClass = $('#cid').val();
                            console.log("最终选择的班级ID:", selectedClass);
                            if (selectedClass != teacher.cid) {
                                console.warn("班级值设置不正确，尝试重新设置");
                                $('#cid').val(teacher.cid);
                                // 如果还是不能设置，可能是option不存在
                                if ($('#cid option[value="' + teacher.cid + '"]').length === 0) {
                                    console.error("找不到对应班级的选项:", teacher.cid);
                                    $('#debug-info').html('警告：教师所属班级(ID:' + teacher.cid + ')在系统中不存在');
                                }
                            }
                        }, 100);
                    } else {
                        console.error("获取到的教师数据无效");
                        $('#debug-info').html('获取教师数据失败');
                    }
                },
                error: function (xhr, status, error) {
                    console.error("获取教师信息失败:", status, error);
                    $('#debug-info').html('加载教师数据失败：' + error);
                }
            });
        }
    </script>
</head>
<body>
<div class="panel admin-panel">
    <div class="panel-head"><strong><span class="icon-pencil-square-o"></span>编辑教师</strong></div>
    <div class="body-content">
        <form method="post" class="form-x" action="">
            <div class="form-group">
                <div class="label">
                    <label>姓名：</label>
                </div>
                <div class="field">
                    <input type="text" class="input" name="tname" id="tname" value="" style="width:30%"/>
                    <div class="tips"></div>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label>性别：</label>
                </div>
                <div class="field">
                    <select class="input" name="sex" id="sex" style="width:30%">
                        <option value="男">男</option>
                        <option value="女">女</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label>手机号：</label>
                </div>
                <div class="field">
                    <input type="text" class="input" name="phone" id="phone" value="" style="width:30%"/>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label>邮箱：</label>
                </div>
                <div class="field">
                    <input type="text" class="input" name="email" id="email" value="" style="width:30%"/>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label>所属班级：</label>
                </div>
                <div class="field">
                    <select class="input" name="cid" id="cid" style="width:30%">
                        <option value="">--请选择班级--</option>
                    </select>
                    <div id="debug-info" style="font-size:12px;color:#999;margin-top:5px;"></div>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label></label>
                </div>
                <div class="field">
                    <button class="button bg-main icon-check-square-o" id="submitBtn" type="button"> 提交</button>
                </div>
            </div>
        </form>
    </div>
</div>
</body>
</html>
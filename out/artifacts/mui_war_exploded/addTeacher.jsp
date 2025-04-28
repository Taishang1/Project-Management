<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>添加教师</title>
    <base href="${pageContext.request.contextPath}/">
    <link rel="stylesheet" href="css/pintuer.css">
    <link rel="stylesheet" href="css/admin.css">
    <script src="js/jquery.js"></script>
    <script src="js/pintuer.js"></script>

    <script>
        $(function () {
            console.log("页面加载完成, 开始获取班级列表...");
            
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
                        $('#debug-info').html('班级列表加载成功，共' + clazzes.length + '个班级');
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
                    methodName: 'addTeacher',
                    tname: tname,
                    sex: sex,
                    phone: phone,
                    email: email,
                    cid: cid
                }, function (data) {
                    if (data == '1') {
                        alert('添加成功');
                        location.href = 'listTeacher.jsp';
                    } else {
                        alert('添加失败');
                    }
                });
            });
        });
    </script>
</head>
<body>
<div class="panel admin-panel">
    <div class="panel-head"><strong><span class="icon-pencil-square-o"></span>添加教师</strong></div>
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
                        <!-- 这里会通过 Ajax 加载班级数据 -->
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

<script>
// 添加页面加载完成后的自检功能
$(document).ready(function() {
    setTimeout(function() {
        var options = $('#cid option').length;
        var debugInfo = $('#debug-info');
        
        if(options <= 1) {
            debugInfo.html('班级列表未能正常加载，请检查控制台错误信息');
            
            // 手动尝试再次加载
            $.ajax({
                url: 'ClazzServlet', 
                type: 'GET',
                data: { methodName: 'getAll' },
                success: function (data) {
                    debugInfo.html('重试获取班级数据结果: ' + (data ? '成功' : '失败'));
                    console.log("重试获取班级数据:", data);
                    
                    // 判断返回数据类型并处理
                    var clazzes;
                    if (typeof data === 'string') {
                        try {
                            clazzes = JSON.parse(data);
                        } catch (e) {
                            debugInfo.html('重试解析班级数据失败: ' + e.message);
                            return;
                        }
                    } else {
                        clazzes = data;
                    }
                    
                    if(clazzes && clazzes.length > 0) {
                        var select = $('#cid');
                        select.empty().append('<option value="">--请选择班级--</option>');
                        for (var i = 0; i < clazzes.length; i++) {
                            select.append('<option value="' + clazzes[i].cid + '">' + clazzes[i].cname + '</option>');
                        }
                        debugInfo.html('重试加载班级成功，共' + clazzes.length + '个班级');
                    }
                },
                error: function() {
                    debugInfo.html('重试获取班级数据失败');
                }
            });
        } else {
            debugInfo.html('班级列表加载成功，共' + (options-1) + '个班级');
        }
    }, 2000);
});
</script>
</body>
</html>
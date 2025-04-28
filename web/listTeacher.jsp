<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>教师列表</title>
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
            padding: 15px 20px;
            border-radius: 8px 8px 0 0;
        }
        
        .panel-head strong {
            font-size: 18px;
        }
        
        .table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-bottom: 0;
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
        
        .btn-delete {
            padding: 6px 12px;
            background: #e74c3c;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
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
        }
    </style>

    <script>
        $(function() {
            loadTeachers();
            
            // 添加加载动画
            $(document).ajaxStart(function() {
                $('.loading').show();
            }).ajaxStop(function() {
                $('.loading').hide();
            });
        });

        function loadTeachers() {
            $.get('TeacherServlet', { methodName: 'getAllTeachers' }, function(data) {
                var teachers = JSON.parse(data);
                displayTeachers(teachers);
            });
        }

        function displayTeachers(teachers) {
            var tbody = $('#teacherList tbody');
            tbody.empty();
            if (teachers.length === 0) {
                tbody.append('<tr><td colspan="6" class="text-center">没有找到相关数据</td></tr>');
                return;
            }
            teachers.forEach(function(teacher) {
                tbody.append(
                    '<tr>' +
                    '<td>' + teacher.tid + '</td>' +
                    '<td>' + teacher.tname + '</td>' +
                    '<td>' + teacher.sex + '</td>' +
                    '<td>' + teacher.phone + '</td>' +
                    '<td>' + teacher.email + '</td>' +
                    '<td>' +
                    '<button class="btn-delete" onclick="deleteTeacher(' + teacher.tid + ')">' +
                    '<i class="fas fa-trash-alt"></i> 删除</button>' +
                    '</td>' +
                    '</tr>'
                );
            });
        }

        function deleteTeacher(tid) {
            if (confirm('确定要删除该教师吗？此操作不可恢复。')) {
                $.get('TeacherServlet', {
                    methodName: 'deleteTeacher',
                    tid: tid
                }, function(data) {
                    if (data == '1') {
                        alert('删除成功');
                        loadTeachers();
                    } else {
                        alert('删除失败，请稍后重试');
                    }
                });
            }
        }
    </script>
</head>
<body>
    <div class="panel">
        <div class="panel-head">
            <strong><i class="fas fa-chalkboard-teacher"></i> 教师列表</strong>
        </div>

        <table class="table" id="teacherList">
            <thead>
                <tr>
                    <th width="10%">ID</th>
                    <th width="15%">姓名</th>
                    <th width="10%">性别</th>
                    <th width="20%">手机号</th>
                    <th width="25%">邮箱</th>
                    <th width="20%">操作</th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>

    <div class="loading">
        <i class="fas fa-spinner fa-spin"></i> 加载中...
    </div>
</body>
</html>
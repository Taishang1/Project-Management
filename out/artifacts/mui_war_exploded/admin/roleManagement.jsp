<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>角色管理</title>
    <link rel="stylesheet" href="../css/pintuer.css">
    <link rel="stylesheet" href="../css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="../js/jquery.js"></script>
    <script src="../js/pintuer.js"></script>
    <style>
        .panel {
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin: 20px;
        }
        .panel-head {
            background: linear-gradient(120deg, #2c3e50, #3498db);
            color: white;
            padding: 15px;
            border-radius: 8px 8px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .table {
            background: white;
            margin: 0;
        }
        .table th {
            background: #f8f9fa;
            color: #2c3e50;
            font-weight: 600;
        }
        .table tr:hover {
            background: #f1f2f6;
        }
        .button {
            border-radius: 4px;
            padding: 8px 15px;
            font-size: 14px;
            transition: all 0.3s;
        }
        .button:hover {
            transform: translateY(-2px);
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }
        .button.border-blue {
            border-color: #3498db;
            color: #3498db;
        }
        .button.border-blue:hover {
            background: #3498db;
            color: white;
        }
        .dialog {
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .dialog-head {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px 8px 0 0;
        }
        .dialog-body {
            padding: 20px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #2c3e50;
            font-weight: 500;
        }
        .input {
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 8px 12px;
            width: 100%;
            transition: all 0.3s;
        }
        .input:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 2px rgba(52,152,219,0.2);
        }
        .permission-list {
            max-height: 200px;
            overflow-y: auto;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 10px;
        }
        .permission-item {
            padding: 8px;
            border-bottom: 1px solid #eee;
        }
        .permission-item:last-child {
            border-bottom: none;
        }
        .empty-message {
            text-align: center;
            padding: 40px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="panel admin-panel">
        <div class="panel-head">
            <strong><i class="fas fa-user-shield"></i> 角色管理</strong>
            <button type="button" class="button border-blue" id="add-role">
                <i class="fas fa-plus"></i> 添加角色
            </button>
        </div>
        <table class="table table-hover">
            <thead>
                <tr>
                    <th width="20%">角色名称</th>
                    <th width="40%">角色描述</th>
                    <th width="20%">创建时间</th>
                    <th width="20%">操作</th>
                </tr>
            </thead>
            <tbody id="roleList">
                <!-- 角色列表将通过AJAX加载 -->
            </tbody>
        </table>
    </div>

    <!-- 角色表单对话框 -->
    <div id="roleDialog" class="dialog" style="display:none;">
        <div class="dialog-head">
            <span class="dialog-title"><i class="fas fa-edit"></i> 角色信息</span>
            <span class="dialog-close"><i class="fas fa-times"></i></span>
        </div>
        <div class="dialog-body">
            <form id="roleForm" method="post">
                <input type="hidden" name="roleId" id="roleId">
                <div class="form-group">
                    <label>角色名称：</label>
                    <input type="text" class="input" name="roleName" id="roleName" required>
                </div>
                <div class="form-group">
                    <label>角色描述：</label>
                    <textarea class="input" name="roleDesc" id="roleDesc" rows="3"></textarea>
                </div>
                <div class="form-group">
                    <label>权限分配：</label>
                    <div class="permission-list" id="permissionList">
                        <!-- 权限列表将通过AJAX加载 -->
                    </div>
                </div>
                <div class="form-group" style="text-align: right;">
                    <button type="button" class="button bg-main" id="saveRole">
                        <i class="fas fa-save"></i> 保存
                    </button>
                    <button type="button" class="button dialog-close">
                        <i class="fas fa-times"></i> 取消
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        $(function() {
            // 加载角色列表
            function loadRoles() {
                $.ajax({
                    url: '../RoleServlet?method=getAllRoles',
                    type: 'GET',
                    success: function(data) {
                        var html = '';
                        if (data && data.length > 0) {
                            data.forEach(function(role) {
                                html += '<tr>';
                                html += '<td>' + (role.roleName || '') + '</td>';
                                html += '<td>' + (role.roleDesc || '') + '</td>';
                                html += '<td>' + formatDate(role.createTime) + '</td>';
                                html += '<td>';
                                html += '<div class="button-group">';
                                html += '<a class="button border-main" href="javascript:void(0)" onclick="editRole(' + role.roleId + ')">';
                                html += '<i class="fas fa-edit"></i> 编辑</a> ';
                                html += '<a class="button border-red" href="javascript:void(0)" onclick="deleteRole(' + role.roleId + ')">';
                                html += '<i class="fas fa-trash-alt"></i> 删除</a>';
                                html += '</div>';
                                html += '</td>';
                                html += '</tr>';
                            });
                        } else {
                            html = '<tr><td colspan="4" class="empty-message">';
                            html += '<i class="fas fa-info-circle"></i> 暂无角色数据';
                            html += '</td></tr>';
                        }
                        $('#roleList').html(html);
                    },
                    error: function() {
                        $('#roleList').html('<tr><td colspan="4" class="empty-message">' +
                            '<i class="fas fa-exclamation-triangle"></i> 加载失败，请刷新重试' +
                            '</td></tr>');
                    }
                });
            }

            // 加载权限列表
            function loadPermissions(roleId) {
                $.ajax({
                    url: '../PermissionServlet?method=getAllPermissions',
                    type: 'GET',
                    success: function(data) {
                        var html = '';
                        if (data && data.length > 0) {
                            data.forEach(function(perm) {
                                html += '<div class="permission-item">';
                                html += '<label>';
                                html += '<input type="checkbox" name="permissions" value="' + perm.permId + '" ';
                                if (roleId && perm.checked) {
                                    html += 'checked ';
                                }
                                html += '> ' + perm.permName;
                                if (perm.permDesc) {
                                    html += ' <small>(' + perm.permDesc + ')</small>';
                                }
                                html += '</label>';
                                html += '</div>';
                            });
                        } else {
                            html = '<div class="empty-message">';
                            html += '<i class="fas fa-info-circle"></i> 暂无权限数据';
                            html += '</div>';
                        }
                        $('#permissionList').html(html);
                    }
                });
            }

            // 初始加载
            loadRoles();

            // 添加角色按钮点击事件
            $('#add-role').click(function() {
                $('#roleForm')[0].reset();
                $('#roleId').val('');
                loadPermissions();
                $('#roleDialog').fadeIn(300);
            });

            // 保存角色
            $('#saveRole').click(function() {
                var formData = {
                    roleId: $('#roleId').val(),
                    roleName: $('#roleName').val(),
                    roleDesc: $('#roleDesc').val(),
                    permissions: []
                };

                $('input[name="permissions"]:checked').each(function() {
                    formData.permissions.push($(this).val());
                });

                $.ajax({
                    url: '../RoleServlet?method=' + (formData.roleId ? 'updateRole' : 'addRole'),
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(formData),
                    success: function(response) {
                        if(response.success) {
                            alert('保存成功');
                            $('#roleDialog').fadeOut(300);
                            loadRoles();
                        } else {
                            alert('保存失败：' + response.message);
                        }
                    }
                });
            });

            // 关闭对话框
            $('.dialog-close').click(function() {
                $('#roleDialog').fadeOut(300);
            });
        });

        // 编辑角色
        function editRole(roleId) {
            $.ajax({
                url: '../RoleServlet?method=getRoleById',
                type: 'GET',
                data: {roleId: roleId},
                success: function(role) {
                    $('#roleId').val(role.roleId);
                    $('#roleName').val(role.roleName);
                    $('#roleDesc').val(role.roleDesc);
                    loadPermissions(roleId);
                    $('#roleDialog').fadeIn(300);
                }
            });
        }

        // 删除角色
        function deleteRole(roleId) {
            if(confirm('确定要删除这个角色吗？')) {
                $.ajax({
                    url: '../RoleServlet?method=deleteRole',
                    type: 'POST',
                    data: {roleId: roleId},
                    success: function(response) {
                        if(response.success) {
                            alert('删除成功');
                            loadRoles();
                        } else {
                            alert('删除失败：' + response.message);
                        }
                    }
                });
            }
        }

        // 格式化日期
        function formatDate(date) {
            if (!date) return '';
            var d = new Date(date);
            return d.getFullYear() + '-' + 
                   padZero(d.getMonth() + 1) + '-' + 
                   padZero(d.getDate()) + ' ' +
                   padZero(d.getHours()) + ':' +
                   padZero(d.getMinutes());
        }

        function padZero(num) {
            return num < 10 ? '0' + num : num;
        }
    </script>
</body>
</html> 
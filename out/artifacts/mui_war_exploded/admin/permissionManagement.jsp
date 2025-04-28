<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>权限管理</title>
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
        .empty-message {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        .perm-code {
            font-family: monospace;
            background: #f8f9fa;
            padding: 2px 6px;
            border-radius: 3px;
            color: #e74c3c;
        }
    </style>
</head>
<body>
    <div class="panel admin-panel">
        <div class="panel-head">
            <strong><i class="fas fa-key"></i> 权限管理</strong>
            <button type="button" class="button border-blue" id="add-permission">
                <i class="fas fa-plus"></i> 添加权限
            </button>
        </div>
        <table class="table table-hover">
            <thead>
                <tr>
                    <th width="20%">权限名称</th>
                    <th width="20%">权限代码</th>
                    <th width="30%">权限描述</th>
                    <th width="15%">创建时间</th>
                    <th width="15%">操作</th>
                </tr>
            </thead>
            <tbody id="permissionList">
                <!-- 权限列表将通过AJAX加载 -->
            </tbody>
        </table>
    </div>

    <!-- 权限表单对话框 -->
    <div id="permissionDialog" class="dialog" style="display:none;">
        <div class="dialog-head">
            <span class="dialog-title"><i class="fas fa-edit"></i> 权限信息</span>
            <span class="dialog-close"><i class="fas fa-times"></i></span>
        </div>
        <div class="dialog-body">
            <form id="permissionForm" method="post">
                <input type="hidden" name="permId" id="permId">
                <div class="form-group">
                    <label>权限名称：</label>
                    <input type="text" class="input" name="permName" id="permName" required>
                </div>
                <div class="form-group">
                    <label>权限代码：</label>
                    <input type="text" class="input" name="permCode" id="permCode" required>
                </div>
                <div class="form-group">
                    <label>权限描述：</label>
                    <textarea class="input" name="permDesc" id="permDesc" rows="3"></textarea>
                </div>
                <div class="form-group" style="text-align: right;">
                    <button type="button" class="button bg-main" id="savePermission">
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
            // 加载权限列表
            function loadPermissions() {
                $.ajax({
                    url: '../PermissionServlet?method=getAllPermissions',
                    type: 'GET',
                    success: function(data) {
                        var html = '';
                        if (data && data.length > 0) {
                            data.forEach(function(perm) {
                                html += '<tr>';
                                html += '<td>' + (perm.permName || '') + '</td>';
                                html += '<td><span class="perm-code">' + (perm.permCode || '') + '</span></td>';
                                html += '<td>' + (perm.permDesc || '') + '</td>';
                                html += '<td>' + formatDate(perm.createTime) + '</td>';
                                html += '<td>';
                                html += '<div class="button-group">';
                                html += '<a class="button border-main" href="javascript:void(0)" onclick="editPermission(' + perm.permId + ')">';
                                html += '<i class="fas fa-edit"></i> 编辑</a> ';
                                html += '<a class="button border-red" href="javascript:void(0)" onclick="deletePermission(' + perm.permId + ')">';
                                html += '<i class="fas fa-trash-alt"></i> 删除</a>';
                                html += '</div>';
                                html += '</td>';
                                html += '</tr>';
                            });
                        } else {
                            html = '<tr><td colspan="5" class="empty-message">';
                            html += '<i class="fas fa-info-circle"></i> 暂无权限数据';
                            html += '</td></tr>';
                        }
                        $('#permissionList').html(html);
                    },
                    error: function() {
                        $('#permissionList').html('<tr><td colspan="5" class="empty-message">' +
                            '<i class="fas fa-exclamation-triangle"></i> 加载失败，请刷新重试' +
                            '</td></tr>');
                    }
                });
            }

            // 初始加载
            loadPermissions();

            // 添加权限按钮点击事件
            $('#add-permission').click(function() {
                $('#permissionForm')[0].reset();
                $('#permId').val('');
                $('#permissionDialog').fadeIn(300);
            });

            // 保存权限
            $('#savePermission').click(function() {
                var formData = {
                    permId: $('#permId').val(),
                    permName: $('#permName').val(),
                    permCode: $('#permCode').val(),
                    permDesc: $('#permDesc').val()
                };

                $.ajax({
                    url: '../PermissionServlet?method=' + (formData.permId ? 'updatePermission' : 'addPermission'),
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(formData),
                    success: function(response) {
                        if(response.success) {
                            alert('保存成功');
                            $('#permissionDialog').fadeOut(300);
                            loadPermissions();
                        } else {
                            alert('保存失败：' + response.message);
                        }
                    }
                });
            });

            // 关闭对话框
            $('.dialog-close').click(function() {
                $('#permissionDialog').fadeOut(300);
            });
        });

        // 编辑权限
        function editPermission(permId) {
            $.ajax({
                url: '../PermissionServlet?method=getPermissionById',
                type: 'GET',
                data: {permId: permId},
                success: function(perm) {
                    $('#permId').val(perm.permId);
                    $('#permName').val(perm.permName);
                    $('#permCode').val(perm.permCode);
                    $('#permDesc').val(perm.permDesc);
                    $('#permissionDialog').fadeIn(300);
                }
            });
        }

        // 删除权限
        function deletePermission(permId) {
            if(confirm('确定要删除这个权限吗？')) {
                $.ajax({
                    url: '../PermissionServlet?method=deletePermission',
                    type: 'POST',
                    data: {permId: permId},
                    success: function(response) {
                        if(response.success) {
                            alert('删除成功');
                            loadPermissions();
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
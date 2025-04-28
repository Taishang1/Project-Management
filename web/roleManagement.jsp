<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>角色权限管理</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="js/jquery.js"></script>
</head>
<body>
    <div class="panel">
        <div class="panel-head">
            <strong>角色管理</strong>
            <button class="btn" onclick="addRole()">添加角色</button>
        </div>
        <div class="panel-body">
            <table class="table" id="roleTable">
                <thead>
                    <tr>
                        <th>角色名称</th>
                        <th>角色描述</th>
                        <th>创建时间</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- 权限分配对话框 -->
    <div id="permDialog" class="dialog">
        <!-- 权限选择列表 -->
    </div>
</body>
</html> 
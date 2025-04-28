<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.bkty.utils.JDBCUtils" %>
<!DOCTYPE html>
<html>
<head>
    <title>班级数据诊断工具</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { color: #3498db; }
        .section { margin-bottom: 30px; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .success { color: green; }
        .error { color: red; }
        pre { background: #f5f5f5; padding: 10px; border-radius: 3px; overflow: auto; }
        table { border-collapse: collapse; width: 100%; margin-top: 10px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        button { padding: 8px 15px; background: #3498db; color: white; border: none; border-radius: 4px; cursor: pointer; }
        button:hover { background: #2980b9; }
    </style>
</head>
<body>
    <h1>班级数据诊断工具</h1>
    
    <div class="section">
        <h2>1. 数据库连接测试</h2>
        <%
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            boolean dbConnected = false;
            
            try {
                conn = JDBCUtils.getConnection();
                dbConnected = true;
                out.println("<div class='success'>数据库连接成功!</div>");
            } catch (Exception e) {
                out.println("<div class='error'>数据库连接失败: " + e.getMessage() + "</div>");
                e.printStackTrace(new java.io.PrintWriter(out));
            }
        %>
    </div>
    
    <div class="section">
        <h2>2. 班级表结构检查</h2>
        <% 
            if (dbConnected) {
                try {
                    DatabaseMetaData metaData = conn.getMetaData();
                    rs = metaData.getTables(null, null, "clazz", null);
                    
                    if (rs.next()) {
                        out.println("<div class='success'>班级表(clazz)存在!</div>");
                        
                        // Check columns
                        out.println("<h3>班级表列信息:</h3>");
                        rs = metaData.getColumns(null, null, "clazz", null);
                        
                        out.println("<table>");
                        out.println("<tr><th>列名</th><th>数据类型</th><th>大小</th><th>可为空</th></tr>");
                        
                        while (rs.next()) {
                            String name = rs.getString("COLUMN_NAME");
                            String type = rs.getString("TYPE_NAME");
                            int size = rs.getInt("COLUMN_SIZE");
                            String nullable = rs.getInt("NULLABLE") == 1 ? "是" : "否";
                            
                            out.println("<tr>");
                            out.println("<td>" + name + "</td>");
                            out.println("<td>" + type + "</td>");
                            out.println("<td>" + size + "</td>");
                            out.println("<td>" + nullable + "</td>");
                            out.println("</tr>");
                        }
                        out.println("</table>");
                    } else {
                        out.println("<div class='error'>班级表(clazz)不存在!</div>");
                        
                        // Automatically create the table
                        out.println("<h3>尝试创建班级表:</h3>");
                        try {
                            String createTableSQL = 
                                "CREATE TABLE clazz (" +
                                "cid INT PRIMARY KEY AUTO_INCREMENT, " +
                                "cname VARCHAR(50) NOT NULL, " +
                                "cteacher VARCHAR(50), " +
                                "remark VARCHAR(200)" +
                                ")";
                            
                            Statement stmt = conn.createStatement();
                            stmt.executeUpdate(createTableSQL);
                            out.println("<div class='success'>成功创建班级表!</div>");
                            
                            // Insert sample data
                            String insertDataSQL = 
                                "INSERT INTO clazz (cname, cteacher, remark) VALUES " +
                                "('计算机1班', '张老师', '计算机科学与技术专业'), " +
                                "('计算机2班', '李老师', '软件工程专业'), " +
                                "('物联网班', '王老师', '物联网工程专业')";
                            stmt.executeUpdate(insertDataSQL);
                            out.println("<div class='success'>成功添加示例数据!</div>");
                            
                        } catch (Exception e) {
                            out.println("<div class='error'>创建班级表失败: " + e.getMessage() + "</div>");
                        }
                    }
                } catch (Exception e) {
                    out.println("<div class='error'>检查班级表结构失败: " + e.getMessage() + "</div>");
                }
            }
        %>
    </div>
    
    <div class="section">
        <h2>3. 班级数据查询</h2>
        <% 
            if (dbConnected) {
                try {
                    ps = conn.prepareStatement("SELECT * FROM clazz");
                    rs = ps.executeQuery();
                    
                    out.println("<h3>班级数据:</h3>");
                    out.println("<table>");
                    out.println("<tr><th>ID</th><th>班级名称</th><th>班主任</th><th>备注</th></tr>");
                    
                    boolean hasData = false;
                    while (rs.next()) {
                        hasData = true;
                        out.println("<tr>");
                        out.println("<td>" + rs.getInt("cid") + "</td>");
                        out.println("<td>" + rs.getString("cname") + "</td>");
                        out.println("<td>" + rs.getString("cteacher") + "</td>");
                        out.println("<td>" + rs.getString("remark") + "</td>");
                        out.println("</tr>");
                    }
                    
                    if (!hasData) {
                        out.println("<tr><td colspan='4' class='error'>班级表中没有数据!</td></tr>");
                    }
                    
                    out.println("</table>");
                    
                    if (!hasData) {
                        // Add form to add a new class
                        out.println("<h3>添加班级数据:</h3>");
                        out.println("<form id='addClassForm'>");
                        out.println("<table>");
                        out.println("<tr><td>班级名称:</td><td><input type='text' name='cname' required></td></tr>");
                        out.println("<tr><td>班主任:</td><td><input type='text' name='cteacher'></td></tr>");
                        out.println("<tr><td>备注:</td><td><input type='text' name='remark'></td></tr>");
                        out.println("<tr><td colspan='2'><button type='submit'>添加班级</button></td></tr>");
                        out.println("</table>");
                        out.println("</form>");
                        out.println("<div id='addResult'></div>");
                    }
                    
                } catch (Exception e) {
                    out.println("<div class='error'>查询班级数据失败: " + e.getMessage() + "</div>");
                }
            }
        %>
    </div>
    
    <div class="section">
        <h2>4. ClazzServlet测试</h2>
        <button id="testServlet">测试ClazzServlet</button>
        <div id="servletResult"></div>
    </div>
    
    <script src="js/jquery.js"></script>
    <script>
        $(function() {
            // Test servlet
            $('#testServlet').click(function() {
                $('#servletResult').html("<div>请求中...</div>");
                
                $.ajax({
                    url: 'ClazzServlet',
                    type: 'GET',
                    data: { methodName: 'getAll' },
                    success: function(data) {
                        $('#servletResult').html("<h3>服务器响应:</h3><pre>" + data + "</pre>");
                        
                        try {
                            var clazzes = JSON.parse(data);
                            $('#servletResult').append("<div class='success'>成功解析JSON数据，找到 " + clazzes.length + " 个班级</div>");
                        } catch (e) {
                            $('#servletResult').append("<div class='error'>JSON解析失败: " + e.message + "</div>");
                        }
                    },
                    error: function(xhr, status, error) {
                        $('#servletResult').html("<div class='error'>请求失败: " + status + " - " + error + "</div>");
                    }
                });
            });
            
            // Add class form submission
            $('#addClassForm').submit(function(e) {
                e.preventDefault();
                
                $.ajax({
                    url: 'ClazzServlet',
                    type: 'POST',
                    data: {
                        methodName: 'addClazz',
                        cname: $('input[name="cname"]').val(),
                        cteacher: $('input[name="cteacher"]').val(),
                        remark: $('input[name="remark"]').val()
                    },
                    success: function(data) {
                        if (data == '1') {
                            $('#addResult').html("<div class='success'>班级添加成功!</div>");
                            // Reload the page to show the new data
                            setTimeout(function() {
                                location.reload();
                            }, 1000);
                        } else {
                            $('#addResult').html("<div class='error'>班级添加失败!</div>");
                        }
                    },
                    error: function() {
                        $('#addResult').html("<div class='error'>请求失败!</div>");
                    }
                });
            });
        });
    </script>
    
    <% 
        // Close resources
        JDBCUtils.closeConnection(rs, ps, conn);
    %>
</body>
</html> 
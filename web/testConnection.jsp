<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.bkty.utils.JDBCUtils" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test Database Connection</title>
</head>
<body>
    <h1>Database Connection Test</h1>
    
    <h2>Connection Status:</h2>
    <%
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = JDBCUtils.getConnection();
            out.println("<div style='color:green'>Database connection successful!</div>");
            
            // Test query to fetch classes
            ps = conn.prepareStatement("SELECT * FROM clazz");
            rs = ps.executeQuery();
            
            out.println("<h2>Classes in Database:</h2>");
            out.println("<table border='1'>");
            out.println("<tr><th>ID</th><th>Name</th><th>Teacher</th><th>Remark</th></tr>");
            
            boolean hasRows = false;
            while(rs.next()) {
                hasRows = true;
                out.println("<tr>");
                out.println("<td>" + rs.getInt("cid") + "</td>");
                out.println("<td>" + rs.getString("cname") + "</td>");
                out.println("<td>" + rs.getString("cteacher") + "</td>");
                out.println("<td>" + rs.getString("remark") + "</td>");
                out.println("</tr>");
            }
            
            if (!hasRows) {
                out.println("<tr><td colspan='4' style='color:red'>No classes found in database!</td></tr>");
            }
            
            out.println("</table>");
        } catch (Exception e) {
            out.println("<div style='color:red'>Database connection failed: " + e.getMessage() + "</div>");
            e.printStackTrace(new java.io.PrintWriter(out));
        } finally {
            JDBCUtils.closeConnection(rs, ps, conn);
        }
    %>
    
    <h2>AJAX Test:</h2>
    <button id="testBtn">Test AJAX Call to ClazzServlet</button>
    <div id="result"></div>
    
    <script src="js/jquery.js"></script>
    <script>
        $(function() {
            $('#testBtn').click(function() {
                $('#result').html("Loading...");
                
                $.ajax({
                    url: 'ClazzServlet',
                    type: 'GET',
                    data: { methodName: 'getAll' },
                    success: function(data) {
                        $('#result').html("<h3>Response Received:</h3><pre>" + data + "</pre>");
                        
                        try {
                            var clazzes = JSON.parse(data);
                            $('#result').append("<h3>Parsed Object:</h3><pre>" + JSON.stringify(clazzes, null, 2) + "</pre>");
                            $('#result').append("<div style='color:green'>Classes count: " + clazzes.length + "</div>");
                        } catch (e) {
                            $('#result').append("<div style='color:red'>Error parsing JSON: " + e.message + "</div>");
                        }
                    },
                    error: function(xhr, status, error) {
                        $('#result').html("<div style='color:red'>Error: " + status + " - " + error + "</div>");
                        $('#result').append("<div>Status Code: " + xhr.status + "</div>");
                        $('#result').append("<div>Response Text: " + xhr.responseText + "</div>");
                    }
                });
            });
        });
    </script>
</body>
</html> 
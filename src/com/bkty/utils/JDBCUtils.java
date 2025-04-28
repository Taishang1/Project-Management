package com.bkty.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class JDBCUtils {
    public static Connection getConnection() throws Exception {
        try {
            // 加载 MySQL 驱动
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 恢复原来的数据库名称
            String url = "jdbc:mysql://localhost:3306/stuoa?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai&useSSL=false";

            // 获取数据库连接
            Connection connection = DriverManager.getConnection(url, "root", "root");
            System.out.println("数据库连接成功: " + connection);
            return connection;
        } catch (Exception e) {
            System.err.println("数据库连接失败: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public static void closeConnection(PreparedStatement ps, Connection connection) {
        // 关闭 PreparedStatement
        if (ps != null) {
            try {
                ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        // 关闭 Connection
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // 添加关闭 ResultSet 的方法
    public static void closeConnection(ResultSet rs, PreparedStatement ps, Connection connection) {
        // 关闭 ResultSet
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        // 关闭 PreparedStatement 和 Connection
        closeConnection(ps, connection);
    }

    /**
     * 为了兼容 BaseDao 中的方法,添加 closeResource 方法
     */
    public static void closeResource(Connection conn, java.sql.Statement ps) {
        closeConnection((PreparedStatement) ps, conn);
    }

    public static void closeResource(Connection conn, java.sql.Statement ps, ResultSet rs) {
        closeConnection(rs, (PreparedStatement) ps, conn);
    }
}
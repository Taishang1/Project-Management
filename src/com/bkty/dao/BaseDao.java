package com.bkty.dao;

import com.bkty.utils.JDBCUtils;

import java.lang.reflect.Field;
import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class BaseDao {

  /**
   * 通用的增删改操作
   */
  public int update(String sql, Object... args) {
    Connection conn = null;
    PreparedStatement ps = null;
    try {
      conn = JDBCUtils.getConnection();
      ps = conn.prepareStatement(sql);
      for (int i = 0; i < args.length; i++) {
        ps.setObject(i + 1, args[i]);
      }
      return ps.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      JDBCUtils.closeResource(conn, ps);
    }
    return 0;
  }

  /**
   * 通用的查询操作，返回单个对象
   */
  public <T> T queryForOne(Class<T> clazz, String sql, Object... args) {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = JDBCUtils.getConnection();
      ps = conn.prepareStatement(sql);
      for (int i = 0; i < args.length; i++) {
        ps.setObject(i + 1, args[i]);
      }
      rs = ps.executeQuery();
      ResultSetMetaData rsmd = rs.getMetaData();
      int columnCount = rsmd.getColumnCount();
      if (rs.next()) {
        T t = clazz.newInstance();
        for (int i = 0; i < columnCount; i++) {
          Object columnValue = rs.getObject(i + 1);
          String columnLabel = rsmd.getColumnLabel(i + 1);
          Field field = clazz.getDeclaredField(columnLabel);
          field.setAccessible(true);
          field.set(t, columnValue);
        }
        return t;
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      JDBCUtils.closeResource(conn, ps, rs);
    }
    return null;
  }

  /**
   * 通用的查询操作，返回多个对象
   */
  public <T> List<T> queryForList(Class<T> clazz, String sql, Object... args) {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = JDBCUtils.getConnection();
      System.out.println("数据库连接成功: " + conn);

      ps = conn.prepareStatement(sql);
      for (int i = 0; i < args.length; i++) {
        ps.setObject(i + 1, args[i]);
      }

      System.out.println("执行SQL: " + sql);
      System.out.println("SQL参数: " + Arrays.toString(args));

      rs = ps.executeQuery();
      ResultSetMetaData rsmd = rs.getMetaData();
      int columnCount = rsmd.getColumnCount();

      // 打印列信息
      System.out.println("查询结果列数: " + columnCount);
      for (int i = 1; i <= columnCount; i++) {
        System.out.println("列" + i + ": " + rsmd.getColumnLabel(i));
      }

      ArrayList<T> list = new ArrayList<>();
      while (rs.next()) {
        T t = clazz.newInstance();
        for (int i = 0; i < columnCount; i++) {
          Object columnValue = rs.getObject(i + 1);
          String columnLabel = rsmd.getColumnLabel(i + 1);

          System.out.println("设置属性: " + columnLabel + " = " + columnValue);

          Field field = clazz.getDeclaredField(columnLabel);
          field.setAccessible(true);
          field.set(t, columnValue);
        }
        list.add(t);
      }

      System.out.println("查询到记录数: " + list.size());
      return list;
    } catch (Exception e) {
      e.printStackTrace();
      throw new RuntimeException("查询失败: " + e.getMessage());
    } finally {
      JDBCUtils.closeResource(conn, ps, rs);
    }
  }
}
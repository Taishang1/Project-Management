package com.bkty.dao.impl;

import com.bkty.dao.CourseDao;
import com.bkty.entity.Course;
import com.bkty.utils.JDBCUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CourseDaoImpl implements CourseDao {

    @Override
    public int addCourse(Course course) {
        Connection connection = null;
        PreparedStatement ps = null;
        int result = 0;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "INSERT INTO course (cname, description) VALUES (?, ?)";
            ps = connection.prepareStatement(sql);
            ps.setString(1, course.getCname());
            ps.setString(2, course.getDescription());
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return result;
    }

    @Override
    public int getCourseCount() {
        Connection connection = null;
        PreparedStatement ps = null;
        int count = 0;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT COUNT(*) FROM course";
            ps = connection.prepareStatement(sql);
            ResultSet resultSet = ps.executeQuery();
            if (resultSet.next()) {
                count = resultSet.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return count;
    }

    @Override
    public int updateCourse(Course course) {
        Connection connection = null;
        PreparedStatement ps = null;
        int result = 0;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "UPDATE course SET cname=?, description=? WHERE cid=?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, course.getCname());
            ps.setString(2, course.getDescription());
            ps.setInt(3, course.getCid());
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return result;
    }

    @Override
    public int deleteCourse(int cid) {
        Connection connection = null;
        PreparedStatement ps = null;
        int result = 0;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "DELETE FROM course WHERE cid=?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, cid);
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return result;
    }

    @Override
    public Course getCourseById(int cid) {
        Connection connection = null;
        PreparedStatement ps = null;
        Course course = null;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT * FROM course WHERE cid=?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, cid);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                course = new Course();
                course.setCid(rs.getInt("cid"));
                course.setCname(rs.getString("cname"));
                course.setDescription(rs.getString("description"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return course;
    }

    @Override
    public List<Course> getAllCourses() {
        Connection connection = null;
        PreparedStatement ps = null;
        List<Course> courses = new ArrayList<>();
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT * FROM course";
            ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Course course = new Course();
                course.setCid(rs.getInt("cid"));
                course.setCname(rs.getString("cname"));
                course.setDescription(rs.getString("description"));
                courses.add(course);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return courses;
    }

    @Override
    public List<Course> searchCourses(String keyword) {
        Connection connection = null;
        PreparedStatement ps = null;
        List<Course> courses = new ArrayList<>();
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT * FROM course WHERE cname LIKE ? OR description LIKE ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Course course = new Course();
                course.setCid(rs.getInt("cid"));
                course.setCname(rs.getString("cname"));
                course.setDescription(rs.getString("description"));
                courses.add(course);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return courses;
    }

    @Override
    public List<Course> getByPage(int start, int size, String keyword) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Course> courses = new ArrayList<>();
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT * FROM course";
            if (keyword != null && !keyword.trim().isEmpty()) {
                sql += " WHERE cname LIKE ? OR description LIKE ?";
                sql += " LIMIT ?,?";
                ps = connection.prepareStatement(sql);
                ps.setString(1, "%" + keyword + "%");
                ps.setString(2, "%" + keyword + "%");
                ps.setInt(3, start);
                ps.setInt(4, size);
            } else {
                sql += " LIMIT ?,?";
                ps = connection.prepareStatement(sql);
                ps.setInt(1, start);
                ps.setInt(2, size);
            }
            System.out.println("执行SQL: " + sql + ", 参数: start=" + start + ", size=" + size);
            rs = ps.executeQuery();
            while (rs.next()) {
                Course course = new Course();
                course.setCid(rs.getInt("cid"));
                course.setCname(rs.getString("cname"));
                course.setDescription(rs.getString("description"));
                courses.add(course);
            }
            System.out.println("查询到 " + courses.size() + " 条记录");
        } catch (Exception e) {
            System.err.println("分页查询失败: " + e.getMessage());
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(rs, ps, connection);
        }
        return courses;
    }
}
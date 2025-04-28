package com.bkty.dao.impl;

import com.bkty.dao.TeacherDao;
import com.bkty.entity.Teacher;
import com.bkty.utils.JDBCUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class TeacherDaoImpl implements TeacherDao {

    @Override
    public int addTeacher(Teacher teacher) {
        Connection connection = null;
        PreparedStatement ps = null;
        int result = 0;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "INSERT INTO teacher (tname, sex, phone, email, cid) VALUES (?, ?, ?, ?, ?)";
            ps = connection.prepareStatement(sql);
            ps.setString(1, teacher.getTname());
            ps.setString(2, teacher.getSex());
            ps.setString(3, teacher.getPhone());
            ps.setString(4, teacher.getEmail());
            ps.setInt(5, teacher.getCid());
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return result;
    }

    @Override
    public int updateTeacher(Teacher teacher) {
        Connection connection = null;
        PreparedStatement ps = null;
        int result = 0;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "UPDATE teacher SET tname=?, sex=?, phone=?, email=?, cid=? WHERE tid=?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, teacher.getTname());
            ps.setString(2, teacher.getSex());
            ps.setString(3, teacher.getPhone());
            ps.setString(4, teacher.getEmail());
            ps.setInt(5, teacher.getCid());
            ps.setInt(6, teacher.getTid());
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return result;
    }

    @Override
    public int deleteTeacher(int tid) {
        Connection connection = null;
        PreparedStatement ps = null;
        int result = 0;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "DELETE FROM teacher WHERE tid=?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, tid);
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return result;
    }

    @Override
    public Teacher getTeacherById(int tid) {
        Connection connection = null;
        PreparedStatement ps = null;
        Teacher teacher = null;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT * FROM teacher WHERE tid=?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, tid);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                teacher = new Teacher();
                teacher.setTid(rs.getInt("tid"));
                teacher.setTname(rs.getString("tname"));
                teacher.setSex(rs.getString("sex"));
                teacher.setPhone(rs.getString("phone"));
                teacher.setEmail(rs.getString("email"));
                teacher.setCid(rs.getInt("cid"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return teacher;
    }

    @Override
    public List<Teacher> getAllTeachers() {
        Connection connection = null;
        PreparedStatement ps = null;
        List<Teacher> teachers = new ArrayList<>();
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT * FROM teacher";
            ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Teacher teacher = new Teacher();
                teacher.setTid(rs.getInt("tid"));
                teacher.setTname(rs.getString("tname"));
                teacher.setSex(rs.getString("sex"));
                teacher.setPhone(rs.getString("phone"));
                teacher.setEmail(rs.getString("email"));
                teacher.setCid(rs.getInt("cid"));
                teachers.add(teacher);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return teachers;
    }

    @Override
    public List<Teacher> searchTeachers(String keyword) {
        Connection connection = null;
        PreparedStatement ps = null;
        List<Teacher> teachers = new ArrayList<>();
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT * FROM teacher WHERE tname LIKE ? OR phone LIKE ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Teacher teacher = new Teacher();
                teacher.setTid(rs.getInt("tid"));
                teacher.setTname(rs.getString("tname"));
                teacher.setSex(rs.getString("sex"));
                teacher.setPhone(rs.getString("phone"));
                teacher.setEmail(rs.getString("email"));
                teacher.setCid(rs.getInt("cid"));
                teachers.add(teacher);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return teachers;
    }
}
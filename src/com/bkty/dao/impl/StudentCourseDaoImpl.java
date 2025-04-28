package com.bkty.dao.impl;

import com.bkty.dao.StudentCourseDao;
import com.bkty.entity.Course;
import com.bkty.entity.Student;
import com.bkty.entity.StudentCourse;
import com.bkty.utils.JDBCUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class StudentCourseDaoImpl implements StudentCourseDao {

    @Override
    public int addStudentCourse(StudentCourse studentCourse) {
        Connection connection = null;
        PreparedStatement ps = null;
        int result = 0;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "INSERT INTO student_course (sid, cid, select_time) VALUES (?, ?, ?)";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, studentCourse.getStudent().getSid());
            ps.setInt(2, studentCourse.getCourse().getCid());
            ps.setTimestamp(3, new java.sql.Timestamp(studentCourse.getSelectTime().getTime()));
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return result;
    }

    @Override
    public int deleteStudentCourse(int scid) {
        Connection connection = null;
        PreparedStatement ps = null;
        int result = 0;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "DELETE FROM student_course WHERE scid=?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, scid);
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return result;
    }

    @Override
    public StudentCourse getStudentCourseById(int scid) {
        Connection connection = null;
        PreparedStatement ps = null;
        StudentCourse studentCourse = null;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT sc.scid, sc.sid, sc.cid, sc.select_time, s.sname, c.cname " +
                    "FROM student_course sc " +
                    "LEFT JOIN student s ON sc.sid = s.sid " +
                    "LEFT JOIN course c ON sc.cid = c.cid " +
                    "WHERE sc.scid=?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, scid);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                studentCourse = new StudentCourse();
                studentCourse.setScid(scid);
                studentCourse.getStudent().setSid(rs.getInt("sid"));
                studentCourse.getStudent().setSname(rs.getString("sname"));
                studentCourse.getCourse().setCid(rs.getInt("cid"));
                studentCourse.getCourse().setCname(rs.getString("cname"));
                studentCourse.setSelectTime(rs.getTimestamp("select_time"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return studentCourse;
    }

    @Override
    public List<StudentCourse> getAllStudentCourses() {
        Connection connection = null;
        PreparedStatement ps = null;
        List<StudentCourse> studentCourses = new ArrayList<>();
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT sc.scid, s.sid, s.sname, c.cid, c.cname, sc.select_time " +
                    "FROM student_course sc " +
                    "LEFT JOIN student s ON sc.sid = s.sid " +
                    "LEFT JOIN course c ON sc.cid = c.cid";
            ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StudentCourse studentCourse = new StudentCourse();
                studentCourse.setScid(rs.getInt("scid"));
                studentCourse.getStudent().setSid(rs.getInt("sid"));
                studentCourse.getStudent().setSname(rs.getString("sname"));
                studentCourse.getCourse().setCid(rs.getInt("cid"));
                studentCourse.getCourse().setCname(rs.getString("cname"));
                studentCourse.setSelectTime(rs.getTimestamp("select_time"));
                studentCourses.add(studentCourse);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return studentCourses;
    }

    @Override
    public List<StudentCourse> searchStudentCourses(String keyword) {
        List<StudentCourse> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = JDBCUtils.getConnection();
            StringBuilder sql = new StringBuilder(
                    "SELECT sc.*, s.sname, c.cname " +
                            "FROM student_course sc " +
                            "JOIN student s ON sc.sid = s.sid " +
                            "JOIN course c ON sc.cid = c.cid " +
                            "WHERE 1=1");

            if (keyword != null && !keyword.trim().isEmpty()) {
                sql.append(" AND (s.sname LIKE ? OR c.cname LIKE ?)");
            }

            ps = conn.prepareStatement(sql.toString());

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(1, "%" + keyword + "%");
                ps.setString(2, "%" + keyword + "%");
            }

            rs = ps.executeQuery();
            while (rs.next()) {
                StudentCourse sc = new StudentCourse();
                // 设置选课信息
                sc.setScid(rs.getInt("scid"));

                // 设置学生信息
                Student student = new Student();
                student.setSid(rs.getInt("sid"));
                student.setSname(rs.getString("sname"));
                sc.setStudent(student);

                // 设置课程信息
                Course course = new Course();
                course.setCid(rs.getInt("cid"));
                course.setCname(rs.getString("cname"));
                sc.setCourse(course);

                list.add(sc);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(rs, ps, conn);
        }
        return list;
    }

    @Override
    public List<StudentCourse> getStudentCoursesByPage(int start, int size, String keyword) {
        Connection connection = null;
        PreparedStatement ps = null;
        List<StudentCourse> studentCourses = new ArrayList<>();
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT sc.scid, s.sid, s.sname, c.cid, c.cname, sc.select_time " +
                    "FROM student_course sc " +
                    "LEFT JOIN student s ON sc.sid = s.sid " +
                    "LEFT JOIN course c ON sc.cid = c.cid ";

            if (keyword != null && !keyword.trim().isEmpty()) {
                sql += "WHERE s.sname LIKE ? OR c.cname LIKE ? ";
            }

            sql += "LIMIT ?, ?";

            ps = connection.prepareStatement(sql);

            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + keyword + "%");
                ps.setString(paramIndex++, "%" + keyword + "%");
            }
            ps.setInt(paramIndex++, start);
            ps.setInt(paramIndex, size);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StudentCourse studentCourse = new StudentCourse();
                studentCourse.setScid(rs.getInt("scid"));

                // 创建并设置学生对象
                Student student = new Student();
                student.setSid(rs.getInt("sid"));
                student.setSname(rs.getString("sname"));
                studentCourse.setStudent(student);

                // 创建并设置课程对象
                Course course = new Course();
                course.setCid(rs.getInt("cid"));
                course.setCname(rs.getString("cname"));
                studentCourse.setCourse(course);

                studentCourse.setSelectTime(rs.getTimestamp("select_time"));
                studentCourses.add(studentCourse);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return studentCourses;
    }

    @Override
    public int getTotalCount(String keyword) {
        Connection connection = null;
        PreparedStatement ps = null;
        int count = 0;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT COUNT(*) FROM student_course sc " +
                    "LEFT JOIN student s ON sc.sid = s.sid " +
                    "LEFT JOIN course c ON sc.cid = c.cid ";

            if (keyword != null && !keyword.trim().isEmpty()) {
                sql += "WHERE s.sname LIKE ? OR c.cname LIKE ?";
            }

            ps = connection.prepareStatement(sql);

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(1, "%" + keyword + "%");
                ps.setString(2, "%" + keyword + "%");
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return count;
    }

    @Override
    public int updateStudentCourse(StudentCourse studentCourse) {
        Connection connection = null;
        PreparedStatement ps = null;
        int result = 0;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "UPDATE student_course SET sid=?, cid=? WHERE scid=?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, studentCourse.getStudent().getSid());
            ps.setInt(2, studentCourse.getCourse().getCid());
            ps.setInt(3, studentCourse.getScid());
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return result;
    }
}
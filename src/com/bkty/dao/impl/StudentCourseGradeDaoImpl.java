package com.bkty.dao.impl;

import com.bkty.dao.StudentCourseGradeDao;
import com.bkty.entity.Course;
import com.bkty.entity.Student;
import com.bkty.entity.StudentCourseGrade;
import com.bkty.utils.JDBCUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class StudentCourseGradeDaoImpl implements StudentCourseGradeDao {

    @Override
    public int addGrade(StudentCourseGrade grade) {
        Connection connection = null;
        PreparedStatement ps = null;
        int result = 0;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "INSERT INTO student_course_grade (sid, cid, grade, exam_date) VALUES (?, ?, ?, ?)";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, grade.getStudent().getSid());
            ps.setInt(2, grade.getCourse().getCid());
            ps.setDouble(3, grade.getGrade());
            ps.setDate(4, new java.sql.Date(grade.getExamDate().getTime()));
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return result;
    }

    @Override
    public int updateGrade(StudentCourseGrade grade) {
        Connection connection = null;
        PreparedStatement ps = null;
        int result = 0;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "UPDATE student_course_grade SET grade=?, exam_date=? WHERE scgid=?";
            ps = connection.prepareStatement(sql);
            ps.setDouble(1, grade.getGrade());
            ps.setDate(2, new java.sql.Date(grade.getExamDate().getTime()));
            ps.setInt(3, grade.getScgid());
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return result;
    }

    @Override
    public int deleteGrade(int scgid) {
        Connection connection = null;
        PreparedStatement ps = null;
        int result = 0;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "DELETE FROM student_course_grade WHERE scgid=?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, scgid);
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return result;
    }

    @Override
    public StudentCourseGrade getGradeById(int scgid) {
        Connection connection = null;
        PreparedStatement ps = null;
        StudentCourseGrade grade = null;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT scg.scgid, scg.sid, scg.cid, scg.grade, scg.exam_date, s.sname, c.cname " +
                    "FROM student_course_grade scg " +
                    "LEFT JOIN student s ON scg.sid = s.sid " +
                    "LEFT JOIN course c ON scg.cid = c.cid " +
                    "WHERE scg.scgid=?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, scgid);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                grade = new StudentCourseGrade();
                grade.setScgid(scgid);
                grade.getStudent().setSid(rs.getInt("sid"));
                grade.getStudent().setSname(rs.getString("sname"));
                grade.getCourse().setCid(rs.getInt("cid"));
                grade.getCourse().setCname(rs.getString("cname"));
                grade.setGrade(rs.getDouble("grade"));
                grade.setExamDate(rs.getDate("exam_date"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return grade;
    }

    @Override
    public StudentCourseGrade getGradeByStudentAndCourse(int sid, int cid) {
        Connection connection = null;
        PreparedStatement ps = null;
        StudentCourseGrade grade = null;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT scg.scgid, scg.sid, scg.cid, scg.grade, scg.exam_date, s.sname, c.cname " +
                    "FROM student_course_grade scg " +
                    "LEFT JOIN student s ON scg.sid = s.sid " +
                    "LEFT JOIN course c ON scg.cid = c.cid " +
                    "WHERE scg.sid=? AND scg.cid=?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, sid);
            ps.setInt(2, cid);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                grade = new StudentCourseGrade();
                grade.setScgid(rs.getInt("scgid"));
                grade.getStudent().setSid(rs.getInt("sid"));
                grade.getStudent().setSname(rs.getString("sname"));
                grade.getCourse().setCid(rs.getInt("cid"));
                grade.getCourse().setCname(rs.getString("cname"));
                grade.setGrade(rs.getDouble("grade"));
                grade.setExamDate(rs.getDate("exam_date"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return grade;
    }

    @Override
    public List<StudentCourseGrade> getAllGrades() {
        Connection connection = null;
        PreparedStatement ps = null;
        List<StudentCourseGrade> grades = new ArrayList<>();
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT scg.scgid, s.sid, s.sname, c.cid, c.cname, scg.grade, scg.exam_date " +
                    "FROM student_course_grade scg " +
                    "JOIN student s ON scg.sid = s.sid " +
                    "JOIN course c ON scg.cid = c.cid";

            ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                StudentCourseGrade grade = new StudentCourseGrade();
                grade.setScgid(rs.getInt("scgid"));

                // 创建并设置学生对象
                Student student = new Student();
                student.setSid(rs.getInt("sid"));
                student.setSname(rs.getString("sname"));
                grade.setStudent(student);

                // 创建并设置课程对象
                Course course = new Course();
                course.setCid(rs.getInt("cid"));
                course.setCname(rs.getString("cname"));
                grade.setCourse(course);

                grade.setGrade(rs.getDouble("grade"));
                grade.setExamDate(rs.getDate("exam_date"));

                grades.add(grade);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return grades;
    }

    @Override
    public List<StudentCourseGrade> searchGrades(String keyword) {
        Connection connection = null;
        PreparedStatement ps = null;
        List<StudentCourseGrade> grades = new ArrayList<>();
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT scg.scgid, scg.sid, scg.cid, scg.grade, scg.exam_date, s.sname, c.cname " +
                    "FROM student_course_grade scg " +
                    "LEFT JOIN student s ON scg.sid = s.sid " +
                    "LEFT JOIN course c ON scg.cid = c.cid " +
                    "WHERE s.sname LIKE ? OR c.cname LIKE ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StudentCourseGrade grade = new StudentCourseGrade();
                grade.setScgid(rs.getInt("scgid"));
                grade.getStudent().setSid(rs.getInt("sid"));
                grade.getStudent().setSname(rs.getString("sname"));
                grade.getCourse().setCid(rs.getInt("cid"));
                grade.getCourse().setCname(rs.getString("cname"));
                grade.setGrade(rs.getDouble("grade"));
                grade.setExamDate(rs.getDate("exam_date"));
                grades.add(grade);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return grades;
    }

    @Override
    public List<StudentCourseGrade> getGradesByPage(int start, int size, String keyword) {
        Connection connection = null;
        PreparedStatement ps = null;
        List<StudentCourseGrade> grades = new ArrayList<>();
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT scg.scgid, s.sid, s.sname, c.cid, c.cname, scg.grade, scg.exam_date " +
                    "FROM student_course_grade scg " +
                    "JOIN student s ON scg.sid = s.sid " +
                    "JOIN course c ON scg.cid = c.cid ";

            if (keyword != null && !keyword.trim().isEmpty()) {
                sql += "WHERE s.sname LIKE ? OR c.cname LIKE ? ";
            }

            sql += "LIMIT ?, ?";

            System.out.println("执行的SQL: " + sql);

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
                StudentCourseGrade grade = new StudentCourseGrade();
                grade.setScgid(rs.getInt("scgid"));

                // 创建并设置学生对象
                Student student = new Student();
                student.setSid(rs.getInt("sid"));
                student.setSname(rs.getString("sname"));
                grade.setStudent(student);

                // 创建并设置课程对象
                Course course = new Course();
                course.setCid(rs.getInt("cid"));
                course.setCname(rs.getString("cname"));
                grade.setCourse(course);

                grade.setGrade(rs.getDouble("grade"));
                grade.setExamDate(rs.getDate("exam_date"));

                grades.add(grade);
                System.out.println("读取到成绩记录: " + grade);
            }
        } catch (Exception e) {
            System.err.println("查询成绩时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return grades;
    }

    @Override
    public int getTotalCount(String keyword) {
        Connection connection = null;
        PreparedStatement ps = null;
        int count = 0;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT COUNT(*) FROM student_course_grade scg " +
                    "JOIN student s ON scg.sid = s.sid " +
                    "JOIN course c ON scg.cid = c.cid ";

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
}
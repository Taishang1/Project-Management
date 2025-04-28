package com.bkty.dao.impl;

import com.bkty.dao.StudentDao;
import com.bkty.entity.Clazz;
import com.bkty.entity.Student;
import com.bkty.utils.JDBCUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

public class StudentDaoImpl implements StudentDao {

    @Override
    public int addStudent(Student student) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = JDBCUtils.getConnection();
            String sql = "INSERT INTO student(sid,sname,sex,hobby,birthdate,phone,reamrk,cid) " +
                    "SELECT COALESCE(MAX(sid), 0) + 1, ?,?,?,?,?,?,? FROM student";
            ps = conn.prepareStatement(sql);

            int paramIndex = 1;
            ps.setString(paramIndex++, student.getSname());
            ps.setString(paramIndex++, student.getSex());
            ps.setString(paramIndex++, student.getHobby());
            ps.setDate(paramIndex++, new java.sql.Date(student.getBirthday().getTime()));
            ps.setString(paramIndex++, student.getPhone());
            ps.setString(paramIndex++, student.getReamrk());
            ps.setInt(paramIndex++, student.getCid());

            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, conn);
        }
        return 0;
    }

    @Override
    public int getTotalCount(String sname, String phone) {
        Connection connection = null;
        PreparedStatement ps = null;
        int totalCount = 0;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT COUNT(*) count FROM student WHERE 1=1";

            if (sname != null && !sname.isEmpty()) {
                sql += " AND sname LIKE '%" + sname + "%'";
            }

            if (phone != null && !phone.isEmpty()) {
                sql += " AND phone = '" + phone + "'";
            }

            ps = connection.prepareStatement(sql);
            ResultSet resultSet = ps.executeQuery();

            if (resultSet.next()) {
                totalCount = resultSet.getInt("count");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return totalCount;
    }

    @Override
    public List<Student> getStudentByPage(int start, int size, String sname, String phone) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Student> students = new ArrayList<>();
        try {
            connection = JDBCUtils.getConnection();
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT s.*, c.cname FROM student s ");
            sql.append("LEFT JOIN clazz c ON s.cid = c.cid ");
            sql.append("WHERE 1=1 ");

            if (sname != null && !sname.trim().isEmpty()) {
                sql.append("AND s.sname LIKE ? ");
            }
            if (phone != null && !phone.trim().isEmpty()) {
                sql.append("AND s.phone LIKE ? ");
            }
            sql.append("LIMIT ?, ?");

            ps = connection.prepareStatement(sql.toString());

            int paramIndex = 1;
            if (sname != null && !sname.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + sname + "%");
            }
            if (phone != null && !phone.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + phone + "%");
            }
            ps.setInt(paramIndex++, start);
            ps.setInt(paramIndex, size);

            rs = ps.executeQuery();
            while (rs.next()) {
                Student student = new Student();
                student.setSid(rs.getInt("sid"));
                student.setSname(rs.getString("sname"));
                student.setSex(rs.getString("sex"));
                student.setBirthdate(rs.getDate("birthdate"));
                student.setPhone(rs.getString("phone"));
                student.setHobby(rs.getString("hobby"));
                student.setReamrk(rs.getString("reamrk"));

                // 设置班级信息
                int cid = rs.getInt("cid");
                if (!rs.wasNull()) {
                    student.setCid(cid);
                    Clazz clazz = new Clazz();
                    clazz.setCid(cid);
                    clazz.setCname(rs.getString("cname"));
                    student.setClazz(clazz);
                }

                students.add(student);
                System.out.println("加载学生数据: " + student);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(rs, ps, connection);
        }
        return students;
    }

    @Override
    public int updateStudent(Student student) {
        Connection connection = null;
        PreparedStatement ps = null;
        int result = 0;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "UPDATE student SET sname=?, sex=?, hobby=?, birthdate=?, phone=?, reamrk=?, cid=? WHERE sid=?";
            ps = connection.prepareStatement(sql);

            ps.setString(1, student.getSname());
            ps.setString(2, student.getSex());
            ps.setString(3, student.getHobby());
            ps.setDate(4, new java.sql.Date(student.getBirthdate().getTime()));
            ps.setString(5, student.getPhone());
            ps.setString(6, student.getReamrk());
            ps.setInt(7, student.getCid());
            ps.setInt(8, student.getSid());

            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return result;
    }

    @Override
    public Student getStudentById(int sid) {
        Connection connection = null;
        PreparedStatement ps = null;
        Student student = null;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT s.*, c.cname FROM student s JOIN clazz c ON s.cid = c.cid WHERE s.sid = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, sid);
            ResultSet resultSet = ps.executeQuery();
            if (resultSet.next()) {
                String sname = resultSet.getString("sname");
                String sex = resultSet.getString("sex");
                String hobby = resultSet.getString("hobby");
                Date birthdate = resultSet.getDate("birthdate");
                String phone = resultSet.getString("phone");
                String reamrk = resultSet.getString("reamrk");
                int cid = resultSet.getInt("cid");
                String cname = resultSet.getString("cname");

                Clazz clazz = new Clazz();
                clazz.setCid(cid);
                clazz.setCname(cname);

                student = new Student(sid, sname, sex, hobby, birthdate, phone, reamrk, cid, clazz);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return student;
    }

    @Override
    public int getStudentCount() {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int count = 0;

        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT COUNT(*) as count FROM student";
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt("count");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(rs, ps, connection);
        }
        return count;
    }

    @Override
    public boolean deleteStudent(int sid) {
        Connection connection = null;
        PreparedStatement ps = null;
        boolean result = false;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "DELETE FROM student WHERE sid = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, sid);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                result = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return result;
    }

    @Override
    public int updateClazz(Clazz clazz) {
        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "UPDATE clazz SET cname = ?, cteacher = ?, remark = ? WHERE cid = ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, clazz.getCname());
            ps.setString(2, clazz.getCteacher());
            ps.setString(3, clazz.getRemark());
            ps.setInt(4, clazz.getCid());
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return 0;
    }

    @Override
    public int addClazz(Clazz clazz) {
        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "INSERT INTO clazz (cname, cteacher, remark) VALUES (?, ?, ?)";
            ps = connection.prepareStatement(sql);
            ps.setString(1, clazz.getCname());
            ps.setString(2, clazz.getCteacher());
            ps.setString(3, clazz.getRemark());
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return 0;
    }

    @Override
    public List<Student> getAll(String sname, String phone) {
        return getStudentByPage(0, Integer.MAX_VALUE, sname, phone);
    }

    @Override
    public int getStudentCount(String sname, String phone) {
        return getTotalCount(sname, phone);
    }

    @Override
    public List<Clazz> getAllClazz() {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Clazz> clazzList = new ArrayList<>();

        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT * FROM clazz";
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Clazz clazz = new Clazz();
                clazz.setCid(rs.getInt("cid"));
                clazz.setCname(rs.getString("cname"));
                clazz.setCteacher(rs.getString("cteacher"));
                clazz.setRemark(rs.getString("remark"));
                clazzList.add(clazz);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(rs, ps, connection);
        }
        return clazzList;
    }

    @Override
    public boolean batchSaveStudents(List<Student> students) {
        try {
            for (Student student : students) {
                addStudent(student);
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
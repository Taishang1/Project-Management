package com.bkty.dao.impl;

import com.bkty.dao.AttendanceDao;
import com.bkty.dao.BaseDao;
import com.bkty.entity.Attendance;

import java.util.List;

public class AttendanceDaoImpl extends BaseDao implements AttendanceDao {

    @Override
    public int addAttendance(Attendance attendance) {
        String sql = "INSERT INTO attendance (sid, cid, attendance_date, status) VALUES (?, ?, ?, ?)";
        return update(sql,
                attendance.getSid(),
                attendance.getCid(),
                attendance.getAttendanceDate(),
                attendance.getStatus());
    }

    @Override
    public int updateAttendance(Attendance attendance) {
        String sql = "UPDATE attendance SET sid=?, cid=?, attendance_date=?, status=? WHERE aid=?";
        return update(sql,
                attendance.getSid(),
                attendance.getCid(),
                attendance.getAttendanceDate(),
                attendance.getStatus(),
                attendance.getAid());
    }

    @Override
    public int deleteAttendance(int aid) {
        String sql = "DELETE FROM attendance WHERE aid=?";
        return update(sql, aid);
    }

    @Override
    public Attendance getAttendanceById(int aid) {
        String sql = "SELECT a.aid, a.sid, a.cid, a.attendance_date as attendanceDate, a.status, " +
                "s.sname as studentName, c.cname as courseName " +
                "FROM attendance a " +
                "LEFT JOIN student s ON a.sid = s.sid " +
                "LEFT JOIN course c ON a.cid = c.cid " +
                "WHERE a.aid = ?";
        try {
            System.out.println("执行单个考勤详情查询SQL: " + sql + ", aid=" + aid);
            Attendance attendance = queryForOne(Attendance.class, sql, aid);
            System.out.println("查询到考勤记录: " + (attendance != null ? "是" : "否"));
            return attendance;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("查询考勤记录失败: " + e.getMessage());
        }
    }

    @Override
    public List<Attendance> getAllAttendances() {
        String sql = "SELECT aid, sid, cid, attendance_date as attendanceDate, " +
                "status FROM attendance ORDER BY attendance_date DESC";
        try {
            System.out.println("执行考勤查询SQL: " + sql);
            List<Attendance> list = queryForList(Attendance.class, sql);
            System.out.println("查询到考勤记录数: " + (list != null ? list.size() : 0));
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("查询考勤记录失败: " + e.getMessage());
        }
    }

    @Override
    public List<Attendance> searchAttendances(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllAttendancesWithDetails();
        }

        try {
            String sql = "SELECT a.aid, a.sid, a.cid, a.attendance_date as attendanceDate, a.status, " +
                    "s.sname as studentName, c.cname as courseName " +
                    "FROM attendance a " +
                    "LEFT JOIN student s ON a.sid = s.sid " +
                    "LEFT JOIN course c ON a.cid = c.cid " +
                    "WHERE s.sname LIKE ? OR c.cname LIKE ? OR a.status LIKE ? " +
                    "ORDER BY a.attendance_date DESC";

            System.out.println("执行考勤搜索SQL: " + sql + ", 关键词: " + keyword);
            String pattern = "%" + keyword + "%";

            List<Attendance> list = queryForList(Attendance.class, sql, pattern, pattern, pattern);
            System.out.println("搜索到考勤记录数: " + (list != null ? list.size() : 0));
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("搜索考勤记录失败: " + e.getMessage());
            return getAllAttendancesWithDetails();
        }
    }

    @Override
    public List<Attendance> getAllAttendancesWithDetails() {
        String sql = "SELECT a.aid, a.sid, a.cid, a.attendance_date as attendanceDate, a.status, " +
                "s.sname as studentName, c.cname as courseName " +
                "FROM attendance a " +
                "LEFT JOIN student s ON a.sid = s.sid " +
                "LEFT JOIN course c ON a.cid = c.cid " +
                "ORDER BY a.attendance_date DESC";
        try {
            System.out.println("执行考勤详情查询SQL: " + sql);
            List<Attendance> list = queryForList(Attendance.class, sql);
            System.out.println("查询到考勤记录数: " + (list != null ? list.size() : 0));
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("查询考勤记录失败: " + e.getMessage());
        }
    }
}
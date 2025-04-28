package com.bkty.controller;

import com.bkty.entity.Attendance;
import com.bkty.service.AttendanceService;
import com.bkty.service.impl.AttendanceServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/AttendanceServlet")
public class AttendanceServlet extends BaseServlet {

    private AttendanceService attendanceService = new AttendanceServiceImpl();
    private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    // 添加考勤记录
    protected void addAttendance(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        String sidStr = req.getParameter("sid");
        int sid = Integer.parseInt(sidStr);
        String cidStr = req.getParameter("cid");
        int cid = Integer.parseInt(cidStr);
        String attendanceDateStr = req.getParameter("attendance_date");
        String status = req.getParameter("status");

        Date attendanceDate = null;
        try {
            attendanceDate = sdf.parse(attendanceDateStr);
        } catch (ParseException e) {
            e.printStackTrace();
            resp.getWriter().write("0");
            return;
        }

        Attendance attendance = new Attendance(sid, cid, attendanceDate, status);

        boolean result = attendanceService.addAttendance(attendance);
        resp.getWriter().write(result ? "1" : "0");
    }

    // 更新考勤记录
    protected void updateAttendance(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        String aidStr = req.getParameter("aid");
        int aid = Integer.parseInt(aidStr);
        String sidStr = req.getParameter("sid");
        int sid = Integer.parseInt(sidStr);
        String cidStr = req.getParameter("cid");
        int cid = Integer.parseInt(cidStr);
        String attendanceDateStr = req.getParameter("attendance_date");
        String status = req.getParameter("status");

        Date attendanceDate = null;
        try {
            attendanceDate = sdf.parse(attendanceDateStr);
        } catch (ParseException e) {
            e.printStackTrace();
            resp.getWriter().write("0");
            return;
        }

        Attendance attendance = new Attendance(aid, sid, cid, attendanceDate, status);

        boolean result = attendanceService.updateAttendance(attendance);
        resp.getWriter().write(result ? "1" : "0");
    }

    // 删除考勤记录
    protected void deleteAttendance(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String aidStr = req.getParameter("aid");
        int aid = Integer.parseInt(aidStr);

        boolean result = attendanceService.deleteAttendance(aid);
        resp.getWriter().write(result ? "1" : "0");
    }

    // 获取考勤记录列表
    protected void getAllAttendances(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            req.setCharacterEncoding("UTF-8");
            resp.setContentType("application/json;charset=UTF-8");
            System.out.println("请求方法: getAllAttendances");

            List<Attendance> attendances = attendanceService.getAllAttendancesWithDetails();
            if (attendances != null) {
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < attendances.size(); i++) {
                    Attendance attendance = attendances.get(i);
                    if (i > 0) {
                        json.append(",");
                    }
                    json.append("{");
                    json.append("\"aid\":").append(attendance.getAid()).append(",");
                    json.append("\"sid\":").append(attendance.getSid()).append(",");
                    json.append("\"cid\":").append(attendance.getCid()).append(",");

                    String dateStr = attendance.getAttendanceDate() != null ? sdf.format(attendance.getAttendanceDate())
                            : "";
                    json.append("\"attendanceDate\":\"").append(dateStr).append("\",");
                    json.append("\"status\":\"").append(escapeJson(attendance.getStatus())).append("\"");

                    if (attendance.getStudentName() != null) {
                        json.append(",\"studentName\":\"").append(escapeJson(attendance.getStudentName())).append("\"");
                    }
                    if (attendance.getCourseName() != null) {
                        json.append(",\"courseName\":\"").append(escapeJson(attendance.getCourseName())).append("\"");
                    }

                    json.append("}");
                }
                json.append("]");

                String jsonStr = json.toString();
                System.out.println("返回考勤JSON: " + jsonStr);
                resp.getWriter().write(jsonStr);
            } else {
                resp.getWriter().write("[]");
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("获取考勤列表失败: " + e.getMessage());
            resp.setStatus(500);
            resp.getWriter().write("{\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    // 根据ID获取考勤记录
    protected void getAttendanceById(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        String aidStr = req.getParameter("aid");
        int aid = Integer.parseInt(aidStr);
        Attendance attendance = attendanceService.getAttendanceById(aid);

        if (attendance != null) {
            StringBuilder json = new StringBuilder("{");
            json.append("\"aid\":").append(attendance.getAid()).append(",");
            json.append("\"sid\":").append(attendance.getSid()).append(",");
            json.append("\"cid\":").append(attendance.getCid()).append(",");

            String dateStr = attendance.getAttendanceDate() != null ? sdf.format(attendance.getAttendanceDate()) : "";
            json.append("\"attendanceDate\":\"").append(dateStr).append("\",");
            json.append("\"status\":\"").append(escapeJson(attendance.getStatus())).append("\"");

            if (attendance.getStudentName() != null) {
                json.append(",\"studentName\":\"").append(escapeJson(attendance.getStudentName())).append("\"");
            }
            if (attendance.getCourseName() != null) {
                json.append(",\"courseName\":\"").append(escapeJson(attendance.getCourseName())).append("\"");
            }

            json.append("}");

            String jsonStr = json.toString();
            System.out.println("返回单个考勤JSON: " + jsonStr);
            resp.getWriter().write(jsonStr);
        } else {
            resp.getWriter().write("{}");
        }
    }

    // 搜索考勤记录
    protected void searchAttendances(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            req.setCharacterEncoding("UTF-8");
            resp.setContentType("application/json;charset=UTF-8");
            System.out.println("请求方法: searchAttendances");

            String keyword = req.getParameter("keyword");
            System.out.println("搜索关键词: " + keyword);

            List<Attendance> attendances;
            if (keyword == null || keyword.trim().isEmpty()) {
                attendances = attendanceService.getAllAttendancesWithDetails();
            } else {
                attendances = attendanceService.searchAttendances(keyword);
            }

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < attendances.size(); i++) {
                Attendance attendance = attendances.get(i);
                if (i > 0) {
                    json.append(",");
                }
                json.append("{");
                json.append("\"aid\":").append(attendance.getAid()).append(",");
                json.append("\"sid\":").append(attendance.getSid()).append(",");
                json.append("\"cid\":").append(attendance.getCid()).append(",");

                String dateStr = attendance.getAttendanceDate() != null ? sdf.format(attendance.getAttendanceDate())
                        : "";
                json.append("\"attendanceDate\":\"").append(dateStr).append("\",");
                json.append("\"status\":\"").append(escapeJson(attendance.getStatus())).append("\"");

                if (attendance.getStudentName() != null) {
                    json.append(",\"studentName\":\"").append(escapeJson(attendance.getStudentName())).append("\"");
                }
                if (attendance.getCourseName() != null) {
                    json.append(",\"courseName\":\"").append(escapeJson(attendance.getCourseName())).append("\"");
                }

                json.append("}");
            }
            json.append("]");

            String jsonStr = json.toString();
            System.out.println("返回搜索结果JSON: " + jsonStr);
            resp.getWriter().write(jsonStr);
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("搜索考勤记录失败: " + e.getMessage());
            resp.setStatus(500);
            resp.getWriter().write("{\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    // 用于转义JSON字符串的辅助方法
    private String escapeJson(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
package com.bkty.controller;

import com.bkty.entity.Teacher;
import com.bkty.service.TeacherService;
import com.bkty.service.impl.TeacherServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/TeacherServlet")
public class TeacherServlet extends HttpServlet {
    private TeacherService teacherService = new TeacherServiceImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        String methodName = request.getParameter("methodName");

        if ("getAllTeachers".equals(methodName)) {
            getAllTeachers(request, response);
        } else if ("addTeacher".equals(methodName)) {
            addTeacher(request, response);
        } else if ("deleteTeacher".equals(methodName)) {
            deleteTeacher(request, response);
        } else if ("getTeacherById".equals(methodName)) {
            getTeacherById(request, response);
        } else if ("updateTeacher".equals(methodName)) {
            updateTeacher(request, response);
        }
    }

    private void getAllTeachers(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<Teacher> teachers = teacherService.getAllTeachers();
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < teachers.size(); i++) {
            Teacher teacher = teachers.get(i);
            if (i > 0) {
                json.append(",");
            }
            json.append("{")
                    .append("\"tid\":").append(teacher.getTid()).append(",")
                    .append("\"tname\":\"").append(teacher.getTname()).append("\",")
                    .append("\"sex\":\"").append(teacher.getSex()).append("\",")
                    .append("\"phone\":\"").append(teacher.getPhone()).append("\",")
                    .append("\"email\":\"").append(teacher.getEmail()).append("\",")
                    .append("\"cid\":").append(teacher.getCid())
                    .append("}");
        }
        json.append("]");
        response.getWriter().write(json.toString());
    }

    private void addTeacher(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String tname = request.getParameter("tname");
        String sex = request.getParameter("sex");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        int cid = Integer.parseInt(request.getParameter("cid"));

        Teacher teacher = new Teacher();
        teacher.setTname(tname);
        teacher.setSex(sex);
        teacher.setPhone(phone);
        teacher.setEmail(email);
        teacher.setCid(cid);

        boolean result = teacherService.addTeacher(teacher);
        response.getWriter().write(result ? "1" : "0");
    }

    private void deleteTeacher(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int tid = Integer.parseInt(request.getParameter("tid"));
        boolean result = teacherService.deleteTeacher(tid);
        response.getWriter().write(result ? "1" : "0");
    }

    private void getTeacherById(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int tid = Integer.parseInt(request.getParameter("tid"));
        Teacher teacher = teacherService.getTeacherById(tid);

        if (teacher != null) {
            StringBuilder json = new StringBuilder();
            json.append("{")
                    .append("\"tid\":").append(teacher.getTid()).append(",")
                    .append("\"tname\":\"").append(teacher.getTname()).append("\",")
                    .append("\"sex\":\"").append(teacher.getSex()).append("\",")
                    .append("\"phone\":\"").append(teacher.getPhone()).append("\",")
                    .append("\"email\":\"").append(teacher.getEmail()).append("\",")
                    .append("\"cid\":").append(teacher.getCid())
                    .append("}");
            response.getWriter().write(json.toString());
        } else {
            response.getWriter().write("{}");
        }
    }

    private void updateTeacher(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int tid = Integer.parseInt(request.getParameter("tid"));
            String tname = request.getParameter("tname");
            String sex = request.getParameter("sex");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            int cid = Integer.parseInt(request.getParameter("cid"));

            Teacher teacher = new Teacher();
            teacher.setTid(tid);
            teacher.setTname(tname);
            teacher.setSex(sex);
            teacher.setPhone(phone);
            teacher.setEmail(email);
            teacher.setCid(cid);

            boolean result = teacherService.updateTeacher(teacher);
            response.getWriter().write(result ? "1" : "0");
        } catch (Exception e) {
            System.out.println("更新教师信息失败: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("0");
        }
    }
}
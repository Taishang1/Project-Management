package com.bkty.controller;

import com.bkty.entity.StudentCourse;
import com.bkty.service.StudentCourseService;
import com.bkty.service.impl.StudentCourseServiceImpl;
import com.bkty.entity.PageBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/StudentCourseServlet")
public class StudentCourseServlet extends HttpServlet {
    private StudentCourseService studentCourseService = new StudentCourseServiceImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        String methodName = request.getParameter("methodName");

        if ("getAllStudentCourses".equals(methodName)) {
            getAllStudentCourses(request, response);
        } else if ("addStudentCourse".equals(methodName)) {
            addStudentCourse(request, response);
        } else if ("deleteStudentCourse".equals(methodName)) {
            deleteStudentCourse(request, response);
        } else if ("getStudentCourseById".equals(methodName)) {
            getStudentCourseById(request, response);
        } else if ("updateStudentCourse".equals(methodName)) {
            updateStudentCourse(request, response);
        } else if ("getStudentCourseJson".equals(methodName)) {
            getStudentCourseJson(request, response);
        }
    }

    private void getAllStudentCourses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int pageIndex = 1;
            try {
                String pageStr = request.getParameter("page");
                if (pageStr != null && !pageStr.trim().isEmpty()) {
                    pageIndex = Integer.parseInt(pageStr);
                }
            } catch (NumberFormatException e) {
                // 使用默认值 1
            }

            String keyword = request.getParameter("keyword");

            PageBean<StudentCourse> pageBean = studentCourseService.getStudentCoursesByPage(pageIndex, keyword);

            response.setContentType("application/json;charset=UTF-8");

            // 创建简单的JSON字符串而不是使用GSON
            StringBuilder json = new StringBuilder();
            json.append("{\"index\":").append(pageBean.getIndex())
                    .append(",\"pageSize\":").append(pageBean.getSize())
                    .append(",\"totalCount\":").append(pageBean.getTotalCount())
                    .append(",\"totalPageCount\":").append(pageBean.getTotalPage())
                    .append(",\"list\":[");

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            List<StudentCourse> list = pageBean.getList();

            for (int i = 0; i < list.size(); i++) {
                StudentCourse sc = list.get(i);
                if (i > 0) {
                    json.append(",");
                }

                json.append("{\"scid\":").append(sc.getScid())
                        .append(",\"student\":{\"sid\":").append(sc.getStudent().getSid())
                        .append(",\"sname\":\"").append(sc.getStudent().getSname()).append("\"}")
                        .append(",\"course\":{\"cid\":").append(sc.getCourse().getCid())
                        .append(",\"cname\":\"").append(sc.getCourse().getCname()).append("\"}")
                        .append(",\"selectTime\":\"")
                        .append(sc.getSelectTime() != null ? sdf.format(sc.getSelectTime()) : "").append("\"}");
            }

            json.append("]}");

            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    private void addStudentCourse(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int sid = Integer.parseInt(request.getParameter("sid"));
        int cid = Integer.parseInt(request.getParameter("cid"));
        StudentCourse studentCourse = new StudentCourse();
        studentCourse.getStudent().setSid(sid);
        studentCourse.getCourse().setCid(cid);
        studentCourse.setSelectTime(new java.util.Date());
        int result = studentCourseService.addStudentCourse(studentCourse);
        response.getWriter().write(result > 0 ? "1" : "0");
    }

    private void deleteStudentCourse(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int scid = Integer.parseInt(request.getParameter("scid"));
        int result = studentCourseService.deleteStudentCourse(scid);
        response.getWriter().write(result > 0 ? "1" : "0");
    }

    private void getStudentCourseById(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int scid = Integer.parseInt(request.getParameter("scid"));
            StudentCourse studentCourse = studentCourseService.getStudentCourseById(scid);

            if (studentCourse != null) {
                request.setAttribute("studentCourse", studentCourse);
                request.getRequestDispatcher("editStudentCourse.jsp").forward(request, response);
            } else {
                response.sendRedirect("listStudentCourse.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("listStudentCourse.jsp");
        }
    }

    private void updateStudentCourse(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int scid = Integer.parseInt(request.getParameter("scid"));
            int sid = Integer.parseInt(request.getParameter("sid"));
            int cid = Integer.parseInt(request.getParameter("cid"));

            StudentCourse studentCourse = new StudentCourse();
            studentCourse.setScid(scid);
            studentCourse.getStudent().setSid(sid);
            studentCourse.getCourse().setCid(cid);

            int result = studentCourseService.updateStudentCourse(studentCourse);
            response.getWriter().write(result > 0 ? "1" : "0");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("0");
        }
    }

    private void getStudentCourseJson(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int scid = Integer.parseInt(request.getParameter("scid"));
            StudentCourse studentCourse = studentCourseService.getStudentCourseById(scid);

            if (studentCourse != null) {
                response.setContentType("application/json;charset=UTF-8");
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

                // 手动构建JSON
                StringBuilder json = new StringBuilder();
                json.append("{\"scid\":").append(studentCourse.getScid())
                        .append(",\"student\":{\"sid\":").append(studentCourse.getStudent().getSid())
                        .append(",\"sname\":\"").append(studentCourse.getStudent().getSname()).append("\"}")
                        .append(",\"course\":{\"cid\":").append(studentCourse.getCourse().getCid())
                        .append(",\"cname\":\"").append(studentCourse.getCourse().getCname()).append("\"}");

                if (studentCourse.getSelectTime() != null) {
                    json.append(",\"selectTime\":\"").append(sdf.format(studentCourse.getSelectTime())).append("\"");
                } else {
                    json.append(",\"selectTime\":null");
                }

                json.append("}");

                response.getWriter().write(json.toString());
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"选课记录不存在\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}
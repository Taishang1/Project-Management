package com.bkty.controller;

import com.bkty.entity.PageBean;
import com.bkty.entity.StudentCourseGrade;
import com.bkty.service.StudentCourseGradeService;
import com.bkty.service.impl.StudentCourseGradeServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/StudentCourseGradeServlet")
public class StudentCourseGradeServlet extends HttpServlet {
    private StudentCourseGradeService studentCourseGradeService = new StudentCourseGradeServiceImpl();
    private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        String methodName = request.getParameter("methodName");

        if ("getAllGrades".equals(methodName)) {
            getAllGrades(request, response);
        } else if ("addGrade".equals(methodName)) {
            addGrade(request, response);
        } else if ("deleteGrade".equals(methodName)) {
            deleteGrade(request, response);
        } else if ("getGradeById".equals(methodName)) {
            getGradeById(request, response);
        } else if ("updateGrade".equals(methodName)) {
            updateGrade(request, response);
        }
    }

    private void getAllGrades(HttpServletRequest request, HttpServletResponse response) throws IOException {
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
            System.out.println("查询参数 - 页码: " + pageIndex + ", 关键字: " + keyword);

            PageBean<StudentCourseGrade> pageBean = studentCourseGradeService.getStudentCourseGradeByPage(pageIndex,
                    keyword);
            System.out.println("查询结果 - 总记录数: " + pageBean.getTotalCount() +
                    ", 当前页数据量: " + (pageBean.getList() != null ? pageBean.getList().size() : 0));

            response.setContentType("application/json;charset=UTF-8");

            // Manual JSON construction instead of Gson
            StringBuilder json = new StringBuilder("{");
            json.append("\"index\":").append(pageBean.getIndex()).append(",");
            json.append("\"totalPageCount\":").append(pageBean.getTotalPage()).append(",");
            json.append("\"totalCount\":").append(pageBean.getTotalCount()).append(",");
            json.append("\"list\":[");

            List<StudentCourseGrade> list = pageBean.getList();
            for (int i = 0; i < list.size(); i++) {
                StudentCourseGrade grade = list.get(i);
                if (i > 0) {
                    json.append(",");
                }
                json.append("{");
                json.append("\"scgid\":").append(grade.getScgid()).append(",");

                // Student info
                json.append("\"student\":{");
                json.append("\"sid\":").append(grade.getStudent().getSid()).append(",");
                json.append("\"sname\":\"").append(escapeJsonString(grade.getStudent().getSname())).append("\"");
                json.append("},");

                // Course info
                json.append("\"course\":{");
                json.append("\"cid\":").append(grade.getCourse().getCid()).append(",");
                json.append("\"cname\":\"").append(escapeJsonString(grade.getCourse().getCname())).append("\"");
                json.append("},");

                // Grade info
                json.append("\"grade\":").append(grade.getGrade()).append(",");

                // Format exam date
                String examDate = grade.getExamDate() != null ? sdf.format(grade.getExamDate()) : "";
                json.append("\"examDate\":\"").append(examDate).append("\"");

                json.append("}");
            }

            json.append("]}");

            System.out.println("返回的JSON数据: " + json.toString());
            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            String errorJson = "{\"error\": \"" + escapeJsonString(e.getMessage()) + "\"}";
            response.getWriter().write(errorJson);
        }
    }

    private void addGrade(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int sid = Integer.parseInt(request.getParameter("sid"));
        int cid = Integer.parseInt(request.getParameter("cid"));
        double grade = Double.parseDouble(request.getParameter("grade"));
        String examDate = request.getParameter("exam_date");

        StudentCourseGrade gradeObj = new StudentCourseGrade();
        gradeObj.getStudent().setSid(sid);
        gradeObj.getCourse().setCid(cid);
        gradeObj.setGrade(grade);
        gradeObj.setExamDate(java.sql.Date.valueOf(examDate));

        int result = studentCourseGradeService.addGrade(gradeObj);
        response.getWriter().write(result > 0 ? "1" : "0");
    }

    private void deleteGrade(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int scgid = Integer.parseInt(request.getParameter("scgid"));
        int result = studentCourseGradeService.deleteGrade(scgid);
        response.getWriter().write(result > 0 ? "1" : "0");
    }

    private void getGradeById(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int scgid = Integer.parseInt(request.getParameter("scgid"));
            StudentCourseGrade grade = studentCourseGradeService.getGradeById(scgid);

            response.setContentType("application/json;charset=UTF-8");

            if (grade != null) {
                StringBuilder json = new StringBuilder("{");
                json.append("\"scgid\":").append(grade.getScgid()).append(",");

                // Student info
                json.append("\"student\":{");
                json.append("\"sid\":").append(grade.getStudent().getSid()).append(",");
                json.append("\"sname\":\"").append(escapeJsonString(grade.getStudent().getSname())).append("\"");
                json.append("},");

                // Course info
                json.append("\"course\":{");
                json.append("\"cid\":").append(grade.getCourse().getCid()).append(",");
                json.append("\"cname\":\"").append(escapeJsonString(grade.getCourse().getCname())).append("\"");
                json.append("},");

                // Grade info
                json.append("\"grade\":").append(grade.getGrade()).append(",");

                // Format exam date
                String examDate = grade.getExamDate() != null ? sdf.format(grade.getExamDate()) : "";
                json.append("\"examDate\":\"").append(examDate).append("\"");

                json.append("}");

                response.getWriter().write(json.toString());
            } else {
                response.getWriter().write("{}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            String errorJson = "{\"error\": \"" + escapeJsonString(e.getMessage()) + "\"}";
            response.getWriter().write(errorJson);
        }
    }

    private void updateGrade(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int scgid = Integer.parseInt(request.getParameter("scgid"));
            double grade = Double.parseDouble(request.getParameter("grade"));
            String examDate = request.getParameter("exam_date");

            StudentCourseGrade gradeObj = new StudentCourseGrade();
            gradeObj.setScgid(scgid);
            gradeObj.setGrade(grade);
            gradeObj.setExamDate(java.sql.Date.valueOf(examDate));

            int result = studentCourseGradeService.updateGrade(gradeObj);
            response.getWriter().write(result > 0 ? "1" : "0");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("0");
        }
    }

    // Helper method to escape JSON strings
    private String escapeJsonString(String input) {
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
package com.bkty.controller;

import com.bkty.entity.Course;
import com.bkty.entity.PageBean;
import com.bkty.service.CourseService;
import com.bkty.service.impl.CourseServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/CourseServlet")
public class CourseServlet extends HttpServlet {

    private CourseService courseService = new CourseServiceImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void getCourseCount(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        int count = courseService.getCourseCount();
        resp.getWriter().write(String.valueOf(count));
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        String methodName = request.getParameter("methodName");

        if (methodName == null || methodName.isEmpty()) {
            response.getWriter().write("请指定方法名");
            return;
        }

        System.out.println("CourseServlet接收请求: " + methodName);

        if ("addCourse".equals(methodName)) {
            addCourse(request, response);
        } else if ("updateCourse".equals(methodName)) {
            updateCourse(request, response);
        } else if ("deleteCourse".equals(methodName)) {
            deleteCourse(request, response);
        } else if ("getCourseById".equals(methodName)) {
            getCourseById(request, response);
        } else if ("getAllCourses".equals(methodName)) {
            getAllCourses(request, response);
        } else if ("searchCourses".equals(methodName)) {
            searchCourses(request, response);
        } else if ("getCourseByPage".equals(methodName)) {
            getCourseByPage(request, response);
        } else {
            response.getWriter().write("未知的方法名: " + methodName);
        }
    }

    protected void addCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String cname = request.getParameter("cname");
        String description = request.getParameter("description");
        Course course = new Course(cname, description);
        boolean result = courseService.addCourse(course);
        response.getWriter().write(result ? "1" : "0");
    }

    protected void updateCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int cid = Integer.parseInt(request.getParameter("cid"));
        String cname = request.getParameter("cname");
        String description = request.getParameter("description");
        Course course = new Course(cid, cname, description);
        boolean result = courseService.updateCourse(course);
        response.getWriter().write(result ? "1" : "0");
    }

    protected void deleteCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int cid = Integer.parseInt(request.getParameter("cid"));
        boolean result = courseService.deleteCourse(cid);
        response.getWriter().write(result ? "1" : "0");
    }

    protected void getCourseById(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int cid = Integer.parseInt(request.getParameter("cid"));
        Course course = courseService.getCourseById(cid);

        // 手动构建JSON
        response.setContentType("application/json;charset=UTF-8");
        StringBuilder json = new StringBuilder();
        json.append("{\"cid\":").append(course.getCid())
                .append(",\"cname\":\"").append(course.getCname()).append("\"")
                .append(",\"description\":\"")
                .append(course.getDescription() != null ? course.getDescription() : "").append("\"")
                .append("}");

        response.getWriter().write(json.toString());
    }

    protected void getAllCourses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            response.setContentType("application/json;charset=UTF-8");
            System.out.println("执行getAllCourses方法");

            List<Course> courses = courseService.getAllCourses();
            System.out.println("查询到课程数量: " + (courses != null ? courses.size() : 0));

            // 手动构建JSON
            StringBuilder json = new StringBuilder("[");
            if (courses != null) {
                for (int i = 0; i < courses.size(); i++) {
                    Course course = courses.get(i);
                    if (i > 0) {
                        json.append(",");
                    }
                    json.append("{\"cid\":").append(course.getCid())
                            .append(",\"cname\":\"").append(course.getCname() != null ? course.getCname() : "")
                            .append("\"}");
                }
            }
            json.append("]");

            String jsonStr = json.toString();
            System.out.println("返回课程JSON: " + jsonStr);
            response.getWriter().write(jsonStr);
        } catch (Exception e) {
            System.err.println("获取课程列表失败: " + e.getMessage());
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("[]");
        }
    }

    protected void searchCourses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Course> courses = courseService.searchCourses(keyword);

        // 手动构建JSON
        response.setContentType("application/json;charset=UTF-8");
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < courses.size(); i++) {
            Course course = courses.get(i);
            if (i > 0) {
                json.append(",");
            }
            json.append("{\"cid\":").append(course.getCid())
                    .append(",\"cname\":\"").append(course.getCname()).append("\"")
                    .append(",\"description\":\"")
                    .append(course.getDescription() != null ? course.getDescription() : "").append("\"")
                    .append("}");
        }
        json.append("]");

        response.getWriter().write(json.toString());
    }

    protected void getCourseByPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int pageIndex = 1;
            try {
                String pageStr = request.getParameter("index");
                if (pageStr != null && !pageStr.trim().isEmpty()) {
                    pageIndex = Integer.parseInt(pageStr);
                }
            } catch (NumberFormatException e) {
                // 使用默认值1
                System.err.println("页码解析失败，使用默认值1: " + e.getMessage());
            }

            String keyword = request.getParameter("keyword");
            System.out.println("分页查询课程: 页码=" + pageIndex + ", 关键词=" + keyword);

            response.setContentType("application/json;charset=UTF-8");

            PageBean<Course> pageBean = courseService.getCourseByPage(pageIndex, keyword);
            System.out.println("查询到课程总数: " + pageBean.getTotalCount() + ", 当前页数据: " + pageBean.getList().size());

            // 手动构建JSON
            StringBuilder json = new StringBuilder();
            json.append("{\"index\":").append(pageBean.getIndex())
                    .append(",\"size\":").append(pageBean.getSize())
                    .append(",\"totalCount\":").append(pageBean.getTotalCount())
                    .append(",\"totalPage\":").append(pageBean.getTotalPage())
                    .append(",\"list\":[");

            List<Course> list = pageBean.getList();
            for (int i = 0; i < list.size(); i++) {
                Course course = list.get(i);
                if (i > 0) {
                    json.append(",");
                }
                json.append("{\"cid\":").append(course.getCid())
                        .append(",\"cname\":\"").append(escapeJson(course.getCname())).append("\"")
                        .append(",\"description\":\"").append(escapeJson(course.getDescription())).append("\"")
                        .append("}");
            }
            json.append("]}");

            String jsonStr = json.toString();
            System.out.println("返回分页JSON: " + jsonStr);

            response.getWriter().write(jsonStr);
        } catch (Exception e) {
            System.err.println("处理课程分页请求失败: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    // 转义JSON字符串的辅助方法
    private String escapeJson(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n")
                .replace("\t", "\\t");
    }
}
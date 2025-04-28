package com.bkty.controller;

import com.bkty.entity.TeachingPlan;
import com.bkty.service.TeachingPlanService;
import com.bkty.service.impl.TeachingPlanServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/TeachingPlanServlet")
public class TeachingPlanServlet extends HttpServlet {
    private TeachingPlanService teachingPlanService = new TeachingPlanServiceImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        String methodName = request.getParameter("methodName");

        if ("getAllTeachingPlans".equals(methodName)) {
            getAllTeachingPlans(request, response);
        } else if ("addTeachingPlan".equals(methodName)) {
            addTeachingPlan(request, response);
        } else if ("deleteTeachingPlan".equals(methodName)) {
            deleteTeachingPlan(request, response);
        }
    }

    private void getAllTeachingPlans(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            List<TeachingPlan> teachingPlans = teachingPlanService.getAllTeachingPlans();

            // 使用手动构建JSON而不是Gson
            StringBuilder jsonBuilder = new StringBuilder("[");
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

            for (int i = 0; i < teachingPlans.size(); i++) {
                TeachingPlan plan = teachingPlans.get(i);
                if (i > 0) {
                    jsonBuilder.append(",");
                }

                jsonBuilder.append("{")
                        .append("\"tpid\":").append(plan.getTpid()).append(",")
                        .append("\"cid\":").append(plan.getCid()).append(",")
                        .append("\"tid\":").append(plan.getTid()).append(",")
                        .append("\"startDate\":\"")
                        .append(plan.getStartDate() != null ? dateFormat.format(plan.getStartDate()) : "").append("\",")
                        .append("\"endDate\":\"")
                        .append(plan.getEndDate() != null ? dateFormat.format(plan.getEndDate()) : "").append("\",")
                        .append("\"description\":\"")
                        .append(plan.getDescription() != null ? escapeJson(plan.getDescription()) : "").append("\"")
                        .append("}");
            }

            jsonBuilder.append("]");
            String jsonString = jsonBuilder.toString();

            System.out.println("返回的教学计划JSON数据: " + jsonString);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(jsonString);

        } catch (Exception e) {
            System.err.println("获取教学计划列表失败: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }

    private void addTeachingPlan(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int cid = Integer.parseInt(request.getParameter("cid"));
            int tid = Integer.parseInt(request.getParameter("tid"));
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String description = request.getParameter("description");

            System.out.println("接收到的教学计划参数: cid=" + cid + ", tid=" + tid +
                    ", startDate=" + startDateStr + ", endDate=" + endDateStr +
                    ", description=" + description);

            TeachingPlan teachingPlan = new TeachingPlan();
            teachingPlan.setCid(cid);
            teachingPlan.setTid(tid);

            // 参数名称修正
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            teachingPlan.setStartDate(dateFormat.parse(startDateStr));
            teachingPlan.setEndDate(dateFormat.parse(endDateStr));
            teachingPlan.setDescription(description);

            boolean result = teachingPlanService.addTeachingPlan(teachingPlan);
            response.getWriter().write(result ? "1" : "0");
        } catch (Exception e) {
            System.err.println("添加教学计划失败: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("0");
        }
    }

    private void deleteTeachingPlan(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int tpid = Integer.parseInt(request.getParameter("tpid"));
            boolean result = teachingPlanService.deleteTeachingPlan(tpid);
            response.getWriter().write(result ? "1" : "0");
        } catch (Exception e) {
            System.err.println("删除教学计划失败: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("0");
        }
    }

    // 转义JSON字符串中的特殊字符
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
package com.bkty.controller;

import com.bkty.entity.SystemLog;
import com.bkty.service.SystemLogService;
import com.bkty.service.impl.SystemLogServiceImpl;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet("/SystemLogServlet")
public class SystemLogServlet extends BaseServlet {

    private SystemLogService systemLogService = new SystemLogServiceImpl();
    private Gson gson = new Gson();

    // 添加系统日志
    protected void addSystemLog(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");
        String uidStr = req.getParameter("uid");
        int uid = Integer.parseInt(uidStr);
        String operation = req.getParameter("operation");
        String module = req.getParameter("module");

        SystemLog systemLog = new SystemLog(uid, operation, module, new Date());

        boolean result = systemLogService.addSystemLog(systemLog);
        resp.getWriter().write(result ? "1" : "0");
    }

    // 获取系统日志列表
    protected void getAllSystemLogs(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            resp.setContentType("application/json;charset=UTF-8");
            List<SystemLog> systemLogs = systemLogService.getAllSystemLogs();
            String json = gson.toJson(systemLogs);
            resp.getWriter().write(json);
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    // 搜索系统日志
    protected void searchSystemLogs(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String keyword = req.getParameter("keyword");
            resp.setContentType("application/json;charset=UTF-8");
            List<SystemLog> systemLogs = systemLogService.searchSystemLogs(keyword);
            String json = gson.toJson(systemLogs);
            resp.getWriter().write(json);
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}
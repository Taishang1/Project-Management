package com.bkty.controller;

import com.bkty.entity.Clazz;
import com.bkty.entity.PageBean;
import com.bkty.entity.TongJi;
import com.bkty.service.ClazzService;
import com.bkty.service.impl.ClazzServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebServlet("/ClazzServlet")
public class ClazzServlet extends HttpServlet {

    private ClazzService clazzService = new ClazzServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String methodName = req.getParameter("methodName");

        if ("getClazzByPage".equals(methodName)) {
            getClazzByPage(req, resp);
        } else if ("getTongJi".equals(methodName)) {
            getTongJi(req, resp);
        } else if ("updateClazz".equals(methodName)) {
            updateClazz(req, resp);
        } else if ("addClazz".equals(methodName)) {
            addClazz(req, resp);
        } else if ("getAll".equals(methodName)) {
            getAll(req, resp);
        } else if ("getClazzById".equals(methodName)) {
            getClazzById(req, resp);
        } else if ("deleteClazz".equals(methodName)) {
            deleteClazz(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    private void getTongJi(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // 设置响应类型和字符编码
        resp.setContentType("application/json;charset=UTF-8");

        try {
            List<TongJi> tongJiList = clazzService.getTongJi();
            StringBuilder jsonBuilder = new StringBuilder();
            jsonBuilder.append("[");

            for (int i = 0; i < tongJiList.size(); i++) {
                TongJi item = tongJiList.get(i);
                if (i > 0) {
                    jsonBuilder.append(",");
                }
                jsonBuilder.append("{")
                        .append("\"name\":\"").append(item.getCname() != null ? item.getCname() : "未命名").append("\",")
                        .append("\"count\":").append(item.getCount() != null ? item.getCount() : 0)
                        .append("}");
            }

            jsonBuilder.append("]");
            String json = jsonBuilder.toString();
            System.out.println("统计数据JSON: " + json); // 添加日志
            resp.getWriter().write(json);

        } catch (Exception e) {
            System.out.println("获取统计数据失败: " + e.getMessage());
            e.printStackTrace();
            resp.getWriter().write("[]"); // 发生错误时返回空数组
        }
    }

    private void updateClazz(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String cid = req.getParameter("cid");
        String cname = req.getParameter("cname");
        String cteacher = req.getParameter("cteacher");
        String remark = req.getParameter("remark");

        Clazz clazz = new Clazz(Integer.parseInt(cid), cname, cteacher, remark);

        int i = clazzService.updateClazz(clazz);

        resp.getWriter().write(i > 0 ? "true" : "false");
    }

    private void addClazz(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String cname = req.getParameter("cname");
        String cteacher = req.getParameter("cteacher");
        String remark = req.getParameter("remark");

        Clazz clazz = new Clazz(null, cname, cteacher, remark);

        int i = clazzService.addClazz(clazz);

        resp.getWriter().write(i > 0 ? "1" : "0");
    }

    private void getAll(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // 设置响应内容类型和字符编码
        resp.setContentType("application/json;charset=UTF-8");

        try {
            List<Clazz> list = clazzService.getAll();

            // 修改JSON构建方式，使用StringBuilder手动构建JSON
            StringBuilder jsonBuilder = new StringBuilder("[");

            for (int i = 0; i < list.size(); i++) {
                Clazz clazz = list.get(i);
                if (i > 0) {
                    jsonBuilder.append(",");
                }

                jsonBuilder.append("{")
                        .append("\"cid\":").append(clazz.getCid()).append(",")
                        .append("\"cname\":\"").append(escapeJson(clazz.getCname())).append("\",")
                        .append("\"cteacher\":\"").append(escapeJson(clazz.getCteacher())).append("\",")
                        .append("\"remark\":\"").append(escapeJson(clazz.getRemark() != null ? clazz.getRemark() : ""))
                        .append("\"")
                        .append("}");
            }

            jsonBuilder.append("]");
            String jsonString = jsonBuilder.toString();
            System.out.println("返回的JSON数据: " + jsonString);
            resp.getWriter().write(jsonString);
        } catch (Exception e) {
            System.err.println("获取班级列表失败: " + e.getMessage());
            e.printStackTrace();
            resp.getWriter().write("[]");
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

    private void getClazzByPage(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int index = Integer.parseInt(req.getParameter("index"));
        String keyword = req.getParameter("keyword");

        System.out.println("分页查询 - 页码: " + index + ", 关键字: " + keyword);

        PageBean<Clazz> pageBean = clazzService.getClazzByPage(index, keyword);

        System.out.println("查询结果 - 总记录数: " + pageBean.getTotalCount() +
                ", 总页数: " + pageBean.getTotalPage() +
                ", 当前页数据量: " + (pageBean.getList() != null ? pageBean.getList().size() : 0) +
                ", 页码数组: " + (pageBean.getNumbers() != null ? Arrays.toString(pageBean.getNumbers()) : "null"));

        resp.setContentType("application/json;charset=UTF-8");

        // 手动构建分页数据的JSON
        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.append("{");
        jsonBuilder.append("\"totalCount\":").append(pageBean.getTotalCount()).append(",");
        jsonBuilder.append("\"totalPage\":").append(pageBean.getTotalPage()).append(",");
        jsonBuilder.append("\"list\":[");

        List<Clazz> list = pageBean.getList();
        if (list != null) {
            for (int i = 0; i < list.size(); i++) {
                Clazz clazz = list.get(i);
                if (i > 0) {
                    jsonBuilder.append(",");
                }
                jsonBuilder.append("{")
                        .append("\"cid\":").append(clazz.getCid()).append(",")
                        .append("\"cname\":\"").append(clazz.getCname()).append("\",")
                        .append("\"cteacher\":\"").append(clazz.getCteacher()).append("\",")
                        .append("\"remark\":\"").append(clazz.getRemark() != null ? clazz.getRemark() : "").append("\"")
                        .append("}");
            }
        }

        jsonBuilder.append("],");
        jsonBuilder.append("\"numbers\":").append(Arrays.toString(pageBean.getNumbers()));
        jsonBuilder.append("}");

        String json = jsonBuilder.toString();
        System.out.println("返回的JSON数据: " + json);
        resp.getWriter().write(json);
    }

    private void getClazzById(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        System.out.println("开始获取班级信息");
        int cid = Integer.parseInt(req.getParameter("cid"));
        System.out.println("获取的班级ID: " + cid);

        Clazz clazz = clazzService.getClazzById(cid);
        System.out.println("查询到的班级信息: " + clazz);

        resp.setContentType("application/json;charset=UTF-8");
        String json = "{" +
                "\"cid\":" + clazz.getCid() + "," +
                "\"cname\":\"" + clazz.getCname() + "\"," +
                "\"cteacher\":\"" + clazz.getCteacher() + "\"," +
                "\"remark\":\"" + (clazz.getRemark() != null ? clazz.getRemark() : "") + "\"" +
                "}";
        System.out.println("返回的JSON数据: " + json);

        resp.getWriter().write(json);
    }

    private void deleteClazz(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int cid = Integer.parseInt(req.getParameter("cid"));
            System.out.println("删除班级，ID: " + cid);

            int result = clazzService.deleteClazz(cid);
            System.out.println("删除结果: " + result);

            resp.getWriter().write(result > 0 ? "1" : "0");
        } catch (Exception e) {
            System.out.println("删除班级失败: " + e.getMessage());
            e.printStackTrace();
            resp.getWriter().write("0");
        }
    }
}
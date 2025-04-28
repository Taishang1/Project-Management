package com.bkty.controller;

import com.bkty.entity.Clazz;
import com.bkty.entity.Student;
import com.bkty.entity.PageBean;
import com.bkty.service.StudentService;
import com.bkty.service.impl.StudentServiceImpl;
import com.bkty.utils.ExcelOperate;
import com.bkty.annotation.RequiresPermission;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/StudentServlet")
@MultipartConfig
public class StudentServlet extends HttpServlet {

    private StudentService studentService = new StudentServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        String methodName = req.getParameter("methodName");

        if ("getStudentById".equals(methodName)) {
            getStudentById(req, resp);
        } else if ("getAll".equals(methodName)) {
            getAll(req, resp);
        } else if ("deleteStudent".equals(methodName)) {
            deleteStudent(req, resp);
        } else if ("getStudentByPage".equals(methodName)) {
            getStudentByPage(req, resp);
        } else if ("exportStudent".equals(methodName)) {
            exportStudent(req, resp);
        } else if ("getAllClazz".equals(methodName)) {
            getAllClazz(req, resp);
        } else if ("getStudentList".equals(methodName)) {
            getStudentList(req, resp);
        } else if ("getStudentCount".equals(methodName)) {
            getStudentCount(req, resp);
        } else if ("getAllStudents".equals(methodName)) {
            getAllStudents(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        String methodName = req.getParameter("methodName");

        if ("addStudent".equals(methodName)) {
            addStudent(req, resp);
        } else if ("updateStudent".equals(methodName)) {
            updateStudent(req, resp);
        } else if ("importStudents".equals(methodName)) {
            importStudents(req, resp);
        }
    }

    @RequiresPermission("student:view")
    private void getStudentList(HttpServletRequest req, HttpServletResponse resp) {
        // ...
    }

    @RequiresPermission("student:add")
    private void addStudent(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String sname = req.getParameter("sname");
            String sex = req.getParameter("sex");
            String phone = req.getParameter("phone");
            String birthdateStr = req.getParameter("birthdate");
            String cidStr = req.getParameter("cid");
            String[] hobbies = req.getParameterValues("hobby");
            String remark = req.getParameter("reamrk");

            // 参数验证
            if (sname == null || sname.trim().isEmpty()) {
                resp.getWriter().write("0");
                return;
            }

            // 处理爱好
            String hobby = "";
            if (hobbies != null && hobbies.length > 0) {
                hobby = String.join(",", hobbies);
            }

            // 处理生日
            Date birthdate = null;
            if (birthdateStr != null && !birthdateStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    birthdate = sdf.parse(birthdateStr);
                } catch (ParseException e) {
                    e.printStackTrace();
                    resp.getWriter().write("0");
                    return;
                }
            }

            // 处理班级ID
            int cid = 0;
            try {
                cid = Integer.parseInt(cidStr);
            } catch (NumberFormatException e) {
                e.printStackTrace();
                resp.getWriter().write("0");
                return;
            }

            // 创建学生对象
            Student student = new Student();
            student.setSname(sname);
            student.setSex(sex);
            student.setBirthday(birthdate);
            student.setHobby(hobby);
            student.setPhone(phone);
            student.setCid(cid);
            student.setReamrk(remark);

            // 保存学生
            int result = studentService.addStudent(student);
            resp.getWriter().write(result > 0 ? "1" : "0");

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("0");
        }
    }

    private void updateStudent(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int sid = Integer.parseInt(req.getParameter("sid"));
            String sname = req.getParameter("sname");
            String sex = req.getParameter("sex");

            // 修改爱好处理逻辑
            String[] hobbies = req.getParameterValues("hobby");
            String hobby = "";
            if (hobbies != null && hobbies.length > 0) {
                hobby = String.join(",", hobbies);
            }

            // 处理生日
            String birthdateStr = req.getParameter("birthdate");
            Date birthdate = null;
            if (birthdateStr != null && !birthdateStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    birthdate = sdf.parse(birthdateStr);
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }

            String phone = req.getParameter("phone");
            String cidStr = req.getParameter("cid");
            int cid = 0;
            if (cidStr != null && !cidStr.trim().isEmpty()) {
                cid = Integer.parseInt(cidStr);
            }
            String remark = req.getParameter("reamrk"); // 注意这里的拼写

            // 创建学生对象
            Student student = new Student(sid, sname, sex, hobby, birthdate, phone, remark, cid, null);

            // 更新学生信息
            int result = studentService.updateStudent(student);

            // 返回结果
            resp.getWriter().write(result > 0 ? "1" : "0");
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("0");
        }
    }

    protected void getStudentById(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String sidStr = req.getParameter("sid");
        int sid = Integer.parseInt(sidStr);

        Student student = studentService.getStudentById(sid);
        // 格式化日期为 yyyy-MM-dd 格式
        if (student != null && student.getBirthday() != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            req.setAttribute("birthdayStr", sdf.format(student.getBirthday()));
        }
        req.setAttribute("student", student);

        // 查询所有班级信息并传递到页面
        List<Clazz> clazzList = studentService.getAllClazz();
        req.setAttribute("clazzList", clazzList);

        req.getRequestDispatcher("updateStudent.jsp").forward(req, resp);
    }

    private void getAll(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        List<Student> students = studentService.getAll(req.getParameter("sname"), req.getParameter("phone"));

        // 手动构建JSON
        resp.setContentType("application/json;charset=UTF-8");
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < students.size(); i++) {
            Student student = students.get(i);
            if (i > 0) {
                json.append(",");
            }

            json.append("{\"sid\":").append(student.getSid())
                    .append(",\"sname\":\"").append(student.getSname() != null ? student.getSname() : "").append("\"")
                    .append(",\"sex\":\"").append(student.getSex() != null ? student.getSex() : "").append("\"");

            if (student.getBirthday() != null) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                json.append(",\"birthday\":\"").append(sdf.format(student.getBirthday())).append("\"");
            } else {
                json.append(",\"birthday\":null");
            }

            json.append(",\"phone\":\"").append(student.getPhone() != null ? student.getPhone() : "").append("\"")
                    .append(",\"hobby\":\"").append(student.getHobby() != null ? student.getHobby() : "").append("\"")
                    .append(",\"reamrk\":\"").append(student.getReamrk() != null ? student.getReamrk() : "")
                    .append("\"")
                    .append(",\"cid\":").append(student.getCid());

            if (student.getClazz() != null) {
                json.append(",\"clazz\":{\"cid\":").append(student.getClazz().getCid())
                        .append(",\"cname\":\"")
                        .append(student.getClazz().getCname() != null ? student.getClazz().getCname() : "")
                        .append("\"}");
            }

            json.append("}");
        }
        json.append("]");

        String jsonStr = json.toString();
        System.out.println("返回所有学生JSON: " + jsonStr);
        resp.getWriter().write(jsonStr);
    }

    private void deleteStudent(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String sidStr = req.getParameter("sid");
        int sid = Integer.parseInt(sidStr);

        boolean result = studentService.deleteStudent(sid);
        resp.getWriter().write(result ? "1" : "0");
    }

    private void getStudentByPage(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // 获取参数
        int index = Integer.parseInt(req.getParameter("index"));
        String sname = req.getParameter("sname");
        String phone = req.getParameter("phone");

        // 设置响应内容类型
        resp.setContentType("application/json;charset=UTF-8");

        // 获取分页数据
        PageBean<Student> pageBean = studentService.getStudentByPage(index, sname, phone);

        // 手动构建JSON
        StringBuilder json = new StringBuilder();
        json.append("{\"index\":").append(pageBean.getIndex())
                .append(",\"size\":").append(pageBean.getSize())
                .append(",\"totalCount\":").append(pageBean.getTotalCount())
                .append(",\"totalPage\":").append(pageBean.getTotalPage())
                .append(",\"list\":[");

        List<Student> list = pageBean.getList();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        for (int i = 0; i < list.size(); i++) {
            Student student = list.get(i);
            if (i > 0) {
                json.append(",");
            }

            json.append("{\"sid\":").append(student.getSid())
                    .append(",\"sname\":\"").append(student.getSname() != null ? student.getSname() : "").append("\"")
                    .append(",\"sex\":\"").append(student.getSex() != null ? student.getSex() : "").append("\"");

            if (student.getBirthday() != null) {
                json.append(",\"birthday\":\"").append(sdf.format(student.getBirthday())).append("\"");
            } else {
                json.append(",\"birthday\":null");
            }

            json.append(",\"phone\":\"").append(student.getPhone() != null ? student.getPhone() : "").append("\"")
                    .append(",\"hobby\":\"").append(student.getHobby() != null ? student.getHobby() : "").append("\"")
                    .append(",\"reamrk\":\"").append(student.getReamrk() != null ? student.getReamrk() : "")
                    .append("\"")
                    .append(",\"cid\":").append(student.getCid());

            if (student.getClazz() != null) {
                json.append(",\"clazz\":{\"cid\":").append(student.getClazz().getCid())
                        .append(",\"cname\":\"")
                        .append(student.getClazz().getCname() != null ? student.getClazz().getCname() : "")
                        .append("\"}");
            }

            json.append("}");
        }
        json.append("]}");

        String jsonStr = json.toString();
        System.out.println("返回分页学生JSON: " + jsonStr);

        // 写入响应
        resp.getWriter().write(jsonStr);
    }

    protected void exportStudent(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("application/vnd.ms-excel");
        resp.setHeader("Content-disposition",
                "attachment; fileName=" + new String(("学生表.xls").getBytes(), "iso8859-1"));

        String sname = req.getParameter("sname");
        String phone = req.getParameter("phone");

        List<Student> list = studentService.getAll(sname, phone);

        ExcelOperate.createExcel(list, resp.getOutputStream());
    }

    private void getAllClazz(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        List<Clazz> clazzList = studentService.getAllClazz();
        resp.setContentType("application/json;charset=UTF-8");

        // 手动构建JSON
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < clazzList.size(); i++) {
            Clazz clazz = clazzList.get(i);
            if (i > 0) {
                json.append(",");
            }

            json.append("{\"cid\":").append(clazz.getCid())
                    .append(",\"cname\":\"").append(clazz.getCname() != null ? clazz.getCname() : "").append("\"");

            // 使用remark属性而不是description
            if (clazz.getRemark() != null) {
                json.append(",\"remark\":\"").append(clazz.getRemark()).append("\"");
            }

            json.append("}");
        }
        json.append("]");

        String jsonStr = json.toString();
        System.out.println("返回班级JSON: " + jsonStr);
        resp.getWriter().write(jsonStr);
    }

    private void importStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Part filePart = request.getPart("excel");
            InputStream inputStream = filePart.getInputStream();

            // 使用 POI 读取 Excel
            List<Student> students = ExcelOperate.importStudents(inputStream);

            // 批量保存学生信息
            boolean success = studentService.batchSaveStudents(students);

            response.getWriter().write(success ? "1" : "0");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("导入失败：" + e.getMessage());
        }
    }

    private void getStudentCount(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            // 设置响应类型
            resp.setContentType("application/json;charset=UTF-8");

            // 获取学生总数
            int count = studentService.getStudentCount();

            // 返回 JSON 格式的数据
            resp.getWriter().write(String.valueOf(count));

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("0");
        }
    }

    private void getAllStudents(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            req.setCharacterEncoding("UTF-8");
            resp.setContentType("application/json;charset=UTF-8");

            List<Student> students = studentService.getAll(null, null);

            // 手动构建JSON
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < students.size(); i++) {
                Student student = students.get(i);
                if (i > 0) {
                    json.append(",");
                }
                json.append("{\"sid\":").append(student.getSid())
                        .append(",\"sname\":\"").append(student.getSname() != null ? student.getSname() : "")
                        .append("\"}");
            }
            json.append("]");

            String jsonStr = json.toString();
            System.out.println("返回学生JSON: " + jsonStr);
            resp.getWriter().write(jsonStr);
        } catch (Exception e) {
            System.err.println("获取学生列表失败: " + e.getMessage());
            e.printStackTrace();
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("[]");
        }
    }
}
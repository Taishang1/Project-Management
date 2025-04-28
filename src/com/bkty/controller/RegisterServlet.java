package com.bkty.controller;

import com.bkty.entity.User;
import com.bkty.service.UserService;
import com.bkty.service.impl.UserServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;

@WebServlet("/RegisterServlet")
@MultipartConfig // 添加这个注解来支持文件上传
public class RegisterServlet extends HttpServlet {
    private UserService userService = new UserServiceImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("utf-8");
        response.setContentType("text/html;charset=utf-8");

        // 获取上传文件的保存路径
        String uploadPath = request.getServletContext().getRealPath("/upload/head");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        try {
            // 获取表单数据
            String ukey = request.getParameter("ukey");
            String pwd = request.getParameter("pwd");

            // 处理文件上传
            Part filePart = request.getPart("head");
            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            String filePath = "upload/head/" + fileName;

            // 保存文件
            filePart.write(uploadPath + File.separator + fileName);

            // 创建用户对象
            User user = new User();
            user.setUkey(ukey);
            user.setPwd(pwd);
            user.setHead(filePath); // 设置头像路径
            user.setType(1); // 设置用户类型，1表示普通用户

            // 保存到数据库
            int result = userService.register(user);

            response.getWriter().write(result > 0 ? "1" : "0");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("0");
        }
    }
}
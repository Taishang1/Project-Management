package com.bkty.controller;

import com.bkty.dao.UserDao;
import com.bkty.dao.impl.UserDaoImpl;
import com.bkty.utils.FileUploadUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@WebServlet("/UploadHeadServlet")
public class UploadHeadServlet extends HttpServlet {
  private UserDao userDao = new UserDaoImpl();

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    // 获取上传文件的保存路径
    String uploadPath = request.getServletContext().getRealPath("/upload/head");

    // 处理文件上传
    Map<String, String> params = FileUploadUtil.uploadFile(request, uploadPath);

    if (params.containsKey("head")) {
      // 获取当前登录用户的ID
      Integer uid = (Integer) request.getSession().getAttribute("uid");
      if (uid != null) {
        // 更新用户头像
        boolean success = userDao.updateUserHead(uid, params.get("head"));
        response.getWriter().write(success ? "1" : "0");
        return;
      }
    }

    response.getWriter().write("0");
  }
}
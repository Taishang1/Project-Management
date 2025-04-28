package com.bkty.controller;

import com.bkty.entity.User;
import com.bkty.service.UserService;
import com.bkty.service.impl.UserServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("utf-8");

        String ukey = req.getParameter("ukey");
        String pwd = req.getParameter("pwd");
        String code = req.getParameter("code");

        // 验证码验证逻辑
        String rand = (String) req.getSession().getAttribute("randStr");
        System.out.println("Session中的验证码: " + rand);
        System.out.println("用户输入的验证码: " + code);
        if (code == null || !code.equals(rand)) {
            resp.getWriter().write("0");
            return;
        }

        // 用户验证逻辑
        UserService userService = new UserServiceImpl();
        User user = userService.login(ukey, pwd);

        if (user == null) {
            resp.getWriter().write("1");
        } else {
            // 获取当前时间和日期
            Date now = new Date();
            SimpleDateFormat timeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy年MM月dd日 EEEE");
            String loginTime = timeFormat.format(now);
            String today = dateFormat.format(now);

            // 获取Session
            HttpSession session = req.getSession();

            // 将用户信息存储到session中
            session.setAttribute("user", user);
            session.setAttribute("uid", user.getUid());
            session.setAttribute("loginTime", loginTime);
            session.setAttribute("today", today);

            resp.getWriter().write("2");
        }
    }
}
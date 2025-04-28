package com.bkty.filter;

import com.bkty.entity.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashSet;
import java.util.Arrays;
import java.util.Set;

@WebFilter("/*")
public class AuthorizationFilter implements Filter {
    private static final Set<String> PUBLIC_PATHS = new HashSet<>(Arrays.asList(
            "/login.jsp", "/LoginServlet", "/register.jsp", "/RegisterServlet",
            "/RandomServlet",
            "/css/", "/js/", "/images/", "/fonts/", "/upload/"));

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 初始化方法，可以在这里配置初始化参数
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        // 打印请求信息
        System.out.println("请求URL: " + req.getRequestURI());
        System.out.println("请求方法: " + req.getParameter("method"));

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length());

        // 检查是否是公共资源
        if (isPublicResource(path)) {
            chain.doFilter(request, response);
            return;
        }

        // 验证用户是否登录
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        // 验证权限
        if (!hasPermission(user, path)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "没有访问权限");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean isPublicResource(String path) {
        return PUBLIC_PATHS.stream().anyMatch(path::startsWith) ||
                path.matches(".*\\.(css|js|png|jpg|gif|ico|woff|ttf)$");
    }

    private boolean hasPermission(User user, String path) {
        // 获取请求对应的权限代码
        String permCode = getPermissionCode(path);
        if (permCode == null) {
            return true; // 没有配置权限要求，默认放行
        }

        // 管理员角色默认拥有所有权限
        if (user.getRole() != null && "管理员".equals(user.getRole().getRoleName())) {
            return true;
        }

        // 检查用户是否拥有该权限
        return user.getRole() != null &&
                user.getRole().getPermissions() != null &&
                user.getRole().getPermissions().stream()
                        .anyMatch(p -> p.getPermCode().equals(permCode));
    }

    private String getPermissionCode(String path) {
        // 根据请求路径获取对应的权限代码
        // 这里需要实现具体的映射逻辑
        return null;
    }

    @Override
    public void destroy() {
        // 销毁方法，用于释放资源
    }
}
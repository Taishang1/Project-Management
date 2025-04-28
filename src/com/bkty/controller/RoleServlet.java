package com.bkty.controller;

import com.bkty.entity.Role;
import com.bkty.service.RoleService;
import com.bkty.service.impl.RoleServiceImpl;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/RoleServlet")
public class RoleServlet extends BaseServlet {
  private RoleService roleService = new RoleServiceImpl();
  private Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();

  protected void getAllRoles(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    List<Role> roles = roleService.getAllRoles();
    writeJson(resp, roles);
  }

  protected void getRoleById(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    Integer roleId = Integer.parseInt(req.getParameter("roleId"));
    Role role = roleService.getRoleById(roleId);
    writeJson(resp, role);
  }

  protected void addRole(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    Role role = gson.fromJson(req.getReader(), Role.class);
    boolean success = roleService.addRole(role);
    writeJson(resp, new Result(success));
  }

  protected void updateRole(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    Role role = gson.fromJson(req.getReader(), Role.class);
    boolean success = roleService.updateRole(role);
    writeJson(resp, new Result(success));
  }

  protected void deleteRole(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    Integer roleId = Integer.parseInt(req.getParameter("roleId"));
    boolean success = roleService.deleteRole(roleId);
    writeJson(resp, new Result(success));
  }

  protected void assignPermissions(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    Integer roleId = Integer.parseInt(req.getParameter("roleId"));
    String[] permIds = req.getParameterValues("permIds");
    List<Integer> permIdList = Arrays.stream(permIds)
        .map(Integer::parseInt)
        .collect(Collectors.toList());
    boolean success = roleService.assignPermissions(roleId, permIdList);
    writeJson(resp, new Result(success));
  }

  private void writeJson(HttpServletResponse resp, Object obj) throws IOException {
    resp.setContentType("application/json;charset=UTF-8");
    resp.getWriter().write(gson.toJson(obj));
  }

  private static class Result {
    private boolean success;
    private String message;

    public Result(boolean success) {
      this.success = success;
      this.message = success ? "操作成功" : "操作失败";
    }
  }
}
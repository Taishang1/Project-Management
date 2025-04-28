package com.bkty.controller;

import com.bkty.entity.Permission;
import com.bkty.service.PermissionService;
import com.bkty.service.impl.PermissionServiceImpl;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/PermissionServlet")
public class PermissionServlet extends BaseServlet {
  private PermissionService permissionService = new PermissionServiceImpl();
  private Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();

  protected void getAllPermissions(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    List<Permission> permissions = permissionService.getAllPermissions();
    writeJson(resp, permissions);
  }

  protected void getPermissionById(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    Integer permId = Integer.parseInt(req.getParameter("permId"));
    Permission permission = permissionService.getPermissionById(permId);
    writeJson(resp, permission);
  }

  protected void addPermission(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    Permission permission = gson.fromJson(req.getReader(), Permission.class);
    boolean success = permissionService.addPermission(permission);
    writeJson(resp, new Result(success));
  }

  protected void updatePermission(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    Permission permission = gson.fromJson(req.getReader(), Permission.class);
    boolean success = permissionService.updatePermission(permission);
    writeJson(resp, new Result(success));
  }

  protected void deletePermission(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    Integer permId = Integer.parseInt(req.getParameter("permId"));
    boolean success = permissionService.deletePermission(permId);
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
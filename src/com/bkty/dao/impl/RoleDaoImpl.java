package com.bkty.dao.impl;

import com.bkty.dao.BaseDao;
import com.bkty.dao.RoleDao;
import com.bkty.entity.Role;
import com.bkty.entity.Permission;

import java.util.List;

public class RoleDaoImpl extends BaseDao implements RoleDao {

  @Override
  public List<Role> getAllRoles() {
    String sql = "SELECT role_id as roleId, role_name as roleName, role_desc as roleDesc, " +
        "create_time as createTime, update_time as updateTime FROM role";
    return queryForList(Role.class, sql);
  }

  @Override
  public Role getRoleById(Integer rid) {
    String sql = "SELECT role_id as roleId, role_name as roleName, role_desc as roleDesc, " +
        "create_time as createTime, update_time as updateTime FROM role WHERE role_id = ?";
    Role role = queryForOne(Role.class, sql, rid);
    if (role != null) {
      // 查询角色的权限
      String permSql = "SELECT p.perm_id as permId, p.perm_name as permName, " +
          "p.perm_code as permCode, p.perm_desc as permDesc, " +
          "p.create_time as createTime " +
          "FROM permission p " +
          "JOIN role_permission rp ON p.perm_id = rp.perm_id " +
          "WHERE rp.role_id = ?";
      List<Permission> permissions = queryForList(Permission.class, permSql, rid);
      role.setPermissions(permissions);
    }
    return role;
  }

  @Override
  public int addRole(Role role) {
    String sql = "INSERT INTO role (role_name, role_desc) VALUES (?, ?)";
    return update(sql, role.getRoleName(), role.getRoleDesc());
  }

  @Override
  public int updateRole(Role role) {
    String sql = "UPDATE role SET role_name = ?, role_desc = ? WHERE role_id = ?";
    return update(sql, role.getRoleName(), role.getRoleDesc(), role.getRoleId());
  }

  @Override
  public int deleteRole(Integer rid) {
    // 先删除角色权限关联
    String deletePerm = "DELETE FROM role_permission WHERE role_id = ?";
    update(deletePerm, rid);

    // 再删除角色
    String deleteRole = "DELETE FROM role WHERE role_id = ?";
    return update(deleteRole, rid);
  }

  @Override
  public boolean assignPermissions(Integer rid, List<Integer> pids) {
    try {
      // 先删除原有权限
      String deleteSql = "DELETE FROM role_permission WHERE role_id = ?";
      update(deleteSql, rid);

      // 批量插入新权限
      String insertSql = "INSERT INTO role_permission (role_id, perm_id) VALUES (?, ?)";
      for (Integer pid : pids) {
        update(insertSql, rid, pid);
      }
      return true;
    } catch (Exception e) {
      e.printStackTrace();
      return false;
    }
  }
}
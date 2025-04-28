package com.bkty.dao.impl;

import com.bkty.dao.BaseDao;
import com.bkty.dao.PermissionDao;
import com.bkty.entity.Permission;

import java.util.List;

public class PermissionDaoImpl extends BaseDao implements PermissionDao {

  @Override
  public List<Permission> getAllPermissions() {
    String sql = "SELECT perm_id as permId, perm_name as permName, " +
        "perm_code as permCode, perm_desc as permDesc, " +
        "create_time as createTime FROM permission";
    return queryForList(Permission.class, sql);
  }

  @Override
  public Permission getPermissionById(Integer permId) {
    String sql = "SELECT perm_id as permId, perm_name as permName, " +
        "perm_code as permCode, perm_desc as permDesc, " +
        "create_time as createTime FROM permission WHERE perm_id = ?";
    return queryForOne(Permission.class, sql, permId);
  }

  @Override
  public int addPermission(Permission permission) {
    String sql = "INSERT INTO permission (perm_name, perm_code, perm_desc) VALUES (?, ?, ?)";
    return update(sql, permission.getPermName(), permission.getPermCode(), permission.getPermDesc());
  }

  @Override
  public int updatePermission(Permission permission) {
    String sql = "UPDATE permission SET perm_name = ?, perm_code = ?, perm_desc = ? WHERE perm_id = ?";
    return update(sql, permission.getPermName(), permission.getPermCode(),
        permission.getPermDesc(), permission.getPermId());
  }

  @Override
  public int deletePermission(Integer permId) {
    String sql = "DELETE FROM permission WHERE perm_id = ?";
    return update(sql, permId);
  }
}
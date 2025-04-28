package com.bkty.dao;

import com.bkty.entity.Permission;
import java.util.List;

public interface PermissionDao {
  List<Permission> getAllPermissions();

  Permission getPermissionById(Integer permId);

  int addPermission(Permission permission);

  int updatePermission(Permission permission);

  int deletePermission(Integer permId);
}
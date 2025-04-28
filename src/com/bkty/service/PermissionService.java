package com.bkty.service;

import com.bkty.entity.Permission;
import java.util.List;

public interface PermissionService {
  List<Permission> getAllPermissions();

  Permission getPermissionById(Integer permId);

  boolean addPermission(Permission permission);

  boolean updatePermission(Permission permission);

  boolean deletePermission(Integer permId);
}
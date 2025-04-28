package com.bkty.service.impl;

import com.bkty.dao.PermissionDao;
import com.bkty.dao.impl.PermissionDaoImpl;
import com.bkty.entity.Permission;
import com.bkty.service.PermissionService;

import java.util.List;

public class PermissionServiceImpl implements PermissionService {
  private PermissionDao permissionDao = new PermissionDaoImpl();

  @Override
  public List<Permission> getAllPermissions() {
    return permissionDao.getAllPermissions();
  }

  @Override
  public Permission getPermissionById(Integer permId) {
    return permissionDao.getPermissionById(permId);
  }

  @Override
  public boolean addPermission(Permission permission) {
    return permissionDao.addPermission(permission) > 0;
  }

  @Override
  public boolean updatePermission(Permission permission) {
    return permissionDao.updatePermission(permission) > 0;
  }

  @Override
  public boolean deletePermission(Integer permId) {
    return permissionDao.deletePermission(permId) > 0;
  }
}
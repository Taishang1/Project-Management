package com.bkty.service.impl;

import com.bkty.dao.RoleDao;
import com.bkty.dao.impl.RoleDaoImpl;
import com.bkty.entity.Role;
import com.bkty.service.RoleService;

import java.util.List;

public class RoleServiceImpl implements RoleService {
  private RoleDao roleDao = new RoleDaoImpl();

  @Override
  public List<Role> getAllRoles() {
    return roleDao.getAllRoles();
  }

  @Override
  public Role getRoleById(Integer rid) {
    return roleDao.getRoleById(rid);
  }

  @Override
  public boolean addRole(Role role) {
    return roleDao.addRole(role) > 0;
  }

  @Override
  public boolean updateRole(Role role) {
    return roleDao.updateRole(role) > 0;
  }

  @Override
  public boolean deleteRole(Integer rid) {
    return roleDao.deleteRole(rid) > 0;
  }

  @Override
  public boolean assignPermissions(Integer rid, List<Integer> pids) {
    return roleDao.assignPermissions(rid, pids);
  }
}
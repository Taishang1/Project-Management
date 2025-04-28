package com.bkty.service;

import com.bkty.entity.Role;
import java.util.List;

public interface RoleService {
  List<Role> getAllRoles();

  Role getRoleById(Integer rid);

  boolean addRole(Role role);

  boolean updateRole(Role role);

  boolean deleteRole(Integer rid);

  boolean assignPermissions(Integer rid, List<Integer> pids);
}
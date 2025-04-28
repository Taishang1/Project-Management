package com.bkty.dao;

import com.bkty.entity.Role;
import java.util.List;

public interface RoleDao {
  List<Role> getAllRoles();

  Role getRoleById(Integer rid);

  int addRole(Role role);

  int updateRole(Role role);

  int deleteRole(Integer rid);

  boolean assignPermissions(Integer rid, List<Integer> pids);
}
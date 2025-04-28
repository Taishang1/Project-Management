package com.bkty.dao;

import com.bkty.entity.User;

public interface UserDao {
    User getUserByUkeyAndPwd(String ukey, String pwd);

    boolean addUser(User user);

    int register(User user);

    User getUserById(int uid);

    boolean updateUser(User user);

    boolean updateUserHead(int uid, String headPath);
}
package com.bkty.service;

import com.bkty.entity.User;

public interface UserService {
    User login(String ukey, String pwd);

    int register(User user);

    User getUserById(int uid);

    boolean updateUser(User user);
}
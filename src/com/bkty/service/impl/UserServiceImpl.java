package com.bkty.service.impl;

import com.bkty.dao.UserDao;
import com.bkty.dao.impl.UserDaoImpl;
import com.bkty.entity.User;
import com.bkty.service.UserService;

public class UserServiceImpl implements UserService {

    private UserDao userDao = new UserDaoImpl();

    @Override
    public User login(String ukey, String pwd) {
        return userDao.getUserByUkeyAndPwd(ukey, pwd);
    }

    @Override
    public int register(User user) {
        return userDao.register(user);
    }

    @Override
    public User getUserById(int uid) {
        return userDao.getUserById(uid);
    }

    @Override
    public boolean updateUser(User user) {
        return userDao.updateUser(user);
    }
}
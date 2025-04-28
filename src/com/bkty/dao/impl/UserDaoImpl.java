package com.bkty.dao.impl;

import com.bkty.dao.UserDao;
import com.bkty.entity.User;
import com.bkty.utils.JDBCUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDaoImpl implements UserDao {

    @Override
    public User getUserByUkeyAndPwd(String ukey, String pwd) {
        Connection connection = null;
        PreparedStatement ps = null;
        User user = null;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT * FROM user WHERE ukey = ? AND pwd = ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, ukey);
            ps.setString(2, pwd);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setUid(rs.getInt("uid"));
                user.setUkey(rs.getString("ukey"));
                user.setPwd(rs.getString("pwd"));
                user.setRealname(rs.getString("realname"));
                user.setType(rs.getInt("type"));
                user.setHead(rs.getString("head"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return user;
    }

    @Override
    public boolean addUser(User user) {
        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "INSERT INTO user (ukey, pwd, realname, type, head) VALUES (?, ?, ?, ?, ?)";
            ps = connection.prepareStatement(sql);
            ps.setString(1, user.getUkey());
            ps.setString(2, user.getPwd());
            ps.setString(3, user.getRealname());
            ps.setInt(4, user.getType());
            ps.setString(5, user.getHead());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return false;
    }

    @Override
    public User getUserById(int uid) {
        Connection connection = null;
        PreparedStatement ps = null;
        User user = null;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT * FROM user WHERE uid = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, uid);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setUid(rs.getInt("uid"));
                user.setUkey(rs.getString("ukey"));
                user.setPwd(rs.getString("pwd"));
                user.setRealname(rs.getString("realname"));
                user.setType(rs.getInt("type"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return user;
    }

    @Override
    public boolean updateUser(User user) {
        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "UPDATE user SET ukey = ?, pwd = ?, realname = ?, type = ? WHERE uid = ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, user.getUkey());
            ps.setString(2, user.getPwd());
            ps.setString(3, user.getRealname());
            ps.setInt(4, user.getType());
            ps.setInt(5, user.getUid());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return false;
    }

    @Override
    public boolean updateUserHead(int uid, String headPath) {
        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "UPDATE user SET head = ? WHERE uid = ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, headPath);
            ps.setInt(2, uid);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return false;
    }

    @Override
    public int register(User user) {
        String sql = "insert into user(ukey,pwd,head,type) values(?,?,?,?)";
        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = JDBCUtils.getConnection();
            ps = connection.prepareStatement(sql);
            ps.setString(1, user.getUkey());
            ps.setString(2, user.getPwd());
            ps.setString(3, user.getHead());
            ps.setInt(4, user.getType());
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return 0;
    }
}
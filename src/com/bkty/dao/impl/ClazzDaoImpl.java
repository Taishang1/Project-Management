package com.bkty.dao.impl;

import com.bkty.dao.ClazzDao;
import com.bkty.entity.Clazz;
import com.bkty.entity.TongJi;
import com.bkty.utils.JDBCUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ClazzDaoImpl implements ClazzDao {

    @Override
    public List<TongJi> getTongJi() {
        Connection connection = null;
        PreparedStatement ps = null;
        List<TongJi> tongJiList = new ArrayList<>();
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT c.cname, COUNT(s.sid) AS studentCount " +
                    "FROM clazz c " +
                    "LEFT JOIN student s ON c.cid = s.cid " +
                    "GROUP BY c.cid, c.cname";
            ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TongJi tongJi = new TongJi();
                tongJi.setCname(rs.getString("cname"));
                tongJi.setCount(rs.getInt("studentCount"));
                tongJiList.add(tongJi);
                System.out.println("统计数据: " + tongJi.getCname() + " - " + tongJi.getCount());
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return tongJiList;
    }

    @Override
    public int updateClazz(Clazz clazz) {
        Connection connection = null;
        PreparedStatement ps = null;
        int result = 0;

        try {
            connection = JDBCUtils.getConnection();
            String sql = "UPDATE clazz SET cname=?, cteacher=?, remark=? WHERE cid=?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, clazz.getCname());
            ps.setString(2, clazz.getCteacher());
            ps.setString(3, clazz.getRemark());
            ps.setInt(4, clazz.getCid());
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }

        return result;
    }

    @Override
    public List<Clazz> getClazzByPage(int start, int size) {
        Connection connection = null;
        PreparedStatement ps = null;
        List<Clazz> clazzList = new ArrayList<>();

        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT * FROM clazz LIMIT ?, ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, start);
            ps.setInt(2, size);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Clazz clazz = new Clazz();
                clazz.setCid(rs.getInt("cid"));
                clazz.setCname(rs.getString("cname"));
                clazz.setCteacher(rs.getString("cteacher"));
                clazz.setRemark(rs.getString("remark"));
                clazzList.add(clazz);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }

        return clazzList;
    }

    @Override
    public int getTotalCount() {
        Connection connection = null;
        PreparedStatement ps = null;
        int totalCount = 0;

        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT COUNT(*) FROM clazz";
            ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                totalCount = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }

        return totalCount;
    }

    @Override
    public List<Clazz> getAll() {
        Connection connection = null;
        PreparedStatement ps = null;
        List<Clazz> clazzList = new ArrayList<>();

        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT * FROM clazz";
            ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Clazz clazz = new Clazz();
                clazz.setCid(rs.getInt("cid"));
                clazz.setCname(rs.getString("cname"));
                clazz.setCteacher(rs.getString("cteacher"));
                clazz.setRemark(rs.getString("remark"));
                clazzList.add(clazz);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }

        return clazzList;
    }

    @Override
    public int addClazz(Clazz clazz) {
        Connection connection = null;
        PreparedStatement ps = null;
        int result = 0;

        try {
            connection = JDBCUtils.getConnection();
            String sql = "INSERT INTO clazz (cname, cteacher, remark) VALUES (?, ?, ?)";
            ps = connection.prepareStatement(sql);
            ps.setString(1, clazz.getCname());
            ps.setString(2, clazz.getCteacher());
            ps.setString(3, clazz.getRemark());
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }

        return result;
    }

    @Override
    public List<Clazz> getAllClazz() {
        return getAll();
    }

    @Override
    public int getTotalCount(String keyword) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = JDBCUtils.getConnection();
            StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM clazz WHERE 1=1");
            if (keyword != null && !keyword.trim().isEmpty()) {
                sql.append(" AND (cname LIKE ? OR cteacher LIKE ?)");
            }
            ps = conn.prepareStatement(sql.toString());
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(1, "%" + keyword + "%");
                ps.setString(2, "%" + keyword + "%");
            }
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(rs, ps, conn);
        }
        return 0;
    }

    @Override
    public List<Clazz> getClazzByPage(int start, int size, String keyword) {
        List<Clazz> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = JDBCUtils.getConnection();
            StringBuilder sql = new StringBuilder("SELECT * FROM clazz WHERE 1=1");

            if (keyword != null && !keyword.trim().isEmpty()) {
                sql.append(" AND (cname LIKE ? OR cteacher LIKE ?)");
            }

            sql.append(" ORDER BY cid LIMIT ?,?");

            System.out.println("执行的SQL: " + sql.toString());
            System.out.println("参数: start=" + start + ", size=" + size + ", keyword=" + keyword);

            ps = conn.prepareStatement(sql.toString());

            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + keyword + "%");
                ps.setString(paramIndex++, "%" + keyword + "%");
            }
            ps.setInt(paramIndex++, start);
            ps.setInt(paramIndex, size);

            rs = ps.executeQuery();
            while (rs.next()) {
                Clazz clazz = new Clazz();
                clazz.setCid(rs.getInt("cid"));
                clazz.setCname(rs.getString("cname"));
                clazz.setCteacher(rs.getString("cteacher"));
                clazz.setRemark(rs.getString("remark"));
                list.add(clazz);
            }
            System.out.println("查询到的记录数: " + list.size());
        } catch (Exception e) {
            System.out.println("查询出错: " + e.getMessage());
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(rs, ps, conn);
        }
        return list;
    }

    @Override
    public Clazz getClazzById(int cid) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Clazz clazz = null;

        try {
            conn = JDBCUtils.getConnection();
            String sql = "SELECT * FROM clazz WHERE cid = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, cid);
            rs = ps.executeQuery();

            if (rs.next()) {
                clazz = new Clazz();
                clazz.setCid(rs.getInt("cid"));
                clazz.setCname(rs.getString("cname"));
                clazz.setCteacher(rs.getString("cteacher"));
                clazz.setRemark(rs.getString("remark"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(rs, ps, conn);
        }

        return clazz;
    }

    @Override
    public int deleteClazz(int cid) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = JDBCUtils.getConnection();
            String sql = "DELETE FROM clazz WHERE cid = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, cid);
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, conn);
        }
        return 0;
    }
}
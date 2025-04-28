package com.bkty.dao.impl;

import com.bkty.dao.TeachingPlanDao;
import com.bkty.entity.TeachingPlan;
import com.bkty.utils.JDBCUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class TeachingPlanDaoImpl implements TeachingPlanDao {

    @Override
    public int addTeachingPlan(TeachingPlan teachingPlan) {
        Connection connection = null;
        PreparedStatement ps = null;
        int result = 0;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "INSERT INTO teaching_plan (cid, tid, start_date, end_date, description) VALUES (?, ?, ?, ?, ?)";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, teachingPlan.getCid());
            ps.setInt(2, teachingPlan.getTid());
            ps.setDate(3, new java.sql.Date(teachingPlan.getStartDate().getTime()));
            ps.setDate(4, new java.sql.Date(teachingPlan.getEndDate().getTime()));
            ps.setString(5, teachingPlan.getDescription());
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return result;
    }

    @Override
    public int updateTeachingPlan(TeachingPlan teachingPlan) {
        Connection connection = null;
        PreparedStatement ps = null;
        int result = 0;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "UPDATE teaching_plan SET cid=?, tid=?, start_date=?, end_date=?, description=? WHERE tpid=?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, teachingPlan.getCid());
            ps.setInt(2, teachingPlan.getTid());
            ps.setDate(3, new java.sql.Date(teachingPlan.getStartDate().getTime()));
            ps.setDate(4, new java.sql.Date(teachingPlan.getEndDate().getTime()));
            ps.setString(5, teachingPlan.getDescription());
            ps.setInt(6, teachingPlan.getTpid());
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return result;
    }

    @Override
    public int deleteTeachingPlan(int tpid) {
        Connection connection = null;
        PreparedStatement ps = null;
        int result = 0;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "DELETE FROM teaching_plan WHERE tpid=?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, tpid);
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return result;
    }

    @Override
    public TeachingPlan getTeachingPlanById(int tpid) {
        Connection connection = null;
        PreparedStatement ps = null;
        TeachingPlan teachingPlan = null;
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT * FROM teaching_plan WHERE tpid=?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, tpid);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                teachingPlan = new TeachingPlan();
                teachingPlan.setTpid(rs.getInt("tpid"));
                teachingPlan.setCid(rs.getInt("cid"));
                teachingPlan.setTid(rs.getInt("tid"));
                teachingPlan.setStartDate(rs.getDate("start_date"));
                teachingPlan.setEndDate(rs.getDate("end_date"));
                teachingPlan.setDescription(rs.getString("description"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return teachingPlan;
    }

    @Override
    public List<TeachingPlan> getAllTeachingPlans() {
        Connection connection = null;
        PreparedStatement ps = null;
        List<TeachingPlan> teachingPlans = new ArrayList<>();
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT * FROM teaching_plan";
            ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TeachingPlan teachingPlan = new TeachingPlan();
                teachingPlan.setTpid(rs.getInt("tpid"));
                teachingPlan.setCid(rs.getInt("cid"));
                teachingPlan.setTid(rs.getInt("tid"));
                teachingPlan.setStartDate(rs.getDate("start_date"));
                teachingPlan.setEndDate(rs.getDate("end_date"));
                teachingPlan.setDescription(rs.getString("description"));
                teachingPlans.add(teachingPlan);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return teachingPlans;
    }

    @Override
    public List<TeachingPlan> searchTeachingPlans(String keyword) {
        Connection connection = null;
        PreparedStatement ps = null;
        List<TeachingPlan> teachingPlans = new ArrayList<>();
        try {
            connection = JDBCUtils.getConnection();
            String sql = "SELECT * FROM teaching_plan WHERE description LIKE ? OR cid IN (SELECT cid FROM course WHERE cname LIKE ?)";
            ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TeachingPlan teachingPlan = new TeachingPlan();
                teachingPlan.setTpid(rs.getInt("tpid"));
                teachingPlan.setCid(rs.getInt("cid"));
                teachingPlan.setTid(rs.getInt("tid"));
                teachingPlan.setStartDate(rs.getDate("start_date"));
                teachingPlan.setEndDate(rs.getDate("end_date"));
                teachingPlan.setDescription(rs.getString("description"));
                teachingPlans.add(teachingPlan);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.closeConnection(ps, connection);
        }
        return teachingPlans;
    }
}
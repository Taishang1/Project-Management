package com.bkty.dao.impl;

import com.bkty.dao.BaseDao;
import com.bkty.dao.SystemLogDao;
import com.bkty.entity.SystemLog;

import java.util.List;

public class SystemLogDaoImpl extends BaseDao implements SystemLogDao {

    @Override
    public int addSystemLog(SystemLog systemLog) {
        String sql = "INSERT INTO system_log (uid, operation, module, log_time, ip_address) " +
                "VALUES (?, ?, ?, ?, ?)";
        return update(sql,
                systemLog.getUid(),
                systemLog.getOperation(),
                systemLog.getModule(),
                systemLog.getLogTime(),
                systemLog.getIpAddress());
    }

    @Override
    public List<SystemLog> getAllSystemLogs() {
        String sql = "SELECT logid as logId, uid, operation, module, " +
                "log_time as logTime FROM system_log ORDER BY log_time DESC";
        return queryForList(SystemLog.class, sql);
    }

    @Override
    public List<SystemLog> searchSystemLogs(String keyword) {
        String sql = "SELECT logid as logId, uid, operation, module, " +
                "log_time as logTime FROM system_log " +
                "WHERE operation LIKE ? OR module LIKE ? " +
                "ORDER BY log_time DESC";
        String pattern = "%" + keyword + "%";
        return queryForList(SystemLog.class, sql, pattern, pattern);
    }
}
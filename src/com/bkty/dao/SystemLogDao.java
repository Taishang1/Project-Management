package com.bkty.dao;

import com.bkty.entity.SystemLog;

import java.util.List;

public interface SystemLogDao {

    // 添加系统日志
    int addSystemLog(SystemLog systemLog);

    // 获取所有系统日志
    List<SystemLog> getAllSystemLogs();

    // 根据条件查询系统日志
    List<SystemLog> searchSystemLogs(String keyword);
}
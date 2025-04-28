package com.bkty.service;

import com.bkty.entity.SystemLog;

import java.util.List;

public interface SystemLogService {

    // 添加系统日志
    boolean addSystemLog(SystemLog systemLog);

    // 获取所有系统日志
    List<SystemLog> getAllSystemLogs();

    // 根据条件查询系统日志
    List<SystemLog> searchSystemLogs(String keyword);
}
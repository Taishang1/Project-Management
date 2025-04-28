package com.bkty.service.impl;

import com.bkty.dao.SystemLogDao;
import com.bkty.dao.impl.SystemLogDaoImpl;
import com.bkty.entity.SystemLog;
import com.bkty.service.SystemLogService;

import java.util.List;

public class SystemLogServiceImpl implements SystemLogService {

    private SystemLogDao systemLogDao = new SystemLogDaoImpl();

    @Override
    public boolean addSystemLog(SystemLog systemLog) {
        return systemLogDao.addSystemLog(systemLog) > 0;
    }

    @Override
    public List<SystemLog> getAllSystemLogs() {
        return systemLogDao.getAllSystemLogs();
    }

    @Override
    public List<SystemLog> searchSystemLogs(String keyword) {
        return systemLogDao.searchSystemLogs(keyword);
    }
}
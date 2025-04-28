package com.bkty.service.impl;

import com.bkty.dao.ClazzDao;
import com.bkty.dao.impl.ClazzDaoImpl;
import com.bkty.entity.Clazz;
import com.bkty.entity.PageBean;
import com.bkty.entity.TongJi;
import com.bkty.service.ClazzService;

import java.util.List;

public class ClazzServiceImpl implements ClazzService {

    private ClazzDao clazzDao = new ClazzDaoImpl();

    @Override
    public List<TongJi> getTongJi() {
        return clazzDao.getTongJi();
    }

    @Override
    public int updateClazz(Clazz clazz) {
        return clazzDao.updateClazz(clazz);
    }

    @Override
    public PageBean<Clazz> getClazzByPage(int index, String keyword) {
        PageBean<Clazz> pageBean = new PageBean<>();
        pageBean.setIndex(index);
        pageBean.setSize(10); // 每页显示10条记录

        // 获取总记录数
        int totalCount = clazzDao.getTotalCount(keyword);
        pageBean.setTotalCount(totalCount);

        // 获取当前页数据
        int start = (index - 1) * pageBean.getSize();
        List<Clazz> list = clazzDao.getClazzByPage(start, pageBean.getSize(), keyword);
        pageBean.setList(list);

        return pageBean;
    }

    @Override
    public List<Clazz> getAll() {
        return clazzDao.getAll();
    }

    @Override
    public int addClazz(Clazz clazz) {
        return clazzDao.addClazz(clazz);
    }

    @Override
    public List<Clazz> getAllClazz() {
        return clazzDao.getAllClazz();
    }

    @Override
    public Clazz getClazzById(int cid) {
        return clazzDao.getClazzById(cid);
    }

    @Override
    public int deleteClazz(int cid) {
        return clazzDao.deleteClazz(cid);
    }
}
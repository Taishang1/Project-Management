package com.bkty.service;

import com.bkty.entity.Clazz;
import com.bkty.entity.PageBean;
import com.bkty.entity.TongJi;

import java.util.List;

public interface ClazzService {

    List<TongJi> getTongJi();

    int updateClazz(Clazz clazz);

    List<Clazz> getAll();

    int addClazz(Clazz clazz);

    List<Clazz> getAllClazz();

    PageBean<Clazz> getClazzByPage(int index, String keyword);

    Clazz getClazzById(int cid);

    int deleteClazz(int cid);
}
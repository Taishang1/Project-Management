package com.bkty.service.impl;

import com.bkty.dao.TeachingPlanDao;
import com.bkty.dao.impl.TeachingPlanDaoImpl;
import com.bkty.entity.TeachingPlan;
import com.bkty.service.TeachingPlanService;

import java.util.List;

public class TeachingPlanServiceImpl implements TeachingPlanService {

    private TeachingPlanDao teachingPlanDao = new TeachingPlanDaoImpl();

    @Override
    public boolean addTeachingPlan(TeachingPlan teachingPlan) {
        return teachingPlanDao.addTeachingPlan(teachingPlan) > 0;
    }

    @Override
    public boolean updateTeachingPlan(TeachingPlan teachingPlan) {
        return teachingPlanDao.updateTeachingPlan(teachingPlan) > 0;
    }

    @Override
    public boolean deleteTeachingPlan(int tpid) {
        return teachingPlanDao.deleteTeachingPlan(tpid) > 0;
    }

    @Override
    public TeachingPlan getTeachingPlanById(int tpid) {
        return teachingPlanDao.getTeachingPlanById(tpid);
    }

    @Override
    public List<TeachingPlan> getAllTeachingPlans() {
        return teachingPlanDao.getAllTeachingPlans();
    }

    @Override
    public List<TeachingPlan> searchTeachingPlans(String keyword) {
        return teachingPlanDao.searchTeachingPlans(keyword);
    }
}
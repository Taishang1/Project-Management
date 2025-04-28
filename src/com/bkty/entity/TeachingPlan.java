package com.bkty.entity;

import java.io.Serializable;
import java.util.Date;

public class TeachingPlan implements Serializable {
    private Integer tpid;
    private Integer cid;
    private Integer tid;
    private Date startDate;
    private Date endDate;
    private String description;

    public TeachingPlan() {
    }

    public TeachingPlan(Integer cid, Integer tid, Date startDate, Date endDate, String description) {
        this.cid = cid;
        this.tid = tid;
        this.startDate = startDate;
        this.endDate = endDate;
        this.description = description;
    }

    public TeachingPlan(Integer tpid, Integer cid, Integer tid, Date startDate, Date endDate, String description) {
        this.tpid = tpid;
        this.cid = cid;
        this.tid = tid;
        this.startDate = startDate;
        this.endDate = endDate;
        this.description = description;
    }

    public Integer getTpid() {
        return tpid;
    }

    public void setTpid(Integer tpid) {
        this.tpid = tpid;
    }

    public Integer getCid() {
        return cid;
    }

    public void setCid(Integer cid) {
        this.cid = cid;
    }

    public Integer getTid() {
        return tid;
    }

    public void setTid(Integer tid) {
        this.tid = tid;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "TeachingPlan{" +
                "tpid=" + tpid +
                ", cid=" + cid +
                ", tid=" + tid +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", description='" + description + '\'' +
                '}';
    }
}
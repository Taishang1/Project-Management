package com.bkty.entity;

public class Clazz {
    private Integer cid;
    private String cname;
    private String cteacher;
    private String remark;

    public Clazz() {
    }

    public Clazz(Integer cid, String cname, String cteacher, String remark) {
        this.cid = cid;
        this.cname = cname;
        this.cteacher = cteacher;
        this.remark = remark;
    }

    public Integer getCid() {
        return cid;
    }

    public void setCid(Integer cid) {
        this.cid = cid;
    }

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }

    public String getCteacher() {
        return cteacher;
    }

    public void setCteacher(String cteacher) {
        this.cteacher = cteacher;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }
}
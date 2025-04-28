package com.bkty.entity;

public class TongJi {
    private String cname;
    private Integer count;

    public TongJi() {
    }

    public TongJi(String cname, Integer count) {
        this.cname = cname;
        this.count = count;
    }

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }

    public Integer getCount() {
        return count;
    }

    public void setCount(Integer count) {
        this.count = count;
    }

    @Override
    public String toString() {
        return "TongJi{" +
                "cname='" + cname + '\'' +
                ", count=" + count +
                '}';
    }
}
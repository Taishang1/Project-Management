package com.bkty.entity;

import java.io.Serializable;
import java.util.Date;

public class Announcement implements Serializable {
    private Integer anid;
    private String title;
    private String content;
    private Date publishDate;
    private String publisher;

    public Announcement() {
    }

    public Announcement(String title, String content, Date publishDate, String publisher) {
        this.title = title;
        this.content = content;
        this.publishDate = publishDate;
        this.publisher = publisher;
    }

    public Announcement(Integer anid, String title, String content, Date publishDate, String publisher) {
        this.anid = anid;
        this.title = title;
        this.content = content;
        this.publishDate = publishDate;
        this.publisher = publisher;
    }

    public Integer getAnid() {
        return anid;
    }

    public void setAnid(Integer anid) {
        this.anid = anid;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getPublishDate() {
        return publishDate;
    }

    public void setPublishDate(Date publishDate) {
        this.publishDate = publishDate;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    @Override
    public String toString() {
        return "Announcement{" +
                "anid=" + anid +
                ", title='" + title + '\'' +
                ", content='" + content + '\'' +
                ", publishDate=" + publishDate +
                ", publisher='" + publisher + '\'' +
                '}';
    }
}
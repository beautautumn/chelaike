package com.ct.erp.lib.entity;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Date;

public class Announcement implements Serializable{
    private Long id;
    private Long companyId;
    private Long marketId;
    private String title;
    private String content;
    private String announcementType;
    private Boolean state;
    private String sender;
    private Boolean top;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getCompanyId() {
        return companyId;
    }

    public void setCompanyId(Long companyId) {
        this.companyId = companyId;
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

    public String getAnnouncementType() {
        return announcementType;
    }

    public void setAnnouncementType(String announcementType) {
        this.announcementType = announcementType;
    }

    public Boolean getState() {
        return state;
    }

    public void setState(Boolean state) {
        this.state = state;
    }

    public String getSender() {
        return sender;
    }

    public void setSender(String sender) {
        this.sender = sender;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Boolean getTop() {
        return top;
    }

    public void setTop(Boolean top) {
        this.top = top;
    }

    public Long getMarketId() {   return marketId;}

    public void setMarketId(Long marketId) {         this.marketId = marketId;     }
}

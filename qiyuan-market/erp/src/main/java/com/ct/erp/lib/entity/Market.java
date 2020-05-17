package com.ct.erp.lib.entity;

import java.io.Serializable;
import java.util.Date;

public class Market implements Serializable{
    private Long marketId;
    private String marketUid;
    private String marketName;
    private Integer marketArea;
    private String marketLinkmanName;
    private String marketLinkmanMobile;
    private String marketLinkmanCode;
    private String marketLegalName;
    private String marketLegalMobile;
    private Date marketContractBeginDate;
    private Date marketContractEndDate;
    private Long staffId;
    private String marketStatus;
    private String marketMobile;

    public Long getMarketId() {
        return marketId;
    }

    public void setMarketId(Long marketId) {
        this.marketId = marketId;
    }

    public String getMarketUid() {
        return marketUid;
    }

    public void setMarketUid(String marketUid) {
        this.marketUid = marketUid;
    }

    public String getMarketName() {
        return marketName;
    }

    public void setMarketName(String marketName) {
        this.marketName = marketName;
    }

    public Integer getMarketArea() {
        return marketArea;
    }

    public void setMarketArea(Integer marketArea) {
        this.marketArea = marketArea;
    }

    public String getMarketLinkmanName() {
        return marketLinkmanName;
    }

    public void setMarketLinkmanName(String marketLinkmanName) {
        this.marketLinkmanName = marketLinkmanName;
    }

    public String getMarketLinkmanMobile() {
        return marketLinkmanMobile;
    }

    public void setMarketLinkmanMobile(String marketLinkmanMobile) {
        this.marketLinkmanMobile = marketLinkmanMobile;
    }

    public String getMarketLinkmanCode() {
        return marketLinkmanCode;
    }

    public void setMarketLinkmanCode(String marketLinkmanCode) {
        this.marketLinkmanCode = marketLinkmanCode;
    }

    public String getMarketLegalName() {
        return marketLegalName;
    }

    public void setMarketLegalName(String marketLegalName) {
        this.marketLegalName = marketLegalName;
    }

    public String getMarketLegalMobile() {
        return marketLegalMobile;
    }

    public void setMarketLegalMobile(String marketLegalMobile) {
        this.marketLegalMobile = marketLegalMobile;
    }

    public Date getMarketContractBeginDate() {
        return marketContractBeginDate;
    }

    public void setMarketContractBeginDate(Date marketContractBeginDate) {
        this.marketContractBeginDate = marketContractBeginDate;
    }

    public Date getMarketContractEndDate() {
        return marketContractEndDate;
    }

    public void setMarketContractEndDate(Date marketContractEndDate) {
        this.marketContractEndDate = marketContractEndDate;
    }

    public Long getStaffId() {
        return staffId;
    }

    public void setStaffId(Long staffId) {
        this.staffId = staffId;
    }

    public String getMarketStatus() {
        return marketStatus;
    }

    public void setMarketStatus(String marketStatus) {
        this.marketStatus = marketStatus;
    }

    public String getMarketMobile() {
        return marketMobile;
    }

    public void setMarketMobile(String marketMobile) {
        this.marketMobile = marketMobile;
    }
}

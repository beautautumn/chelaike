package com.ct.erp.lib.entity;

import java.io.Serializable;
import java.util.Date;

public class Checker implements Serializable{
    private Long checkerId;
    private String checkerUid;
    private String checkerName;
    private String checkerMobile;
    private String checkerCode;
    private Date checkerCreateDate;
    private Market market;

    public Long getCheckerId() {
        return checkerId;
    }

    public void setCheckerId(Long checkerId) {
        this.checkerId = checkerId;
    }

    public String getCheckerUid() {
        return checkerUid;
    }

    public void setCheckerUid(String checkerUid) {
        this.checkerUid = checkerUid;
    }

    public String getCheckerName() {
        return checkerName;
    }

    public void setCheckerName(String checkerName) {
        this.checkerName = checkerName;
    }

    public String getCheckerMobile() {
        return checkerMobile;
    }

    public void setCheckerMobile(String checkerMobile) {
        this.checkerMobile = checkerMobile;
    }

    public String getCheckerCode() {
        return checkerCode;
    }

    public void setCheckerCode(String checkerCode) {
        this.checkerCode = checkerCode;
    }

    public Date getCheckerCreateDate() {
        return checkerCreateDate;
    }

    public void setCheckerCreateDate(Date checkerCreateDate) {
        this.checkerCreateDate = checkerCreateDate;
    }

    public Market getMarket() {
        return market;
    }

    public void setMarket(Market market) {
        this.market = market;
    }
}

package com.ct.erp.lib.entity;

import java.sql.Timestamp;

public class FirstCheck implements java.io.Serializable{

    private Long id;
    private Long gateLogId;
    private Long operatorId;
    private Timestamp operateTime;
    private Long checkerId;
    private Timestamp checkTime;
    private String status;
    private Long carId;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public FirstCheck() {
    }

    public FirstCheck(Long id, Long gateLogId, Long operatorId,
                      Timestamp operateTime, Long checkerId, Timestamp checkTime,
                      String status, Long carId, Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.gateLogId = gateLogId;
        this.operatorId = operatorId;
        this.operateTime = operateTime;
        this.checkerId = checkerId;
        this.checkTime = checkTime;
        this.status = status;
        this.carId = carId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getGateLogId() {
        return gateLogId;
    }

    public void setGateLogId(Long gateLogId) {
        this.gateLogId = gateLogId;
    }

    public Long getOperatorId() {
        return operatorId;
    }

    public void setOperatorId(Long operatorId) {
        this.operatorId = operatorId;
    }

    public Timestamp getOperateTime() {
        return operateTime;
    }

    public void setOperateTime(Timestamp operateTime) {
        this.operateTime = operateTime;
    }

    public Long getCheckerId() {
        return checkerId;
    }

    public void setCheckerId(Long checkerId) {
        this.checkerId = checkerId;
    }

    public Timestamp getCheckTime() {
        return checkTime;
    }

    public void setCheckTime(Timestamp checkTime) {
        this.checkTime = checkTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Long getCarId() {
        return carId;
    }

    public void setCarId(Long carId) {
        this.carId = carId;
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
}

package com.ct.erp.lib.entity;

import java.sql.Timestamp;

public class Authorization implements java.io.Serializable{

    private Long id;
    private Long carId;
    private Long grantorId;
    private String note;
    private Long operatorId;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private String state;

    public Authorization() {

    }

    public Authorization(Long id, Long carId, Long grantorId, String note,
                         Long operatorId, Timestamp createdAt, Timestamp updatedAt, String state) {
        this.id = id;
        this.carId = carId;
        this.grantorId = grantorId;
        this.note = note;
        this.operatorId = operatorId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.state = state;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getCarId() {
        return carId;
    }

    public void setCarId(Long carId) {
        this.carId = carId;
    }

    public Long getGrantorId() {
        return grantorId;
    }

    public void setGrantorId(Long grantorId) {
        this.grantorId = grantorId;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Long getOperatorId() {
        return operatorId;
    }

    public void setOperatorId(Long operatorId) {
        this.operatorId = operatorId;
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

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }
}

package com.ct.erp.lib.entity;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Date;

public class ParkingCards implements Serializable {

    // Fields
    private Long id;
    private Long shop_id;
    private Long operator_id;
    private String no;
    private String note;
    private Timestamp created_at;
    private Timestamp updated_at;
    private String state;

    @Override
    public String toString() {
        return "ParkingCards{" +
                "id=" + id +
                ", shop_id=" + shop_id +
                ", operator_id=" + operator_id +
                ", no='" + no + '\'' +
                ", note='" + note + '\'' +
                ", created_at=" + created_at +
                ", updated_at=" + updated_at +
                ", state='" + state + '\'' +
                '}';
    }

    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }
    public Long getShop_id() {
        return shop_id;
    }

    public void setShop_id(Long shop_id) {
        this.shop_id = shop_id;
    }

    public Long getOperator_id() {
        return operator_id;
    }

    public void setOperator_id(Long operator_id) {
        this.operator_id = operator_id;
    }

    public String getNo() {
        return no;
    }

    public void setNo(String no) {
        this.no = no;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }

    public Timestamp getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(Timestamp updated_at) {
        this.updated_at = updated_at;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }
}

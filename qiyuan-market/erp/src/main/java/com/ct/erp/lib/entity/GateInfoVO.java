package com.ct.erp.lib.entity;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Created by DeeWang on 17/12/16.
 */
public class GateInfoVO implements Serializable {
    private Long id;                //主键
    private String no;              //闸道编号
    private String name;            //闸道名称
    private String direction;      //in 进   ；out  出
    private Timestamp created_at;   //
    private Timestamp updated_at;   //
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNo() {
        return no;
    }

    public void setNo(String no) {
        this.no = no;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setDirection(String direction) {
        this.direction = direction;
    }

    public String getDirection() {
        return direction;
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

}


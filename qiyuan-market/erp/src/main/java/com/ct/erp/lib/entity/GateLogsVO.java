package com.ct.erp.lib.entity;

import java.sql.Timestamp;
/*
* 进出闸流水
* created by DeeWang on 2017/12/19
* */
public class GateLogsVO {
    private Long id;
    private Long gate_id;                           //道闸
    private Long shop_id;                           //车商
    private Long car_id;                            //车辆
    private Long opener_id;                          //开闸保安的id
    private String rfid;                            //RFID
    private String open_type;                      //开闸方式：RFID、保安扫码、车商扫码、停车卡
    private Long parking_card_id;                  //停车卡
    private String direction;                       //进in、出out
    private Timestamp created_at;
    private Timestamp updated_at;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getGate_id() {
        return gate_id;
    }

    public void setGate_id(Long gate_id) {
        this.gate_id = gate_id;
    }

    public Long getShop_id() {
        return shop_id;
    }

    public void setShop_id(Long shop_id) {
        this.shop_id = shop_id;
    }

    public Long getCar_id() {
        return car_id;
    }

    public void setCar_id(Long car_id) {
        this.car_id = car_id;
    }

    public void setOpener_id(Long opener_id) {
        this.opener_id = opener_id;
    }

    public Long getOpener_id() {
        return opener_id;
    }

    public String getRfid() {
        return rfid;
    }

    public void setRfid(String rfid) {
        this.rfid = rfid;
    }

    public String getOpen_type() {
        return open_type;
    }

    public void setOpen_type(String open_type) {
        this.open_type = open_type;
    }

    public Long getParking_card_id() {
        return parking_card_id;
    }

    public void setParking_card_id(Long parking_card_id) {
        this.parking_card_id = parking_card_id;
    }

    public String getDirection() {
        return direction;
    }

    public void setDirection(String direction) {
        this.direction = direction;
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

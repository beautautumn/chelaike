package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Staff;

import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;

/**
 * ChargeRecord entity. @author MyEclipse Persistence Tools
 */

public class ChargeRecord implements java.io.Serializable {

  // Fields

  private Long id;
  private Staff staff;
  private String carType;
  private String cardId;
  private Timestamp comeTime;
  private Timestamp goTime;
  private Integer freeMinutes;
  private Integer price;
  private Integer chargeMinutes;
  private Integer totalPlanFee;
  private Integer totalActualFee;
  private Timestamp chargeTime;
  private String chargeDesc;
  private String state;
  private Set parkRecords = new HashSet(0);

  // Constructors

  /** default constructor */
  public ChargeRecord() {
  }

  /** full constructor */
  public ChargeRecord(Staff staff, String carType, String cardId,
                      Timestamp comeTime, Timestamp goTime, Integer freeMinutes, Integer price,
                      Integer chargeMinutes, Integer totalPlanFee, Integer totalActualFee,
                      Timestamp chargeTime, String chargeDesc, String state, Set parkRecords) {
    this.staff = staff;
    this.carType = carType;
    this.cardId = cardId;
    this.comeTime = comeTime;
    this.goTime = goTime;
    this.freeMinutes = freeMinutes;
    this.price = price;
    this.chargeMinutes = chargeMinutes;
    this.totalPlanFee = totalPlanFee;
    this.totalActualFee = totalActualFee;
    this.chargeTime = chargeTime;
    this.chargeDesc = chargeDesc;
    this.state = state;
    this.parkRecords = parkRecords;
  }

  // Property accessors

  public Long getId() {
    return this.id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public Staff getStaff() {
    return this.staff;
  }

  public void setStaff(Staff staff) {
    this.staff = staff;
  }

  public String getCarType() {
    return this.carType;
  }

  public void setCarType(String carType) {
    this.carType = carType;
  }

  public String getCardId() {
    return this.cardId;
  }

  public void setCardId(String cardId) {
    this.cardId = cardId;
  }

  public Timestamp getComeTime() {
    return this.comeTime;
  }

  public void setComeTime(Timestamp comeTime) {
    this.comeTime = comeTime;
  }

  public Timestamp getGoTime() {
    return this.goTime;
  }

  public void setGoTime(Timestamp goTime) {
    this.goTime = goTime;
  }

  public Integer getFreeMinutes() {
    return this.freeMinutes;
  }

  public void setFreeMinutes(Integer freeMinutes) {
    this.freeMinutes = freeMinutes;
  }

  public Integer getPrice() {
    return this.price;
  }

  public void setPrice(Integer price) {
    this.price = price;
  }

  public Integer getChargeMinutes() {
    return this.chargeMinutes;
  }

  public void setChargeMinutes(Integer chargeMinutes) {
    this.chargeMinutes = chargeMinutes;
  }

  public Integer getTotalPlanFee() {
    return this.totalPlanFee;
  }

  public void setTotalPlanFee(Integer totalPlanFee) {
    this.totalPlanFee = totalPlanFee;
  }

  public Integer getTotalActualFee() {
    return this.totalActualFee;
  }

  public void setTotalActualFee(Integer totalActualFee) {
    this.totalActualFee = totalActualFee;
  }

  public Timestamp getChargeTime() {
    return this.chargeTime;
  }

  public void setChargeTime(Timestamp chargeTime) {
    this.chargeTime = chargeTime;
  }

  public String getChargeDesc() {
    return this.chargeDesc;
  }

  public void setChargeDesc(String chargeDesc) {
    this.chargeDesc = chargeDesc;
  }

  public String getState() {
    return this.state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public Set getParkRecords() {
    return this.parkRecords;
  }

  public void setParkRecords(Set parkRecords) {
    this.parkRecords = parkRecords;
  }

}
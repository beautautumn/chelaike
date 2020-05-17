package com.ct.erp.lib.entity;

import javax.persistence.Transient;
import java.math.BigDecimal;
import java.util.Date;

/**
 * Created by x on 2017/9/8.
 */
public class CheckTask implements java.io.Serializable {
    private Long taskId;
    private String taskType;
    private String taskState;
    private String taskReportH5Url;
    private Date taskCreateTime;
    private Date taskModifyTime;
    private Long checkerId;
    private Long carId;
    private Trade trade;
    private String report_type;
    private String report_url;
    private String valuation;

    public String getReport_type() {
        return report_type;
    }

    public void setReport_type(String report_type) {
        this.report_type = report_type;
    }

    public String getReport_url() {
        return report_url;
    }

    public void setReport_url(String report_url) {
        this.report_url = report_url;
    }

    public String getValuation() {
        return valuation;
    }

    public void setValuation(String valuation) {
        this.valuation = valuation;
    }

    @Transient
    private Cars cars;
    private Staff createStaff;
    private Staff checkStaff;

    public Long getCheckerId() {
        return this.checkerId;
    }

    public void setCheckerId(Long checkerId) {
        this.checkerId = checkerId;
    }

    public Long getTaskId() {
        return taskId;
    }

    public void setTaskId(Long taskId) {
        this.taskId = taskId;
    }

    public String getTaskType() {
        return taskType;
    }

    public void setTaskType(String taskType) {
        this.taskType = taskType;
    }

    public String getTaskState() {
        return taskState;
    }

    public void setTaskState(String taskState) {
        this.taskState = taskState;
    }

    public String getTaskReportH5Url() {
        return taskReportH5Url;
    }

    public void setTaskReportH5Url(String taskReportH5Url) {
        this.taskReportH5Url = taskReportH5Url;
    }

    public Date getTaskCreateTime() {
        return taskCreateTime;
    }

    public void setTaskCreateTime(Date taskCreateTime) {
        this.taskCreateTime = taskCreateTime;
    }

    public Date getTaskModifyTime() {
        return taskModifyTime;
    }

    public void setTaskModifyTime(Date taskModifyTime) {
        this.taskModifyTime = taskModifyTime;
    }

    public Cars getCars() {
        return cars;
    }

    public void setCars(Cars cars) {
        this.cars = cars;
    }

    public Staff getCreateStaff() {
        return createStaff;
    }

    public void setCreateStaff(Staff createStaff) {
        this.createStaff = createStaff;
    }

    public Staff getCheckStaff() {
        return checkStaff;
    }

    public Long getCarId() {
        return carId;
    }

    public void setCarId(Long carId) {
        this.carId = carId;
    }

    public Trade getTrade() {
        return trade;
    }

    public void setTrade(Trade trade) {
        this.trade = trade;
    }

    public void setCheckStaff(Staff checkStaff) {
        this.checkStaff = checkStaff;
    }
}

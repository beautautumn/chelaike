package com.ct.erp.lib.entity;
import java.io.Serializable;
import java.sql.Timestamp;

public class Shops implements Serializable {
    private Long id;
    private String name;
    private Long company_id;
    private Timestamp created_at;
    private Timestamp updated_at;
    private Timestamp deleted_at;
    private String address;
    private String phone;
    private Long erp_agency_id;
    private String status;

    @Override
    public String toString() {
        return "Shops{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", company_id=" + company_id +
                ", created_at=" + created_at +
                ", updated_at=" + updated_at +
                ", deleted_at=" + deleted_at +
                ", address='" + address + '\'' +
                ", phone='" + phone + '\'' +
                ", erp_agency_id=" + erp_agency_id +
                ", status='" + status + '\'' +
                '}';
    }

    public Timestamp getDeleted_at() {
        return deleted_at;
    }
    public void setDeleted_at(Timestamp deleted_at) {
        this.deleted_at = deleted_at;
    }
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public Long getCompany_id() {
        return company_id;
    }
    public void setCompany_id(Long company_id) {
        this.company_id = company_id;
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
    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }
    public String getPhone() {
        return phone;
    }
    public void setPhone(String phone) {
        this.phone = phone;
    }
    public Long getErp_agency_id() {
        return erp_agency_id;
    }
    public void setErp_agency_id(Long erp_agency_id) {
        this.erp_agency_id = erp_agency_id;
    }
}

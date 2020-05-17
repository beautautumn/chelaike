package com.ct.erp.lib.entity;

import java.sql.Time;
import java.sql.Timestamp;

public class User implements java.io.Serializable {
    private Long id;
    private String name;
    private String username;
    private String password_digest;
    private String email;
    private String pass_reset_token;
    private String phone;
    private String state;
    private boolean is_alliance_contact;
    private Timestamp pass_reset_expired_at;
    private Timestamp last_sign_in_at;
    private Timestamp current_sign_in_at;
    private Integer company_id;
    private Integer shop_id;
    private Integer manager_id;
    private String note;
    private String authority_type;
    private String authorities;
    private Timestamp created_at;
    private Timestamp updated_at;
    private Timestamp deleted_at;
    private String avatar;
    private Object settings;
    private String mac_address;
    private String cross_shop_authorities;
    private String device_numbers;
    private Object client_info;
    private String first_letter;
    private String mobile_app_car_detail_menu;
    private String rc_token;
    private String  current_device_number;
    private String qrcode_url;
    private String  self_description;
    private String user_type;
    private Integer erp_staff_id;

    public User() {
    }

    public User(Long id, String name, String username, String password_digest, String email, String pass_reset_token, String phone, String state, boolean is_alliance_contact, Timestamp pass_reset_expired_at, Timestamp last_sign_in_at, Timestamp current_sign_in_at, Integer company_id, Integer shop_id, Integer manager_id, String note, String authority_type, String authorities, Timestamp created_at, Timestamp updated_at, Timestamp deleted_at, String avatar, Object settings, String mac_address, String cross_shop_authorities, String device_numbers, Object client_info, String first_letter, String mobile_app_car_detail_menu, String rc_token, String current_device_number, String qrcode_url, String self_description, String user_type, Integer erp_staff_id) {
        this.id = id;
        this.name = name;
        this.username = username;
        this.password_digest = password_digest;
        this.email = email;
        this.pass_reset_token = pass_reset_token;
        this.phone = phone;
        this.state = state;
        this.is_alliance_contact = is_alliance_contact;
        this.pass_reset_expired_at = pass_reset_expired_at;
        this.last_sign_in_at = last_sign_in_at;
        this.current_sign_in_at = current_sign_in_at;
        this.company_id = company_id;
        this.shop_id = shop_id;
        this.manager_id = manager_id;
        this.note = note;
        this.authority_type = authority_type;
        this.authorities = authorities;
        this.created_at = created_at;
        this.updated_at = updated_at;
        this.deleted_at = deleted_at;
        this.avatar = avatar;
        this.settings = settings;
        this.mac_address = mac_address;
        this.cross_shop_authorities = cross_shop_authorities;
        this.device_numbers = device_numbers;
        this.client_info = client_info;
        this.first_letter = first_letter;
        this.mobile_app_car_detail_menu = mobile_app_car_detail_menu;
        this.rc_token = rc_token;
        this.current_device_number = current_device_number;
        this.qrcode_url = qrcode_url;
        this.self_description = self_description;
        this.user_type = user_type;
        this.erp_staff_id = erp_staff_id;
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

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword_digest() {
        return password_digest;
    }

    public void setPassword_digest(String password_digest) {
        this.password_digest = password_digest;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPass_reset_token() {
        return pass_reset_token;
    }

    public void setPass_reset_token(String pass_reset_token) {
        this.pass_reset_token = pass_reset_token;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public boolean isIs_alliance_contact() {
        return is_alliance_contact;
    }

    public void setIs_alliance_contact(boolean is_alliance_contact) {
        this.is_alliance_contact = is_alliance_contact;
    }

    public Timestamp getPass_reset_expired_at() {
        return pass_reset_expired_at;
    }

    public void setPass_reset_expired_at(Timestamp pass_reset_expired_at) {
        this.pass_reset_expired_at = pass_reset_expired_at;
    }

    public Timestamp getLast_sign_in_at() {
        return last_sign_in_at;
    }

    public void setLast_sign_in_at(Timestamp last_sign_in_at) {
        this.last_sign_in_at = last_sign_in_at;
    }

    public Timestamp getCurrent_sign_in_at() {
        return current_sign_in_at;
    }

    public void setCurrent_sign_in_at(Timestamp current_sign_in_at) {
        this.current_sign_in_at = current_sign_in_at;
    }

    public Integer getCompany_id() {
        return company_id;
    }

    public void setCompany_id(Integer company_id) {
        this.company_id = company_id;
    }

    public Integer getShop_id() {
        return shop_id;
    }

    public void setShop_id(Integer shop_id) {
        this.shop_id = shop_id;
    }

    public Integer getManager_id() {
        return manager_id;
    }

    public void setManager_id(Integer manager_id) {
        this.manager_id = manager_id;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getAuthority_type() {
        return authority_type;
    }

    public void setAuthority_type(String authority_type) {
        this.authority_type = authority_type;
    }

    public String getAuthorities() {
        return authorities;
    }

    public void setAuthorities(String authorities) {
        this.authorities = authorities;
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

    public Timestamp getDeleted_at() {
        return deleted_at;
    }

    public void setDeleted_at(Timestamp deleted_at) {
        this.deleted_at = deleted_at;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public Object getSettings() {
        return settings;
    }

    public void setSettings(Object settings) {
        this.settings = settings;
    }

    public String getMac_address() {
        return mac_address;
    }

    public void setMac_address(String mac_address) {
        this.mac_address = mac_address;
    }

    public String getCross_shop_authorities() {
        return cross_shop_authorities;
    }

    public void setCross_shop_authorities(String cross_shop_authorities) {
        this.cross_shop_authorities = cross_shop_authorities;
    }

    public String getDevice_numbers() {
        return device_numbers;
    }

    public void setDevice_numbers(String device_numbers) {
        this.device_numbers = device_numbers;
    }

    public Object getClient_info() {
        return client_info;
    }

    public void setClient_info(Object client_info) {
        this.client_info = client_info;
    }

    public String getFirst_letter() {
        return first_letter;
    }

    public void setFirst_letter(String first_letter) {
        this.first_letter = first_letter;
    }

    public String getMobile_app_car_detail_menu() {
        return mobile_app_car_detail_menu;
    }

    public void setMobile_app_car_detail_menu(String mobile_app_car_detail_menu) {
        this.mobile_app_car_detail_menu = mobile_app_car_detail_menu;
    }

    public String getRc_token() {
        return rc_token;
    }

    public void setRc_token(String rc_token) {
        this.rc_token = rc_token;
    }

    public String getCurrent_device_number() {
        return current_device_number;
    }

    public void setCurrent_device_number(String current_device_number) {
        this.current_device_number = current_device_number;
    }

    public String getQrcode_url() {
        return qrcode_url;
    }

    public void setQrcode_url(String qrcode_url) {
        this.qrcode_url = qrcode_url;
    }

    public String getSelf_description() {
        return self_description;
    }

    public void setSelf_description(String self_description) {
        this.self_description = self_description;
    }

    public String getUser_type() {
        return user_type;
    }

    public void setUser_type(String user_type) {
        this.user_type = user_type;
    }

    public Integer getErp_staff_id() {
        return erp_staff_id;
    }

    public void setErp_staff_id(Integer erp_staff_id) {
        this.erp_staff_id = erp_staff_id;
    }
}



package com.tianche.domain;

import java.util.ArrayList;
import java.util.List;

public class MenuItemErp {
    private Integer id;
    private Boolean isLeaf=true;
    private String name="";
    private String url="";
    private String icon="";
    private List<MenuItemErp> leavies;

    public MenuItemErp() {
        leavies = new ArrayList<MenuItemErp>();
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Boolean getIsLeaf() {
        return isLeaf;
    }

    public void setIsLeaf(Boolean leaf) {
        isLeaf = leaf;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public List<MenuItemErp> getLeavies() {
        return leavies;
    }

    public void setLeavies(List<MenuItemErp> leavies) {
        this.leavies = leavies;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }
}

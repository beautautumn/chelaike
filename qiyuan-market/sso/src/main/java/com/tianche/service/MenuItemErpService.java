package com.tianche.service;

import com.tianche.domain.MenuItemErp;

import java.util.List;

public interface MenuItemErpService {
    List<MenuItemErp> listItemByStaffId(Long id);
}

package com.tianche.service.impl;

import com.tianche.dao.LogDao;
import com.tianche.dao.MenuItemErpDao;
import com.tianche.domain.MenuItemErp;
import com.tianche.service.MenuItemErpService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
@Service
public class MenuItemErpServiceImpl implements MenuItemErpService {
    @Resource
    private MenuItemErpDao menuItemErpDao;
    @Override
    public List<MenuItemErp> listItemByStaffId(Long id) {
        return menuItemErpDao.findByStaffId(id);
    }
}

package com.ct.erp.parkingcard.web;

import com.alibaba.fastjson.JSON;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.ParkingCards;
import com.ct.erp.lib.entity.Shops;
import com.ct.erp.lib.entity.User;
import com.ct.erp.parkingcard.dao.ParkingCardsDao;
import com.ct.erp.shops.dao.ShopsDao;
import com.ct.erp.sys.dao.UserDao;
import com.ct.erp.util.UcmsWebUtils;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.util.ValueStack;
import org.apache.struts2.ServletActionContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import javax.json.JsonObject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Timestamp;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import static com.ct.erp.shops.dao.ShopsDao.*;


@SuppressWarnings("serial")
@Scope("prototype")
@Controller("erp.parkingCardAction")
public class parkingCardAction extends SimpleActionSupport {
      private static final Logger logger = (Logger) LoggerFactory.getLogger(parkingCardAction.class);
      private Shops shops;
      @Autowired
      private ShopsDao shopsDao;
      List<Shops> shopsList = new LinkedList<>();

      private User users;
      @Autowired
      private UserDao usersDao;
      List<User> usersList = new LinkedList<>();

      private ParkingCards parkingCard;
      @Autowired
      private ParkingCardsDao parkingCardsDao;

    public List<User> getUsersList() {
        return usersList;
    }
    public void setUsersList(List<User> usersList) {
        this.usersList = usersList;
    }

    public List<Shops> getShopsList() {
        return shopsList;
    }
    public void setShopsList(List<Shops> shopsList) {
        this.shopsList = shopsList;
    }

    /*
    * 转发到新建停车卡jsp
    * */
    public String toCreate() {
        shopsList = shopsDao.findAll();
        usersList = usersDao.findAll();
        ValueStack stack = ActionContext.getContext().getValueStack();
        stack.set("shopsList",shopsList);
        stack.set("usersList",usersList);
        return "toCreate";
    }
    /*
     * 新建一条停车卡信息
     * */
    public void create() {
        HttpServletResponse response = ServletActionContext.getResponse();
        try {
            parkingCard.setCreated_at(new Timestamp(System.currentTimeMillis()));
            parkingCard.setUpdated_at(new Timestamp(System.currentTimeMillis()));
            parkingCard.setState("enable");
            parkingCardsDao.save(parkingCard);
            UcmsWebUtils.ajaxOutPut(response,"success");
        }catch (Exception e) {
            e.printStackTrace();
            UcmsWebUtils.ajaxOutPut(response,"false");
        }
    }

    /*
     * 转发到修改jsp
     * */
    public String toEdit(){
        parkingCard = parkingCardsDao.get(id);
        shopsList = shopsDao.findAll();
        usersList = usersDao.findAll();
        ValueStack stack = ActionContext.getContext().getValueStack();
        stack.set("shopsList",shopsList);
        stack.set("usersList",usersList);
        return "toEdit";
    }

    /*
     * 修改停车卡信息
     * */
    public void edit(){
        HttpServletResponse response = ServletActionContext.getResponse();
        SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
        try {
            Long parkingcardId = parkingCard.getId();
            ParkingCards parkingCardsUpdates = parkingCardsDao.load(parkingcardId);
            System.out.println(parkingCardsUpdates.toString());
            parkingCardsUpdates.setNote(parkingCard.getNote());
            parkingCardsUpdates.setShop_id(parkingCard.getShop_id());
            parkingCardsUpdates.setOperator_id(parkingCard.getOperator_id());
            parkingCardsUpdates.setNo(parkingCard.getNo());
            parkingCardsUpdates.setUpdated_at(new Timestamp(System.currentTimeMillis()));
            parkingCardsDao.getSession().flush();
            UcmsWebUtils.ajaxOutPut(response, "success");
        }catch (Exception e){
            e.printStackTrace();
            UcmsWebUtils.ajaxOutPut(response,"false");
        }
    }
    /*
    * 转发停/启用jsp界面
    * */
    public String changeState(){
            parkingCard=parkingCardsDao.get(id);
            ValueStack stack = ActionContext.getContext().getValueStack();
            if(parkingCard.getShop_id() == null){
                shops = new Shops();
                shops.setId(null);
            }else{
                shops = shopsDao.get(parkingCard.getShop_id());
            }
             stack.set("shops",shops);
             //ParkingCards parkingCardsUpdate = parkingCardsDao.get(id);
            if(parkingCard.getState().equals("enable")){
                return "disable";
            }else if(parkingCard.getState().equals("disable")){
                return "enable";
            } else return "";
    }

    /*
     * 修改停/启用状态
     */
    public void editState(){
        HttpServletResponse response = ServletActionContext.getResponse();
        SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
        try{
            Long nowid = parkingCard.getId();
            ParkingCards parkingCardsUpdate = parkingCardsDao.load(nowid);
            if(parkingCardsUpdate.getState().equals("enable")){
                parkingCardsUpdate.setState("disable");
                parkingCardsUpdate.setUpdated_at(new Timestamp(System.currentTimeMillis()));
                parkingCardsDao.getSession().flush();
                UcmsWebUtils.ajaxOutPut(response,"success");
             }else if(parkingCardsUpdate.getState().equals("disable")) {
                parkingCardsUpdate.setState("enable");
                parkingCardsUpdate.setUpdated_at(new Timestamp(System.currentTimeMillis()));
                parkingCardsDao.getSession().flush();
                UcmsWebUtils.ajaxOutPut(response, "success");
            } else  UcmsWebUtils.ajaxOutPut(response, "false");
        }catch (Exception e){
            e.printStackTrace();
            UcmsWebUtils.ajaxOutPut(response, "false");
        }
    }

    /*
    * 车商输入框模糊查询匹配
    * */
    public void inputSelectByShopsName(){
        shopsList = shopsDao.findAll();
        String jsonStr = JSON.toJSONString(shopsList);
        HttpServletResponse response = ServletActionContext.getResponse();
        UcmsWebUtils.ajaxOutPut(response, jsonStr);
    }
/*
* 操作人输入框模糊查询匹配
* */
    public void inputSelectByUsersName(){
        usersList = usersDao.findAll();
        String jsonStr = JSON.toJSONString(usersList);
        HttpServletResponse response = ServletActionContext.getResponse();
        UcmsWebUtils.ajaxOutPut(response,jsonStr);
    }
/*
* 验证卡号是否有重复
* */
    public void checkNo(){
        HttpServletRequest request = ServletActionContext.getRequest();
        HttpServletResponse response = ServletActionContext.getResponse();
        Boolean result = parkingCardsDao.checkNo(request.getParameter("nos"));
        if(result){
            UcmsWebUtils.ajaxOutPut(response,"success");
        }else{
            UcmsWebUtils.ajaxOutPut(response,"false");
        }
    }
    public void setParkingCard(ParkingCards parkingCard) {
        this.parkingCard = parkingCard;
    }
    public ParkingCards getParkingCard() {
        return parkingCard;
    }
}
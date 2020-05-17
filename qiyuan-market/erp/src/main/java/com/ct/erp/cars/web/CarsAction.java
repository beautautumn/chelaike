package com.ct.erp.cars.web;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.aliyun.oss.common.utils.DateUtil;
import com.ct.erp.Authorization.dao.AuthorizationDao;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.*;
import com.ct.erp.market.dao.MarketDao;
import com.ct.erp.market.service.MarketService;
import com.ct.erp.market.service.ServiceResult;
import com.ct.erp.sys.dao.StaffDao;
import com.ct.erp.sys.dao.UserDao;
import com.ct.erp.util.DataSync;
import com.ct.erp.util.UIDGenerator;
import com.ct.erp.util.UcmsWebUtils;
import com.qiyuan.dao.CarsDao;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.TimeZone;

@SuppressWarnings("serial")
@Scope("prototype")
@Controller("qiyuan.carsAction")
public class CarsAction extends SimpleActionSupport{

    private Long carId;
    private Authorization authorization;
    private List<User> userList;

    public List<User> getUserList() {
        return userList;
    }

    public void setUserList(List<User> userList) {
        this.userList = userList;
    }

    @Autowired
    private CarsDao carsDao;
    @Autowired
    private DataSync dataSync;
    @Autowired
    private UserDao userDao;
    @Autowired
    private AuthorizationDao authorizationDao;

    public Long getCarId() {
        return carId;
    }

    public void setCarId(Long carId) {
        this.carId = carId;
    }

    public Authorization getAuthorization() { return authorization; }

    public void setAuthorization(Authorization authorization) { this.authorization = authorization; }


    public String toTakedown(){
        return "toTakedown";
    }

    public String toSpecAuth() {

        HttpServletRequest request=ServletActionContext.getRequest();
        HttpSession session =request.getSession();
        session.setAttribute("carId",carId);


        userList=userDao.findAll();
        
        return "toSpecAuth";
    }

    /**
     * 下架
     */
    public void takedown(){
        SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
        Long staffId = sessionInfo.getStaffId();
        int cnt = carsDao.updateCarsState(carId, "offline_show", new String[]{"online_show"},staffId);
        dataSync.publishTradeToRuby(carId.toString());
        HttpServletResponse response = ServletActionContext.getResponse();
        JSONObject result = new JSONObject();
        if(cnt > 0) {
            result.put("success", true);
            result.put("message", "下架成功");
        }else{
            result.put("success", false);
            result.put("message", "只有已上架的车辆才能下架");
        }
        UcmsWebUtils.ajaxOutPut(response, JSON.toJSONString(result));
    }

    public String toPutaway(){
        return "toPutaway";
    }

    /**
     * 上架
     */
    public void putaway(){
        SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
        Long staffId = sessionInfo.getStaffId();
        int cnt = carsDao.updateCarsState(carId, "online_show_preview", null, staffId);
        dataSync.publishTradeToRuby(carId.toString());
        HttpServletResponse response = ServletActionContext.getResponse();
        JSONObject result = new JSONObject();
        if(cnt > 0) {
            result.put("success", true);
            result.put("message", "上架成功");
        }else{
            result.put("success", false);
            result.put("message", "只有未上架的车辆才能上架");
        }
        UcmsWebUtils.ajaxOutPut(response, JSON.toJSONString(result));
    }

    public String toDelete(){
        return "toDelete";
    }

    /**
     * 删除
     */
    public void delete(){
        SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
        Long staffId = sessionInfo.getStaffId();
        int cnt = carsDao.updateCarsState(carId, "deleted", null, staffId);
        dataSync.publishTradeToRuby(carId.toString());
        HttpServletResponse response = ServletActionContext.getResponse();
        JSONObject result = new JSONObject();
        if(cnt > 0) {
            result.put("success", true);
            result.put("message", "删除成功");
        }else{
            result.put("success", false);
            result.put("message", "只有未删除的车辆才能删除");
        }
        UcmsWebUtils.ajaxOutPut(response, JSON.toJSONString(result));
    }

    public String toAuthIn(){
        return "toAuthIn";
    }

    /**
     * 入库审核-通过
     */
    public void authInPass(){
        SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
        Long staffId = sessionInfo.getStaffId();
        Calendar calendar = Calendar.getInstance(TimeZone.getTimeZone("UTC"));
        int cnt = carsDao.updateCarsStateIn(carId, "in_hall", new String[]{"in_hall_preview","in_hall_refused"}, calendar.getTime(), staffId);
        dataSync.publishTradeToRuby(carId.toString());
        HttpServletResponse response = ServletActionContext.getResponse();
        JSONObject result = new JSONObject();
        if(cnt > 0) {
            result.put("success", true);
            result.put("message", "入库审核通过");
        }else{
            result.put("success", false);
            result.put("message", "只有入库待审核或审核被拒的记录才能进行入库审核");
        }
        UcmsWebUtils.ajaxOutPut(response, JSON.toJSONString(result));
    }

    /**
     * 入库审核-未通过
     */
    public void authInReject(){
        SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
        Long staffId = sessionInfo.getStaffId();
        int cnt = carsDao.updateCarsState(carId, "in_hall_refused", new String[]{"in_hall_preview","in_hall_refused"}, staffId);
        dataSync.publishTradeToRuby(carId.toString());
        HttpServletResponse response = ServletActionContext.getResponse();
        JSONObject result = new JSONObject();
        if(cnt > 0) {
            result.put("success", true);
            result.put("message", "入库审核驳回成功");
        }else{
            result.put("success", false);
            result.put("message", "只有入库待审核或审核被拒的记录才能进行入库审核");
        }
        UcmsWebUtils.ajaxOutPut(response, JSON.toJSONString(result));
    }

    public String toPutawayAuth(){
        return "toPutawayAuth";
    }

    /**
     * 上架审核-通过
     */
    public void putawayAuthPass(){
        SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
        Long staffId = sessionInfo.getStaffId();
        int cnt = carsDao.updateCarsState(carId, "online_show", new String[]{"online_show_preview","online_show_refused"}, staffId);
        dataSync.publishTradeToRuby(carId.toString());
        HttpServletResponse response = ServletActionContext.getResponse();
        JSONObject result = new JSONObject();
        if(cnt > 0) {
            result.put("success", true);
            result.put("message", "上架审核通过");
        }else{
            result.put("success", false);
            result.put("message", "只有上架待审核或审核被拒的记录才能进行上架审核");
        }
        UcmsWebUtils.ajaxOutPut(response, JSON.toJSONString(result));
       /* Cars cars = carsDao.load(carId);
        String carState = cars.getState();
        if(carState == null ||carState.indexOf("#online_show_preview#online_show_refused#")<0){
            //TODO 只有上架待审核或审核被拒的记录才能进行审核
        }
        cars.setState("online_show");
        carsDao.getSession().flush();*/
    }
    /**
     * 上架审核-拒绝
     */
    public void putawayAuthReject(){
        SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
        Long staffId = sessionInfo.getStaffId();
        int cnt = carsDao.updateCarsState(carId, "online_show_refused", new String[]{"online_show_preview","online_show_refused"}, staffId);
        dataSync.publishTradeToRuby(carId.toString());
        HttpServletResponse response = ServletActionContext.getResponse();
        JSONObject result = new JSONObject();
        if(cnt > 0) {
            result.put("success", true);
            result.put("message", "上架审核驳回成功");
        }else{
            result.put("success", false);
            result.put("message", "只有上架待审核或审核被拒的记录才能进行上架审核");
        }
        UcmsWebUtils.ajaxOutPut(response, JSON.toJSONString(result));
    }

    public String toFirstCheckAuth(){
        return "toFirstCheckAuth";
    }
    public void firstCheckAuthPass(){
        SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
        Long staffId = sessionInfo.getStaffId();
        int cnt = carsDao.updateCheckState(carId, "verified", new String[]{"first_reported"}, staffId);
//        dataSync.publishTradeToRuby(carId.toString());
        HttpServletResponse response = ServletActionContext.getResponse();
        JSONObject result = new JSONObject();
        if(cnt > 0) {
            result.put("success", true);
            result.put("message", "认证审核通过");
        }else{
            result.put("success", false);
            result.put("message", "只有完成初检的记录才能进行初检审核");
        }
        UcmsWebUtils.ajaxOutPut(response, JSON.toJSONString(result));
    }
    public void firstCheckAuthReject(){
        SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
        Long staffId = sessionInfo.getStaffId();
        int cnt = carsDao.updateCheckState(carId, "unverified", new String[]{"first_reported"}, staffId);
//        dataSync.publishTradeToRuby(carId.toString());
        HttpServletResponse response = ServletActionContext.getResponse();
        JSONObject result = new JSONObject();
        if(cnt > 0) {
            result.put("success", true);
            result.put("message", "认证审核驳回成功");
        }else{
            result.put("success", false);
            result.put("message", "只有完成初检的记录才能进行初检审核");
        }
        UcmsWebUtils.ajaxOutPut(response, JSON.toJSONString(result));
    }
    //特殊授权
    public String speciallyAuthorize(){
        HttpServletRequest request=ServletActionContext.getRequest();
        HttpSession session =request.getSession();
        HttpServletResponse response = ServletActionContext.getResponse();
        SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
         this.carId=(Long)session.getAttribute("carId");

            try {
                Authorization authorization=new Authorization();
                authorization.setCarId(carId);
                authorization.setGrantorId(Long.parseLong(request.getParameter("grantor_id")));
                authorization.setNote(request.getParameter("note"));
                authorization.setOperatorId(sessionInfo.getStaffId());
                authorization.setCreatedAt(new Timestamp(System.currentTimeMillis()));
                authorization.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
                authorization.setState("enabled");
                authorizationDao.save(authorization);

                authorizationDao.getSession().flush();

                UcmsWebUtils.ajaxOutPut(response, "success");
            } catch (Exception e) {
                e.printStackTrace();
                UcmsWebUtils.ajaxOutPut(response, "false");
            }


        return null;
    }


}

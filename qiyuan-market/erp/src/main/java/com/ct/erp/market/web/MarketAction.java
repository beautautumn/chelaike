package com.ct.erp.market.web;

import com.alibaba.fastjson.JSON;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.Market;
import com.ct.erp.market.dao.MarketDao;
import com.ct.erp.market.service.MarketService;
import com.ct.erp.market.service.ServiceResult;
import com.ct.erp.sys.dao.StaffDao;
import com.ct.erp.util.DataSync;
import com.ct.erp.util.UIDGenerator;
import com.ct.erp.util.UcmsWebUtils;
import org.apache.commons.codec.binary.Hex;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import javax.servlet.http.HttpServletResponse;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@SuppressWarnings("serial")
@Scope("prototype")
@Controller("erp.marketAction")
public class MarketAction extends SimpleActionSupport{
    private String uid;
    private Market market;
    private Long marketId;
    private String marketLinkmanName;
    private String marketLinkmanMobile;
    private String marketName;
    @Autowired
    private MarketDao marketDao;
    @Autowired
    private StaffDao staffDao;
    @Autowired
    private MarketService marketService;

    @Autowired
    private DataSync dataSync;
    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public Market getMarket() {
        return market;
    }

    public void setMarket(Market market) {
        this.market = market;
    }

    public Long getMarketId() {
        return marketId;
    }

    public void setMarketId(Long marketId) {
        this.marketId = marketId;
    }

    public String getMarketLinkmanName() {
        return marketLinkmanName;
    }

    public void setMarketLinkmanName(String marketLinkmanName) {
        this.marketLinkmanName = marketLinkmanName;
    }

    public String getMarketLinkmanMobile() {
        return marketLinkmanMobile;
    }

    public void setMarketLinkmanMobile(String marketLinkmanMobile) {
        this.marketLinkmanMobile = marketLinkmanMobile;
    }

    public String getMarketName() {
        return marketName;
    }

    public void setMarketName(String marketName) {
        this.marketName = marketName;
    }

    public String toMarketInput(){
        this.uid = UIDGenerator.getUid(9);
        return "create";
    }
    public void create(){
        HttpServletResponse response = ServletActionContext.getResponse();
        SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
        market.setStaffId(sessionInfo.getStaffId());
        market.setMarketStatus("normal");
        ServiceResult result = marketService.createMarket(market);
        if(result.getSuccess()) {
            dataSync.publishMarketToRuby(market.getMarketId().toString());
        }
        UcmsWebUtils.ajaxOutPut(response, JSON.toJSONString(result));
        //FIXME 需要調用ruby的sdk
    }
    public String toEdit(){
        market = marketDao.get(marketId);
        return "edit";
    }
    public void doManage(){
        Long marketId = market.getMarketId();
        Market marketToUpdate = marketDao.load(marketId);
        marketToUpdate.setMarketArea(market.getMarketArea());
        marketToUpdate.setMarketContractBeginDate(market.getMarketContractBeginDate());
        marketToUpdate.setMarketContractEndDate(market.getMarketContractEndDate());
        marketToUpdate.setMarketLegalMobile(market.getMarketLegalMobile());
        marketToUpdate.setMarketLegalName(market.getMarketLegalName());
        marketToUpdate.setMarketLinkmanCode(market.getMarketLinkmanCode());
        marketToUpdate.setMarketLinkmanMobile(market.getMarketLinkmanMobile());
        marketToUpdate.setMarketLinkmanName(market.getMarketLinkmanName());
        marketToUpdate.setMarketMobile(market.getMarketMobile());
        marketToUpdate.setMarketName(market.getMarketName());
        marketDao.getSession().flush();
        dataSync.publishMarketToRuby(market.getMarketId().toString());
        HttpServletResponse response = ServletActionContext.getResponse();
        UcmsWebUtils.ajaxOutPut(response, "success");
    }
    public String toFrozen(){
        return "frozen";
    }
    public String toUnFrozen(){
        return "unfrozen";
    }
    public String toCancel(){
        return "cancel";
    }
    public void doFrozenAct(){
        marketService.doFrozen(marketId);
        dataSync.publishMarketToRuby(marketId.toString());
        HttpServletResponse response = ServletActionContext.getResponse();
        UcmsWebUtils.ajaxOutPut(response, "success");
    }
    public void doUnFrozenAct(){
        marketService.doUnFrozen(marketId);
        dataSync.publishMarketToRuby(marketId.toString());
        HttpServletResponse response = ServletActionContext.getResponse();
        UcmsWebUtils.ajaxOutPut(response, "success");
    }
    public void doCancelAct(){
        marketService.doCancel(marketId);
        dataSync.publishMarketToRuby(marketId.toString());
        HttpServletResponse response = ServletActionContext.getResponse();
        UcmsWebUtils.ajaxOutPut(response, "success");
    }
    public static void main(String[] args) throws NoSuchAlgorithmException {
        MessageDigest md5= MessageDigest.getInstance("MD5");
        System.out.println(Hex.encodeHexString(md5.digest(("12345678"+"12345678").getBytes())));
    }
}

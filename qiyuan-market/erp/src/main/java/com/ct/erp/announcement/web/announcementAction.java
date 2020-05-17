package com.ct.erp.announcement.web;

import com.ct.erp.announcement.dao.AnnouncementDao;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.lib.entity.Announcement;
import com.ct.erp.lib.entity.Market;
import com.ct.erp.market.service.MarketService;
import com.ct.erp.util.DataSync;
import com.ct.erp.util.UcmsWebUtils;
import org.apache.struts2.ServletActionContext;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.core.security.SecurityUtils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import javax.servlet.http.HttpServletResponse;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;


@SuppressWarnings("serial")
@Scope("prototype")
@Controller("qiyuan.announcementAction")
public class announcementAction extends SimpleActionSupport {

    @Autowired
    private AnnouncementDao announcementDao;

    private Announcement announcement;
    private String announcementId;

    private List<Market> markets= new ArrayList<Market>();
    @Autowired
    private MarketService marketService;
    @Autowired
    private DataSync dataSync;

    public List<Market> getMarkets() {
        return markets;
    }

    public void setMarkets(List<Market> markets) {
        this.markets = markets;
    }

    public Announcement getAnnouncement() {
        return announcement;
    }

    public void setAnnouncement(Announcement announcement) {
        this.announcement = announcement;
    }

    public String getAnnouncementId() {
        return announcementId;
    }

    public void setAnnouncementId(String announcementId) {
        this.announcementId = announcementId;
    }

    public String toEdit(){
        this.setMarkets(marketService.findValidMarketList());
        return "toEdit";
    }

    public String toRevoke(){
        return "toRevoke";
    }

    public void create() {
        SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
        String userType = sessionInfo.getUserType();
        Boolean isPlatform = (userType!= null && userType.equals("platform")); //是否平台用户
        Boolean canCrossCompany =  isPlatform && (sessionInfo.getMarketId() == null); //平台用户是否允许跨市场发布
        Long curMarketId = sessionInfo.getMarketId() ;

        if (isPlatform) { //如果是平台发布公告
            if (canCrossCompany) {  //如果允许选择跨市场发布
                if (announcement.getMarketId() == -1) {  //如果选择的是全部市场，则设置发布公司范围为 null（表示发给所有市场）
                    announcement.setCompanyId(null);
                }
                else {  //否则，将指定市场的marketId 转换为 companyId （表示发布给指定的市场）
                    announcement.setCompanyId(marketService.convertMarketId2CompanyId(announcement.getMarketId()));
                }
            }
            else {  //如果不允许跨市场发布 ，只允许发布给当前登录员工所在的市场
                announcement.setCompanyId(marketService.convertMarketId2CompanyId(curMarketId));
            }
        }
        else { //否则就是市场发布公告，只能发布给登录员工所在的市场
            announcement.setAnnouncementType("market");
            announcement.setCompanyId(marketService.convertMarketId2CompanyId(curMarketId));
        }

        //设置公告的其它相关字段属性，并保存到数据库
        announcement.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        announcement.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
        announcement.setState(true);
        announcement.setTop(announcement.getTop()!=null);
        announcement.setSender(userType);
        announcementDao.save(announcement);

        //通知ruby去向用户推送消息提示
        dataSync.publishToRuby("announcement_sync", announcement.getId().toString());

        //返回成功信息给前端
        HttpServletResponse response = ServletActionContext.getResponse();
        UcmsWebUtils.ajaxOutPut(response, "success");
    }

    public void revoke() {
        Announcement announcement = announcementDao.get(new Long(announcementId));
        announcement.setState(false);
        announcementDao.save(announcement);
        announcementDao.getSession().flush();
        HttpServletResponse response = ServletActionContext.getResponse();
        UcmsWebUtils.ajaxOutPut(response, "success");
    }

}

package com.ct.erp.sys.web;

import com.ct.erp.announcement.dao.AnnouncementDao;
import com.ct.erp.carin.dao.TradeDao;
import com.ct.erp.common.model.Result;
import com.ct.erp.common.model.TreeNode;
import com.ct.erp.common.utils.Struts2Utils;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.core.model.ComboboxDataBean;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.*;
import com.ct.erp.market.service.MarketService;
import com.ct.erp.sys.model.StatusState;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.sys.service.base.SysrightService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import javax.persistence.criteria.CriteriaBuilder;
import java.util.*;

@SuppressWarnings("serial")
@Scope("prototype")
@Controller("sys.homeAction")
public class HomeAction extends SimpleActionSupport {
	private static final long serialVersionUID = 3955786343333698369L;

	@Autowired
	private StaffService staffService;

	@Autowired
	private MarketService marketService;

	@Autowired
	private AnnouncementDao announcementDao;

	@Autowired
	private TradeDao tradeDao;

	private Long marketId;
	private Long todayTradeCount;
	private Long monthTradeCount;
	private Long todayInStockCount;
	private Long monthInStockCount;
	private Long waitingFirstCheckCount;
	private Long waitingSecondCheckCount;
	private List<Announcement> latestAnnouncements;

	public String home() {
		SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
		Staff staff = staffService.findStaffById(sessionInfo.getStaffId());
		//marketId = staff.getMarket().getMarketId();
		marketId = sessionInfo.getMarketId();

		HashMap<String, Long> result = tradeDao.getStatisticsByMarketId(marketId);
		todayTradeCount = result.get("todayTradeCount");
		monthTradeCount = result.get("monthTradeCount");
		todayInStockCount = result.get("todayInStockCount");
		monthInStockCount = result.get("monthInStockCount");
		waitingFirstCheckCount = result.get("waitingFirstCheckCount");
		waitingSecondCheckCount = result.get("waitingSecondCheckCount");
		if (marketId != null) {
			latestAnnouncements = announcementDao.getLatestAnnouncements(marketId);
		}
		return "home";
	}

	public Long getMarketId() {
		return marketId;
	}

	public void setMarketId(Long marketId) {
		this.marketId = marketId;
	}

	public Long getTodayTradeCount() {
		return todayTradeCount;
	}

	public void setTodayTradeCount(Long todayTradeCount) {
		this.todayTradeCount = todayTradeCount;
	}

	public Long getMonthTradeCount() {
		return monthTradeCount;
	}

	public void setMonthTradeCount(Long monthTradeCount) {
		this.monthTradeCount = monthTradeCount;
	}

	public Long getTodayInStockCount() {
		return todayInStockCount;
	}

	public void setTodayInStockCount(Long todayInStockCount) {
		this.todayInStockCount = todayInStockCount;
	}

	public Long getMonthInStockCount() {
		return monthInStockCount;
	}

	public void setMonthInStockCount(Long monthInStockCount) {
		this.monthInStockCount = monthInStockCount;
	}

	public Long getWaitingFirstCheckCount() {
		return waitingFirstCheckCount;
	}

	public void setWaitingFirstCheckCount(Long waitingFirstCheckCount) {
		this.waitingFirstCheckCount = waitingFirstCheckCount;
	}

	public Long getWaitingSecondCheckCount() {
		return waitingSecondCheckCount;
	}

	public void setWaitingSecondCheckCount(Long waitingSecondCheckCount) {
		this.waitingSecondCheckCount = waitingSecondCheckCount;
	}

	public List<Announcement> getLatestAnnouncements() {
		return latestAnnouncements;
	}

	public void setLatestAnnouncements(List<Announcement> latestAnnouncements) {
		this.latestAnnouncements = latestAnnouncements;
	}
}
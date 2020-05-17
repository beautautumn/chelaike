package com.ct.erp.carin.dao;

import java.math.BigInteger;
import java.util.HashMap;
import java.util.List;
import java.util.Date;
import java.util.Calendar;
import java.util.GregorianCalendar;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.Trade;
import com.ct.erp.lib.entity.VehicleSync;

@Repository
public class TradeDao extends BaseDaoImpl<Trade> {

	public HashMap<String, Long> getStatisticsByMarketId(Long id) {
		HashMap<String, Long> ret = new HashMap<>();

		String tradeSaleHql = "select count(*) from Trade t where t.state = 'stocked_out' and goDate between :begin and :end";
		if (id != null) tradeSaleHql += (" and t.agency.market.id =" + id);

		Query query = this.getSession().createQuery(tradeSaleHql);
		query.setTimestamp("begin", getBeginOfToday());
		query.setTimestamp("end", getEndOfToday());
		ret.put("todayTradeCount", (Long)query.uniqueResult());

		query = this.getSession().createQuery(tradeSaleHql);
		query.setTimestamp("begin", getBeginOfMonth());
		query.setTimestamp("end", getEndOfMonth());
		ret.put("monthTradeCount", (Long)query.uniqueResult());



		if (id != null) {
			// 市场
			String firstCheckSql = "select count(*) from CheckTask t where t.taskType = 'acquisition_check' and t.taskState = 'init' and t.trade.agency.market.id = :market_id";
			query = this.getSession().createQuery(firstCheckSql);
			query.setLong("market_id", id);
			ret.put("waitingFirstCheckCount", (Long)query.uniqueResult());

			String secondCheckSql = "select count(*) from CheckTask t where t.taskType = 'sold_check' and t.taskState = 'init' and t.trade.agency.market.id = :market_id";
			query = this.getSession().createQuery(secondCheckSql);
			query.setLong("market_id", id);
			ret.put("waitingSecondCheckCount", (Long)query.uniqueResult());
		} else {
			// 总公司
			String tradeInStockHql = "select count(*) from Trade t where t.state not in ('draft', 'in_hall_preview', 'in_hall_refused') and t.comeDate between :begin and :end";

			query = this.getSession().createQuery(tradeInStockHql);
			query.setTimestamp("begin", getBeginOfToday());
			query.setTimestamp("end", getEndOfToday());
			ret.put("todayInStockCount", (Long)query.uniqueResult());

			query = this.getSession().createQuery(tradeInStockHql);
			query.setTimestamp("begin", getBeginOfMonth());
			query.setTimestamp("end", getEndOfMonth());
			ret.put("monthInStockCount", (Long)query.uniqueResult());
		}

		return ret;
	}

	private Date getBeginOfToday() {
		Calendar calendar = getCalendarForNow();
		setTimeToBeginningOfDay(calendar);
		return calendar.getTime();
	}

	private Date getEndOfToday() {
		Calendar calendar = getCalendarForNow();
		setTimeToEndofDay(calendar);
		return calendar.getTime();
	}

	private Date getBeginOfMonth() {
		Calendar calendar = getCalendarForNow();
		calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMinimum(Calendar.DAY_OF_MONTH));
		setTimeToBeginningOfDay(calendar);
		return calendar.getTime();
	}

	private Date getEndOfMonth() {
		Calendar calendar = getCalendarForNow();
		calendar.set(Calendar.DAY_OF_MONTH,
				calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
		setTimeToEndofDay(calendar);
		return calendar.getTime();
	}

	private Calendar getCalendarForNow() {
		Calendar calendar = GregorianCalendar.getInstance();
		calendar.setTime(new Date());
		return calendar;
	}

	private void setTimeToBeginningOfDay(Calendar calendar) {
		calendar.set(Calendar.HOUR_OF_DAY, 0);
		calendar.set(Calendar.MINUTE, 0);
		calendar.set(Calendar.SECOND, 0);
		calendar.set(Calendar.MILLISECOND, 0);
	}

	private void setTimeToEndofDay(Calendar calendar) {
		calendar.set(Calendar.HOUR_OF_DAY, 23);
		calendar.set(Calendar.MINUTE, 59);
		calendar.set(Calendar.SECOND, 59);
		calendar.set(Calendar.MILLISECOND, 999);
	}

	public List<Trade> getTradeListByAgencyId(Long agencyId)throws Exception{
		String hql=" from Trade t where t.agency.id=:agencyId and t.state in(100,101)";
		Finder finder = Finder.create(hql);
        finder.setParam("agencyId",agencyId);
        return this.find(finder);
	}
	public Trade getTradeByBarCode(String barCode)throws Exception{
		String hql=" from Trade t where t.barCode=:barCode and t.state=111";
		Finder finder = Finder.create(hql);
		finder.setParam("barCode",barCode);
		List<Trade> list =this.find(finder);
		if((list!=null)&&(list.size()>0))
		{
			return list.get(0);
		}
		return null;
	}

	public List<Trade> getFinancingTrade() throws Exception{
		String hql=" from Trade t where t.state=103 and t.financingTag='1' and t.firstTransferTag='0'";
		Finder finder = Finder.create(hql);
		List<Trade> list =this.find(finder);
		return list;
	}


	public Trade getTradeByBCode(String barCode) {
		String hql=" from Trade t where t.barCode=:barCode ";
		Finder finder = Finder.create(hql);
		finder.setParam("barCode",barCode);
		List<Trade> list =this.find(finder);
		if((list!=null)&&(list.size()>0))
		{
			return list.get(0);
		}
		return null;
	}

	public Trade getTradeBySCode(String shelfCode) {
		String sql="select * from tf_c_trade t where t.vehicle_id in (select id from tf_c_vehicle where shelf_code = '"+shelfCode+"')";
		Query query = super.getSession().createSQLQuery(sql)
				.addEntity("t", Trade.class);
		List<Trade> list = query.list();
		if((list!=null)&&(list.size()>0))
		{
			return list.get(0);
		}
		return null;
	}

	public Trade getTradeByShelfCode(String shelfCode) {
		String sql="select * from tf_c_trade t where t.vehicle_id in (select id from tf_c_vehicle where shelf_code = '"+shelfCode+"') and t.state in (111) order by t.id desc";
		Query query = super.getSession().createSQLQuery(sql)
				.addEntity("t", Trade.class);
		List<Trade> list = query.list();
		if((list!=null)&&(list.size()>0))
		{
			return list.get(0);
		}
		return null;
	}

	public List<Trade> getOnSaleList() {
    /*String hql="select {t.*} from Trade t join VehicleSync v on t.id=v.trade.id where t.state not in (111,121)";*/
		String hql="select t from Trade t where t.state not in (111,112) and t.outerId is not null";
		Finder finder = Finder.create(hql);

		List<Trade> list =this.find(finder);

		return list;
	}
	public Trade findByOutId(long outerId) {
		String hql=" from Trade t where t.outerId=:outerId ";
	    Finder finder = Finder.create(hql);
	    finder.setParam("outerId",outerId);
	    List<Trade> list =this.find(finder);
	    if((list!=null)&&(list.size()>0))
	    {
	      return list.get(0);
	    }
	    return null;
	}
	@SuppressWarnings("unchecked")
	public Trade getTradeByVehicleId(Long vehicleId) {
		String hql=" from Trade t where t.vehicle.id=:vehicleId ";
	    Finder finder = Finder.create(hql);
	    finder.setParam("vehicleId",vehicleId);
	    List<Trade> list =this.find(finder);
	    if((list!=null)&&(list.size()>0))
	    {
	      return list.get(0);
	    }
	    return null;
	}
	
	@SuppressWarnings("unchecked")
	public List<Trade> listTrade() {
		StringBuffer hql = new StringBuffer();
		hql.append("  from Trade t where t.valuationFee = 0 ");
		hql.append(" and t.state IN (100,101,102,103,104,105,106) ");
		Finder finder = Finder.create(hql.toString());
		return this.find(finder);
	}
	
	public String getSumFee(Long agencyId) {
		String sql = "select sum(t.valuation_fee) from tf_c_trade t where t.agency_id="+agencyId+" and t.state in (100,101,102,103,104,105,106)";
		Query query = super.getSession().createSQLQuery(sql);
		return query.list().get(0).toString();
	}

}

package com.ct.erp.task.service;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.api.ApiCallException;
import com.ct.erp.api.che300.Che300Api;
import com.ct.erp.api.che300.IdentifyModel;
import com.ct.erp.api.che300.ModelInfo;
import com.ct.erp.api.che300.UsedCarPrice;
import com.ct.erp.carin.dao.TradeDao;
import com.ct.erp.carin.service.TradeInfoService;
import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.lib.entity.Trade;
import com.ct.erp.lib.entity.Vehicle;

@Service
@Transactional(propagation = Propagation.SUPPORTS)
public class VehicleEvaluationService {

	private static final Logger log = LoggerFactory.getLogger(VehicleEvaluationService.class);

	private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");

	@Autowired
	private TradeInfoService tradeInfoService;

	@Autowired
	private TradeDao tradeDao;

	/**
	 * 车辆估价
	 * 
	 * @throws ParseException
	 * @throws ApiCallException
	 */
	public void vehicleEvaluation() throws ParseException, ApiCallException {
		List<Trade> trades = this.tradeInfoService.listTrade();
		if (trades != null && trades.size() > 0) {
			for (Trade trade : trades) {
				try {
					this.callChe300Api(trade);
				} catch (Exception e) {
					log.error("自动同步che300估值系统异常", e);
				}
			}
		}
	}

	/**
	 * @param t
	 * @return
	 * @throws ParseException
	 * @throws ApiCallException
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public Trade callChe300Api(Trade trade) throws ApiCallException, ParseException {
		Trade t = this.tradeDao.get(trade.getId());
		Vehicle vehicle = t.getVehicle();
		String brand = vehicle.getBrandName();
		String series = vehicle.getSeriesName();
		String model = vehicle.getKindName();
		String modelYear = vehicle.getRegistMonth();
		if (StringUtils.isBlank(brand)) {
			throw new ApiCallException("品牌为空");
		}
		if (StringUtils.isBlank(series)) {
			throw new ApiCallException("车系为空");
		}
		if (StringUtils.isBlank(model)) {
			throw new ApiCallException("车型为空");
		}
		if (StringUtils.isBlank(vehicle.getMileageCount())) {
			throw new ApiCallException("行驶里程不存在");
		}
		Double mile = Double.valueOf(vehicle.getMileageCount());
		if (StringUtils.isBlank(modelYear)) {
			throw new ApiCallException("上牌年月为空");
		}
		Calendar c = Calendar.getInstance();
		c.setTime(sdf.parse(modelYear));
		String year = c.get(Calendar.YEAR) + "";

		IdentifyModel identifyModel = Che300Api.identifyModel(brand, series, model, year, null);
		if ("0".equals(identifyModel.getStatus())) {
			throw new ApiCallException("调用che300的车型识别接口失败");
		}
		ModelInfo modelInfo = identifyModel.getModelInfo();
		if (modelInfo == null) {
			throw new ApiCallException("调用che300的车型识别接口数据不能逆向失败");
		}
		UsedCarPrice usedCarPrice = Che300Api.getUsedCarPrice(modelInfo.getModel_id(), modelYear, mile, 11, null, null);
		System.out.println(usedCarPrice);
		if (usedCarPrice != null && "1".equals(usedCarPrice.getStatus())) {
			t.setValuationFee(new BigDecimal(usedCarPrice.getEval_price()).multiply(new BigDecimal("10000")).longValue());
			this.tradeDao.update(t);
			return t;
		}
		return null;
	}
}

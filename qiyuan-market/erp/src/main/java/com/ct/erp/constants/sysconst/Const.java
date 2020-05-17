package com.ct.erp.constants.sysconst;

import java.util.Arrays;
import java.util.List;

import com.ct.erp.common.utils.GlobalConfigUtil;

public class Const {

	/* 车三宝相关配置 */
	// 车三宝内部的大公交易市场id
	public static final String SYNC_AGENCY_CORPID = GlobalConfigUtil
			.get("CORPID");
	// 新增车商接口
	public static final String SYNC_AGENCY_URL = GlobalConfigUtil
			.get("SYNC_AGENCY_URL");
	public static final String SYNC_VEHICLE_URL = GlobalConfigUtil
			.get("SYNC_VEHICLE_URL");
	public static final String SYNC_VEHICLE_BACK_URL = GlobalConfigUtil
			.get("SYNC_VEHICLE_BACK_URL");
	public static final String SYNC_ALL_VEHICLE_BACK_URL = GlobalConfigUtil
			.get("SYNC_All_VEHICLE_BACK_URL");
	public static final String BARCODE_URL = GlobalConfigUtil
			.get("BARCODE_URL");
	public static final String SYNC_BARCODE_URL = GlobalConfigUtil
			.get("SYNC_BARCODE_URL");

	// 车3宝同步状态
	public static final String SYNC_STATE_UNSYNC = "0";
	public static final String SYNC_STATE_SUCCESS = "1";
	public static final String SYNC_STATE_ERROR = "9";

	// 车来客同步状态
	public static final String SYNC_STATE_CANT = "0";
	public static final String SYNC_STATE_CAN = "1";
	public static final String SYNC_STATE_DONE = "2";
	public static final String SYNC_STATE_FALSE = "9";
	public static final int SYNC_NUM = 3;

	/* 交易系统相关参数 */
	public static final String TRANSFER_FINACING_ACQU_URL = GlobalConfigUtil
			.get("TRANSFER_FINACING_ACQU_URL");
	public static final String VALID_IDS = "有效市场方身份证";

	public static final String IMAGE_ADDR = GlobalConfigUtil.get("IMAGE_ADDR");
	public static final String IMAGE_SAVEPATH = GlobalConfigUtil
			.get("IMAGE_SAVEPATH");
	public static final Short VEHICLE_MANAGE = 0;
	public static final Short FEE_MANAGE = 1;
	public static final Short VEHICLE_PUBLISH = 2;
	public static final Short SYS_MANAGE = 3;
	public static final String TEMP_PATH = GlobalConfigUtil
			.get("UPLOAD_TEMP_DIR");

	// 公司LOGO
	public static final String IMAGE_TYPE_CORP_LOGO = "corp_logo";
	// 首页扁平LOGO
	public static final String IMAGE_TYPE_MAIN_LOGO = "main_logo";
	// 商户图片
	public static final String IMAGE_TYPE_STORE_PIC = "store_pic";
	// 车辆图片
	public static final String IMAGE_TYPE_VEHICLE_PIC = "vehicle_pic";
	// 合同图片
	public static final String IMAGE_TYPE_CONTRACT_PIC = "contract_pic";
	//商铺合同图片
	public static final String IMAGE_TYPE_SHOP_CONTRACT_PIC = "contract_pic";

	// 交易表状态
	// 待入场,新入场、已检测、已估值、已商户预收、已收购过户、已付收购款、已收销售款、已销售过户、已付商户款、已过期处置、已过期退款
	public static final Integer WAITFOR_IN = 111;// 待入场
	public static final String WAITFOR_IN_STR = "111";// 待入场
	public static final Integer NEW_CAR = 100;// 新入场
	public static final String NEW_CAR_STR = "100";// 新入场
	public static final Integer EVALUATED = 101;// 已检测
	public static final String EVALUATED_STR = "101";// 已检测
	public static final Integer VALUATED = 102;// 已估值
	public static final Integer GATHERING_AGENCY = 103;// 已商户预收完
	public static final String GATHERING_AGENCY_STR = "103";// 已商户预收完
	public static final Integer ACQU_TRANSFERED = 104;// 已收购过户
	public static final String ACQU_TRANSFERED_STR = "104";// 已收购过户
	public static final Integer PAID_CUST = 105;// 已付完卖主款
	public static final String PAID_CUST_STR = "105";// 已付完卖主款
	public static final Integer GATHERING_CUST = 106;// 已收完客户款
	public static final String GATHERING_CUST_STR = "106";// 已收完客户款
	public static final Integer SALE_TRANSFERED = 107;// 已销售过户
	public static final String SALE_TRANSFERED_STR = "107";// 已销售过户
	public static final Integer PAID_AGENCY = 108;// 已付完商户款
	public static final Integer GATHERING_DISPOSAL = 109;// 已收完处置款
	public static final String GATHERING_DISPOSAL_STR = "109";// 已收完处置款
	public static final Integer REFUND_AGENCY = 110;// 已退完商家款
	public static final Integer OUT_STOCK = 112;// 已离场
	public static final String OUT_STOCK_STR = "112";// 已离场

	public static final Integer DELETED = 199;// 调整车位删除
	public static final String DELETED_STR = "199";// 调整车位删除
	public static final String PUSH_URL = GlobalConfigUtil.get("PUSH_URL");

	public static final String SSO_LOGIN_URL = GlobalConfigUtil
			.get("sso.login");

	public static final String FINANCING_PERCENT = GlobalConfigUtil
			.get("FINANCING_PERCENT");

	public static final String SSO_INDEX_URL = GlobalConfigUtil
			.get("sso.index");

	public static final String AUCTION = GlobalConfigUtil.get("AuctionDesc");

	public static final String AGENCY_PIC = "0";// 商户图片
	public static final String CONTRACT_PIC = "1";// 合同图片
	public static final String DRIVE_PIC = "2";// 行驶证图片
	public static final String FINANCING_PIC = "3";// 融资检测图片

	//oss参数
	public static String accessKeyId = GlobalConfigUtil
			.get("accessKeyId");
	public static String accessKeySecret = GlobalConfigUtil
			.get("accessKeySecret");
	public static String endpoint = GlobalConfigUtil.get("endpoint");
	static{
		endpoint = GlobalConfigUtil.get("endpoint");
		accessKeySecret = GlobalConfigUtil
				.get("accessKeySecret");
		accessKeyId = GlobalConfigUtil
				.get("accessKeyId");
		vehicleBucket = GlobalConfigUtil
				.get("vehicleBucket");
		agencyBucket = GlobalConfigUtil
				.get("agencyBucket");
		checkBucket = GlobalConfigUtil
				.get("checkBucket");
	}
	public static final String img_url = GlobalConfigUtil.get("img_url");// oss图片访问地址
	public static final String img_vehicle_size = GlobalConfigUtil.get("img_vehicle_size");// oss车辆小图尺寸
	public static final String img_agency_size = GlobalConfigUtil.get("img_agency_size");// oss车商小图尺寸
	public static String vehicleBucket = GlobalConfigUtil
			.get("vehicleBucket");
	public static String agencyBucket = GlobalConfigUtil
			.get("agencyBucket");
	public static String checkBucket = GlobalConfigUtil
			.get("checkBucket");
	

	public static final String ERP_IP = GlobalConfigUtil.get("erp.ip");

	/**
	 * 车来客车商同步注册
	 */
	public static final String CHELAIKE_REGISTUSER = GlobalConfigUtil
			.get("CHELAIKE_REGISTUSER");

	// 合同状态
	public static final String WAITFOR_WORK = "101";// 待生效
	public static final String WORKING = "102";// 已生效
	public static final String WAITFOR_END = "103";// 待终止
	public static final String TERMINATED = "104";// 已终止

	// 合同终止原因
	public static final String TIME_OUT = "1";// 过期终止
	public static final String FEE_OUT = "2";// 欠费终止
	public static final String ACTIVE_OUT = "3";// 主动终止
	public static final String ABOLISH = "4";// 废除

	// 商户状态
	public static final String WAITFOR_sign = "101";// 待签
	public static final String WAIT_IN = "102";// 待入场
	public static final String ALREADY_IN = "103";// 在场
	public static final String ALREADY_OUT = "106";// 已离场

	// 收款计划状态
	public static final String WAITFOR_COLLECT = "0";// 待收款
	public static final String COLLECTING = "1";// 收款中
	public static final String COLLECTED = "2";// 已收完

	// 操作记录类型
	public static final String CONTRACT = "0";// 合同
	public static final String TRADE = "1";// 交易
	public static final String PUBLISH = "2";// 发布
	public static final String SITEAREA = "3";// 场地区域
	public static final String SITESHOP = "4";// 商铺区域
	public static final String SHOP_CONTRACT = "5";// 商铺合同
	
	/**
	 * 车辆在库状态
	 */
	public static final List<Integer> VEHICLE_STOCK_STATE = Arrays.asList(
			NEW_CAR,EVALUATED,VALUATED,GATHERING_AGENCY,ACQU_TRANSFERED,
			PAID_CUST,GATHERING_CUST,SALE_TRANSFERED,PAID_AGENCY,
			GATHERING_DISPOSAL,REFUND_AGENCY);
	
	/** 车辆交易表 tf_c_trade
	 *  "0"-未检测，"1"-已检测
	 */
	public static final String DETECT_YES = "1";
	public static final String DETECT_NO = "0";
	
	
	/**
	 * 微信公众号 appid , secret
	 */ 
	public static final String APPID = GlobalConfigUtil
			.get("appid");
	public static final String SECRET = GlobalConfigUtil
			.get("secret");
	
	//微信端商户信息
	public final static String WX_SESSION_AGENCY_USERINFO = "wxAgencyInfo";

	// 车来客桌面端部署地址
	public final static String DesktopUrl = GlobalConfigUtil.get("desktopUrl");
	
	
}

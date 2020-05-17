package com.ct.erp.util;

import java.io.PrintWriter;
import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Time;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;
import net.sourceforge.pinyin4j.PinyinHelper;
import net.sourceforge.pinyin4j.format.HanyuPinyinCaseType;
import net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat;
import net.sourceforge.pinyin4j.format.HanyuPinyinToneType;
import net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination;

import com.ct.util.lang.ComUtils;
import com.ct.util.lang.StrUtils;

/**
 * @author 张均章 车管家工具类
 */
public class UcmsWebUtils extends ComUtils {

	/**
	 * 获取当前sql类型的time时间
	 * 
	 * @return
	 */
	public static Time getNowTime() {
		return new java.sql.Time(System.currentTimeMillis());
	}

	/**
	 * 根据期望销售日期的开始时间和结束时间计算两个日期的时间差
	 * 
	 * @param startTime 开始时间
	 * @param endTime 结束时间
	 * @return
	 */
	public static int getDateValues(Date startTime, Date endTime)
			throws Exception {
		int dataVal = 0;
		long times = endTime.getTime() - startTime.getTime();
		long addTime = times / (24 * 60 * 60 * 1000);
		dataVal = (int) (addTime);
		return dataVal;
	}

	/**
	 * 根据期望销售日期的开始时间和结束时间计算两个日期的时间差
	 * 
	 * @param startTime 开始时间
	 * @param endTime 结束时间
	 * @return
	 */
	public static int getDateValuesByDate(Date startTime, Date endTime)
			throws Exception {
		int dataVal = 0;
		long times = endTime.getTime() - startTime.getTime();
		long addTime = times / (24 * 60 * 60 * 1000);
		dataVal = (int) (addTime);
		return dataVal;
	}

	/**
	 * 获取从当前前20年时间
	 * 
	 * @return
	 */
	@SuppressWarnings("static-access")
	public static List<String> getInitYearMap() {
		List<String> yearList = new ArrayList<String>();
		Calendar calendar = Calendar.getInstance();
		int currutnYear = calendar.get(calendar.YEAR);
		for (int i = currutnYear; i >= currutnYear - 20; i--) {
			yearList.add(i + "");
		}
		return yearList;
	}

	/**
	 * 返回ajax返回码的方法
	 * 
	 * @param response 相应对象
	 * @param serializable 需要相应的值
	 */
	public static void ajaxOutPut(HttpServletResponse response,
			Serializable serializable) {
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = null;
		try {
			out = response.getWriter();
			out.print(serializable);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			out.flush();
			out.close();
		}
	}
	
	public static void jsonOutPut(HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json;charset=utf-8");
		PrintWriter out = null;
		try {
			out = response.getWriter();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			out.flush();
			out.close();
		}
	}

	/**
	 * 
	 * @Title: wanTofen
	 * @Description: 将万元转换为分
	 * @param wanPrice
	 * 
	 */
	public static Integer wanTofen(String wanPrice) {
		if ((wanPrice != null) && !wanPrice.equals("0")
				&& (wanPrice.length() > 0)) {
			double price = Double.parseDouble(wanPrice.toString());
			BigDecimal b = new BigDecimal(price * 1000000);
			return b.setScale(0, BigDecimal.ROUND_HALF_UP).intValue();
		}
		return 0;
	}

	public static Integer wanToyuan(String wanPrice) {
		if ((wanPrice != null) && !wanPrice.equals("0")
				&& (wanPrice.length() > 0)) {
			double price = Double.parseDouble(wanPrice.toString());
			BigDecimal b = new BigDecimal(price * 10000);
			return b.setScale(0, BigDecimal.ROUND_HALF_UP).intValue();
		}
		return 0;
	}	
	
	/**
	 * 
	 * @Title: wanTofen
	 * @Description: 将分转换为万元
	 * @param wanPrice
	 * 
	 */
	public static String fenTowan(Integer fenPrice) {
		if (fenPrice != null) {
			return new BigDecimal(fenPrice).divide(new BigDecimal(1000000))
					.toString();
		}
		return "0";
	}

	/**
	 * 
	 * @Title: wanTofen
	 * @Description: 将元转换为分
	 * @param wanPrice
	 * 
	 */
	public static Integer yuanTofen(String yuanPrice) {
    if ( StrUtils.isNotNull(yuanPrice) && !yuanPrice.equals("0")
        && (yuanPrice.length() > 0)) {
      double price = Double.parseDouble(yuanPrice.toString());
      BigDecimal b = new BigDecimal(price * 100);
      return b.setScale(0, BigDecimal.ROUND_HALF_UP).intValue();
    }
    return 0;
		
	}

	/**
	 * 
	 * @Title: wanTofen
	 * @Description: 将分转换为元
	 * @param wanPrice
	 * 
	 */
	public static String fenToYuan(Integer fenPrice) {
		if (fenPrice != null) {
			double dPrice = fenPrice;
			String result = dPrice / 100 + "";
			if (result.indexOf('.') > -1) {
				String subResult = result.substring(result.indexOf('.') + 1);
				if (subResult.matches("0+")) {
					result = result.substring(0, result.indexOf('.'));
				}
			}
			return result;

		}
		return "0";
	}
	
	/**
	 * 
	 * @Title: fenToyuan
	 * @Description: 将分转换为元
	 * @param fenPrice
	 * 
	 */
	public static Long fenToYuan(Long fenPrice) {
		if (fenPrice != null) {
			Long result = fenPrice / 100;
			return result;
		}
		return (long) 0;
	}

	/**
	 * 将阿拉伯数字转换成大写数字
	 * 
	 * @return
	 */
	public static String smallToBig(double money) throws Exception {
		double temp = 0;
		long l = Math.abs((long) money);
		BigDecimal bil = new BigDecimal(l);
		if (bil.toString().length() > 14) {
			throw new Exception("数字太大，计算精度不够!");
		}
		NumberFormat nf = NumberFormat.getInstance();
		nf.setMaximumFractionDigits(2);
		int i = 0;
		String result = "", sign = "", tempStr = "", temp1 = "";
		String[] arr = null;
		sign = money < 0 ? "负" : "";
		temp = Math.abs(money);
		if (l == temp) {
			result = doForEach(new BigDecimal(temp).multiply(
					new BigDecimal(100)).toString(), sign);
		} else {
			nf.setMaximumFractionDigits(2);
			temp1 = nf.format(temp);
			arr = temp1.split(",");
			while (i < arr.length) {
				tempStr += arr[i];
				i++;
			}
			BigDecimal b = new BigDecimal(tempStr);
			b = b.multiply(new BigDecimal(100));
			tempStr = b.toString();
			if (tempStr.indexOf(".") == tempStr.length() - 3) {
				result = doForEach(tempStr.substring(0, tempStr.length() - 3),
						sign);
			} else {
				result = doForEach(tempStr.substring(0, tempStr.length() - 3)
						+ "0", sign);
			}
		}
		return result;

	}

	/**
	 * 被smallToBig调用
	 */
	public static String doForEach(String result, String sign) {

		String flag = "", b_string = "";
		String[] arr = { "分", "角", "圆", "拾", "佰", "仟", "万", "拾", "佰", "仟", "亿",
				"拾", "佰", "仟", "万", "拾" };
		String[] arr1 = { "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖" };
		boolean zero = true;
		int len = 0, i = 0, z_count = 0;
		if (result == null) {
			len = 0;
		} else {
			len = result.length();
		}
		while (i < len) {
			flag = result.substring(i, i + 1);
			i++;
			if (flag.equals("0")) {
				if ((len - i == 10) || (len - i == 6) || (len - i == 2)
						|| (len == i)) {
					if (zero) {
						b_string = b_string.substring(0,
								(b_string.length()) - 1);
						zero = false;
					}
					if (len - i == 10) {
						b_string = b_string + "亿";
					}
					if (len - i == 6) {
						b_string = b_string + "万";
					}
					if (len - i == 2) {
						// b_string = b_string + "圆";
					}
					if (len == i) {
						// b_string = b_string + "整";
					}
					z_count = 0;
				} else {
					if (z_count == 0) {
						b_string = b_string + "零";
						zero = true;
					}
					z_count = z_count + 1;
				}
			} else {
				b_string = b_string + arr1[Integer.parseInt(flag) - 1]
						+ arr[len - i];
				z_count = 0;
				zero = false;
			}
		}
		b_string = sign + b_string;
		return b_string;
	}

	/**
	 * 
	 * @Title: striToTimestamp
	 * @Description: 将字符串时间格式转换为Timestamp
	 * @param time
	 * @return
	 * @throws:
	 * @author: Addy Create at: 2012-1-16 下午01:52:31
	 */
	public static Timestamp striToTimestamp(String time) throws Exception {
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		format.setLenient(false);
		// 要转换字符串 str_test
		Timestamp ts = new Timestamp(format.parse(time).getTime());
		if (ts != null) {
			return ts;
		}
		return null;
	}

	/**
	 * 
	 * @Title: striToTimestamp
	 * @Description: 将字符串时间格式转换为Timestamp
	 * @param time
	 * @return
	 * @throws:
	 * @author: Addy Create at: 2012-1-16 下午01:52:31
	 */
	public static Timestamp striToTimestamp(String date, String time)
			throws Exception {
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		format.setLenient(false);
		// 要转换字符串 str_test
		String str = date + " " + time;
		Timestamp ts = new Timestamp(format.parse(str).getTime());
		return ts;
	}

	/**
	 * 计算两个时间差多少分钟
	 * 
	 * @param time
	 * @return
	 */
	public static long minuteToNow(Timestamp time) {
		long time1 = time.getTime();
		long time2 = UcmsWebUtils.now().getTime();
		long diff = Math.abs(time1 - time2);
		long days = diff / (1000 * 60);
		return days;
	}

	/**
	 * 计算指定日期距离今天的天数差
	 * 
	 * @param time
	 * @return
	 */
	public static long dayToNow(Timestamp time) throws Exception {
		long time1 = striToTimestamp(timestampTOStr(time)).getTime();
		long time2 = striToTimestamp(timestampTOStr(UcmsWebUtils.now()))
				.getTime();
		long diff = time2 - time1;
		long days = diff / (1000 * 60 * 60 * 24);
		return days;
	}

	/**
	 * 计算指定日期距离今天的天数差
	 * 
	 * @param time
	 * @return
	 */
	public static long dayToNowForDate(Date date) throws Exception {
		long time1 = striToTimestamp(timestampTOStrForDate(date)).getTime();
		long time2 = striToTimestamp(timestampTOStr(UcmsWebUtils.now()))
				.getTime();
		long diff = time2 - time1;
		long days = diff / (1000 * 60 * 60 * 24);
		return days;
	}

	/**
	 * 获取指定多少天后的timestamp
	 * 
	 * @param time
	 * @param day
	 * @return
	 */
	public static Timestamp getNextTimestamp(Timestamp time, int day) {
		Date date = timestampToDate(time);
		Timestamp tt = dateToTimestamp(ComUtils.modifyDate(date, 0, 0, day, 0,
				0, 0));
		return tt;
	}

	/**
	 * 获取指定多少天后的timestamp
	 * 
	 * @param time
	 * @param day
	 * @return
	 */
	public static Date getNextDate(Date date, int day) {
		return ComUtils.modifyDate(date, 0, 0, day, 0, 0, 0);
	}

	/**
	 * 判断是否是偶数
	 * 
	 * @param num
	 * @return
	 */
	public static boolean isEven(int num) {
		return (num % 2 == 0);
	}

	/**
	 * 将timestamp转换成date
	 * 
	 * @author hellostoy
	 * @param tt
	 * @return
	 */
	public static Date timestampToDate(Timestamp tt) {
		return new Date(tt.getTime());
	}

	/**
	 * 将Date转换成timestamp
	 * 
	 * @param date
	 * @return
	 */
	public static Timestamp dateToTimestamp(Date date) {
		return new Timestamp(date.getTime());
	}

	/**
	 * 
	 * @Title: wanToLi
	 * @Description: 将万里转换里
	 * @param wanStr
	 * @return
	 * @throws:
	 * @author: Addy Create at: 2012-1-16 下午01:55:05
	 */
	public static int wanToLi(String wanStr) {
		if ((wanStr != null) && !wanStr.equals("0") && (wanStr.length() > 0)) {
			double price = Double.parseDouble(wanStr.toString());
			Double pp = price * 10000;
			return pp.intValue();
		}
		return 0;
	}

	/**
	 * 
	 * @Title: liToWan
	 * @Description: 将里转换万里
	 * @param wanStr
	 * @return
	 * @throws:
	 * @author: Addy Create at: 2012-1-16 下午01:55:05
	 */
	public static String liToWan(Double liStr) {
		if (liStr != null) {
			if (liStr > 0) {
				return to2Double((liStr / 10000)) + "";
			}
		}
		return "";
	}

	/**
	 * 
	 * @Title: liToWan
	 * @Description: 将里转换万里
	 * @param wanStr
	 * @return
	 * @throws:
	 * @author: Addy Create at: 2012-1-16 下午01:55:05
	 */
	public static String liToWan(Integer liStr) {
		if (liStr != null) {
			return new BigDecimal(liStr).divide(new BigDecimal(10000))
					.toString();
		}

		// if (liStr != null) {
		// if (liStr > 0) {
		// return (liStr / 10000) + "";
		// }
		// }
		return "0";
	}

	/**
	 * 
	 * @Title: getStaffId
	 * @Description: 从session 中读取登录id
	 * @param request
	 * @param name
	 * @return
	 * @throws:
	 * @author: Addy
	 */
	public static Integer getStaffId(HttpServletRequest request, String name)
			throws Exception {
		return (Integer) request.getSession().getAttribute(name);
		// 测试阶段使用，正式上线改用上面一段代码
		// return Integer.valueOf(1);
	}

	/**
	 * 
	 * @Title: getJsonString
	 * @Description: 转换为json字符串
	 * @param obj
	 * @return
	 * @throws:
	 * @author: Addy Create at: 2012-2-2 上午11:47:43
	 */
	public static String getJsonString(Object obj) {
		String jsonStr = "";
		/*JsonConfig jsonConfig = new JsonConfig(); //建立配置文件
		jsonConfig.setIgnoreDefaultExcludes(false); //设置默认忽略
		jsonConfig.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);*/
		JSONObject jsonObj = JSONObject.fromObject(obj);
		jsonStr = jsonObj.toString();
		return jsonStr;
	}

	/**
	 * 
	 * @Title: TimestampToStr 将字符串时间格式转换为Timestamp
	 */

	public static String timestampTOStr(Timestamp time) {
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		format.setLenient(false);
		// 要转换字符串 str_test
		String str = "";
		if (time != null) {
			str = format.format(time);
		}
		return str;
	}

	/**
	 * 
	 * @Title: TimestampToStr 将字符串时间格式转换为Timestamp
	 */

	public static String timestampTOStrForDate(Date date) {
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		format.setLenient(false);
		// 要转换字符串 str_test
		String str = "";
		if (date != null) {
			str = format.format(date);
		}
		return str;
	}

	public static String dateTOStr(Date date) {
		if (date == null) {
			return "";
		}
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		format.setLenient(false);
		// 要转换字符串 str_test
		String str = format.format(date);
		return str;
	}

	public static List<String> getSpellList() {
		List<String> spellLists = new ArrayList<String>();
		spellLists.add("");
		for (int i = 65; i < 91; i++) {
			int iValue = Integer.parseInt(i + "", 10);
			char tempC = (char) iValue;// 把数字转换为一个字符
			spellLists.add(tempC + "");
		}
		return spellLists;
	}

	// 获得汉字首字母
	public static char cn2FirstSpell(String chinese) {
		StringBuffer pybf = new StringBuffer();
		char[] arr = chinese.toCharArray();
		HanyuPinyinOutputFormat defaultFormat = new HanyuPinyinOutputFormat();
		defaultFormat.setCaseType(HanyuPinyinCaseType.UPPERCASE);
		defaultFormat.setToneType(HanyuPinyinToneType.WITHOUT_TONE);
		for (char element : arr) {
			if (element > 128) {
				try {
					String[] _t = PinyinHelper.toHanyuPinyinStringArray(
							element, defaultFormat);
					if (_t != null) {
						pybf.append(_t[0].charAt(0));
					}
				} catch (BadHanyuPinyinOutputFormatCombination e) {
					e.printStackTrace();
				}
			} else {
				pybf.append(element);
			}
		}
		String str = pybf.toString().replaceAll("\\W", "").trim();
		char chr = str.substring(0, 1).charAt(0);
		return chr;
	}

	// 去除空格
	public static String replaceBlank(String str) {
		String dest = "";
		if (str != null) {
			Pattern p = Pattern.compile("\\s*|\t|\r|\n");
			Matcher m = p.matcher(str);
			dest = m.replaceAll("");
		}
		return dest;
	}

	/**
	 * 获取当前时间（string类型）
	 * 
	 * @return
	 */
	public static String getCurrentDate() {
		Calendar cal = Calendar.getInstance();
		Date d = cal.getTime();
		SimpleDateFormat sp = new SimpleDateFormat("yyyy-MM-dd");
		return sp.format(d);
	}

	/**
	 * 获取做昨天日期字符串
	 * 
	 * @return
	 */
	public static String getYesterday() {
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1);
		Date d = cal.getTime();
		SimpleDateFormat sp = new SimpleDateFormat("yyyy-MM-dd");
		return sp.format(d);
	}

	/**
	 * 获取明天日期字符串
	 * 
	 * @return
	 */
	public static String getTomorrow() {
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, 1);
		Date d = cal.getTime();
		SimpleDateFormat sp = new SimpleDateFormat("yyyy-MM-dd");
		return sp.format(d);
	}

	/**
	 * 获取当前月的第一天日期字符串
	 * 
	 * @return
	 */
	public static String getFirstDayAtCurrMonth() {
		Calendar cal = Calendar.getInstance();
		cal.set(GregorianCalendar.DAY_OF_MONTH, 1);
		Date beginTime = cal.getTime();
		SimpleDateFormat sp = new SimpleDateFormat("yyyy-MM-dd");
		return sp.format(beginTime);

	}

	/**
	 * 根据参数获取下次日期
	 * 
	 * @param str 当前日期字符串
	 * @param day 天数
	 * @return
	 */
	public static String getNextTimeByStr(String str, int day) {
		Date date = UcmsWebUtils.strToDate(str);
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		cal.add(Calendar.DATE, +day);
		Date d = cal.getTime();
		SimpleDateFormat sp = new SimpleDateFormat("yyyy-MM-dd");
		return sp.format(d);
	}

	/**
	 * 获取当前月
	 * 
	 * @return
	 */
	public static Integer getCurrentMonth() {
		Calendar calendar = Calendar.getInstance(TimeZone.getDefault(),
				Locale.CHINESE);
		calendar.setTime(new Date());
		int month = calendar.get(Calendar.MONTH) + 1;
		return month;
	}

	/**
	 * 获取当前年
	 * 
	 * @return
	 */
	public static Integer getCurrentYear() {
		Calendar calendar = Calendar.getInstance(TimeZone.getDefault(),
				Locale.CHINESE);
		calendar.setTime(new Date());
		int year = calendar.get(Calendar.YEAR);
		return year;
	}

	/**
	 * 根据当前月份获取当前年月 yyyyMM格式
	 * 
	 * @param month
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("boxing")
	public static String getCurrentYearMonth(Integer month) throws Exception {
		if ((month < 0) || (month > 12)) {
			throw new IllegalArgumentException("IllegalMonth! argument:"
					+ month.toString());
		}
		int year = getCurrentYear();
		String date = "";
		if (month < 10) {
			date = year + "0" + month;
		} else {
			date = year + "" + month;
		}
		return date;
	}

	/**
	 * 根据当前年月获取当前月的天数
	 * 
	 * @param yearMonth
	 * @return
	 */
	public static Integer getCurrentMonthDay(String yearMonth) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		Calendar calendar = new GregorianCalendar();
		Date date = sdf.parse(yearMonth);
		calendar.setTime(date);
		int day = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
		return day;
	}

	/**
	 * 根据参数拼接日期
	 * 
	 * @param monthYear ex:201206
	 * @param day ex 8
	 * @return 2012-06-08
	 */
	public static Date yearDayToDate(String monthYear, int day)
			throws Exception {

		if ((day <= 0) || (day > 31)) {
			throw new IllegalArgumentException("IllegalDay! argument:"
					+ String.valueOf(day));
		}
		String monthYearDay = "";
		if (day < 10) {
			monthYearDay = monthYear + "0" + day;
		} else {
			monthYearDay = monthYear + day;
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		Date date = sdf.parse(monthYearDay);
		return date;

	}

	/**
	 * 处理double保留2位小数
	 * 
	 * @param num
	 * @return
	 */
	public static double to2Double(double num) {
		if ((num != 0.0) && (num != -1.0)) {
			num = Math.floor(num * 100 + .5) / 100;
		}
		return num;
	}

	// 获取钥匙号 3位的
	public static String getNextKeyId(String txt) {
		int index = 0;
		String[] numStr = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
				"A", "B", "C", "D", "E", "F", "G", "H", "J", "K", "L", "M",
				"N", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" };
		String startA = String.valueOf(txt.charAt(0)); // 百位
		String startB = String.valueOf(txt.charAt(1)); // 十位
		String startC = String.valueOf(txt.charAt(2)); // 个位

		String endA = "";
		String endB = "";
		String endC = "";

		// 处理个位
		for (int i = 0; i < numStr.length; i++) {
			if (numStr[i].equals(startC)) {
				index = i;
				break;
			}
		}
		if (index == 33) {
			index = -1;
		}
		endC = numStr[index + 1]; // 个位

		if (startC.equals("Z")) {
			// 处理10位
			for (int i = 0; i < numStr.length; i++) {
				if (numStr[i].equals(startB)) {
					index = i;
					break;
				}
			}
			if (index == 33) {
				index = -1;
			}
			endB = numStr[index + 1]; // 10位
		} else {
			endB = startB;
		}

		if (startB.equals("Z") && startC.equals("Z")) {
			// 处理百位
			for (int i = 0; i < numStr.length; i++) {
				if (numStr[i].equals(startA)) {
					index = i;
					break;
				}
			}
			if (index == 33) {
				index = -1;
			}
			endA = numStr[index + 1]; // 10位
		} else {
			endA = startA;
		}
		return endA + endB + endC;
	}

	/**
	 * 获取当前日期 格式：yyyyMMdd
	 * 
	 * @param time
	 * @return
	 * @throws Exception
	 */
	public static String getNowTimeByYYYYMMDD() {
		DateFormat format = new SimpleDateFormat("yyyyMMdd");
		// 要转换字符串 str_test
		return format.format(UcmsWebUtils.now());
	}

	/**
	 * 拼接车辆新价地址、汽车之家网站传递的key需要对key进行encode
	 * 
	 * @param url 默认地址
	 * @param styleName 查找的key
	 * @return 评价的地址
	 * @throws UnsupportedEncodingException
	 */
	public static String spliceVehiclePriceUrl(String url, String styleName)
			throws UnsupportedEncodingException {
		String encodeStyleName = "";
		try {
			encodeStyleName = URLEncoder.encode(styleName, "GBK");
		} catch (UnsupportedEncodingException e) {
			throw e;
		}
		return url.replaceAll("#seriesName#", encodeStyleName);

	}

	/**
	 * 
	 * @Title: getPreMonth
	 * @Description: 获取当前日期的上个月份
	 */
	public static Integer getPreMonth() throws Exception {
		Calendar calendar = Calendar.getInstance(TimeZone.getDefault(),
				Locale.CHINESE);
		calendar.setTime(new Date());
		int month = calendar.get(Calendar.MONTH);
		return month;
	}

	/**
	 * 
	 * @Title: getStartDate
	 * @Description: 获得月份的开始日期
	 */
	public static String getStartDate(Integer month) throws Exception {
		String monthYear = getCurrentYearMonth(month);
		Date startDate = yearDayToDate(monthYear, 1);
		return dateTOStr(startDate);
	}

	/**
	 * 
	 * @Title: getStartDate
	 * @Description: 获得月份的结束日期
	 */
	public static String getEndDate(Integer month) throws Exception {
		String monthYear = getCurrentYearMonth(month);
		Integer day = getCurrentMonthDay(monthYear);
		Date endDate = yearDayToDate(monthYear, day);
		return dateTOStr(endDate);
	}

	/**
	 * 计算百分比
	 * 
	 * @param a
	 * @param b
	 * @return
	 */
	public static double getPercent(Integer a, Integer b) {
		if ((b == null) || (b == 0) || (a == null) || (a == 0)) {
			return 0;
		}
		double aaa = 0.0;
		aaa = a / (double) b * 100;
		aaa = Math.floor(aaa * 100 + .5) / 100;
		return aaa;
	}

	public static Date getFirstDayOfMonth(Integer year, Short month)
			throws Exception {
		if ((month <= 0) || (month > 12)) {
			throw new IllegalArgumentException("IllegalMonth! argument:"
					+ String.valueOf(month));
		}
		String monthYearDay = "";
		if (month < 10) {
			monthYearDay = year + "0" + month + "01";
		} else {
			monthYearDay = year.toString() + month.toString() + "01";
		}

		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		Date date = sdf.parse(monthYearDay);
		return date;
	}

	// 获取多少年后的日期
	public static String getYearAfter(Integer year) throws Exception {
		Date time = new Date();
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		Calendar canlandar = Calendar.getInstance();
		canlandar.setTime(time);
		canlandar.add(canlandar.YEAR, year);
		String syncTime = df.format(canlandar.getTime()).toString();
		return syncTime;
	}

	// 获取多少天后的日期
	public static String getDayAfter(Integer day) throws Exception {
		Date time = new Date();
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		Calendar canlandar = Calendar.getInstance();
		canlandar.setTime(time);
		canlandar.add(canlandar.DATE, day);
		String syncTime = df.format(canlandar.getTime()).toString();
		return syncTime;
	}

	// 获取多少天后的日期
	public static String getDayAfterByStr(Integer day, String date)
			throws Exception {
		// Date time = new Date();
		Date time = strToDate(date);
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		Calendar canlandar = Calendar.getInstance();
		canlandar.setTime(time);
		canlandar.add(canlandar.DATE, day);
		String syncTime = df.format(canlandar.getTime()).toString();
		return syncTime;
	}

	public static String formatDate(Date time) {
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		format.setLenient(false);
		// 要转换字符串 str_test
		String str = "";
		if (time != null) {
			str = format.format(time);
		}
		return str;
	}

	public static String yuanTowan(Integer price) {
		if (price != null) {
			double dPrice = price;
			return to2Double(dPrice / 10000) + "";
		}
		return "";
	}
	public static String yuanTowan(Long price) {
		if (price != null) {
			double dPrice = price;
			return to2Double(dPrice / 10000) + "";
		}
		return "";
	}
	public static long daysBetween(Timestamp t1, Timestamp t2) throws Exception {
		long time1 = striToTimestamp(timestampTOStr(t1)).getTime();
		long time2 = striToTimestamp(timestampTOStr(t2)).getTime();
		long diff = time2 - time1;
		long days = diff / (1000 * 60 * 60 * 24);
		return days;
	}

	/**
	 * 
	 * @Title: TimestampToStr 将字符串时间格式转换为Timestamp
	 */

	public static String newTimestampToStr(Timestamp time) {
		DateFormat format = new SimpleDateFormat("MM-dd HH:mm");
		format.setLenient(false);
		// 要转换字符串 str_test
		String str = "";
		if (time != null) {
			str = format.format(time);
		}
		return str;
	}

	public static String newDateToStr(Date date) {
		if (date == null) {
			return "";
		}
		DateFormat format = new SimpleDateFormat("MM-dd HH:mm");
		format.setLenient(false);
		// 要转换字符串 str_test
		String str = format.format(date);
		return str;
	}

	/**
	 * 
	 * @Title: TimestampToStr 将字符串时间格式转换为Timestamp
	 */

	public static String againTimestampToStr(Timestamp time) {
		DateFormat format = new SimpleDateFormat("MM-dd");
		format.setLenient(false);
		// 要转换字符串 str_test
		String str = "";
		if (time != null) {
			str = format.format(time);
		}
		return str;
	}

	public static String againDateToStr(Date date) {
		if (date == null) {
			return "";
		}
		DateFormat format = new SimpleDateFormat("MM-dd");
		format.setLenient(false);
		// 要转换字符串 str_test
		String str = format.format(date);
		return str;
	}

	/**
	 * 获取小图路径
	 * 
	 * @param url
	 * @return
	 */
	public static String getSmallPicPath(String url) {
		String result = "";
		try {
			if ((url != null) && (url.length() > 0)) {
				int index = url.lastIndexOf(".");
				String a = url.substring(0, index);
				String h = url.substring(index, url.length());
				result = a + "_small" + h;
			}
		} catch (Exception e) {
			// TODO: handle exception
			result = "";
		}
		return result;
	}

	public static String strToDate(Date time) {
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		format.setLenient(false);
		// 要转换字符串 str_test
		String str = "";
		if (time != null) {
			str = format.format(time);
		}
		return str;
	}

	/**
	 * Md5数据加密
	 * 
	 * @param plainText
	 * @return
	 */
	public static String Md5(String plainText) {
		try {

			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(plainText.getBytes("utf-8"));
			byte b[] = md.digest();
			int i;
			StringBuffer buf = new StringBuffer("");
			for (int offset = 0; offset < b.length; offset++) {
				i = b[offset];
				if (i < 0) {
					i += 256;
				}
				buf.append(Integer.toHexString(i));
			}
			String MD532 = buf.toString();
			return MD532;
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}

	public static Date today() {
		Calendar c = Calendar.getInstance();
		return c.getTime();
	}
	
	
	public static String timeToStr(Timestamp time) {
		DateFormat format = new SimpleDateFormat("MM-dd HH:mm");
		format.setLenient(false);
		// 要转换字符串 str_test
		String str = "";
		if (time != null) {
			str = format.format(time);
		}
		return str;
	}
	
	public static Date stringToDate(String date) throws Exception{
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date d = sdf.parse(date);
		return d;
	}
	
	/**
	 * 计算两个日期之间相差几个月
	 */
	public static int getMonths(String date1,String date2) throws Exception{
		Calendar cal1 = Calendar.getInstance();
		Calendar cal2 = Calendar.getInstance();
		cal1.setTime(UcmsWebUtils.stringToDate(date1));
		cal2.setTime(UcmsWebUtils.stringToDate(date2));
		int months = (cal2.get(Calendar.YEAR)-cal1.get(Calendar.YEAR))*12 + cal2.get(Calendar.MONTH)-cal1.get(Calendar.MONTH);
		return months;
	}
	
	/**
	 * 计算收费次数
	 */
	public static int getFeeNums(int months,int cycleCount)throws Exception{
		int cycle = 0;
		if(months/cycleCount == 0){
			cycle = 1;
		}else{
			if( months%cycleCount == 0){
				cycle = months/cycleCount;
			}else{
				cycle = months/cycleCount+1;
			}
		}
		return cycle;
	}

}

package com.ct.erp.util;

import java.math.BigDecimal;
import java.util.Hashtable;
import com.ct.util.lang.StrUtils;

public class DigitUtil {

	/**
	 * 汉字中的数字字符
	 */
	private static final Character[] SCDigits = { '零','一', '二', '三', '四', '五',
			'六', '七', '八', '九' };

	/**
	 * 阿拉伯数字
	 */
	private static final Character[] araDigits = { '0', '1', '2', '3', '4',
			'5', '6', '7', '8', '9' };

	/**
	 * 阿拉伯数字
	 */
	private static Hashtable<Character, Character> araHash = new Hashtable<Character, Character>();

	/**
	 * 阿拉伯数字
	 */
	private static Hashtable<Character, Integer> YWQBSHash = new Hashtable<Character, Integer>();

	static {
		for (int i = 0; i < SCDigits.length; i++) {
			araHash.put(SCDigits[i], araDigits[i]);
		}
		YWQBSHash.put('亿', 100000000);
		YWQBSHash.put('万', 10000);
		YWQBSHash.put('千', 1000);
		YWQBSHash.put('百', 100);
		YWQBSHash.put('十', 10);
	}

	/**
	 * @param remain 剩下多少个字符
	 * @param curchar 当前分析的字符
	 */
	private static int ywqbs(int num, Boolean bool, int no, int remain,
			char curchar, char lastshow) {
		if (num == 0) {
			num += no;
			return num;
		}
		String numString = String.valueOf(num); // 将num转换成String
		String last = numString.substring(numString.length() - 1, numString
				.length()); // 获取最后一个字符
		String exceptlast = numString.substring(0, numString.length() - 1); // 获取除了最后一个字符所有字符串
		if (exceptlast.length() == 0) { // 说明num是个位值
			num = Integer.parseInt(last) * no;
			return num;
		}
		/***** 针对有连续的这些字符[十百千万亿] start *****/
		if (bool && (YWQBSHash.get(curchar) > YWQBSHash.get(lastshow))) { // 说明上个字符属于[十百千万亿]
			num *= no;
			return num;
		}
		/***** 针对有连续的这些字符[十百千万亿] end *****/
		/***** 分析到最后一个字符 start *****/
		/**** 针对这种情况(一千二百二十一万) ****/
		if ((remain == 1) && (YWQBSHash.get(curchar) > YWQBSHash.get(lastshow))) {
			num *= YWQBSHash.get(curchar);
			return num;
		}
		/**** 针对这种情况(一千二百二十一万) ****/
		/***** 分析到最后一个字符 end *****/
		/***** last如果为0 start *****/
		if (last.equals("0")) { // 循环到最后一位字符,last等于0
			last = "1"; // 
		}
		/***** last如果为0 end *****/
		exceptlast = exceptlast + "0"; // 缺少最后一位,需要补上
		num = Integer.parseInt(exceptlast) + Integer.parseInt(last) * no;
		return num;
	}

	public static int parse(String word) {
		int num = 0;
		char lastchar = '一'; // 上次字符,字符特指[十百千万亿],默认随便填写一个'一'
		char lastshow = '一'; // 上次出现的字符,字符特指[十百千万亿],默认随便填写一个'一'
		char[] ch = word.toCharArray();
		Boolean bool = false; // 是否连续出现[十百千万亿]
		for (int i = 0; i < ch.length; i++) {
			Character find = araHash.get(ch[i]);
			if (find != null) {
				num += Integer.parseInt(String.valueOf(find.charValue()));
				bool = false;
				lastchar = '一'; // 恢复到默认值
				continue;
			} else if (ch[i] == '十') {
				num = ywqbs(num, bool, 10, ch.length - i, ch[i], lastshow);
				bool = true;
				lastchar = '十';
				lastshow = '十';
			} else if (ch[i] == '千') {
				num = ywqbs(num, bool, 1000, ch.length - i, ch[i], lastshow);
				bool = true;
				lastchar = '千';
				lastshow = '千';
			} else if (ch[i] == '百') {
				num = ywqbs(num, bool, 100, ch.length - i, ch[i], lastshow);
				bool = true;
				lastchar = '百';
				lastshow = '百';
			} else if (ch[i] == '万') {
				num = ywqbs(num, bool, 10000, ch.length - i, ch[i], lastshow);
				bool = true;
				lastchar = '万';
				lastshow = '万';
			}
		}
		ch = null;
		return num;
	}

	public static String getChineseNumber(int num) {
		if (num == 1) {
			return "一";
		} else if (num == 2) {
			return "二";
		} else if (num == 3) {
			return "三";
		} else if (num == 4) {
			return "四";
		} else if (num == 5) {
			return "五";
		} else if (num == 6) {
			return "六";
		} else if (num == 7) {
			return "七";
		} else if (num == 8) {
			return "八";
		} else if (num == 9) {
			return "九";
		} else if (num == 10) {
			return "十";
		} else {
			return String.valueOf(num);
		}
	}

	public static String yuanTowan(Integer price) {
		if (price != null) {
			double dPrice = price;
			return to2Double(dPrice / 10000) + "";
		}
		return "";
	}

	public static double to2Double(double num) {
		if ((num != 0.0) && (num != -1.0)) {
			num = Math.floor(num * 100 + .5) / 100;
		}
		return num;
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
		if (StrUtils.isNotNull(yuanPrice) && !yuanPrice.equals("0")) {
			double price = Double.parseDouble(yuanPrice);
			return (int) (price * 100);
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
}

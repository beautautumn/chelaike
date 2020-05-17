package com.ct.erp.common.utils;

import org.apache.commons.lang3.StringUtils;

public class ColorUtils {

	/**
	 * 计算十六进制表示颜色的反色
	 * 
	 * @param rgb
	 * @return
	 */
	public static String calcReverseColor(String rgb) {
		if (StringUtils.isEmpty(rgb)) {
			return rgb;
		}
		if (rgb.length() != 7) {
			return rgb;
		}

		String revR = addPlaceHolder(Integer.toHexString(255 - Integer
				.parseInt(rgb.substring(1, 3), 16)));
		String revG = addPlaceHolder(Integer.toHexString(255 - Integer
				.parseInt(rgb.substring(3, 5), 16)));
		String revB = addPlaceHolder(Integer.toHexString(255 - Integer
				.parseInt(rgb.substring(5, 7), 16)));
		return revR + revG + revB;

		// String strG = Integer.parseInt(rgb.substring(3, 4));
		// String strB = Integer.parseInt(rgb.substring(5, 6));
	}

	private static String addPlaceHolder(String str) {
		if (str.length() == 1) {
			return "0" + str;
		}
		return str;
	}
}

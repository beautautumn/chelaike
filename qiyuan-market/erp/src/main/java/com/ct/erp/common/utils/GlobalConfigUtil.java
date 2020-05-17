package com.ct.erp.common.utils;

import java.util.ResourceBundle;

public class GlobalConfigUtil {

	private static ResourceBundle bundle;

	/** 默认的配置文件 */
	private static final String fileName = "config/global";

	public static String get(String key) {
		return GlobalConfigUtil.bundle.getString(key);
	}

	static {
		GlobalConfigUtil.bundle = ResourceBundle
				.getBundle(GlobalConfigUtil.fileName);
	}

}

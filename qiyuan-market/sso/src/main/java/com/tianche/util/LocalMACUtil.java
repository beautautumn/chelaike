package com.tianche.util;

import javax.servlet.http.HttpServletRequest;

public class LocalMACUtil {


	public static String getLocalMacAndIp(HttpServletRequest request)
			throws Exception {
		String ip = request.getHeader("x-forwarded-for");
	    if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
	      ip = request.getHeader("Proxy-Client-IP");
	    }
	    if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
	      ip = request.getHeader("WL-Proxy-Client-IP");
	    }
	    if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
	      ip = request.getRemoteAddr();
	    }

	    return "(ip:" + ip + ")";
	}


}

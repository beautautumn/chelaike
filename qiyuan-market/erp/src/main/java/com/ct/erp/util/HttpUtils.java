package com.ct.erp.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.CoreConnectionPNames;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.apache.http.util.EntityUtils;

import com.ct.erp.constants.sysconst.Const;

 

public class HttpUtils {

	public static String sendPost(String url, String param, String charSet) {
		String result = "";
		if (url == null || "".equals(url)) {
			return result;
		}
		try {
			URL httpurl = new URL(url);
			HttpURLConnection httpConn = (HttpURLConnection) httpurl.openConnection();
			httpConn.setConnectTimeout(60000);
			httpConn.setReadTimeout(60000);
			httpConn.setDoOutput(true);
			httpConn.setDoInput(true);
			PrintWriter out = new PrintWriter(httpConn.getOutputStream());
			out.print(param);
			out.flush();
			out.close();

			BufferedReader in = new BufferedReader(new InputStreamReader(
					httpConn.getInputStream(), charSet));

			String line;
			while ((line = in.readLine()) != null) {
				result += line;
			}

			in.close();
		} catch (Exception e) {
			return "timeOut";
		}
		return result;
	}

	public static String sendGet(String url) {
		HttpGet httpGet = new HttpGet(url);
		try {
			HttpClient client = new DefaultHttpClient();
			// 请求超时
            client.getParams().setParameter(CoreConnectionPNames.CONNECTION_TIMEOUT, 30000);
            // 读取超时
            client.getParams().setParameter(CoreConnectionPNames.SO_TIMEOUT, 30000);
			HttpResponse hp = client.execute(httpGet);
			if (hp.getStatusLine().getStatusCode() == 200) {
				return EntityUtils.toString(hp.getEntity());
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "timeOut";
		}
		return "";
	}

	public static String sendLogin(String url, String param, String charSet) {
		String result = "";
		if (url == null || "".equals(url)) {
			return result;
		}
		try {
			URL httpurl = new URL(url);
			HttpURLConnection httpConn = (HttpURLConnection) httpurl
					.openConnection();
			httpConn.setConnectTimeout(6000);
			httpConn.setReadTimeout(6000);
			httpConn.setDoOutput(true);
			httpConn.setDoInput(true);
			PrintWriter out = new PrintWriter(httpConn.getOutputStream());
			out.print(param);
			out.flush();
			out.close();

			BufferedReader in = new BufferedReader(new InputStreamReader(
					httpConn.getInputStream(), charSet));

			String line;
			while ((line = in.readLine()) != null) {
				result += line;
			}

			in.close();
		} catch (Exception e) {
			return "timeOut";
		}
		return result;
	}

	 

	public static String sendHttpPost(String url, List<NameValuePair> params,
			String charSet) {
		String result = "";
		if (url == null || "".equals(url)) {
			return result;
		}
		try {
			HttpPost httpRequest  = new HttpPost(url);
			httpRequest.setEntity(new UrlEncodedFormEntity(params, charSet));
			HttpParams httpParameters = new BasicHttpParams();
			HttpConnectionParams.setConnectionTimeout(httpParameters, 20000);
			HttpConnectionParams.setSoTimeout(httpParameters, 20000);
			HttpClient client = new DefaultHttpClient(httpParameters);
			HttpResponse respons = client.execute(httpRequest);
			if (respons.getStatusLine().getStatusCode() == 200) {
				result = EntityUtils.toString(respons.getEntity());
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "timeOut";
		}
		return result;
	}
	  
	public static void main(String args[]){
    	String str = HttpUtils.sendGet("http://47.93.43.192/ewalker-web/controller/getBrandList");
    	System.out.println(str);
	}
}

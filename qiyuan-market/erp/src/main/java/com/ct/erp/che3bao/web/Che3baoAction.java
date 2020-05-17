package com.ct.erp.che3bao.web;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.util.URIUtil;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;


@Scope("prototype")
@Controller("che3bao.webInterfaceAction")
public class Che3baoAction {
    private static Logger log = Logger.getLogger(Che3baoAction.class);
    private static final String list_url = "http://api.che3bao.com/api/stock/list";   
    private static final String detail_url = "http://api.che3bao.com/api/stock/detail";   
	
    
    public static void getVehicleList(){
    	try
    	{
		    GetMethod method = new GetMethod(list_url);
		    String rJson="";
		    String accessToken ="2bb9f632cf7301ef8ad6b9b29042497d";//被调用方提供的消息调用令牌
		    try
		    {
				//通过以下方法可以模拟页面参数提交
			    StringBuffer queryString =new StringBuffer();
			    queryString.append("accessToken=");
			    queryString.append(accessToken);
			    queryString.append("&brandName=");
			    queryString.append("&seriesName=");
			    queryString.append("&catalogueName=");
			    queryString.append("&priceLow=");
			    queryString.append("&priceHigh=");
			    queryString.append("&carAgeLow=");
			    queryString.append("&carAgeHigh=");
			    queryString.append("&mileageLow=");
			    queryString.append("&mileageHigh=");				   
			    queryString.append("&mileageLow=");				   
			    queryString.append("&mileageHigh=");				   
			    queryString.append("&ovLow=");				   
			    queryString.append("&ovHigh=");				   
			    queryString.append("&carColor=");				   
			    queryString.append("&stockState=1");				   
			    queryString.append("&showHasPic=0");				   
			    queryString.append("&showNoPrice=0");				   
			    queryString.append("&sortBy=");				   
			    queryString.append("&pageSize=9999");				   
			    queryString.append("&pageNum=1");	
			    String str1 =queryString.toString();
			    
			    HttpClient client = new HttpClient();
			    client.getHttpConnectionManager().getParams().setConnectionTimeout(5000);
			    if (StringUtils.isNotBlank(str1)) 
                    method.setQueryString(URIUtil.encodeQuery(str1)); 
	            client.executeMethod(method); 
	            if (method.getStatusCode() == HttpStatus.SC_OK) { 
	            	rJson = method.getResponseBodyAsString(); 
	            } 
			    dealVehicleInfo(rJson);
		   }
		   catch(Exception e)
		   {
			  rJson ="";
			  log.error(e);
		   }
		   finally
		   {
			   method.releaseConnection(); 
		   }
		 
    	}
    	catch(Exception e)
    	{
    	  log.error(e);
    	}
    }
	
	private static void dealVehicleInfo(String responseBody){
		JSONObject obj =JSONObject.fromObject(responseBody);
		if(obj.has("res") && obj.getJSONObject("res").has("code") 
				&& obj.getJSONObject("res").getString("code").equals("0000"))
		{
			JSONObject o = null;
			JSONArray arr = obj.getJSONObject("result").getJSONArray("rows");
			StringBuffer str = new StringBuffer();
			for(int i=0;i<arr.size();i++){
				o=arr.getJSONObject(i);
	            str.append(o.getString("stockId"));
	            str.append(",");
	            break;
			} 
			String ids= str.substring(0, str.length()-1);
			getVehicleDetail(ids);
		}
		
   	}
	
	private static void getVehicleDetail(String ids){
    	try
    	{
		    GetMethod method = new GetMethod(detail_url);
		    String rJson="";
		    String accessToken ="2bb9f632cf7301ef8ad6b9b29042497d";//被调用方提供的消息调用令牌
		    try
		    {
				//通过以下方法可以模拟页面参数提交
			    StringBuffer queryString =new StringBuffer();
			    queryString.append("accessToken=");
			    queryString.append(accessToken);
			    queryString.append("&stockId=");
			    queryString.append(ids);
			    queryString.append("&pageSize=9999");				   
			    queryString.append("&pageNum=1");	
			    String str1 =queryString.toString();
			    
			    HttpClient client = new HttpClient();
			    client.getHttpConnectionManager().getParams().setConnectionTimeout(5000);
			    if (StringUtils.isNotBlank(str1)) 
                    method.setQueryString(URIUtil.encodeQuery(str1)); 
	            client.executeMethod(method); 
	            if (method.getStatusCode() == HttpStatus.SC_OK) { 
	            	rJson = method.getResponseBodyAsString(); 
	            } 
	            log.debug(rJson);
		   }
		   catch(Exception e)
		   {
			  rJson ="";
			  log.error(e);
		   }
		   finally
		   {
			   method.releaseConnection(); 
		   }
		 
    	}
    	catch(Exception e)
    	{
    	  log.error(e);
    	}
		
	}
	
	public static void main(String[] args){
		getVehicleList();
	}
	
}

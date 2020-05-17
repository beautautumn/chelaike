package com.ct.erp.wx.util;


import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URL;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;


/**
 * Https访问工具类
 * @author admin
 * @version 2014-6-26
 * @see HttpsAccessUtil
 * @since
 */
public class HttpsAccessUtil
{

    /**
     * 日志 
     */
    private static Logger log = Logger.getLogger(HttpsAccessUtil.class);


    /**
     * 发起https请求并获取结果
     * 
     * @param requestUrl 请求地址
     * @param requestMethod 请求方式（GET、POST）
     * @param attachments 附加提交的数据，可以是单字符串{"json":"value"} 或者 多个参数遵循 A=a&B=b格式
     * @return remoteHttps 返回的结果
     */
    public static String httpsRequest(String requestUrl, String requestMethod, String attachments)
    {
        HttpsURLConnection httpUrlConn = null;
        InputStream inputStream = null;
        InputStreamReader inputStreamReader = null;
        BufferedReader bufferedReader = null;
        OutputStream outputStream = null;
        StringBuilder buffer = new StringBuilder();
        try
        {
            //bug fiexd for: javax.net.ssl.SSLProtocolException: handshake alert: unrecognized_name
            System.setProperty ("jsse.enableSNIExtension", "false");
            
            // 创建SSLContext对象，并使用我们指定的信任管理器初始化
            TrustManager[] tm = {new MyX509TrustManager()};
            SSLContext sslContext = SSLContext.getInstance("SSL", "SunJSSE");
            sslContext.init(null, tm, new java.security.SecureRandom());

            // 从上述SSLContext对象中得到SSLSocketFactory对象
            SSLSocketFactory ssf = sslContext.getSocketFactory();

            URL url = new URL(requestUrl);
            httpUrlConn = (HttpsURLConnection)url.openConnection();
            httpUrlConn.setSSLSocketFactory(ssf);

            //bug fixed for: java.security.cert.CertificateException: No subject alternative DNS name matching
            httpUrlConn.setHostnameVerifier(new CustomizedHostnameVerifier());
            
            httpUrlConn.setDoOutput(true);
            httpUrlConn.setDoInput(true);
            httpUrlConn.setUseCaches(false);

            //使用json格式通信
            //httpUrlConn.setRequestProperty("Content-Type", "application/json;charset=UTF-8");

            // 设置请求方式（GET/POST）
            httpUrlConn.setRequestMethod(requestMethod);
            httpUrlConn.connect();

            // 当有额外数据需要提交时
            if (!StringUtils.isBlank(attachments))
            {
                outputStream = httpUrlConn.getOutputStream();
                // 注意编码格式，防止中文乱码
                outputStream.write(attachments.getBytes("UTF-8"));
                outputStream.flush();
                outputStream.close();
            }
            // 将返回的输入流转换成字符串
            inputStream = httpUrlConn.getInputStream();
            inputStreamReader = new InputStreamReader(inputStream, "UTF-8");
            bufferedReader = new BufferedReader(inputStreamReader);

            String str = null;
            while ((str = bufferedReader.readLine()) != null)
            {
                buffer.append(str);
            }
        }
        catch (Exception e)
        {
            log.error("https request error ", e);
        }
        finally
        {
            try
            {
                IOUtils.closeQuietly(bufferedReader);
                IOUtils.closeQuietly(inputStreamReader);
                IOUtils.closeQuietly(inputStream);
                IOUtils.closeQuietly(outputStream);
                if (httpUrlConn != null)
                {
                    httpUrlConn.disconnect();
                }
            }
            catch (Exception e)
            {
                log.error(e);
            }
        }
        return buffer.toString();
    }

    public static void main(String[] args)
    {
        //微信请求httpsURL
        String requestUrl = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=appid&secret=appsecret";

        //GET请求
        String httpsRsp = HttpsAccessUtil.httpsRequest(requestUrl, "POST", "{\"json\":\"json\"}");

        System.out.print("request remote AccessToken, return rsp is " + httpsRsp);
    }
}
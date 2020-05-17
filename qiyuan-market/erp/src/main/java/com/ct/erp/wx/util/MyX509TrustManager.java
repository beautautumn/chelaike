/*
 * 文件名：MyX509TrustManager.java
 * 版权：
 * 描述：
 * 修改人：admin
 * 修改时间：2014-6-26
 * 跟踪单号：
 * 修改单号：
 * 修改内容：
 */

package com.ct.erp.wx.util;

import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;

import javax.net.ssl.X509TrustManager;


/**
 * 证书信任管理器（用于https请求） 
 * 这个证书管理器的作用就是让它信任我们指定的证书，上面的代码意味着信任所有证书，不管是否权威机构颁发
 * @author admin
 * @version 2014-6-26
 * @see MyX509TrustManager
 * @since
 */
public class MyX509TrustManager implements X509TrustManager
{

    @Override
    public void checkClientTrusted(X509Certificate[] arg0, String arg1)
        throws CertificateException
    {

    }

    @Override
    public void checkServerTrusted(X509Certificate[] arg0, String arg1)
        throws CertificateException
    {

    }

    @Override
    public X509Certificate[] getAcceptedIssuers()
    {
        return null;
    }

}

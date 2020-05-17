/*
 * 文件名：CustomizedHostnameVerifier.java
 * 版权：
 * 描述：
 * 修改人：admin
 * 修改时间：2014-8-15
 * 跟踪单号：
 * 修改单号：
 * 修改内容：
 */

package com.ct.erp.wx.util;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLSession;


/**
 * HostnameVerifier
 * bug fixed : <http://iteches.com/archives/45015>
 * @author admin
 * @version 2014-8-15
 * @see CustomizedHostnameVerifier
 * @since
 */
public class CustomizedHostnameVerifier implements HostnameVerifier
{

    @Override
    public boolean verify(String arg0, SSLSession arg1)
    {
        return true;
    }

}

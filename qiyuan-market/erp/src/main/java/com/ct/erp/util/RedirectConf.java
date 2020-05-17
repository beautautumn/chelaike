package com.ct.erp.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class RedirectConf {
    private static final Properties properties = new Properties();
    static{
        InputStream in = RedirectConf.class.getResourceAsStream("/config/redirect.properties");
        try {
            properties.load(in);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    public static String getRedirectByServerName(String serverName){
        return properties.getProperty("nologin."+serverName);
    }
}

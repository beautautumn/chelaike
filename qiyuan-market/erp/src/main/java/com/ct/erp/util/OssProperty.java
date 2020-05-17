package com.ct.erp.util;


import java.io.IOException;
import java.util.Properties;

public class OssProperty {
    private static String endPoint;
    private static String accessKeyId;
    private static String accessKeySecret;
    private static String bucket;
    private static String host;

    static{
        Properties property = new Properties();
        try {
            property.load(OssProperty.class.getResourceAsStream("/oss.properties"));
            endPoint = property.getProperty("endPoint");
            accessKeyId = property.getProperty("accessKeyId");
            accessKeySecret = property.getProperty("accessKeySecret");
            bucket = property.getProperty("bucket");
            host = property.getProperty("host");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static String getEndPoint() {
        return endPoint;
    }

    public static String getAccessKeyId() {
        return accessKeyId;
    }

    public static String getAccessKeySecret() {
        return accessKeySecret;
    }

    public static String getBucket() {
        return bucket;
    }

    public static String getHost() {
        return host;
    }
}

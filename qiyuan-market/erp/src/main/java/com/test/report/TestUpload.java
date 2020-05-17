package com.test.report;

import com.aliyun.oss.OSSClient;
import com.aliyun.oss.model.PutObjectResult;
import com.ct.erp.util.OssProperty;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.UUID;

/**
 * 测试上传到阿里云
 */
public class TestUpload {


    /**
     * accessKeyId=oppOculaV6cUtaeB
     accessKeySecret=6cgzciZxRaXBTOSOAACgf1MHP0qDwl
     bucket=prime
     endPoint=http://oss-cn-hangzhou-internal.aliyuncs.com
     host=http://prime.oss-cn-hangzhou.aliyuncs.com
     */

    public static void main(String[] args) throws IOException {

        String endpoint = "http://oss-cn-hangzhou-internal.aliyuncs.com";
        String accessKeyId = "oppOculaV6cUtaeB";
        String accessKeySecret = "6cgzciZxRaXBTOSOAACgf1MHP0qDwl";
        // 创建OSSClient实例
        OSSClient ossClient = new OSSClient(endpoint, accessKeyId, accessKeySecret);

        //File source = new File("\"D:\\\\demo.png\"");
        // 上传文件流
         InputStream inputStream = new FileInputStream(new File("D:\\demo.png"));
        String folderName = "report/" + "file";

        String key = folderName + "/" + UUID.randomUUID();

        String vehicleBucket = "prime";

        //PutObjectResult result = ossClient.putObject(vehicleBucket, key, new File("C:\\demo.png"));
        PutObjectResult result = ossClient.putObject(vehicleBucket, key,inputStream);
        // 关闭client
        System.out.println((OssProperty.getHost() + "/" + key));
        ossClient.shutdown();
    }

}

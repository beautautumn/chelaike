package com.ct.erp.util;

import java.io.InputStream;
import java.net.URL;
import java.util.Date;

import org.apache.log4j.Logger;

import com.aliyun.oss.OSSClient;
import com.aliyun.oss.model.GeneratePresignedUrlRequest;
import com.aliyun.oss.model.OSSObject;
import com.aliyun.oss.model.ObjectMetadata;
import com.aliyun.oss.model.PutObjectResult;
import com.cloudtrend.erprocks.util.LogUtil;

public class AliyunOssAPIUtil {
	
	private static final Logger logger = Logger.getLogger(AliyunOssAPIUtil.class);
	
	public static String ACCESS_KEY_ID = null;
	public static String ACCESS_KEY_SECRET = null;
	public static String ENDPOINT = null;
	public static String BUCKETNAME = null;
	public static String BUCKETNAME_VIDEO = null;
	public static String OUT_OF_DATE = null;
	private OSSClient client = null;
	private ObjectMetadata meta = null;

	static {
		try {
//			ACCESS_KEY_ID = SysConst.getProperty("OSS_ACCESS_KEY_ID");
//			ACCESS_KEY_SECRET = SysConst.getProperty("OSS_ACCESS_KEY_SECRET");
//			ENDPOINT = SysConst.getProperty("OSS_ENDPOINT");
//			BUCKETNAME = SysConst.getProperty("OSS_BUCKETNAME");
//			BUCKETNAME_VIDEO = SysConst.getProperty("OSS_BUCKETNAME_VIDEO");
//			OUT_OF_DATE = SysConst.getProperty("OSS_OUT_OF_DATE");
		} catch (java.lang.Exception e) {
			e.printStackTrace();
		}
	}

	public void init() {
		// 初始化一个OSSClient
		client = new OSSClient(ENDPOINT, ACCESS_KEY_ID, ACCESS_KEY_SECRET);
		meta = new ObjectMetadata();
	}

	/**
	 * @Description: 上传文件到OSS文件服务器
	 * @param content
	 *            文件流
	 * @param key
	 *            上传为OSS文件服务器的唯一标识
	 * @param mimeType
	 *            文档类型
	 * @throws Exception
	 * @ReturnType:String OSSObject的ETag值。
	 */
	public String uploadFile(InputStream content, String key, String mimeType) throws Exception {
		// 进行初始化
		init();
		// 必须设置ContentLength
		meta.setContentType(mimeType);
		// 上传Object.
		logger.debug("*****************上传图片到oss服务器开始*****************" + key);
		PutObjectResult result = client.putObject(BUCKETNAME, key, content, meta);
		logger.debug("*****************上传图片到oss服务器结束*****************" + key);
		return result.getETag();
	}

	/**
	 * @Description: 根据key获取oss服务器上的图片地址
	 * @param key
	 * @return
	 * @ReturnType:String
	 */
	public String getImgURl(String key) {
		init();
		Date expires = new Date(new Date().getTime() + Integer.parseInt(OUT_OF_DATE)); // 30
																						// minute
																						// to
																						// expire
		GeneratePresignedUrlRequest generatePresignedUrlRequest;
		if (key.startsWith("msplatform")) {
			generatePresignedUrlRequest = new GeneratePresignedUrlRequest(BUCKETNAME, key);
		} else {
			generatePresignedUrlRequest = new GeneratePresignedUrlRequest(BUCKETNAME_VIDEO, key);
		}
		generatePresignedUrlRequest.setExpiration(expires);
		URL url = client.generatePresignedUrl(generatePresignedUrlRequest);
		return url.toString();
	}

	/**
	 * @Description:根据key获取oss服务器上的ipa文件地址
	 * @param key
	 * @return
	 * @ReturnType:String
	 */
	public String getIpaURl(String key) {
		init();
		Date expires = new Date(new Date().getTime() + 10 * 365 * 24 * 3600 * 1000);
		GeneratePresignedUrlRequest generatePresignedUrlRequest;
		if (key.startsWith("msplatform")) {
			generatePresignedUrlRequest = new GeneratePresignedUrlRequest(BUCKETNAME, key);
		} else {
			generatePresignedUrlRequest = new GeneratePresignedUrlRequest(BUCKETNAME_VIDEO, key);
		}
		generatePresignedUrlRequest.setExpiration(expires);
		URL url = client.generatePresignedUrl(generatePresignedUrlRequest);
		return url.toString();
	}

	/**
	 * @Description: 根据key获取oss服务器上的图片地址
	 * @param key
	 * @return
	 * @ReturnType:String
	 */
	public InputStream getObject(String key) {
		init();
		OSSObject object = null;
		if (key.startsWith("msplatform")) {
			object = client.getObject(BUCKETNAME, key);
		} else {
			object = client.getObject(BUCKETNAME_VIDEO, key);
		}
		object.getObjectMetadata().getContentType();
		// 获取Object的输入流
		InputStream objectContent = object.getObjectContent();

		return objectContent;
	}

	/**
	 * @Description:删除文件
	 * @param key
	 *            OSS文件服务器上文件的唯一标识
	 * @ReturnType:void
	 */
	public void deleteFile(String key) {
		init();
		client.deleteObject(BUCKETNAME, key);
	}

	/**
	 * @Description: 断点上传文件到OSS文件服务器
	 * @param content
	 *            文件流
	 * @param key
	 *            上传为OSS文件服务器的唯一标识
	 * @param position
	 *            位置
	 */
//	public String appendObjectFile(InputStream content, String key, int position, String mimeType) throws Exception {
//		// 进行初始化
//		init();
//		// 必须设置ContentLength
//		meta.setContentLength(position);
//		meta.setContentType(mimeType);
//		meta.setCacheControl("no-cache");
//		meta.setContentEncoding("utf-8");
//		// 上传
//		logger.debug("*****************断点上传图片到oss服务器开始*****************" + key);
//		AppendObjectRequest appendObjectRequest = new AppendObjectRequest(BUCKETNAME, key, content, meta);
//		appendObjectRequest.setPosition(Long.valueOf(position));
//		AppendObjectResult appendObjectResult = client.appendObject(appendObjectRequest);
//		LogUtil.printConsoleLog("*****************断点上传图片到oss服务器结束*****************" + key);
//		return appendObjectResult.getNextPosition().toString();
//	}

}

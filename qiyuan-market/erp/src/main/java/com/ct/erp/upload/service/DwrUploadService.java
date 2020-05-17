package com.ct.erp.upload.service;

import org.directwebremoting.WebContextFactory;
import org.directwebremoting.io.FileTransfer;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;

/**
 * Created by x on 2017/9/13.
 */
@Service
public class DwrUploadService {
    /**
     * 上传文件
     * @param uploadFile InputStream 类型为file的input域
     * @param fileUrl String 上传路劲
     * @param fileName String 文件名
     * @return String
     */
    public static String uploadFile(FileTransfer uploadFile, String fileUrl, String fileName) throws Exception {
        if (uploadFile != null && uploadFile.getSize() > 0) {
            fileUrl = getRealPath(fileUrl);
            File dir = new File(fileUrl);
            if (!dir.exists() || !dir.isDirectory()) {
                dir.mkdirs();
            }
            File file = new File(dir, fileName);
            InputStream is = uploadFile.getInputStream();
            int available = is.available();
            byte[] b = new byte[available];
            FileOutputStream fos = new FileOutputStream(file);
            is.read(b);
            fos.write(b);
            fos.flush();
            fos.close();
            is.close();
            fos = null;
            is = null;
            uploadFile = null;
            return fileUrl + "/" + fileName;
        } else {
            return null;
        }
    }

    /**
     * 返回 web root 下的某个目录
     * @param dir String
     * @return String
     */
    public static String getRealPath(String dir) {
        return WebContextFactory.get().getServletContext().getRealPath(dir);
    }

}

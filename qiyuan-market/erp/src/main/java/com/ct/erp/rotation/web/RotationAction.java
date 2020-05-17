package com.ct.erp.rotation.web;

import com.alibaba.fastjson.JSON;
import com.aliyun.oss.OSSClient;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.Market;
import com.ct.erp.lib.entity.Rotation;
import com.ct.erp.market.dao.MarketDao;
import com.ct.erp.market.service.MarketService;
import com.ct.erp.market.service.ServiceResult;
import com.ct.erp.rotation.dao.RotationDao;
import com.ct.erp.sys.dao.StaffDao;
import com.ct.erp.util.Base64Image;
import com.ct.erp.util.OssProperty;
import com.ct.erp.util.UIDGenerator;
import com.ct.erp.util.UcmsWebUtils;
import com.tianche.common.AliUpload;
import org.apache.commons.codec.binary.Hex;
import org.apache.commons.lang3.StringUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Timestamp;
import java.util.Base64;
import java.util.Date;
import java.util.UUID;


@SuppressWarnings("serial")
@Scope("prototype")
@Controller("qiyuan.rotationAction")
public class RotationAction extends SimpleActionSupport{
    @Autowired
    private RotationDao rotationDao;

    private File rotationFile;//命名应该和上传页面name属性值保持一致
    private Rotation rotation;
    private String rotationFileBase64;
    private Long rotationId;

    public String toCreate(){
        return "toCreate";
    }
    public String toEdit(){
        rotation = rotationDao.get(rotationId);
        return "toEdit";
    }
    public String toDelete(){
        Rotation rotation = rotationDao.get(rotationId);
        int cnt = rotationDao.countByType(rotation.getRotationType());
        if(cnt <=1 ){
            return "toCannotdelete";
        }
        return "toDelete";
    }
    public void delete(){
        Rotation rotation = rotationDao.get(rotationId);
        int cnt = rotationDao.countByType(rotation.getRotationType());
        if(cnt <=1 ){
            HttpServletResponse response = ServletActionContext.getResponse();
            UcmsWebUtils.ajaxOutPut(response, "已删除4张轮播图，本次无法执行删除操作。");
        }else {
            String folderName = "rotation/" + rotation.getRotationType();
            String key = folderName + "/" + rotation.getName();
            rotationDao.delete(rotation);
            rotationDao.getSession().flush();
            OSSClient ossClient = getOssClient();
            String vehicleBucket = OssProperty.getBucket();
            ossClient.deleteObject(vehicleBucket, key);
            HttpServletResponse response = ServletActionContext.getResponse();
            UcmsWebUtils.ajaxOutPut(response, "success");
        }
    }
    public void create(){
        CheckResult checkResult = checkTypeCnt();
        if(checkResult.getPass()) {
            rotation.setCreateAt(new Timestamp(System.currentTimeMillis()));
            rotation.setUpdateAt(new Timestamp(System.currentTimeMillis()));
            rotation.setUuid(getUUID());
            try {
                OSSClient ossClient = getOssClient();
                String vehicleBucket = OssProperty.getBucket();
                String folderName = "rotation/" + rotation.getRotationType();
                Base64.Decoder decoder = Base64.getDecoder();
                byte[] bytes = decoder.decode(rotationFileBase64);
                String key = folderName + "/" + rotation.getName()+rotation.getUuid();
                ossClient.putObject(vehicleBucket, key, new ByteArrayInputStream(bytes));
                rotation.setUrl(OssProperty.getHost() + "/" + key);
            } catch (Exception e) {
                e.printStackTrace();
            }
            rotationDao.save(rotation);
            HttpServletResponse response = ServletActionContext.getResponse();
            UcmsWebUtils.ajaxOutPut(response, "success");
        }else{
            HttpServletResponse response = ServletActionContext.getResponse();
            UcmsWebUtils.ajaxOutPut(response, checkResult.getMessage());
        }
    }

    private String getUUID() {
        return UUID.randomUUID().toString().replaceAll("- ", "");
    }

    public void edit(){
        CheckResult checkResult = checkTypeCnt();
        if(checkResult.getPass()) {
            Rotation rotation = rotationDao.load(this.rotation.getId());
            String oldFolderName = "rotation/" + rotation.getRotationType();
            String oldKey = oldFolderName + "/" + rotation.getName()+rotation.getUuid();
            rotation.setUpdateAt(new Timestamp(System.currentTimeMillis()));
            rotation.setName(this.rotation.getName());
            rotation.setRedirectUrl(this.rotation.getRedirectUrl());
            rotation.setRotationType(this.rotation.getRotationType());
            rotation.setSorting(this.rotation.getSorting());
            try {
                String vehicleBucket = OssProperty.getBucket();
                OSSClient ossClient = getOssClient();
                if (StringUtils.isNotBlank(rotationFileBase64)) {
                    String uuid = getUUID();
                    rotation.setUuid(uuid);
                    String folderName = "rotation/" + rotation.getRotationType();
                    Base64.Decoder decoder = Base64.getDecoder();
                    byte[] bytes = decoder.decode(rotationFileBase64);
                    String key = folderName + "/" + rotation.getName()+rotation.getUuid();
                    ossClient.deleteObject(vehicleBucket, oldKey);
                    ossClient.putObject(vehicleBucket, key, new ByteArrayInputStream(bytes));
                    rotation.setUrl(OssProperty.getHost() + "/" + key);
                }
                rotationDao.getSession().flush();
                HttpServletResponse response = ServletActionContext.getResponse();
                UcmsWebUtils.ajaxOutPut(response, "success");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }else{
            HttpServletResponse response = ServletActionContext.getResponse();
            UcmsWebUtils.ajaxOutPut(response, checkResult.getMessage());
        }
    }

    private CheckResult checkTypeCnt() {
        int cnt = rotationDao.countByTypeAndId(rotation.getRotationType(), rotation.getId());
        String rotationType = rotation.getRotationType();
        String appName = "";
        if(StringUtils.equals(rotationType, "shop")){
            appName = "车商APP";
        }
        if(StringUtils.equals(rotationType, "company")){
            appName = "经营公司APP";
        }

        CheckResult checkResult = new CheckResult();
        if(cnt >=5 ){
            checkResult.setPass(false);
            checkResult.setMessage(appName + "最多只允许上传5张轮播图.");
        }else {
            checkResult.setPass(true);
        }
        return checkResult;
    }

    private OSSClient getOssClient() {
        String endpoint = OssProperty.getEndPoint();
        String accessKeyId = OssProperty.getAccessKeyId();
        String accessKeySecret = OssProperty.getAccessKeySecret();
        return new OSSClient(endpoint, accessKeyId,accessKeySecret);
    }

    public File getRotationFile() {
        return rotationFile;
    }

    public void setRotationFile(File rotationFile) {
        this.rotationFile = rotationFile;
    }

    public Rotation getRotation() {
        return rotation;
    }

    public void setRotation(Rotation rotation) {
        this.rotation = rotation;
    }

    public String getRotationFileBase64() {
        return rotationFileBase64;
    }

    public void setRotationFileBase64(String rotationFileBase64) {
        this.rotationFileBase64 = rotationFileBase64;
    }

    public Long getRotationId() {
        return rotationId;
    }

    public void setRotationId(Long rotationId) {
        this.rotationId = rotationId;
    }

    private class CheckResult {
        private Boolean pass;
        private String message;

        public Boolean getPass() {
            return pass;
        }

        public void setPass(Boolean pass) {
            this.pass = pass;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }
    }
}

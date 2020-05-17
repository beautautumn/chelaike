package com.ct.erp.gateSystem.action;

import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.gateSystem.dao.GateInfoDao;
import com.ct.erp.lib.entity.GateInfoVO;
import com.ct.erp.util.MatrixToImageWriter;
import com.ct.erp.util.UcmsWebUtils;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.common.BitMatrix;
import org.apache.struts2.ServletActionContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by DeeWang on 2017-12-16.
 */
@SuppressWarnings("serial")
@Scope("prototype")
@Controller("qiyuan.gateInfoAction")
public class GateInfoAction extends SimpleActionSupport {
    private static final Logger logger = LoggerFactory.getLogger(GateInfoAction.class);
    private GateInfoVO gateInfoVO;

    @Autowired
    private GateInfoDao gateInfoDao;
    private String urlCode;
    /*
    * 初始化添加窗口
    * */
    public String initAdd(){
        return "initAdd";
    }
    /*
     * 初始化编辑窗口
     * */
    public String initEdit(){
        try {
            gateInfoVO = gateInfoDao.get(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "initEdit";
    }

    /*
     * 打印二维码
     * */
    public String initPrintCodePage(){
        try {
            gateInfoVO = gateInfoDao.get(id);
            urlCode="https://www.baidu.com";
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "initPrintCode";
    }

    /*
     * 新增闸口信息
     * */
    public String addGateInfo(){
        HttpServletResponse response = ServletActionContext.getResponse();
        try {
            gateInfoVO.setCreated_at(new Timestamp(System.currentTimeMillis()));
            gateInfoVO.setUpdated_at(new Timestamp(System.currentTimeMillis()));
            gateInfoDao.save(gateInfoVO);
            UcmsWebUtils.ajaxOutPut(response, "success");
        } catch (Exception e) {
            e.printStackTrace();
            UcmsWebUtils.ajaxOutPut(response, "false");
        }
        return null;
    }
    /*
     * 编辑闸口信息
     * */
    public String editGateInfo(){
        HttpServletResponse response = ServletActionContext.getResponse();
        try {
            Long gate_id = gateInfoVO.getId();
            GateInfoVO gateInfoToUpdate = gateInfoDao.load(gate_id);
            gateInfoToUpdate.setNo(gateInfoVO.getNo());
            gateInfoToUpdate.setName(gateInfoVO.getName());
            gateInfoToUpdate.setDirection(gateInfoVO.getDirection());
            gateInfoToUpdate.setUpdated_at(new Timestamp(System.currentTimeMillis()));
            gateInfoDao.getSession().flush();
            UcmsWebUtils.ajaxOutPut(response, "success");
        } catch (Exception e) {
            e.printStackTrace();
            UcmsWebUtils.ajaxOutPut(response, "false");
        }
        return null;
    }
    /*
     * 打印二维码
     * */
    public void getQRCodeStream(){
        HttpServletResponse response = ServletActionContext.getResponse();
        response.setContentType("image/png");
        try {
            OutputStream outputStream = response.getOutputStream();
            String url = "http://www.baidu.com";
            int width = 260; // 图像宽度
            int height = 260; // 图像高度
            String format = "png";// 图像类型

            Map<EncodeHintType, Object> hints = new HashMap<EncodeHintType, Object>();
            hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
            hints.put(EncodeHintType.MARGIN, 0);
            BitMatrix bitMatrix;
            bitMatrix = new MultiFormatWriter().encode(url, BarcodeFormat.QR_CODE, width, height, hints);
            MatrixToImageWriter.writeToStream(bitMatrix, format, outputStream);
            //用于小文件流转换
            String str = outputStream.toString();
            InputStream in = new ByteArrayInputStream(str.getBytes());
            OutputStream os = response.getOutputStream();  //创建输出流
            byte[] b = new byte[1024];
            while( in.read(b)!= -1){
                os.write(b);
            }
            in.close();
            os.flush();
            os.close();

        } catch (Exception e) {
            System.err.println("二维码输出错误！");
            e.printStackTrace();
        }finally{
            try {
                //fis.close();
            } catch (Exception e) {
            }
        }
    }
    public void setGateInfoVO(GateInfoVO gateInfoVO) {
        this.gateInfoVO = gateInfoVO;
    }

    public GateInfoVO getGateInfoVO() {
        return gateInfoVO;
    }

    public void setUrlCode(String urlCode) {
        this.urlCode = urlCode;
    }

    public String getUrlCode() {
        return urlCode;
    }
}

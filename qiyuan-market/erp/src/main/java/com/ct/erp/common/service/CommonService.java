package com.ct.erp.common.service;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.springframework.stereotype.Service;

import com.ct.erp.constants.sysconst.Const;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
@Service
public class CommonService {
	
	private int width = 105;

    private int height = 50;
	
	public void barcodePic(String barcode) {
        try {
        	File vehicleDir = new File(Const.IMAGE_SAVEPATH+"/barcode_pic/");
    		if (!vehicleDir.exists()) {
    			vehicleDir.mkdir();
    		}
            BitMatrix bitMatrix = new MultiFormatWriter().encode(barcode,
                    BarcodeFormat.CODE_39, width, height, null);
            File file = new File(Const.IMAGE_SAVEPATH+"/barcode_pic/"+barcode+".png");
            MatrixToImageWriter.writeToFile(bitMatrix, "png", file);
        } catch (WriterException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}

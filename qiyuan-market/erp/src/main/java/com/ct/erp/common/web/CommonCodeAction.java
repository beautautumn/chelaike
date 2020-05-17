package com.ct.erp.common.web;

import com.ct.erp.constants.sysconst.Const;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;

import org.apache.struts2.ServletActionContext;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;

/**
 * Created by jf on 15/6/16.
 */

@Scope("prototype")
@Controller("common.codeAction")
public class CommonCodeAction extends SimpleActionSupport {

    private String barcode;

    private int width = 105;

    private int height = 50;

    public void barcode() {
        try {
            BitMatrix bitMatrix = new MultiFormatWriter().encode(barcode,
                    BarcodeFormat.CODE_39, width, height, null);
            HttpServletResponse response = ServletActionContext.getResponse();
            response.setContentType("multipart/form-data");
            ServletOutputStream out = response.getOutputStream();
            MatrixToImageWriter.writeToStream(bitMatrix, "png", out);
            out.flush();
        } catch (WriterException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    

    public String getBarcode() {
        return barcode;
    }

    public void setBarcode(String barcode) {
        this.barcode = barcode;
    }

    public int getWidth() {
        return width;
    }

    public void setWidth(int width) {
        this.width = width;
    }

    public int getHeight() {
        return height;
    }

    public void setHeight(int height) {
        this.height = height;
    }
}

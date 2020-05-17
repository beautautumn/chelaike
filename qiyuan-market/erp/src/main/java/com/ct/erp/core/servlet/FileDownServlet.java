package com.ct.erp.core.servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ct.util.file.FileOperator;
import com.ct.util.file.FileOperatorImpl;

public class FileDownServlet extends HttpServlet {
	private static final long serialVersionUID = 7872542692671198031L;

	public static final String FILE_NAME = "fileName";

	public static final String FILE_PATH = "filePath";
	
	private FileOperator fileOperate=new FileOperatorImpl();

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		fileDownLoad(request, response);
	}

	public void doGet(HttpServletRequest req, HttpServletResponse response)
			throws ServletException, IOException {
		fileDownLoad(req, response);
	}

	private void fileDownLoad(HttpServletRequest req, HttpServletResponse response)
			throws ServletException, IOException {
		String fileName = req.getParameter(FILE_NAME);
		String filePath = req.getParameter(FILE_PATH);
		File loadFile = new File(filePath);
		if (null == loadFile) {
			return;
		}
		//response.setContentType("application/vnd.ms-excel;charset=UTF-8");
		//response.setHeader("Content-Disposition", "attachment;filename="+fileName)	;
		
		//response.setContentType("APPLICATION/OCTET-STREAM");
		//response.setHeader("Content-Disposition", "Attachment;Filename=\""+fileName+".xls\"");
		response.reset();//必须加，不然保存不了临时文件    
		//response.setContentType("application/x-msdownload"); 
		//response.setHeader("Content-Disposition", "attachment; filename=\""+fileName+".xls\"");
		
		response.setHeader("Content-disposition","attachment; filename="+fileName+".xls");//filename是下载的xls的名，建议最好用英文
        response.setContentType("application/msexcel;charset=UTF-8");//设置类型
        response.setHeader("Pragma","No-cache");//设置头
        response.setHeader("Cache-Control","no-cache");//设置头
        response.setDateHeader("Expires", 0);//设置日期头
		
		ServletOutputStream out = response.getOutputStream();
		InputStream in = new FileInputStream(loadFile);

		int byteRead = 0;
		byte[] buffer = new byte[8192];
		while ((byteRead = in.read(buffer, 0, 8192)) != -1) {
			out.write(buffer, 0, byteRead);
		}
		in.close();
		out.flush();
		out.close();
		File parent=loadFile.getParentFile();
		fileOperate.deleteFile(parent);
	}
}
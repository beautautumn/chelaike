package com.ct.erp.list.service.impl;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ct.erp.list.dao.DynamicViewDao;
import com.ct.erp.list.model.ComposeQueryBean;
import com.ct.erp.list.service.BusDataExportExcel;
import com.ct.erp.list.service.CalculateGridService;
import com.ct.util.AppRunTimeException;

@Service
public class BusDataExportExcelImpl implements BusDataExportExcel{
	
	private static final Logger logger = LoggerFactory.getLogger(BusDataExportExcelImpl.class);


	private DynamicViewDao dynamicViewDao;

	@Autowired
	public void setDynamicViewDao(DynamicViewDao dynamicViewDao) {
		this.dynamicViewDao = dynamicViewDao;
	}
	
	
	public String exportFile(String fileInfo, String pageTitle,
			String titleText, String sql, String urlLink,
			ComposeQueryBean composeQueryBean,String maxExportIndex)throws AppRunTimeException{
		int maxPageSize = 50000;
		if(StringUtils.isNotBlank(maxExportIndex)){
			maxPageSize = Integer.valueOf(maxExportIndex);
		}
		long countIndex = 999999999;
		String sheetName = pageTitle;

		// 取列头
		String[] colNameIds = titleText.split(";");
		String[] colNameInfo = colNameIds[0].split("\\,");// 列头中文信息
		String[] colDataInfo =  colNameIds[3].split("\\,");// 列头数据类型信息
		String[] colLengthInfo =  colNameIds[1].split("\\,");// 列头宽度信息
		String[] colIndexInfo =  colNameIds[2].split("\\,");// 列头数据源标记信息
		int indexPage = 1;

		// 写XLS文件
		boolean hasMoreHead = false;
		HSSFWorkbook book = new HSSFWorkbook();
		boolean pageQuery = false;
		List dataList = null;
		if (countIndex > maxPageSize) {// 分页查询
			composeQueryBean.getPageInfo().setPage(1);
			composeQueryBean.getPageInfo().setRp(maxPageSize);
			dataList = dynamicViewDao.findDynamicDataList(sql,composeQueryBean);
			CalculateGridService.calculateXsum(dataList, composeQueryBean.getColPageTableColInfoMap());
			pageQuery = true;
		} 
		if (null == dataList) {
			return null;
		}
		int rownum = 1;
		while(dataList.size() > 0) {
			HSSFCellStyle style = book.createCellStyle();
			style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			style.setBorderRight(HSSFCellStyle.BORDER_THIN);
			style.setBorderTop(HSSFCellStyle.BORDER_THIN);

			OutputStream output = null;
			try {
				output = new FileOutputStream(fileInfo);
			} catch (FileNotFoundException e) {
				logger.error("目标文件加载失败", e);
			}
			Sheet sheet = null;
			if (indexPage > 1) {
				sheetName = pageTitle + "-" + (indexPage - 1);
				sheet = book.createSheet(sheetName);
				rownum = 0;
			} else {
				// 写表头
				if (hasMoreHead) {
					sheet = book.getSheetAt(0);
				} else {
					sheet = book.createSheet(sheetName);
				}

				if (!hasMoreHead) {
					Row row = sheet.createRow(0);
					HSSFCellStyle headStyle = book.createCellStyle();
					headStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
					headStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
					headStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
					headStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);

					// 上下左右居中
					headStyle.setAlignment(HSSFCellStyle.VERTICAL_CENTER);
					headStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);

					// 设置底色
					headStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
					headStyle.setFillForegroundColor(HSSFColor.LEMON_CHIFFON.index);
					
					for (int j = 0; j < colNameInfo.length; j++) {
						Cell cell = row.createCell(j);
						cell.setCellValue(colNameInfo[j]);
						cell.setCellStyle(headStyle);
					}
					
					if(CalculateGridService.isXsum( composeQueryBean.getColPageTableColInfoMap())){
						Cell cell = row.createCell(colNameInfo.length);
						cell.setCellValue("合计");
						cell.setCellStyle(headStyle);
					}
				}
			}


			// 设置列宽
			for (int j = 0; j < colLengthInfo.length; j++) {
				sheet.setColumnWidth(j,
						Integer.valueOf(colLengthInfo[j])*60 );
			}

			// 单元格左对齐
			style.setAlignment(HSSFCellStyle.VERTICAL_CENTER);
			style.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			style.setWrapText(true);

			for (int i = 0; i < dataList.size(); i++) {
				Map dataMap = (Map) dataList.get(i);
				Row row = sheet.createRow(rownum);
				for (int j = 0; j < colIndexInfo.length; j++) {
					Object obj = dataMap.get(colIndexInfo[j]);
					Cell cell = row.createCell(j);
					cell.setCellStyle(style);
					if (null == obj) {
						cell.setCellType(Cell.CELL_TYPE_STRING);
						cell.setCellValue("--");
					} else {
						if (colDataInfo[j].equalsIgnoreCase("integer")) {
							cell.setCellType(Cell.CELL_TYPE_NUMERIC);
							cell.setCellType(Integer.valueOf(String
									.valueOf(obj)));
						} else if (colDataInfo[j]
								.equalsIgnoreCase("string")) {
							cell.setCellType(Cell.CELL_TYPE_STRING);
							String cellVal = String.valueOf(obj).replaceAll("<br>", "\n").replaceAll("\\&[a-zA-Z]{1,10};", "") //去除类似< >  的字串
									.replaceAll("<[a-zA-Z]+[1-9]?[^><]*>", "") //去除开始标签及没有结束标签的标签
									.replaceAll("</[a-zA-Z]+[1-9]?>", "");
							cell.setCellValue(cellVal);
						} else if (colDataInfo[j].equalsIgnoreCase("date")) {
							cell.setCellType(Cell.CELL_TYPE_STRING);
							cell.setCellValue(String.valueOf(obj));
						} else if (colDataInfo[j].equalsIgnoreCase("time")) {
							cell.setCellType(Cell.CELL_TYPE_STRING);
							cell.setCellValue(String.valueOf(obj));
						} else if (colDataInfo[j]
								.equalsIgnoreCase("timestamp")) {
							cell.setCellType(Cell.CELL_TYPE_STRING);
							cell.setCellValue(String.valueOf(obj));
						} else {
							cell.setCellType(Cell.CELL_TYPE_STRING);
							String cellVal = String.valueOf(obj).replaceAll("<br>", "\n").replaceAll("\\&[a-zA-Z]{1,10};", "") //去除类似< >  的字串
									.replaceAll("<[a-zA-Z]+[1-9]?[^><]*>", "") //去除开始标签及没有结束标签的标签
									.replaceAll("</[a-zA-Z]+[1-9]?>", "");
							cell.setCellValue(cellVal);
						}
					}
				}
				//如果x轴有汇总那么在最后一列生成一列信息
				if(CalculateGridService.isXsum( composeQueryBean.getColPageTableColInfoMap())){
					Cell cell = row.createCell( colIndexInfo.length);
					cell.setCellStyle(style);
					cell.setCellValue(String.valueOf(dataMap.get("xsum")));
				}
				rownum++;
			}
			// 清除数据集合重新再查询
			if (pageQuery&&dataList.size()==maxPageSize) {// 执行分页查询
				
				indexPage++;
				composeQueryBean.getPageInfo().setPage(indexPage);
				composeQueryBean.getPageInfo().setRp(maxPageSize);
				try {
					dataList = dynamicViewDao.findDynamicDataList(sql,composeQueryBean);
					
					CalculateGridService.calculateXsum(dataList, composeQueryBean.getColPageTableColInfoMap());
				} catch (Exception e) {
					logger.error("findDynamicDataList失败!", e);
				}
			}else {
				dataList.clear();
			}
			try {
				book.write(output);
				output.flush();
				output.close();
			} catch (IOException e) {
				logger.error("输出文件失败!", e);
			}
		}
		return fileInfo;
	}

}

package com.ct.erp.list.service;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import com.ct.erp.common.model.GridPageInfo;
import com.ct.erp.common.model.json.DataGrid;
import com.ct.erp.list.model.ListColumn;
import com.ct.erp.list.model.PageTableColInfo;

/**
 * 
 * <P>公司名称: 云潮网络</P>
 * <P>项目名称： 哪有车爬虫</P>
 * <P>模块名称： 分页信息类</P>
 * @Title:	PageResultSet.java
 * @Description: TODO
 * @author:    jieketao
 * @version:   1.0
 * Create at:  2012-1-18 下午02:26:45
 */
public class PageResultSet {

	private static final Logger logger = LoggerFactory.getLogger(PageResultSet.class);

	private GridPageInfo pageInfo;
	
	private DataGrid dataGrid;

	private int curPage = 1; // 当前页

	private int pageSize = 20; // 每页显示的行数

	private long rowsCount = 0; // 总行数

	private int pageCount = 0; // 总页数

	private String sql = null;
	
	public PageResultSet(DataGrid dataGrid) {

		this.dataGrid = dataGrid;
		this.pageSize = dataGrid.getRows();
		this.curPage = dataGrid.getPage();
		this.rowsCount=dataGrid.getTotal();
	}

	public PageResultSet(GridPageInfo pageInfo) {

		this.pageInfo = pageInfo;
		this.pageSize = pageInfo.getRp();
		this.curPage = pageInfo.getPage();
		this.rowsCount=pageInfo.getTotal();

	}
	
	public List getColumnData(String sql, Object[] param, Connection con,Map<String,ListColumn> colFields) throws Exception {
		try {
			List result=new ArrayList();
			this.sql = sql;
			if(rowsCount==0){
				this.rowsCount = queryRowsCount(param, con);
				this.dataGrid.setTotal(this.rowsCount);
			}
			this.pageCount = (int) Math.ceil((double) rowsCount / pageSize);
			int startNum = 0;
			int endNum = 1;
			if (this.pageCount<=1&&this.curPage<=1) {
				this.dataGrid.setPage(1);
				startNum = 0;
				endNum = pageSize;
			} else {
				startNum = (curPage - 1) * pageSize;
				endNum = curPage * pageSize;
			}


			sql=sql.replaceAll("<mf>","");
			sql=sql.replaceAll("</mf>","");
			//String tmpsql = " SELECT  * FROM  (" + sql + ") as qwer WHERE 1=1 limit " + startNum + " , " + pageSize;
			String tmpsql=sql+ " limit " + startNum + " , " + pageSize;
			logger.info(tmpsql);
			Statement st=con.createStatement();
		
			ResultSet rs=st.executeQuery(tmpsql);
			StringBuilder field=new StringBuilder();
			try {
				if(null!=rs){
					while(rs.next()){
						Map<String,Object> map=new HashMap<String,Object>();
						Iterator it=colFields.entrySet().iterator();

						while(it.hasNext()){
							Map.Entry<String,ListColumn> entry = (Map.Entry<String,ListColumn>) it.next();
							field.append(entry.getKey());
							field.append(",");
							if(entry.getValue().getFieldType().toLowerCase().equals("string")){
								map.put(entry.getKey(), rs.getString(entry.getKey()));
							}else if(entry.getValue().getFieldType().toLowerCase().equals("int")){
								map.put(entry.getKey(), rs.getInt(entry.getKey()));
							}else if(entry.getValue().getFieldType().toLowerCase().equals("double")){
								map.put(entry.getKey(), rs.getDouble(entry.getKey()));
							}else if(entry.getValue().getFieldType().toLowerCase().equals("float")){
									map.put(entry.getKey(), rs.getFloat(entry.getKey()));
							}else if(entry.getValue().getFieldType().toLowerCase().equals("timestamp")){
								if(StringUtils.isNotBlank(entry.getValue().getFieldFormat())){
									if(rs.getTimestamp(entry.getKey())!=null){
										DateFormat format = new SimpleDateFormat(entry.getValue().getFieldFormat());
										map.put(entry.getKey(), format.format(rs.getTimestamp(entry.getKey())));
									}
								}								
							}
						}
						result.add(map);
					}
				}
				this.dataGrid.setField(field.toString());
			} catch (Exception e) {
				// TODO: handle exception
				throw e;
			}finally{
				if(rs!=null)rs.close();
				if(st!=null)st.close();
				if(con!=null&&!con.isClosed())con.close();
			}

			return result;
		} catch (Exception e) {
			// TODO: handle exception
			throw e;
		}
	}
	
	/**
	 * 获得数据分页的数据
	 * 
	 * @param param
	 * @param rowMapper
	 * @return
	 */
	public List getData(String sql, Object[] param, Connection con,Map<String,PageTableColInfo> colFields) throws Exception {
		try {
			List result=new ArrayList();
			this.sql = sql;
			if(rowsCount==0){
				this.rowsCount = queryRowsCount(param, con);
				this.pageInfo.setTotal(this.rowsCount);
			}
			this.pageCount = (int) Math.ceil((double) rowsCount / pageSize);
			this.pageInfo.setPageCount(pageCount);
			int startNum = 0;
			int endNum = 1;
			if (this.pageCount<=1&&this.curPage<=1) {
				this.pageInfo.setPage(1);
				startNum = 0;
				endNum = pageSize;
			} else {
				startNum = (curPage - 1) * pageSize;
				endNum = curPage * pageSize;
			}

			this.pageInfo.setQuerySql(sql);
			this.pageInfo.setQueryParam(param);

			sql=sql.replaceAll("<mf>","");
			sql=sql.replaceAll("</mf>","");
			//String tmpsql = " SELECT  * FROM  (" + sql + ") as qwer WHERE 1=1 limit " + startNum + " , " + pageSize;
			String tmpsql=sql+ " limit " + pageSize + " offset " + startNum;
			logger.info(tmpsql);
			Statement st=con.createStatement();
		
			ResultSet rs=st.executeQuery(tmpsql);
			try {
				if(null!=rs){
					while(rs.next()){
						Map<String,Object> map=new HashMap<String,Object>();
						Iterator it=colFields.entrySet().iterator();
						while(it.hasNext()){
							Map.Entry<String,PageTableColInfo> entry = (Map.Entry<String,PageTableColInfo>) it.next();
							if(entry.getValue().getFieldType().toLowerCase().equals("string")){
								map.put(entry.getKey(), rs.getString(entry.getKey()));
							}else if(entry.getValue().getFieldType().toLowerCase().equals("int")){
								map.put(entry.getKey(), rs.getInt(entry.getKey()));
							}else if(entry.getValue().getFieldType().toLowerCase().equals("double")){
								map.put(entry.getKey(), rs.getDouble(entry.getKey()));
							}else if(entry.getValue().getFieldType().toLowerCase().equals("float")){
									map.put(entry.getKey(), rs.getFloat(entry.getKey()));
							}else if(entry.getValue().getFieldType().toLowerCase().equals("timestamp")){
								if(StringUtils.isNotBlank(entry.getValue().getColFormat())){
									if(rs.getTimestamp(entry.getKey())!=null){
										DateFormat format = new SimpleDateFormat(entry.getValue().getColFormat());
										map.put(entry.getKey(), format.format(rs.getTimestamp(entry.getKey())));
									}
								}
								
							}
						}
						result.add(map);
					}
				}
			} catch (Exception e) {
				// TODO: handle exception
				throw e;
			}finally{
				if(rs!=null)rs.close();
				if(st!=null)st.close();
				if(con!=null&&!con.isClosed())con.close();
			}

			return result;
		} catch (Exception e) {
			// TODO: handle exception
			throw e;
		}
	}

	/**
	 * 获得数据分页的数据
	 * 
	 * @param param
	 * @param rowMapper
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List getData(String sql, Object[] param, RowMapper rowMapper, JdbcTemplate jdbcTemplate) throws Exception {
		this.sql=sql;
		if(rowsCount==0){
			//this.rowsCount = queryRowsCount(param, rowMapper, jdbcTemplate);
			this.pageInfo.setTotal(this.rowsCount);
		}		
		this.pageCount = (int) Math.ceil((double) rowsCount / pageSize);

		int startNum = 0;
		int endNum = 0;
		if (this.pageCount < curPage) {//
			this.pageInfo.setPage(1);
			startNum = 0;
			endNum = pageSize;
		} else {
			startNum = (curPage - 1) * pageSize;
			endNum = curPage * pageSize;
		}

		pageInfo.setPageCount(pageCount);
		pageInfo.setQuerySql(sql);
		pageInfo.setQueryParam(param);

		sql=sql.replaceAll("<mf>","");
		sql=sql.replaceAll("</mf>","");
		//String tmpsql = " SELECT  * FROM  (" + this.sql + ")t  WHERE 1=1 limit " + startNum +", " +pageSize;
		String tmpsql = this.sql + " limit " + startNum +", " +pageSize;
		return jdbcTemplate.query(tmpsql, param, rowMapper);
	}


	private String changeSql(String sql) {
		return " SELECT A.*,ROWNUM ROW_NUM FROM (" + sql + ") A ";
	}

	/**
	 * 获得进行记录总数的查询
	 * 
	 * @param param
	 * @param rowMapper
	 * @return
	 * @throws Exception
	 */
	private long queryRowsCount(Object[] param, Connection con) throws Exception {
		long count = 0;
		if (null == this.sql) {
			return 0;
		}
		String fromTag="<mf>";
		int fromIndex=sql.indexOf(fromTag);
		String tmpsql = "";
		if(fromIndex!=-1){
			sql=sql.substring(fromIndex);
			sql=sql.replaceAll("<mf>","");
			sql=sql.replaceAll("</mf>","");
			tmpsql="select count(*)  ";
			tmpsql+=sql;
		}else{
			tmpsql = "SELECT COUNT(*) FROM (" + sql + ") l";
		}
		//String tmpsql = "SELECT COUNT(*) FROM (" + sql + ") l";
		try {
			Statement st=con.createStatement();
			ResultSet rs=st.executeQuery(tmpsql);
			if(rs!=null&&rs.next()){
				return rs.getLong(1);
			}
		} catch (Exception e) {
			// TODO: handle exception
			throw e ;
		}
		return count;
	}

}
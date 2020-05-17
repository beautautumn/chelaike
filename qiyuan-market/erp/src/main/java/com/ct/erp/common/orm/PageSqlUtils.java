package com.ct.erp.common.orm;

import java.text.MessageFormat;

import com.ct.erp.common.utils.SysConstants;
/**
 * 分页SQL工具类.
 * <br>支持MySQL、Oracle、Postgresql分页查询.
 * @version 1.0
 */
public class PageSqlUtils {
	
	// 数据库类型
	/**
	 * MySQL数据库
	 */
	public static final String DATABSE_TYPE_MYSQL = "mysql";
	/**
	 * postgresql数据库
	 */
	public static final String DATABSE_TYPE_POSTGRE = "postgresql";
	/**
	 * oracle数据库
	 */
	public static final String DATABSE_TYPE_ORACLE = "oracle";
	
	// 分页SQL
	/**
	 * MySQL分页SQL
	 */
	public static final String MYSQL_SQL = "select * from ( {0}) sel_tab00 limit {1},{2}";
	/**
	 * Postgresql分页SQL
	 */
	public static final String POSTGRE_SQL = "select * from ( {0}) sel_tab00 limit {1} offset {2}";
	/**
	 * Oracle分页SQL
	 */
	public static final String ORACLE_SQL = "select * from (select row_.*,rownum rownum_ from ({0}) row_ where rownum <= {1}) where rownum_>{2}";

	/**
	 * 按照数据库类型，封装SQL（根据配置文件自动识别）.
	 * <br>支持MySQL、Oracle、Postgresql分页查询.
	 * @param sql 查询语句 例如:"select * from user "
	 * @param page 第几页
	 * @param rows 页大小
	 * @return
	 */
	public static String createPageSql(String sql, int page, int rows) {
		int beginNum = (page - 1) * rows;
		String[] sqlParam = new String[3];
		sqlParam[0] = sql;
		sqlParam[1] = beginNum + "";
		sqlParam[2] = rows + "";
		if (SysConstants.getJdbcUrl().indexOf(PageSqlUtils.DATABSE_TYPE_MYSQL) != -1) {
			sql = MessageFormat.format(PageSqlUtils.MYSQL_SQL, sqlParam);
		} else if (SysConstants.getJdbcUrl().indexOf(
				PageSqlUtils.DATABSE_TYPE_POSTGRE) != -1) {
			sql = MessageFormat.format(PageSqlUtils.POSTGRE_SQL, sqlParam);
		} else if (SysConstants.getJdbcUrl().indexOf(
				PageSqlUtils.DATABSE_TYPE_ORACLE) != -1) {
			int beginIndex = (page - 1) * rows;
			int endIndex = beginIndex + rows;
			sqlParam[2] = beginIndex + "";
			sqlParam[1] = endIndex + "";
			sql = MessageFormat.format(PageSqlUtils.ORACLE_SQL, sqlParam);
		}
		return sql;
	}
}

package com.ct.erp.common.orm.jdbc;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.common.orm.PageSqlUtils;
import com.ct.erp.common.utils.reflection.MyBeanUtils;

/**
 * Spring Jdbc工具类.
 * <br>支持MySQL、Oracle、postgresql分页查询.
 * @author 尔演&Eryan eryanwcp@gmail.com
 * @date 2013-2-12 下午9:36:42
 */
@Repository
@Transactional
public class JdbcDao extends SimpleJdbcDao{
	
	public JdbcDao(){
	}
	
	@Autowired
	public JdbcDao(DataSource dataSource) {
		super(dataSource);
	}
	
	/**
	 * 根据sql语句，返回对象集合
	 * @param sql语句(参数用冒号加参数名，例如select * from tb where id=:id)
	 * @param clazz类型
	 * @param parameters参数集合(key为参数名，value为参数值)
	 * @return bean对象集合
	 */
	@SuppressWarnings("rawtypes")
	@Transactional(readOnly = true)
	public List find(String sql,Class clazz,Map parameters){
		return super.find(sql,clazz,parameters);
	}
	
	/**
	 * 根据sql语句，返回对象
	 * @param sql语句(参数用冒号加参数名，例如select * from tb where id=:id)
	 * @param clazz类型
	 * @param parameters参数集合(key为参数名，value为参数值)
	 * @return bean对象
	 */
	@SuppressWarnings("rawtypes")
	@Transactional(readOnly = true)
	public Object findForObject(String sql,Class clazz,Map parameters){
		return super.findForObject(sql, clazz, parameters);
	}
	
	/**
	 * 根据sql语句，返回数值型返回结果
	 * @param sql语句(参数用冒号加参数名，例如select count(*) from tb where id=:id)
	 * @param parameters参数集合(key为参数名，value为参数值)
	 * @return bean对象
	 */
	@SuppressWarnings("rawtypes")
	@Transactional(readOnly = true)
	public long findForLong(String sql,Map parameters){
		return super.findForLong(sql, parameters);
	}
	
	/**
	 * 根据sql语句，返回Map对象,对于某些项目来说，没有准备Bean对象，则可以使用Map代替Key为字段名,value为值
	 * @param sql语句(参数用冒号加参数名，例如select count(*) from tb where id=:id)
	 * @param parameters参数集合(key为参数名，value为参数值)
	 * @return bean对象
	 */
	@SuppressWarnings("rawtypes")
	@Transactional(readOnly = true)
	public Map findForMap(String sql,Map parameters){
		return super.findForMap(sql, parameters);
	}
	
	/**
	 * 根据sql语句，返回Map对象集合
	 * @see findForMap
	 * @param sql语句(参数用冒号加参数名，例如select count(*) from tb where id=:id)
	 * @param parameters参数集合(key为参数名，value为参数值)
	 * @return bean对象
	 */
	@SuppressWarnings("rawtypes")
	@Transactional(readOnly = true)
	public List<Map<String,Object>> findForListMap(String sql,Map parameters){
		return super.findForListMap(sql, parameters);
	}
	
	/**
	 * 执行insert，update，delete等操作<br>
	 * 例如insert into users (name,login_name,password) values(:name,:loginName,:password)<br>
	 * 参数用冒号,参数为bean的属性名
	 * @param sql
	 * @param bean
	 */
	public int executeForObject(String sql,Object bean){
		return super.executeForObject(sql, bean);
	}

	/**
	 * 执行insert，update，delete等操作<br>
	 * 例如insert into users (name,login_name,password) values(:name,:login_name,:password)<br>
	 * 参数用冒号,参数为Map的key名
	 * @param sql
	 * @param parameters
	 */
	@SuppressWarnings("rawtypes")
	public int executeForMap(String sql,Map parameters){
		return super.executeForMap(sql, parameters);
	}
	/*
	 * 批量处理操作
	 * 例如：update t_actor set first_name = :firstName, last_name = :lastName where id = :id
	 * 参数用冒号
	 */
	public int[] batchUpdate(final String sql,List<Object[]> batch ){
        return super.batchUpdate(sql,batch);
	}
	
	/**
	 * 使用指定的检索标准检索数据并分页返回数据
	 */
	@Transactional(readOnly = true)
	public List<Map<String, Object>> findForJdbc(String sql, int page, int rows) {
		//封装分页SQL
		sql = PageSqlUtils.createPageSql(sql,page,rows);
		return this.jdbcTemplate.queryForList(sql);
	}
	
	@Transactional(readOnly = true)
	public List<Map<String, Object>> findForJdbc(String sql, Object... objs) {
		return this.jdbcTemplate.queryForList(sql,objs);
	}

	
	/**
	 * 使用指定的检索标准检索数据并分页返回数据
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 */
	@Transactional(readOnly = true)
	public List<T> findObjForJdbc(String sql, int page, int rows,Class<T> clazz) {
		List<T> rsList = new ArrayList<T>();
		//封装分页SQL
		sql = PageSqlUtils.createPageSql(sql,page,rows);
		List<Map<String, Object>> mapList = jdbcTemplate.queryForList(sql);
		
		T po = null;
		for(Map<String,Object> m:mapList){
			try {
				po = clazz.newInstance();
				MyBeanUtils.copyMap2Bean_Nobig(po, m);
				rsList.add(po);
			}  catch (Exception e) {
				e.printStackTrace();
			}
		}
		return rsList;
	}

	/**
	 * 使用指定的检索标准检索数据并分页返回数据-采用预处理方式
	 * 
	 * @param criteria
	 * @param firstResult
	 * @param maxResults
	 * @return
	 * @throws DataAccessException
	 */
	@Transactional(readOnly = true)
	public  List<Map<String, Object>>  findForJdbcParam(String  sql,  int page, int rows,Object... objs){
		//封装分页SQL
		sql = PageSqlUtils.createPageSql(sql,page,rows);
		return jdbcTemplate.queryForList(sql,objs);
	}
	
	@Transactional(readOnly = true)
	public Map<String, Object> findOneForJdbc(String sql, Object... objs) {
		try{ 
			return this.jdbcTemplate.queryForMap(sql, objs);
		}catch (EmptyResultDataAccessException e) {   
		    return null;   
		}  
	}
	
	/**
	 * 使用指定的检索标准检索数据并分页返回数据For JDBC
	 */
	@Transactional(readOnly = true)
	public Long getCountForJdbc(String  sql) {
		return  jdbcTemplate.queryForLong(sql);
	}
	/**
	 * 使用指定的检索标准检索数据并分页返回数据For JDBC-采用预处理方式
	 * 
	 */
	@Transactional(readOnly = true)
	public Long getCountForJdbcParam(String  sql,Object... objs) {
		return  jdbcTemplate.queryForLong(sql, objs);
	}

	public Integer executeSql2(String sql,List<Object> param) {
		return this.jdbcTemplate.update(sql,param);
	}

	public Integer executeSql(String sql, Object... param) {
		return this.jdbcTemplate.update(sql,param);
	}

	public Integer countByJdbc(String sql, Object... param) {
		return this.jdbcTemplate.queryForInt(sql, param);
	}

	
}

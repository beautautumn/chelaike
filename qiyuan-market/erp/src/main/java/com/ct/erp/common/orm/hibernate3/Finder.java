package com.ct.erp.common.orm.hibernate3;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.type.Type;


public class Finder {
	protected Finder() {
	}

	public Finder(String hql) {
		hqlBuilder = new StringBuilder(hql);
	}

	public static Finder create(String hql) {
		Finder finder = new Finder(hql);
		return finder;
	}

	public Finder append(String hql) {
		hqlBuilder.append(hql);
		return this;
	}

	/**
	 * 获得原始hql语句
	 * 
	 * @return
	 */
	public String getOrigHql() {
		return hqlBuilder.toString();
	}

	/**
	 * 获得查询数据库记录数的hql语句。
	 * 
	 * @return
	 */
	public String getRowCountHql() {
		String hql = hqlBuilder.toString();

		//int fromIndex = hql.toLowerCase().indexOf(FROM);
		
		int fromIndex = this.getIndexFrom(hql.toLowerCase());
		
		
		String projectionHql = hql.substring(0, fromIndex);

		hql = hql.substring(fromIndex);
		
		String rowCountHql = hql.replace(HQL_FETCH, "");

		int index = rowCountHql.indexOf(ORDER_BY);
		if (index > 0) {
			rowCountHql = rowCountHql.substring(0, index);
		}
		return wrapProjection(projectionHql) + rowCountHql;
	}
	

/*	public int getIndexFrom(String sql){
		if(StringUtils.isNotEmpty(sql)){
			if(sql.indexOf(NEW)>-1){
				int preThesisIndex=sql.indexOf(LEFR_BRACKETS);
				String suffixStr=sql.substring(preThesisIndex);
				int index = suffixStr.indexOf(ORDER_BY);
				if (index > 0) {
					suffixStr = suffixStr.substring(0, index);
				}
				index=suffixStr.lastIndexOf(SEMICOLON);
				if(index==-1) return sql.indexOf(FROM);//括号内只有一个属性没有  semicolm
				suffixStr=suffixStr.substring(index);
				int fromIndex = suffixStr.toLowerCase().indexOf(FROM);
				if(suffixStr.substring(0,fromIndex).indexOf(LEFR_BRACKETS)>-1){
					suffixStr=suffixStr.substring(fromIndex+4);
					fromIndex = suffixStr.toLowerCase().indexOf(FROM);
					//suffixStr=suffixStr.substring(fromIndex);
				}
				return sql.indexOf(suffixStr.substring(fromIndex));
			}else return sql.indexOf(FROM);
		}
		return -1;
	}*/
	
	/**
	 * 动态查找count前的sql语句
	 * @Title:	getIndexFrom
	 * @Description: TODO
	 * @param sql
	 * @return
	 * @throws:   
	 * @author:   jieketao
	 * Create at: 2011-8-1 下午02:51:56
	 */	
	public int getIndexFrom(String sql){
		if(StringUtils.isNotEmpty(sql)){
			if(sql.indexOf(NEW)>-1){
				int leftBacketsNum=0;
				int rightBacketsNum=0;
				int fromIndex=sql.indexOf(FROM);
				String preSql=sql.substring(0,fromIndex+4);
				String sufSql=sql.substring(fromIndex+4);
				leftBacketsNum=StringUtils.countMatches(preSql, LEFR_BRACKETS);
				rightBacketsNum=StringUtils.countMatches(preSql, RIGHT_BRACKETS);				
				while(leftBacketsNum>rightBacketsNum){
					fromIndex=sufSql.indexOf(FROM);
					sufSql=sufSql.substring(fromIndex+4);
					preSql=sql.substring(0,sql.indexOf(sufSql));
					leftBacketsNum=StringUtils.countMatches(preSql, LEFR_BRACKETS);
					rightBacketsNum=StringUtils.countMatches(preSql, RIGHT_BRACKETS);
				}
				fromIndex=sql.indexOf(sufSql);
				return sql.indexOf(sql.substring(fromIndex))-4;
			}else return sql.indexOf(FROM);
		}
		return -1;
	}
	

	
	public int parenthesisRecuis(String str){
		
		return -1;
	}

	public int getFirstResult() {
		return firstResult;
	}

	public void setFirstResult(int firstResult) {
		this.firstResult = firstResult;
	}

	public int getMaxResults() {
		return maxResults;
	}

	public void setMaxResults(int maxResults) {
		this.maxResults = maxResults;
	}

	/**
	 * 设置参数。与hibernate的Query接口一致。
	 * 
	 * @param param
	 * @param value
	 * @return
	 */
	public Finder setParam(String param, Object value) {
		return setParam(param, value, null);
	}

	/**
	 * 设置参数。与hibernate的Query接口一致。
	 * 
	 * @param param
	 * @param value
	 * @param type
	 * @return
	 */
	public Finder setParam(String param, Object value, Type type) {
		getParams().add(param);
		getValues().add(value);
		getTypes().add(type);
		return this;
	}

	/**
	 * 设置参数。与hibernate的Query接口一致。
	 * 
	 * @param paramMap
	 * @return
	 */
	public Finder setParams(Map<String, Object> paramMap) {
		for (Map.Entry<String, Object> entry : paramMap.entrySet()) {
			setParam(entry.getKey(), entry.getValue());
		}
		return this;
	}

	/**
	 * 设置参数。与hibernate的Query接口一致。
	 * 
	 * @param name
	 * @param vals
	 * @param type
	 * @return
	 */
	public Finder setParamList(String name, Collection<Object> vals, Type type) {
		getParamsList().add(name);
		getValuesList().add(vals);
		getTypesList().add(type);
		return this;
	}

	/**
	 * 设置参数。与hibernate的Query接口一致。
	 * 
	 * @param name
	 * @param vals
	 * @return
	 */
	public Finder setParamList(String name, Collection<Object> vals) {
		return setParamList(name, vals, null);
	}

	/**
	 * 设置参数。与hibernate的Query接口一致。
	 * 
	 * @param name
	 * @param vals
	 * @param type
	 * @return
	 */
	public Finder setParamList(String name, Object[] vals, Type type) {
		getParamsArray().add(name);
		getValuesArray().add(vals);
		getTypesArray().add(type);
		return this;
	}

	/**
	 * 设置参数。与hibernate的Query接口一致。
	 * 
	 * @param name
	 * @param vals
	 * @return
	 */
	public Finder setParamList(String name, Object[] vals) {
		return setParamList(name, vals, null);
	}

	/**
	 * 将finder中的参数设置到query中。
	 * 
	 * @param query
	 */
	public Query setParamsToQuery(Query query) {
		if (params != null) {
			for (int i = 0; i < params.size(); i++) {
				if (types.get(i) == null) {
					query.setParameter(params.get(i), values.get(i));
				} else {
					query.setParameter(params.get(i), values.get(i), types
							.get(i));
				}
			}
		}
		if (paramsList != null) {
			for (int i = 0; i < paramsList.size(); i++) {
				if (typesList.get(i) == null) {
					query
							.setParameterList(paramsList.get(i), valuesList
									.get(i));
				} else {
					query.setParameterList(paramsList.get(i),
							valuesList.get(i), typesList.get(i));
				}
			}
		}
		if (paramsArray != null) {
			for (int i = 0; i < paramsArray.size(); i++) {
				if (typesArray.get(i) == null) {
					query.setParameterList(paramsArray.get(i), valuesArray
							.get(i));
				} else {
					query.setParameterList(paramsArray.get(i), valuesArray
							.get(i), typesArray.get(i));
				}
			}
		}
		return query;
	}

	public Query createQuery(Session s) {
		return setParamsToQuery(s.createQuery(getOrigHql()));
	}

	private String wrapProjection(String projection) {
		if (projection.indexOf("select") == -1) {
			return ROW_COUNT;
		} else if(projection.toLowerCase().indexOf("new")>0){
			return ROW_COUNT;
		}else{
			return projection.replace("select", "select count(") + ") ";
		}
	}

	private List<String> getParams() {
		if (params == null) {
			params = new ArrayList<String>();
		}
		return params;
	}

	private List<Object> getValues() {
		if (values == null) {
			values = new ArrayList<Object>();
		}
		return values;
	}

	private List<Type> getTypes() {
		if (types == null) {
			types = new ArrayList<Type>();
		}
		return types;
	}

	private List<String> getParamsList() {
		if (paramsList == null) {
			paramsList = new ArrayList<String>();
		}
		return paramsList;
	}

	private List<Collection<Object>> getValuesList() {
		if (valuesList == null) {
			valuesList = new ArrayList<Collection<Object>>();
		}
		return valuesList;
	}

	private List<Type> getTypesList() {
		if (typesList == null) {
			typesList = new ArrayList<Type>();
		}
		return typesList;
	}

	private List<String> getParamsArray() {
		if (paramsArray == null) {
			paramsArray = new ArrayList<String>();
		}
		return paramsArray;
	}

	private List<Object[]> getValuesArray() {
		if (valuesArray == null) {
			valuesArray = new ArrayList<Object[]>();
		}
		return valuesArray;
	}

	private List<Type> getTypesArray() {
		if (typesArray == null) {
			typesArray = new ArrayList<Type>();
		}
		return typesArray;
	}

	private StringBuilder hqlBuilder;

	private List<String> params;
	private List<Object> values;
	private List<Type> types;

	private List<String> paramsList;
	private List<Collection<Object>> valuesList;
	private List<Type> typesList;

	private List<String> paramsArray;
	private List<Object[]> valuesArray;
	private List<Type> typesArray;

	private int firstResult = 0;

	private int maxResults = 0;

	public static final String ROW_COUNT = "select count(*) ";
	public static final String FROM = "from";
	public static final String NEW = "new";
	public static final String LEFR_BRACKETS = "(";
	public static final String RIGHT_BRACKETS = ")";
	public static final String SEMICOLON=",";
	public static final String DISTINCT = "distinct";
	public static final String HQL_FETCH = "fetch";
	public static final String ORDER_BY = "order";
	
	
	


	public static void main(String[] args) {
//		Finder find = Finder
//				.create("select distinct p FROM BookType join fetch p");

		String sql="select new com.cloudtrend.chemama.front.entity.BuyInfoStyleVo("
		         +"(select veh.catalogueName from VehicleCatalogue veh where veh.catalogueCode = buy.kindCode2) as styleName1,"
		          +"(select veh.catalogueName from VehicleCatalogue veh where veh.catalogueCode = buy.kindCode2) as styleName2, "
		           +"(select veh.catalogueName from VehicleCatalogue veh where veh.catalogueCode = buy.kindCode3) as styleName3,"
		            +"(select col.colorName from Color col where col.colorCode = buy.colorCode ) as colorName, buy.* "
		             + ") from Buy as buy ,sells1 ,sell2,where exists "
	                  +" (select info.infoId from Info as info where info.infoId = buy.buyId and info.member = :member ) " 
	                  	+"order by buy.createTime desc";
		

		Finder find=new Finder(sql);
		//f.getIndexFrom(sql);
		
		
	
		
	}
}
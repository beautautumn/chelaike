package com.ct.erp.common.web.struts2.converter;

import java.sql.Clob;
import java.util.Map;

import org.apache.struts2.util.StrutsTypeConverter;

import com.ct.erp.common.io.ClobUtil;

public class ClobConverter extends StrutsTypeConverter {

	@SuppressWarnings("rawtypes")
    @Override
	public Object convertFromString(Map context, String[] values, Class toClass) {
		if (values == null || values.length == 0) {
			return null;
		}
		return ClobUtil.getClob(values[0]);
	}

	@SuppressWarnings("rawtypes")
    @Override
	public String convertToString(Map context, Object o) {
		if (o instanceof Clob) {
			return ClobUtil.getString((Clob) o);
		}
		return "";
	}

}

package com.ct.erp.common.utils;

import java.util.Iterator;
import java.util.Map;

import bsh.EvalError;
import bsh.Interpreter;

import com.ct.util.log.LogUtil;

public final class BshUtils {

	private Interpreter bsh = null;

	public BshUtils() {
		bsh = new Interpreter();
	}

	public Interpreter getBsh() {
		return bsh;
	}

	public final Object eval(String expr, Map varMap) throws Exception {
		Object obj = null;
		if (varMap == null || null == expr || "".equals(expr)) {
			return null;
		}

		Iterator it = varMap.keySet().iterator();
		try {
			while (it.hasNext()) {
				String key = (String) it.next();
				Object value = varMap.get(key);
				setValue(key, value);
			}
			obj = bsh.eval(expr);

			// 返回变量
			return obj;
		} catch (Exception ex) {
			LogUtil.logError(this.getClass(), "Error in method eval", ex);
			throw ex;
		}
	}

	// 变量赋值
	private void setValue(String key, Object value) throws EvalError {
		if (value instanceof Boolean) {
			bsh.set(key, ((Boolean) value).booleanValue());
		} else if (value instanceof Byte) {
			bsh.set(key, ((Byte) value).byteValue());
		} else if (value instanceof Character) {
			bsh.set(key, ((Character) value).charValue());
		} else if (value instanceof Short) {
			bsh.set(key, ((Short) value).shortValue());
		} else if (value instanceof Integer) {
			bsh.set(key, ((Integer) value).intValue());
		} else if (value instanceof Long) {
			bsh.set(key, ((Long) value).longValue());
		} else if (value instanceof Float) {
			bsh.set(key, ((Float) value).floatValue());
		} else if (value instanceof Double) {
			bsh.set(key, ((Double) value).doubleValue());
		} else {
			bsh.set(key, value);
		}
	}
}

package com.ct.erp.util;

import java.util.Iterator;
import java.util.Map;

import bsh.EvalError;
import bsh.Interpreter;

import com.ct.util.log.LogUtil;

/**
 * Beanshell规则引擎执行方法
 * @author y
 *
 */
public class BeanShellUtil {

	private static Interpreter interpreter = new Interpreter();

	@SuppressWarnings("unchecked")
	/**
	 * 执行方法
	 */
	public static final Object eval(String expr, Map valueMap) throws Exception {
		Object obj = null;
		if (valueMap == null || null == expr || "".equals(expr)) {
			return null;
		}

		Iterator it = valueMap.keySet().iterator();
		try {
			while (it.hasNext()) {
				String key = (String) it.next();
				Object value = valueMap.get(key);
				setValue(key, value);
			}
			obj = interpreter.eval(expr);

			// 返回变量
			return obj;
		} catch (Exception ex) {
			LogUtil.logError(BeanShellUtil.class,"Error in BeanShellUtil-->method eval", ex);
			throw ex;
		}
	}

	// 变量赋值
	private static void setValue(String key, Object value) throws EvalError {
		if (value instanceof Boolean) {
			interpreter.set(key, ((Boolean) value).booleanValue());
		} else if (value instanceof Byte) {
			interpreter.set(key, ((Byte) value).byteValue());
		} else if (value instanceof Character) {
			interpreter.set(key, ((Character) value).charValue());
		} else if (value instanceof Short) {
			interpreter.set(key, ((Short) value).shortValue());
		} else if (value instanceof Integer) {
			interpreter.set(key, ((Integer) value).intValue());
		} else if (value instanceof Long) {
			interpreter.set(key, ((Long) value).longValue());
		} else if (value instanceof Float) {
			interpreter.set(key, ((Float) value).floatValue());
		} else if (value instanceof Double) {
			interpreter.set(key, ((Double) value).doubleValue());
		} else {
			interpreter.set(key, value);
		}
	}
}

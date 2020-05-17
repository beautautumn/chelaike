package com.ct.erp.common.utils.mapper;

import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.lang.reflect.Array;
import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * Json构建工具(不依赖于第三方组件).
 * <br>不推荐使用.
 * 2013-01-17 新增日期格式化: 
 * <br>java.util.Date默认格式化("yyyy-MM-dd")字符串,修改DATE_FORMART可自定义个格式化.
 * @author 尔演&Eryan eryanwcp@gmail.com
 * @date 2012-10-16 上午9:19:51
 */
@Deprecated
public class JsonBuilder {
    /**
     * 自定义Date类型 格式化 默认：null
     */
    public static String DATE_FORMART;
    /**
     * 默认Date类型 格式化："yyyy-MM-dd"
     */
    private static String DEFAULT_DATE_FORMART = "yyyy-MM-dd";
    /**
     * 单引号
     */
    private static String QUOTE = "\"";

    static Set<Class<?>> simpleTypes = new HashSet<Class<?>>();
    static {
        simpleTypes.add(Byte.TYPE);
        simpleTypes.add(Short.TYPE);
        simpleTypes.add(Integer.TYPE);
        simpleTypes.add(Long.TYPE);
        simpleTypes.add(Float.TYPE);
        simpleTypes.add(Double.TYPE);
        simpleTypes.add(Boolean.TYPE);

    }

    /**
     * 排除的类型.
     * 
     * @param excludeClass
     * @return
     */
    private static Set<Class<?>> excludeClasses(Class<?>[] excludeClass) {
        Set<Class<?>> excludeClasses = new HashSet<Class<?>>();
        excludeClasses.add(Class.class);
        if (excludeClass == null) {
            return excludeClasses;
        }
        for (Class<?> type : excludeClasses) {
            excludeClasses.add(type);
        }
        return excludeClasses;
    }

    /**
     * 排除的属性.
     * 
     * @param exculdeProperties
     * @return
     */
    private static Set<String> excludeProperties(String[] exculdeProperties) {
        Set<String> exculdePropertyNames = new HashSet<String>();
        if (exculdeProperties == null) {
            return exculdePropertyNames;
        }

        for (String name : exculdeProperties) {
            exculdePropertyNames.add(name);
        }
        return exculdePropertyNames;
    }

    /**
     * 属性名称替换.
     * 
     * @param names
     * @return
     */
    private static Map<String, String> replacePropertyNames(String names) {

        Map<String, String> replaceNamesMaps = new HashMap<String, String>();
        if (names != null && "" != names) {// aa:bb,cc:dd
            String[] nameStrings = names.split(",");
            for (String name : nameStrings) {
                String[] params = name.split(":");
                replaceNamesMaps.put(params[0], params[1]);
            }
        }
        return replaceNamesMaps;
    }

    /**
     * 构造json数据.
     * 
     * @param o
     *            对象
     * @return
     */
    public static String build(Object o) {
        return build(o, null, null, null);
    }

    /**
     * 构造json数据.
     * 
     * @param o
     *            对象
     * @param replaceNames
     *            属性名称替换 例如："oldName1:newName1,oldName2:newName2"
     * @return
     */
    public static String build(Object o, String replaceNames) {

        return build(o, null, null, replaceNames);
    }

    /**
     * 构造json数据.
     * 
     * @param o
     *            对象
     * @param exculdeProperties
     *            排除的属性
     * @return
     */
    public static String build(Object o, String[] exculdeProperties) {

        return build(o, null, exculdeProperties, null);
    }

    /**
     * 构造json数据.
     * 
     * @param o
     *            对象
     * @param exculdeProperties
     *            排除的属性
     * @param replaceNames
     *            属性名称替换 例如："oldName1:newName1,oldName2:newName2"
     * @return
     */
    public static String build(Object o, String[] exculdeProperties,
            String replaceNames) {

        return build(o, null, exculdeProperties, replaceNames);
    }

    /**
     * 构造json数据.
     * 
     * @param o
     *            对象
     * @param excludeClasses
     *            排除的类类型
     * @param exculdeProperties
     *            排除的属性
     * @param replaceNames
     *            属性名称替换 例如："oldName1:newName1,oldName2:newName2"
     * @return
     */
    public static String build(Object o, Class<?>[] excludeClasses,
            String[] exculdeProperties, String replaceNames) {

        Map<String, String> replaceNamesMaps = replacePropertyNames(replaceNames);
        Set<Class<?>> excludeClz = excludeClasses(excludeClasses);
        Set<String> exculdePropertyNames = excludeProperties(exculdeProperties);
        String result;
        try {
            result = buildNode("actionbean", o, new StringBuilder(), false,
                    replaceNamesMaps, excludeClz, exculdePropertyNames);
            DATE_FORMART = null;//将自定义个日期格式化变量清空
            return result;
        } catch (Exception e) {
        }
        return "";
    }

    /**
     * 构造单个节点.
     * 
     * @param targetName
     * @param in
     * @param out
     * @param incollect
     * @param replaceNamesMaps
     * @param excludeClz
     * @param exculdePropertyNames
     * @return
     * @throws Exception
     */
    public static String buildNode(String targetName, Object in,
            StringBuilder out, boolean incollect,
            Map<String, String> replaceNamesMaps, Set<Class<?>> excludeClz,
            Set<String> exculdePropertyNames) throws Exception {
        if (incollect) {
            out.append(QUOTE + targetName + QUOTE);
            out.append(":");
        }
        if (Collection.class.isAssignableFrom(in.getClass())) {

            buildCollection(targetName, in, out, incollect, replaceNamesMaps,
                    excludeClz, exculdePropertyNames);

        } else if (in.getClass().isArray()) {

            buildArray(targetName, in, out, incollect, replaceNamesMaps,
                    excludeClz, exculdePropertyNames);

        } else if (Map.class.isAssignableFrom(in.getClass())) {

            buildMap(targetName, in, out, incollect, replaceNamesMaps,
                    excludeClz, exculdePropertyNames);

        } else {

            buildObject(targetName, in, out, incollect, replaceNamesMaps,
                    excludeClz, exculdePropertyNames);
        }
        // this.objectValues.put(targetName, out.toString());
        return out.toString();
    }

    private static boolean isExcludedType(Class<?> type,
            Set<Class<?>> excludeClasses) {
        for (Class<?> excludedType : excludeClasses) {
            if (excludedType.isAssignableFrom(type)) {
                return true;
            } else if (type.isArray()
                    && excludedType.isAssignableFrom(type.getComponentType())) {
                return true;
            }
        }
        return false;
    }

    private static boolean isExcludedName(String name,
            Set<String> exculdePropertyNames) {
        for (String excludedName : exculdePropertyNames) {
            if (excludedName.trim().equalsIgnoreCase(name.trim())) {
                return true;
            }
        }
        return false;
    }

    @SuppressWarnings("rawtypes")
    private static boolean isSimpleType(Object property) {
        if (property == null) {
            return true;
        }
        Class type = property.getClass();
        return simpleTypes.contains(type)
                || Number.class.isAssignableFrom(type)
                || String.class.isAssignableFrom(type)
                || Boolean.class.isAssignableFrom(type)
                || Date.class.isAssignableFrom(type);
    }

    @SuppressWarnings("rawtypes")
    private static String getSimpleTypeStr(Object property) {
        if (property == null)
            return "null";
        Class type = property.getClass();
        if (String.class.isAssignableFrom(type)) {
            return quote((String) property);
        } else if (Date.class.isAssignableFrom(type)) {
            // return "new Date(" + ((Date) property).getTime() + ")";
            Date date = (Date) property;
            String d = null ;
            d = QUOTE+new SimpleDateFormat(DEFAULT_DATE_FORMART).format(date) + QUOTE;
            if(DATE_FORMART != null){
                try {
                    if(date != null){
                       d = QUOTE+new SimpleDateFormat(DATE_FORMART).format(date) + QUOTE;
                    }
                } catch (Exception e) {
                }
            }
            return d;
        } else {
            return property.toString();
        }
    }

    public static String quote(String string) {
        if (string == null || string.length() == 0) {
            return QUOTE+QUOTE;
        }

        char c = 0;
        int len = string.length();
        StringBuilder sb = new StringBuilder(len + 10);

        sb.append('"');
        for (int i = 0; i < len; ++i) {
            c = string.charAt(i);
            switch (c) {
            case '\\':
            case '"':
                sb.append('\\').append(c);
                break;
            case '\b':
                sb.append("\\b");
                break;
            case '\t':
                sb.append("\\t");
                break;
            case '\n':
                sb.append("\\n");
                break;
            case '\f':
                sb.append("\\f");
                break;
            case '\r':
                sb.append("\\r");
                break;
            default:
                if (c < ' ') {
                    // The following takes lower order chars and creates
                    // unicode style
                    // char literals for them (e.g. \u00F3)
                    sb.append("\\u");
                    String hex = Integer.toHexString(c);
                    int pad = 4 - hex.length();
                    for (int j = 0; j < pad; ++j) {
                        sb.append("0");
                    }
                    sb.append(hex);
                } else {
                    sb.append(c);
                }
            }
        }

        sb.append('"');
        return sb.toString();
    }

    private static void buildCollection(String targetName, Object in,
            StringBuilder out, boolean incollect,
            Map<String, String> replaceNamesMaps, Set<Class<?>> excludeClz,
            Set<String> exculdePropertyNames) throws Exception {

        int length = ((Collection<?>) in).size(), i = 0;

        out.append("[");
        for (Object value : (Collection<?>) in) {
            if (isSimpleType(value)) {
                out.append(getSimpleTypeStr(value));
            } else {
                buildNode(targetName, value, out, false, replaceNamesMaps,
                        excludeClz, exculdePropertyNames);
            }
            if (i++ != (length - 1)) {
                out.append(", ");
            }
        }

        out.append("]");
    }

    private static void buildArray(String targetName, Object in,
            StringBuilder out, boolean incollect,
            Map<String, String> replaceNamesMaps, Set<Class<?>> excludeClz,
            Set<String> exculdePropertyNames) throws Exception {

        int length = Array.getLength(in);

        out.append("[");
        for (int i = 0; i < length; i++) {
            Object value = Array.get(in, i);
            if (isSimpleType(value)) {
                out.append(getSimpleTypeStr(value));
            } else {
                buildNode(targetName, value, out, false, replaceNamesMaps,
                        excludeClz, exculdePropertyNames);
            }
            if (i != length - 1) {
                out.append(", ");
            }
        }

        out.append("]");

    }

    private static void buildMap(String targetName, Object in,
            StringBuilder out, boolean incollect,
            Map<String, String> replaceNamesMaps, Set<Class<?>> excludeClz,
            Set<String> exculdePropertyNames) throws Exception {

        out.append("{");

        int oldLength = out.length();
        for (Map.Entry<?, ?> entry : ((Map<?, ?>) in).entrySet()) {
            String propertyName = getSimpleTypeStr(entry.getKey());
            Object value = entry.getValue();

            if (isSimpleType(value)) {
                if (out.length() > oldLength) {
                    out.append(", ");
                }
                out.append(propertyName);
                out.append(":");
                out.append(getSimpleTypeStr(value));
            } else {
                if (out.length() > oldLength) {
                    out.append(", ");
                }
                buildNode(propertyName, value, out, true, replaceNamesMaps,
                        excludeClz, exculdePropertyNames);
            }
        }
        out.append("}");
    }

    @SuppressWarnings("rawtypes")
    private static void buildObject(String targetName, Object in,
            StringBuilder out, boolean incollect,
            Map<String, String> replaceNamesMaps, Set<Class<?>> excludeClz,
            Set<String> exculdePropertyNames) throws Exception {

        Class clazz = in.getClass();
        // 去掉动态生成的类
        // if(clazz.getName().contains("$")){
        // return;
        // }

        out.append("{");
        int oldLength = out.length();

        PropertyDescriptor[] props;
        if (clazz.getName().contains("$")) {
            props = Introspector.getBeanInfo(clazz, clazz.getSuperclass())
                    .getPropertyDescriptors();
        } else {

            props = Introspector.getBeanInfo(in.getClass())
                    .getPropertyDescriptors();
        }

        if (props != null) {
            for (PropertyDescriptor property : props) {
                // 去掉动态生成的方法
                // if (property.getName().contains("$")) {
                // continue;
                // }
                if (isExcludedType(property.getPropertyType(), excludeClz)) {
                    continue;
                }

                if (isExcludedName(property.getName(), exculdePropertyNames)) {
                    continue;
                }

                try {

                    Method accessor = property.getReadMethod();
                    Method readMethod = null;

                    if (clazz.getName().indexOf("$$EnhancerByCGLIB$$") > -1) { // 如果是CGLIB动态生成的类
                        try {
                            // 下面的逻辑是根据CGLIB动态生成的类名，得到原本的实体类名
                            // 例如 EntityClassName$$EnhancerByCGLIB$$ac21e这样
                            // 的类，将返回的是EntityClassName这个类中的相应方法，若
                            // 获取不到对应方法，则说明要序列化的属性例如hibernateLazyInitializer之类
                            // 不在原有实体类中，而是仅存在于CGLib生成的子类中，此时baseAccessor
                            // 保持为null
                            readMethod = Class.forName(
                                    clazz.getName().substring(0,
                                            clazz.getName().indexOf("$$")))
                                    .getDeclaredMethod(accessor.getName(),
                                            accessor.getParameterTypes());
                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }
                    } else {
                        // 若不是CGLib生成的类，那么要序列化的属性的accessor方法就是该类中的方法。
                        readMethod = accessor;
                    }

                    if (readMethod != null) {
                        Object value = property.getReadMethod().invoke(in);
                        if (value == null) {
                            continue;
                        }

                        String key = property.getName();
                        if (replaceNamesMaps.get(key.trim()) != null) {
                            key = replaceNamesMaps.get(key);
                        }

                        if (isSimpleType(value)) {

                            if (out.length() > oldLength) {
                                out.append(", ");
                            }
                            out.append(QUOTE + key + QUOTE);
                            out.append(":");
                            out.append(getSimpleTypeStr(value));
                        } else {
                            if (out.length() > oldLength) {
                                out.append(", ");
                            }
                            buildNode(key, value, out, true, replaceNamesMaps,
                                    excludeClz, exculdePropertyNames);
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        out.append("}");
    }

}

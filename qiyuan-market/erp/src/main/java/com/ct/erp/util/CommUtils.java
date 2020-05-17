package com.ct.erp.util;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Date;

public class CommUtils {
	public static void copyBean(Object source,Object target) throws NoSuchMethodException, IllegalAccessException, IllegalArgumentException, InvocationTargetException{
        if(source.getClass()!=target.getClass()) return;
        if(source==null) return;
        if(target==null) return;
        
		Field[] field = source.getClass().getDeclaredFields();        //获取实体类的所有属性，返回Field数组  
        for(int j=0 ; j<field.length ; j++){     //遍历所有属性
                String name = field[j].getName();    //获取属性的名字
                name = name.substring(0,1).toUpperCase()+name.substring(1); //将属性的首字符大写，方便构造get，set方法
                String type = field[j].getGenericType().toString();    //获取属性的类型
                if(type.equals("class java.lang.String")){   //如果type是类类型，则前面包含"class "，后面跟类名
                    Method m = source.getClass().getMethod("get"+name);
                    String value = (String) m.invoke(source);    //调用getter方法获取属性值
                    Method m1=target.getClass().getMethod("set"+name,String.class);
                    m1.invoke(target, value);
                }else
                if(type.equals("class java.lang.Integer")){     
                    Method m = source.getClass().getMethod("get"+name);
                    Integer value = (Integer) m.invoke(source);
                    Method m1=target.getClass().getMethod("set"+name,Integer.class);
                    m1.invoke(target, value);
                }else
                if(type.equals("class java.lang.Short")){     
                    Method m = source.getClass().getMethod("get"+name);
                    Short value = (Short) m.invoke(source);
                    Method m1=target.getClass().getMethod("set"+name,Short.class);
                    m1.invoke(target, value);
                }else       
                if(type.equals("class java.lang.Double")){     
                    Method m = source.getClass().getMethod("get"+name);
                    Double value = (Double) m.invoke(source);
                    Method m1=target.getClass().getMethod("set"+name,Double.class);
                    m1.invoke(target, value);
                }else                  
                if(type.equals("class java.lang.Long")){     
                    Method m = source.getClass().getMethod("get"+name);
                    Long value = (Long) m.invoke(source);
                    Method m1=target.getClass().getMethod("set"+name,Long.class);
                    m1.invoke(target, value);
                }else 
                if(type.equals("class java.lang.Boolean")){
                    Method m = source.getClass().getMethod("get"+name);    
                    Boolean value = (Boolean) m.invoke(source);
                    Method m1=target.getClass().getMethod("set"+name,Boolean.class);
                    m1.invoke(target, value);
                 }else
                if(type.equals("class java.util.Date")){
                    Method m = source.getClass().getMethod("get"+name);                    
                    Date value = (Date) m.invoke(source);
                    Method m1=target.getClass().getMethod("set"+name,Date.class);
                    m1.invoke(target, value);
                }if(type.equals("class java.lang.Boolean")){
                  Method m = source.getClass().getMethod("get"+name);                    
                  Boolean value = (Boolean) m.invoke(source);
                  Method m1=target.getClass().getMethod("set"+name,Date.class);
                  m1.invoke(target, value);
                }else{
                     //
                }              
            }
    }
}

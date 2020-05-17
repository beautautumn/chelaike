package com.ct.erp.core.tag;

import java.io.IOException;

import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import com.ct.erp.common.model.json.ComboBox;


public class ComboBoxTag  extends TagSupport {
	protected String id;// ID
	protected String text;// 显示文本
	protected String url;//远程数据
	protected String name;//控件名称
	protected Integer width;//宽度
	protected Integer listWidth;//下拉框宽度
	protected Integer listHeight;//下拉框高度
	protected boolean editable=true;//定义是否可以直接到文本域中键入文本
	private boolean multiple=false;
	private boolean disabled=false;
	public int doStartTag() throws JspTagException {
		return EVAL_PAGE;
	}
	public int doEndTag() throws JspTagException {
		try {
			JspWriter out = this.pageContext.getOut();
			out.print(end().toString());
			out.flush();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return EVAL_PAGE;
	}
	public StringBuffer end() {
		StringBuffer sb = new StringBuffer();
		ComboBox comboBox=new ComboBox();
		comboBox.setText(text);
		comboBox.setId(id);
		sb.append("<script type=\"text/javascript\">"
				//+"$(function() {"
				+"$( document ).ready(function() {"
				+"$(\'#id"+id+"\').combobox({"
				+"url:\'"+url+"\',"
				+"editable:"+editable+","
				+"disabled:"+disabled+","
				+"valueField:\'id\',"
				+"textField:\'name\'," 
				+"width:\'"+width+"\'," 
				+"listWidth:\'"+listWidth+"\'," 
				+"listHeight:\'"+listWidth+"\'," 
				+"onChange:function(){"			
				+"var val = $(\'#id"+id+"\').combobox(\'getValues\');"
				+"$(\'#"+id+"\').val(val);"
				+"}"
				+"});"
				//+"console.log('the id is:"+id+" name is :"+name+"');"
				+"});"
				
				+"</script>");
		sb.append("<input type=\"hidden\" name=\""+name+"\" id=\""+id+"\"  />");
		sb.append("<input class=\"easyui-combobox\" panelHeight=\"auto\" id=\"id"+id+"\" />");
		return sb;
	}
	public void setId(String id) {
		this.id = id;
	}
	public void setText(String text) {
		this.text = text;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Integer getWidth() {
		return width;
	}
	public void setWidth(Integer width) {
		this.width = width;
	}
	public Integer getListWidth() {
		return listWidth;
	}
	public void setListWidth(Integer listWidth) {
		this.listWidth = listWidth;
	}
	public Integer getListHeight() {
		return listHeight;
	}
	public void setListHeight(Integer listHeight) {
		this.listHeight = listHeight;
	}
	public boolean isEditable() {
		return editable;
	}
	public void setEditable(boolean editable) {
		this.editable = editable;
	}
	public boolean isMultiple() {
		return multiple;
	}
	public void setMultiple(boolean multiple) {
		this.multiple = multiple;
	}
	public String getId() {
		return id;
	}
	public String getText() {
		return text;
	}
	public String getUrl() {
		return url;
	}
	public String getName() {
		return name;
	}
	public boolean isDisabled() {
		return disabled;
	}
	public void setDisabled(boolean disabled) {
		this.disabled = disabled;
	}
	
	
	
}

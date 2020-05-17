package com.ct.erp.common.model;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.apache.commons.lang3.builder.ToStringBuilder;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * easyui树形节点Menu模型.
 * 
 * @author : 尔演&Eryan eryanwcp@gmail.com
 * @date : 2013-9-11 下午10:01:30
 */
@SuppressWarnings("serial")
public class Menu implements Serializable {

	/**
	 * 节点id
	 */
	private String id;
	/**
	 * 树节点名称
	 */
	private String text;
	/**
	 * 前面的小图标样式
	 */
	private String iconCls;
	/**
	 * URL
	 */
	private String href;
	/**
	 * 自定义属性
	 */
	private Map<String, Object> attributes = Maps.newHashMap();
	/**
	 * 子节点
	 */
	private List<Menu> children = Lists.newArrayList();


	/**
	 * 添加子节点.
	 * 
	 * @param childMenu
	 *            子节点
	 */
	public void addChild(Menu childMenu) {
		this.children.add(childMenu);
	}

	/**
	 * 节点id
	 */
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	/**
	 * 树节点名称
	 */
	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

    public String getHref() {
        return href;
    }

    public void setHref(String href) {
        this.href = href;
    }

    /**
	 * 自定义属性
	 */
	public Map<String, Object> getAttributes() {
		return attributes;
	}

	public void setAttributes(Map<String, Object> attributes) {
		this.attributes = attributes;
	}

	/**
	 * 子节点
	 */
	public List<Menu> getChildren() {
		return children;
	}

	public void setChildren(List<Menu> children) {
		this.children = children;
	}


	/**
	 * 图标样式
	 */
	public String getIconCls() {
		return iconCls;
	}

	public void setIconCls(String iconCls) {
		this.iconCls = iconCls;
	}
	
	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this);
	}

}

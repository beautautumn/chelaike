package com.ct.erp.common.model;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

import com.google.common.collect.Maps;
import org.apache.commons.lang3.builder.ToStringBuilder;

import com.google.common.collect.Lists;

/**
 * easyui树形节点TreeNode模型.
 * 
 * @author : 尔演&Eryan eryanwcp@gmail.com
 * @date : 2013-1-11 下午10:01:30
 */
@SuppressWarnings("serial")
public class TreeNode implements Serializable {

	/**
	 * 静态变量 展开节点
	 */
	public static final String STATE_OPEN = "open";
	/**
	 * 静态变量 关闭节点
	 */
	public static final String STATE_CLOASED = "closed";

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
	private String iconCls = "";
	/**
	 * 是否勾选状态（默认：否false）
	 */
	private Boolean checked = false;
	/**
	 * 自定义属性
	 */
	private Map<String, Object> attributes = Maps.newHashMap();
	/**
	 * 子节点
	 */
	private List<TreeNode> children;
	/**
	 * 是否展开 (open,closed)-(默认值:open)
	 */
	private String state = STATE_OPEN;

	public TreeNode() {
		this(null, null, "");
	}

	/**
	 * 
	 * @param id
	 *            节点id
	 * @param text
	 *            树节点名称
	 */
	public TreeNode(String id, String text) {
		this(id, text, "");
	}

	/**
	 * 
	 * @param id
	 *            节点id
	 * @param text
	 *            树节点名称
	 * @param iconCls
	 *            图标样式
	 */
	public TreeNode(String id, String text, String iconCls) {
		this(id, text, STATE_OPEN, iconCls);
	}

	/**
	 * 
	 * @param id
	 *            节点id
	 * @param text
	 *            树节点名称
	 * @param state
	 *            是否展开
	 * @param iconCls
	 *            图标样式
	 */
	public TreeNode(String id, String text, String state, String iconCls) {
		this.id = id;
		this.text = text;
		this.state = state;
		this.iconCls = iconCls;
		this.children = Lists.newArrayList();
	}

	/**
	 * 
	 * @param id
	 *            节点id
	 * @param text
	 *            树节点名称
	 * @param iconCls
	 *            图标样式
	 * @param checked
	 *            是否勾选状态（默认：否）
	 * @param attributes
	 *            自定义属性
	 * @param children
	 *            子节点
	 * @param state
	 *            是否展开
	 */
	public TreeNode(String id, String text, String iconCls, Boolean checked,
			Map<String, Object> attributes, List<TreeNode> children,
			String state) {
		super();
		this.id = id;
		this.text = text;
		this.iconCls = iconCls;
		this.checked = checked;
		this.attributes = attributes;
		this.children = children;
		this.state = state;
	}

	/**
	 * 添加子节点.
	 * 
	 * @param childNode
	 *            子节点
	 */
	public void addChild(TreeNode childNode) {
		this.children.add(childNode);
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

	/**
	 * 是否勾选状态（默认：否）
	 */
	public Boolean getChecked() {
		return checked;
	}

	public void setChecked(Boolean checked) {
		this.checked = checked;
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
	public List<TreeNode> getChildren() {
		return children;
	}

	public void setChildren(List<TreeNode> children) {
		this.children = children;
	}

	/**
	 * 是否展开
	 */
	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
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

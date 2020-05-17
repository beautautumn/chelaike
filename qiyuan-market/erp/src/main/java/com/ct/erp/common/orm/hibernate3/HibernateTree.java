package com.ct.erp.common.orm.hibernate3;


public interface HibernateTree {
	public static final String LFT = "lft";
	public static final String RGT = "rgt";
	public static final String PARENT = "parent";

	public Integer getLft();

	public void setLft(Integer lft);

	public Integer getRgt();

	public void setRgt(Integer rgt);

	public Long getParentId();

	public Long getId();

	public String getTreeCondition();
}

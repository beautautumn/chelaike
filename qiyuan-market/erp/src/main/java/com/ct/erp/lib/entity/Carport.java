package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Agency;

/**
 * Carport entity. @author MyEclipse Persistence Tools
 */

public class Carport implements java.io.Serializable {

	// Fields

	private Long id;
	private Agency agency;
	private Integer totalNum;
	private Integer usedNum;
	private Integer unusedNum;

	// Constructors

	/** default constructor */
	public Carport() {
	}

	/** full constructor */
	public Carport(Agency agency, Integer totalNum, Integer usedNum,
                   Integer unusedNum) {
		this.agency = agency;
		this.totalNum = totalNum;
		this.usedNum = usedNum;
		this.unusedNum = unusedNum;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Agency getAgency() {
		return this.agency;
	}

	public void setAgency(Agency agency) {
		this.agency = agency;
	}

	public Integer getTotalNum() {
		return this.totalNum;
	}

	public void setTotalNum(Integer totalNum) {
		this.totalNum = totalNum;
	}

	public Integer getUsedNum() {
		return this.usedNum;
	}

	public void setUsedNum(Integer usedNum) {
		this.usedNum = usedNum;
	}

	public Integer getUnusedNum() {
		return this.unusedNum;
	}

	public void setUnusedNum(Integer unusedNum) {
		this.unusedNum = unusedNum;
	}

}
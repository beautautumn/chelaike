package com.ct.erp.lib.entity;

/**
 * IdentityCard entity. @author MyEclipse Persistence Tools
 */

public class IdentityCard implements java.io.Serializable {

	// Fields

	private Long id;
	private String identityCard;
	private String cardName;
	private String cardDesc;
	private String validTag;

	// Constructors

	/** default constructor */
	public IdentityCard() {
	}

	/** full constructor */
	public IdentityCard(String identityCard, String cardName, String cardDesc,
			String validTag) {
		this.identityCard = identityCard;
		this.cardName = cardName;
		this.cardDesc = cardDesc;
		this.validTag = validTag;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getIdentityCard() {
		return this.identityCard;
	}

	public void setIdentityCard(String identityCard) {
		this.identityCard = identityCard;
	}

	public String getCardName() {
		return this.cardName;
	}

	public void setCardName(String cardName) {
		this.cardName = cardName;
	}

	public String getCardDesc() {
		return this.cardDesc;
	}

	public void setCardDesc(String cardDesc) {
		this.cardDesc = cardDesc;
	}

	public String getValidTag() {
		return this.validTag;
	}

	public void setValidTag(String validTag) {
		this.validTag = validTag;
	}

}
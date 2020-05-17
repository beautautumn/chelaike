package com.ct.erp.rent.web;


import java.io.PrintWriter;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.model.Result;
import com.ct.erp.common.utils.Struts2Utils;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.lib.entity.FeeItem;
import com.ct.erp.rent.service.FeeItemService;


@SuppressWarnings("serial")
@Scope("prototype")
@Controller("rent.FeeItemAction")
public class FeeItemAction extends SimpleActionSupport {
	private FeeItem feeItem;
	private Long feeItemId;
	
	@Autowired
	private FeeItemService feeItemService;
	public String view(){
		return null;
	}
	
	public String toUpdate(){
		if(this.feeItemId==null){
			return null;
		}else{
			this.feeItem = this.feeItemService.findById(this.feeItemId);
			return "fee_item_update";
		}
	}
	
	public String update(){
		PrintWriter out = null;
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html;charset=utf-8");
		if(feeItem==null){
			return null;
		}else{
			try{
				out = response.getWriter();
				this.feeItemService.update(this.feeItem,this.feeItemId);
				out.print("success");
				out.close();
			}catch (Exception e) {
				e.printStackTrace();
				out.print("error");
			}
		}
		return null;
	}
	
	
	public String toAdd(){
		return "fee_item_add";
	}
	
	public String add(){
		PrintWriter out = null;
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html;charset=utf-8");
		if(feeItem==null){
			return null;
		}else{
			try{
				out = response.getWriter();
				this.feeItemService.save(this.feeItem);
				out.print("success");
				out.close();
			}catch (Exception e) {
				e.printStackTrace();
				out.print("error");
			}
		}
		return null;
	}
	
	public void delete() throws Exception{
		if(this.feeItemId == null){
			return ;
		}
		try {
			this.feeItemService.delete(this.feeItemId);
			Result result = new Result(Result.SUCCESS, "操作成功!", null);
			Struts2Utils.renderJson(result);
		} catch (Exception e) {
			Result result = new Result(Result.ERROR, "操作失败!", null);
			Struts2Utils.renderJson(result);
			throw e;
		}
	}

	public FeeItem getFeeItem() {
		return feeItem;
	}

	public void setFeeItem(FeeItem feeItem) {
		this.feeItem = feeItem;
	}

	public FeeItemService getFeeItemService() {
		return feeItemService;
	}

	public void setFeeItemService(FeeItemService feeItemService) {
		this.feeItemService = feeItemService;
	}

	public Long getFeeItemId() {
		return feeItemId;
	}

	public void setFeeItemId(Long feeItemId) {
		this.feeItemId = feeItemId;
	}
	
	
	
	
}
package com.ct.erp.rent.web;

import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.model.Result;
import com.ct.erp.common.utils.Struts2Utils;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.lib.entity.FeeItem;
import com.ct.erp.lib.entity.ManagerFee;
import com.ct.erp.rent.model.ManagerFeeBean;
import com.ct.erp.rent.service.FeeItemService;
import com.ct.erp.rent.service.ManagerFeeService;
@Scope("prototype")
@Controller("rent.managerFeeAction")
public class ManagerFeeAction  extends SimpleActionSupport {
	private static final long serialVersionUID = 8706608353779301761L;
	private List<FeeItem> feeItems;
	private ManagerFeeBean managerFeeBean;
	private ManagerFee managerFee;
	@Autowired
	private FeeItemService feeItemService;
	@Autowired
	private ManagerFeeService managerFeeService;
	private Long managerFeeId;
	/**
	 * 转入新增页面
	 * @return
	 */
	public String toManagerFeePage(){
		if(managerFeeId != null){
			managerFee = managerFeeService.findById(managerFeeId);
			managerFeeBean = new ManagerFeeBean(managerFee);
		}
			feeItems = feeItemService.findByStatus("1");
		return "toManagerFeePage";
	}
	public String doAddManagerFee() throws Exception{
		PrintWriter out = null;
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html;charset=utf-8");
		try {
			out = response.getWriter();
			if(managerFeeId != null){
				managerFee = managerFeeService.findById(managerFeeId);
				managerFeeBean.setManagerFee(managerFee);
				managerFee = managerFeeBean.getManagerFee();
				managerFeeService.update(managerFee);
			}else{
				ManagerFee managerFee = managerFeeBean.getManagerFee();
				managerFeeService.save(managerFee);
			}
			out.print("success");
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
			out.print("error");
		}
		return null;
	}
	public void delManagerFee(){
		managerFee = managerFeeService.findById(managerFeeId);
		managerFeeService.delete(managerFee);
		Result result = new Result(Result.SUCCESS, "操作成功!", null);
		Struts2Utils.renderJson(result);
	}
	
	public List<FeeItem> getFeeItems() {
		return feeItems;
	}
	public void setFeeItems(List<FeeItem> feeItems) {
		this.feeItems = feeItems;
	}
	public ManagerFeeBean getManagerFeeBean() {
		return managerFeeBean;
	}
	public void setManagerFeeBean(ManagerFeeBean managerFeeBean) {
		this.managerFeeBean = managerFeeBean;
	}
	public Long getManagerFeeId() {
		return managerFeeId;
	}
	public void setManagerFeeId(Long managerFeeId) {
		this.managerFeeId = managerFeeId;
	}
	public ManagerFee getManagerFee() {
		return managerFee;
	}
	public void setManagerFee(ManagerFee managerFee) {
		this.managerFee = managerFee;
	}
	
}

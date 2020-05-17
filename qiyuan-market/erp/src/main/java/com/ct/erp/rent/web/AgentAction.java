package com.ct.erp.rent.web;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.lib.entity.Agent;
import com.ct.erp.lib.entity.Contract;
import com.ct.erp.rent.model.AgentBean;
import com.ct.erp.rent.service.AgentService;
import com.ct.erp.rent.service.ContractService;
import com.ct.erp.util.UcmsWebUtils;

@SuppressWarnings("serial")
@Scope("prototype")
@Controller("rent.AgentAction")
public class AgentAction extends SimpleActionSupport {
	private Long agentId;
	private Agent agent;
	private Long agencyId;
	private String agentName;
	private String agentIdCard;
	private Long contractId;
	private String otherRecvFee;
	private String otherFeeDesc;
	private List<Agent> listAgent = new ArrayList<Agent>();
	private List<AgentBean> agentList = new ArrayList<AgentBean>();
	private List<Contract> contracts=new ArrayList<Contract>();
	@Autowired
	private AgentService agentService;
	@Autowired
	private ContractService contractService;

	public String view() {
		return null;
	}

	public String add() {
		PrintWriter out = null;
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html;charset=utf-8");
		if (this.agent == null) {
			return null;
		} else {
			try {
				out = response.getWriter();
				this.agentService.save(this.agent, this.agencyId);
				out.print("success");
				out.close();
			} catch (Exception e) {
				e.printStackTrace();
				out.print("error");
			}
		}
		return null;
	}

	public String toManage() {
		if (this.agencyId == null) {
			return null;
		}
		// 默认显示
		if (this.agentName == null || this.agentName == "") {
			this.listAgent = this.agentService.findByAgencyId(this.agencyId);
			return "agent_manage";
			// 条件查询
		} else {
			this.listAgent = this.agentService.findByAgentName(this.agencyId,
					this.agentName);
			return "agent_manage";
		}
	}

	public String update() {
		PrintWriter out = null;
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html;charset=utf-8");
		try {
			out = response.getWriter();
			for (AgentBean agentBean : agentList) {
				Agent agent = this.agentService.findById(agentBean.getId());
				if (agent.getName().equals(agentBean.getName())
						&& agent.getIdCard().equals(agentBean.getIdCard())) {
					break;
				}
				agent.setName(agentBean.getName());
				agent.setIdCard(agentBean.getIdCard());
				agent.setUpdateTime(UcmsWebUtils.now());
				this.agentService.update(agent);
			}
			out.print("success");
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
			out.print("error");
		}
		return null;
	}
	
	public String singleUpdate() {
		PrintWriter out = null;
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html;charset=utf-8");
		try {
			out = response.getWriter();
			this.agentService.singleUpdate(this.agentId,this.agentIdCard,this.agentName);
			out.print("success");
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
			out.print("error");
		}
		return null;
	}

	public String delete() {
		PrintWriter out = null;
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html;charset=utf-8");
		if (this.agentId == null) {
			return null;
		} else {
			try {
				out = response.getWriter();
				this.agentService.delete(this.agentId);
				out.print("success");
				out.close();
			} catch (Exception e) {
				e.printStackTrace();
				out.print("error");
			}
		}
		return null;
	}
	public String toOtherFee(){
		contracts=this.contractService.findAvaByAgencyId(agencyId);
		return "toOtherFee";
	}
	public String dealOtherFee(){
		PrintWriter out = null;
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html;charset=utf-8");
		
		try {
			out = response.getWriter();
			this.contractService.dealOtherFee(contractId,otherRecvFee,otherFeeDesc);
			out.print("success");
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
			out.print("error");
		}
		
		return null;
	}
	

	public Long getAgencyId() {
		return agencyId;
	}

	public void setAgencyId(Long agencyId) {
		this.agencyId = agencyId;
	}

	public List<Agent> getListAgent() {
		return listAgent;
	}

	public void setListAgent(List<Agent> listAgent) {
		this.listAgent = listAgent;
	}

	public Long getAgentId() {
		return agentId;
	}

	public void setAgentId(Long agentId) {
		this.agentId = agentId;
	}

	public Agent getAgent() {
		return agent;
	}

	public void setAgent(Agent agent) {
		this.agent = agent;
	}

	public AgentService getAgentService() {
		return agentService;
	}

	public void setAgentService(AgentService agentService) {
		this.agentService = agentService;
	}

	public String getAgentName() {
		return agentName;
	}

	public void setAgentName(String agentName) {
		this.agentName = agentName;
	}

	public List<AgentBean> getAgentList() {
		return agentList;
	}

	public void setAgentList(List<AgentBean> agentList) {
		this.agentList = agentList;
	}

	public String getAgentIdCard() {
		return agentIdCard;
	}

	public void setAgentIdCard(String agentIdCard) {
		this.agentIdCard = agentIdCard;
	}

	public List<Contract> getContracts() {
		return contracts;
	}

	public void setContracts(List<Contract> contracts) {
		this.contracts = contracts;
	}

	public String getOtherRecvFee() {
		return otherRecvFee;
	}

	public void setOtherRecvFee(String otherRecvFee) {
		this.otherRecvFee = otherRecvFee;
	}

	public String getOtherFeeDesc() {
		return otherFeeDesc;
	}

	public void setOtherFeeDesc(String otherFeeDesc) {
		this.otherFeeDesc = otherFeeDesc;
	}

	public Long getContractId() {
		return contractId;
	}

	public void setContractId(Long contractId) {
		this.contractId = contractId;
	}
	
	
	
}
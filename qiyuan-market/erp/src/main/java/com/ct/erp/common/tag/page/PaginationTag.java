package com.ct.erp.common.tag.page;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.BodyTagSupport;

import com.ct.erp.common.model.FlexiGridPageInfo;

public class PaginationTag extends BodyTagSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -189879708577798415L;

	private FlexiGridPageInfo pager;
	
	private String submitFun;
	
	public int doEndTag() throws JspException {
		try {
			HttpServletRequest request = (HttpServletRequest) super.pageContext.getRequest();
			StringBuilder sb = new StringBuilder();
			createPaginateDiv(sb);
			createPaginateJs(sb);
			JspWriter out = super.pageContext.getOut();
			out.write(sb.toString());
		} catch (Exception exception) {
			throw new JspException(exception);
		}
		return SKIP_BODY;
	}
	
	private void createPaginateDiv(StringBuilder sb){
		sb.append("<div id=\"pagination\"></div>");
		sb.append("<inupt type=\"hidden\" name=\"pageNo\"  id=\"pageNo\" value=\""+pager.getPage()+"\"></input>");
		sb.append("<inupt type=\"hidden\" name=\"pageSize\"  id=\"pageSize\" value=\""+pager.getRp()+"\"></input>");
	}
	
	private void createPaginateJs(StringBuilder sb){
		sb.append("<script type=\"text/javascript\">");
		sb.append("function pageselectCallback(page_index, jq){");
			sb.append("$(\"#pageNo\").val(page_index);");
			sb.append("console.log(\"the page_indexs is %s\",page_index);");
			sb.append(this.submitFun);
			sb.append("();");
		sb.append("}");
		
		sb.append("function initPagination() {");		
			sb.append("$(\"#pagination\").pagination("+pager.getTotal()+", {");
			sb.append("callback: pageselectCallback,");
			sb.append("link_to : 'javascript:void(0);',");
			sb.append("current_page : "+(pager.getPage()-1)+",");
			sb.append("items_per_page : "+pager.getRp()+",");
			sb.append("num_display_entries : "+pager.getNde()+",");
			sb.append("prev_text : '上一页',");
			sb.append("next_text : '下一页'");
			sb.append("});");
		sb.append("}");
		sb.append("$(document).ready(function(){  ");		
			sb.append("initPagination();");
		sb.append("});");
		
		sb.append(" </script>");
	}

	
	public FlexiGridPageInfo getPager() {
		return pager;
	}

	public void setPager(FlexiGridPageInfo pager) {
		this.pager = pager;
	}

	public String getSubmitFun() {
		return submitFun;
	}

	public void setSubmitFun(String submitFun) {
		this.submitFun = submitFun;
	}
	
	
	
}

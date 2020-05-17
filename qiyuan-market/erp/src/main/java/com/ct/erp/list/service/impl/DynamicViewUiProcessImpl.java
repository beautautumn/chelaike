package com.ct.erp.list.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import com.ct.erp.common.model.GridPageInfo;
import com.ct.erp.lib.entity.Sysright;
import com.ct.erp.list.model.AbsElement;
import com.ct.erp.list.model.Button;
import com.ct.erp.list.model.ComparatorElement;
import com.ct.erp.list.model.ConditionBean;
import com.ct.erp.list.model.ConditionInfo;
import com.ct.erp.list.model.DialogBean;
import com.ct.erp.list.model.DialogInfo;
import com.ct.erp.list.model.Form;
import com.ct.erp.list.model.Input;
import com.ct.erp.list.model.Option;
import com.ct.erp.list.model.PageConfigBean;
import com.ct.erp.list.model.PageTableColBean;
import com.ct.erp.list.model.PageTableColInfo;
import com.ct.erp.list.model.Select;
import com.ct.erp.list.model.SelectBean;
import com.ct.erp.list.model.StateQueryBtnBean;
import com.ct.erp.list.service.DynamicViewUiProcess;
import com.ct.util.AppRunTimeException;
import com.ct.util.lang.ComUtils;

@Service
public class DynamicViewUiProcessImpl  implements DynamicViewUiProcess{

	private static final String LINESPACE=" \n";
	

	/**
	 * 生成默认下拉框html
	 * @Title:	combinConditonDefSelectHtml
	 * @param buf
	 * @param bean
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午04:07:54
	 */
	public void combinConditonDefSelectHtml(StringBuilder buf,ConditionBean bean,Map<String,String> formMap){
		if(bean==null) return;
		buf.append(" <select name=\"mainSelect\"  id=\"mainSelect\" class=\"chzn-select\"  tabindex=\"2\"");
		if(bean!=null){
			if(StringUtils.isNotEmpty(bean.getSelectStyle())){
				buf.append(" style=\"");
				buf.append(bean.getSelectStyle());
				buf.append("\"");
			}
			buf.append(">");
			List<ConditionInfo> conditionList=bean.getConditionInfos();
			ConditionInfo condition=searchVisibleCondition(conditionList, formMap);
			if(conditionList!=null){
				for(ConditionInfo c:conditionList){
					//支持参数配置的时候选中已经配置的option
					if(c.equals(condition)){
						
					}
					if(c.equals(condition)){
						buf.append(" <option selected  value=\"");
						buf.append(c.getOption().getValue());
						buf.append("\">");
						buf.append(c.getOption().getText());
						buf.append("</option> \n");
					}else {
						buf.append(" <option  value=\"");
						buf.append(c.getOption().getValue());
						buf.append("\">");
						buf.append(c.getOption().getText());
						buf.append("</option> \n");
					}
				}
			}			
		}


		buf.append("</select> ");
		buf.append(LINESPACE);
	}
	/**
	 * 生成文本框html
	 * @Title:	combinInput
	 * @param buf
	 * @param input
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午04:08:15
	 */
	public void combinInput(StringBuilder buf,Input input){
		buf.append("<input type=\"text\" onFocus =\"clearObj(this);\"");
		if(StringUtils.isNotEmpty(input.getDefultValue())){
			buf.append(" value=\"");
			buf.append(input.getDefultValue());
			buf.append("\"");
		}
		if(StringUtils.isNotEmpty(input.getInputClass())){
			buf.append(" class=\"");
			buf.append(input.getInputClass());
			buf.append("\"");
		}
		if(StringUtils.isNotEmpty(input.getName())){
			buf.append(" name=\"");
			buf.append(input.getName());
			buf.append("\"");
		}
		if(StringUtils.isNotEmpty(input.getOnclick())){
			buf.append(" onclick=\"");
			buf.append(input.getOnclick());
			buf.append("\"");
		}
		if(StringUtils.isNotEmpty(input.getPattern())){
			buf.append(" pattern=\"");
			buf.append(input.getPattern());
			buf.append("\"");
		}		
		if(StringUtils.isNotEmpty(input.getStyle())){
			buf.append(" style=\"");
			buf.append(input.getStyle());
			buf.append("\"");
		}
		if(StringUtils.isNotEmpty(input.getWidth())){
			buf.append(" width=\"");
			buf.append(input.getWidth());
			buf.append("\"");
		}		
		buf.append("/>");
		buf.append(LINESPACE);
	}
	/**
	 * 生成默认条件文本框html
	 * @Title:	combinConditionDefInputHtml
	 * @param buf
	 * @param bean
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午04:08:26
	 */
	public void combinConditionDefInputHtml(StringBuilder buf,ConditionBean bean, Map<String, String> formMap,List<Sysright> sysrightList){
		if(bean==null)return;
		List<ConditionInfo> conditionList=bean.getConditionInfos();
		ConditionInfo condition=searchVisibleCondition(conditionList, formMap);
		if(condition!=null){
			ComparatorElement compElement=new ComparatorElement();
			List<AbsElement> list=new ArrayList<AbsElement>();
			if(condition.getInputList()!=null){
				list.addAll(condition.getInputList());
			}
			if(condition.getSelectList()!=null){
				list.addAll(condition.getSelectList());
			}			
			Collections.sort(list,compElement);
			for(AbsElement element:list){
				boolean showAuth=false;
				if(element!=null&&StringUtils.isNotBlank(element.getRightCode())){
					String rightCodes[]=element.getRightCode().split(",");//此处可以设置有多个权限
					if(sysrightList!=null){
						for(String rightCode:rightCodes){						
							for(Sysright right:sysrightList){
								if(right.getRightCode().equals(rightCode)){
									showAuth=true;
									break;
								}
							}
						}
					}
	
				}else showAuth=true;
				if(showAuth){
					if(element instanceof Input){
						combinSimpleConditionInputHtml(buf, (Input)element, formMap);
					}else if(element instanceof SelectBean){					
						combinSimpleCondtionSelectHtml(buf, (SelectBean)element, formMap);
					}					
				}
			}
			//combinMutiptCondtionSelectHtml(buf, condition, formMap);
			//combinMutiptConditionInputHtml(buf, condition, formMap);			
			buf.append(LINESPACE);
		}
	}
	
	/**
	 * 判断是否下拉框是否可以选中
	 * @param conditionList  调价list
	 * @param formMap        前台参数map
	 * @return               当前显示的对象
	 */
	public ConditionInfo searchVisibleCondition(List<ConditionInfo> conditionList,Map<String, String> formMap){
		ConditionInfo result=null;
		for(ConditionInfo c:conditionList){
			//如果是查找到是参数传递的对象，那么返回
			if(c.isVersible(formMap)){
				return c;
			}
			//如果不是那么就查找默认显示对象
			if(c.getOption()!=null&&c.getDefaultFlag()!=null&&c.getDefaultFlag().equals("true")){
				result=c;
			}
		}
		return result;
	}
	
	public void combinConditionHiddenInputHtml(StringBuilder buf,ConditionBean bean){
		if(bean==null)return;
		List<ConditionInfo> conditionList=bean.getConditionInfos();
		for(ConditionInfo c:conditionList){
			if(c.getOption()!=null&&c.getDefaultFlag()!=null&&c.getDefaultFlag().equals("true")){
				combinMutiptConditionInputHtml(buf, c, null);
				buf.append(LINESPACE);
			}
		}
	}
	
	
	/**
	 * 生成条件处理html
	 */
	public String conditionBeanProcess(ConditionBean bean,Map<String,String> formMap)
			throws AppRunTimeException {
		if(bean!=null){
			StringBuilder buf=new StringBuilder();
			combinConditonDefSelectHtml(buf, bean,formMap);
			return buf.toString();
		}return "";

	}
	
	public String conditionInputBeanProcess(ConditionBean bean, Map<String, String> formMap,List<Sysright> sysrightList)
			throws AppRunTimeException {
		if (bean != null) {
			StringBuilder buf = new StringBuilder();
			combinConditionDefInputHtml(buf, bean,formMap,sysrightList);
			return buf.toString();
		}
		return "";

	}
	
	
	public String combinSelectHiddenValue(ConditionBean bean)
			throws AppRunTimeException {
		StringBuilder buf = new StringBuilder();
		List<ConditionInfo> conditionList=bean.getConditionInfos();
		for(ConditionInfo c:conditionList){
			if(c.getOption()!=null&&c.getDefaultFlag()!=null&&c.getDefaultFlag().equals("true")){
				combinSelectHiddenValue(buf, c, null);
				buf.append(LINESPACE);
			}
		}
		return buf.toString();

	}
	

	public void combinSelectHiddenValue(StringBuilder buf,
			ConditionInfo info, Map<String, String> formMap) {
		buf.append("<input type=\"hidden\" id=\"_mainSelect\" name=\"_mainSelect\" value=\"");
		buf.append(info.getOption().getValue());
		buf.append("\" ></input>");
		buf.append(LINESPACE);
	}
	
	public void combinMutiptCondtionSelectHtml(StringBuilder buf,
			ConditionInfo info, Map<String, String> formMap) {
		List<SelectBean> selectList=info.getSelectList();
		if(selectList!=null){
			for(SelectBean bean:selectList){
//				if(StringUtils.isNotBlank(bean.getLabel())){
					buf.append(bean.getLabel());
					buf.append("<select ");
					if(StringUtils.isNotBlank(bean.getName())){
						buf.append(" name='");
						buf.append(bean.getName()).append("'");
					}
					if(StringUtils.isNotBlank(bean.getCssClass())){
						buf.append(" class='");
						buf.append(bean.getCssClass()).append("'");
					}
					if(StringUtils.isNotBlank(bean.getStyle())){
						buf.append(" style='");
						buf.append(bean.getStyle()).append("'");
					}	
					buf.append(">");
					for(Option option:bean.getOptions()){
						buf.append("<option value='");
						buf.append(option.getValue()).append("'>");
						buf.append(option.getText());
						buf.append("</option>");
					}
					buf.append("</select>");
//				}

			}
		}
	}

	public void combinSimpleCondtionSelectHtml(StringBuilder buf,
			SelectBean bean, Map<String, String> formMap) {
//		if (StringUtils.isNotBlank(bean.getLabel())) {
            if(bean.getNewLine()){
                buf.append("<div class=\"over-line\"></div>");
            }
			buf.append("<span style=\"display:-moz-inline-box;display:inline-block;padding-left:5px;\">");
            if(StringUtils.isNotBlank(bean.getLabel())) {
                buf.append("<span title=\"" + bean.getLabel() + "\" class=\"over-label\">");
                buf.append(bean.getLabel());
                buf.append("</span>");
            }
			buf.append("<select ");
			if (StringUtils.isNotBlank(bean.getName())) {
				buf.append(" name='");
				buf.append(bean.getName()).append("'");
			}
			if (StringUtils.isNotBlank(bean.getId())) {
				buf.append(" id='");
				buf.append(bean.getId()).append("'");
			}	
			if (StringUtils.isNotBlank(bean.getOnchange())) {
				buf.append(" onchange=\"");
				buf.append(bean.getOnchange()).append("\"");
			}
			if(StringUtils.isNotBlank(bean.getCssClass())){
				buf.append(" class='");
				buf.append(bean.getCssClass()).append("'");
			}
			if (StringUtils.isNotBlank(bean.getStyle())) {
				buf.append(" style='");
				buf.append(bean.getStyle()).append("'");
			}
			buf.append(">");
			for (Option option : bean.getOptions()) {
				buf.append("<option value='");
				buf.append(option.getValue()).append("'");
				
				if(option.isDefaultSelect()){
					buf.append(" selected ");
				}
				buf.append(">");
				buf.append(option.getText());
				buf.append("</option>");
			}
			buf.append("</select>");
			buf.append(" </span>");
			if(bean.isWrap()){
				buf.append("<br>");
			}
//		}
	}
	
	public void combinSimpleConditionInputHtml(StringBuilder buf,
			Input input, Map<String, String> formMap) {
	    if(input.getNewLine()){
	        buf.append("<div class=\"over-line\"></div>");
        }
		buf.append("<span style=\"display:-moz-inline-box;display:inline-block;padding-left:5px;\">");		
		if(StringUtils.isNotEmpty(input.getText())){
			combinInputLavelText(buf, input.getText(), input.getLabelClass());
		}
		combinInput(buf, input, formMap);
		buf.append(" </span>");
		if(input.isWrap()){
			buf.append("<br>");
		}
	}
	
	
	
	public void combinMutiptConditionInputHtml(StringBuilder buf,
			ConditionInfo info, Map<String, String> formMap) {
		List<Input> inputList = info.getInputList();
		Option option = info.getOption();
		if (info.getNodeType().equals("input")) {
			if (inputList != null) {
				for (Input input : inputList) {
					//buf.append("<div style=\"float:left;\">");
					if(StringUtils.isNotEmpty(input.getText())){
						combinInputLavelText(buf, input.getText());
					}
					combinInput(buf, input, formMap);
					//buf.append("</div>");
					buf.append(LINESPACE);
				}
			}
		} else if (info.getNodeType().equals("select")) {
			
			buf.append("<div class=\"input_select_div\">");
			combinInputLavelText(buf, option.getText());
			combinConditonRowSelectHtml(buf, info.getSecondSelect(),formMap);
			buf.append("</div>");
			buf.append(LINESPACE);
			
			if (inputList != null) {
				for (Input input : inputList) {
					//buf.append("<div class=\"search-input\">");
					if(StringUtils.isNotEmpty(input.getText())){
						combinInputLavelText(buf, input.getText());
					}
					combinInput(buf, input, formMap);
					//buf.append("</div>");
					buf.append(LINESPACE);
				}
			}			
		}
	}

    private void combinInputLavelText(StringBuilder buf,String text){
        combinInputLavelText(buf, text,"over-label");
    }

	private void combinInputLavelText(StringBuilder buf,String text, String labelClass){
		buf.append("<span title=\""+text+"\" class=\""+labelClass+"\">");
		buf.append(text);
		buf.append("</span>");
	}
	
	public void combinConditonRowSelectHtml(StringBuilder buf,Select bean,Map<String, String> formMap){
		buf.append(" <select name=\""+bean.getName()+"\" ");
		List<Option> optionList=bean.getOptions();
		
		if(bean!=null){
			if(StringUtils.isNotEmpty(bean.getStyle())){
				buf.append(" style=\"");
				buf.append(bean.getStyle().concat(";height:18px;margin-top:0px;"));
				buf.append("\"");
			}
			
			if(StringUtils.isNotEmpty(bean.getSelectClass())){
				buf.append(" class=\"");
				buf.append(bean.getSelectClass());
				buf.append("\"");
			}
			buf.append(">");
			for(Option o:optionList){
				if(formMap!=null&&formMap.get(bean.getName())!=null){
					buf.append(" <option selected value=\"");
				}else{
					buf.append(" <option  value=\"");
				}
				buf.append(o.getValue());
				buf.append("\">");
				buf.append(o.getText());
				buf.append("</option> \n");	
			}
		}
		buf.append("</select> ");
		buf.append(LINESPACE);
	}
	
	public void combinInput(StringBuilder buf,Input input,Map<String,String> formMap){
		String inputType = input.getType();
		inputType = (inputType == null || inputType.equals(""))?"text":"hidden";
		String inputClass="over-input";
        inputClass = StringUtils.isBlank(input.getInputClass())?inputClass:input.getInputClass();
		buf.append("<input class=\""+inputClass+"\" type=\""+inputType+"\" onFocus =\"clearObj(this);\"");
		if(formMap!=null&&formMap.containsKey(input.getName())){
			buf.append(" value=\"");
			buf.append(formMap.get(input.getName()));
			buf.append("\"");
		}
		/**
		else if(StringUtils.isNotEmpty(input.getDefultValue())){
			buf.append(" value=\"");
			buf.append(input.getDefultValue());
			buf.append("\"");
		}
		*/
		if(StringUtils.isNotBlank(input.getMonthDiff())){
			String dateVal;
			Date now=new Date();
			Calendar cal=new GregorianCalendar();
			cal.setTime(now);
			cal.add(Calendar.MONTH,Integer.parseInt(input.getMonthDiff()));
			buf.append(" value=\""+new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime())+"\"");
		}
		if(StringUtils.isNotEmpty(input.getInputClass())){
			buf.append(" class=\"");
			buf.append(input.getInputClass());
			buf.append("\"");
			if(input.getInputClass().equals("Wdate")){
				buf.append(" value=\"");
				if(StringUtils.isNotBlank(input.getDefultValue())){
					buf.append(ComUtils.format.format(ComUtils.getCurTimeByOffsetDay(Integer.valueOf(input.getDefultValue()))));
				}else{
					//buf.append(ComUtils.format.format(new Date()));
				}				
				buf.append("\"");
			}
		}
		if(StringUtils.isNotEmpty(input.getName())){
			buf.append(" name=\"");
			buf.append(input.getName());
			buf.append("\"");
		}
		if(StringUtils.isNotEmpty(input.getOnclick())){
			buf.append(" onclick=\"");
			buf.append(input.getOnclick());
			buf.append("\"");
		}
		if(StringUtils.isNotEmpty(input.getPattern())){
			buf.append(" pattern=\"");
			buf.append(input.getPattern());
			buf.append("\"");
		}		
		if(StringUtils.isNotEmpty(input.getStyle())){
			buf.append(" style=\"");
			
			buf.append(input.getStyle());			
			buf.append("\"");
		}
		if(StringUtils.isNotEmpty(input.getWidth())){
			buf.append(" width=\"");
			buf.append(input.getWidth());
			buf.append("\"");
		}
		if (StringUtils.isNotEmpty(input.getPlaceHolder())) {
			buf.append(" placeholder=\"");
			buf.append(input.getPlaceHolder());
			buf.append("\"");
		}
		buf.append("/>");
		buf.append(LINESPACE);
	}
	
	
	/**
	 * 生成条件列html
	 */
	public String pageTableColProcess(PageTableColBean colbean)
			throws AppRunTimeException {
		
		try {
			if(colbean.getColInfos()!=null){
				StringBuilder colBuf=new StringBuilder();
				colBuf.append("<tr> ");
				colBuf.append(LINESPACE);
				for(PageTableColInfo col:colbean.getColInfos()){
					colBuf.append("<td ");
					combinHeadColHtml(colBuf, col);
					colBuf.append(col.getColName());
					colBuf.append("</td> ");
					colBuf.append(LINESPACE);
					
				}
				colBuf.append("</tr> ");
				
				colBuf.append(LINESPACE);
				return colBuf.toString();
			}

		} catch (Exception e) {
			// TODO: handle exception
			throw new AppRunTimeException("表头列出错:"+e);
		}
		return null;
	}
	
	
	/**
	 * 根据列查找需要查询的colfiled域
	 */
	public List<String> findPageTableColProperty(PageTableColBean colbean,String type)throws AppRunTimeException{
		try {
			List<String> result=new ArrayList<String>();
			for(PageTableColInfo col:colbean.getColInfos()){
				if(StringUtils.isNotEmpty(type)){
					if(type.equals("1")){
						result.add(col.getColField());
					}
				}
			}
			return result;
		} catch (Exception e) {
			throw new AppRunTimeException(e);
		}
	}
	
	public Map<String,PageTableColInfo> findColFieldMap(PageTableColBean colbean)throws AppRunTimeException{
		try {
			Map<String,PageTableColInfo> result=new HashMap<String,PageTableColInfo>();
			for(PageTableColInfo col:colbean.getColInfos()){
				result.put(col.getColField(), col);
			}
			return result;
		} catch (Exception e) {
			// TODO: handle exception
			throw new AppRunTimeException(e);
		}
	}
	public void combinHeadColHtml(StringBuilder colBuf,PageTableColInfo col){
		
		if(StringUtils.isNotEmpty(col.getColClass())){
			colBuf.append(" class=\"");
			colBuf.append(col.getColClass());
			colBuf.append("\"");
		}
		if(StringUtils.isNotEmpty(col.getColWidth())){
			colBuf.append(" width=\"");
			colBuf.append(col.getColWidth());
			colBuf.append("\"");
		}
		colBuf.append(">");
	}
	
	public void combinDataHtml(StringBuilder colBuf,PageTableColInfo col){		
		if(StringUtils.isNotEmpty(col.getColClass())){
			colBuf.append(" class=\"");
			colBuf.append(col.getColClass());
			colBuf.append("\"");
		}
		if(StringUtils.isNotEmpty(col.getColWidth())){
			colBuf.append(" width=\"");
			colBuf.append(col.getColWidth());
			colBuf.append("\"");
		}
		colBuf.append(">");
	}

	/**
	 * 链接处理
	 * @Title:	combinLink
	 * @param info
	 * @param buf
	 * @param map
	 * @param path
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午04:10:51
	 */
	public void combinLink(PageTableColInfo info,StringBuilder buf,Map<String,Object> map,String path){
		buf.append("<td bgcolor=\"#ffffff\"");
		if(StringUtils.isNotEmpty(info.getColWidth())){
			buf.append(" width=\"");
			buf.append(info.getColWidth());
			buf.append("\"");
		}
		buf.append(">");
		buf.append("<a href=\"javascript:toViewDialog('");
		buf.append(info.getDialogInfo().getDialogTitle());
		buf.append("','");
		String url=info.getDialogInfo().getDialogUrl().replaceAll("#",(String)map.get(info.getColField()));
		buf.append(path+url);
		buf.append("',");
		buf.append(info.getDialogInfo().getDialogWidth());
		buf.append(",").append(info.getDialogInfo().getDialogHeight());
		buf.append(")\">");
		buf.append(ComUtils.filterNull(map.get(info.getColField())));
		buf.append("</a>");
		buf.append("</td>");
		buf.append(LINESPACE);
	}

	/**
	 * formHtml生成
	 * @Title:	combinFormHtml
	 * @param form
	 * @param buf
	 * @param value
	 * @param path
	 * @param condStr
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午04:11:38
	 */
	public void combinFormHtml(Form form,StringBuilder buf,String value,String path,String condStr)throws AppRunTimeException{
		buf.append("<form  name=\"rptForm\" action=\"");
		buf.append(path);
		buf.append(form.getAction());
		buf.append("\"");
		if(form.getFormClass()!=null&&StringUtils.isNotEmpty(form.getFormClass())){
			buf.append(" class=\"");
			buf.append(form.getFormClass());
			buf.append("\"");
		}
		if(form.getMethod()!=null&&StringUtils.isNotEmpty(form.getMethod())){
			buf.append(" method=\"");
			buf.append(form.getMethod());
			buf.append("\"");
		}	
		if(form.getStyle()!=null&&StringUtils.isNotEmpty(form.getStyle())){
			buf.append(" style=\"");
			buf.append(form.getStyle());
			buf.append("\"");
		}		
		buf.append(">");
		buf.append(LINESPACE);
		if(form.getHiddenName()!=null&&StringUtils.isNotEmpty(form.getHiddenName())){
			buf.append(" <input type=\"hidden\"  name=\"");
			buf.append(form.getHiddenName());
			buf.append("\" id=\"");
			buf.append(form.getHiddenName());
			buf.append("\"");
			if(StringUtils.isNotEmpty(value)){
				buf.append(" value=\"");
				buf.append(value);
				buf.append("\"");
			}
			
			buf.append(" />");
		}	
		
		buf.append(" <input type=\"hidden\"  name=\"condStr");
		buf.append("\" id=\"condStr");
		buf.append("\"");
		if(StringUtils.isNotEmpty(value)){
			buf.append(" value=\"");
			buf.append(condStr);
			buf.append("\"");
		}
		buf.append(" />");
		buf.append(LINESPACE);
		
	}
	
	/**
	 * 隐藏变量生成
	 * @Title:	combinPageCurInputHidden
	 * @param pageInfo
	 * @param buf
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午04:12:33
	 */
	public void combinPageCurInputHidden(GridPageInfo pageInfo,StringBuilder buf)throws AppRunTimeException{
		buf.append("<input type=\"hidden\" name=\"pageCount\"");
		buf.append(" value=\"");
		buf.append(pageInfo.getPageCount());
		buf.append("\"/>");
		buf.append(LINESPACE);
	}
	
	public void combinPageButton(Button button,GridPageInfo pageInfo,StringBuilder buf,String path)throws AppRunTimeException{
		buf.append("<input type=\"button\" value=\"");
		buf.append(button.getValue());
		buf.append("\"");
		if(button.getStyle()!=null){
			buf.append(" style=\"");
			buf.append(button.getStyle());
			buf.append("\"");
		}
		if(button.getOnclick()!=null){
			buf.append(" onclick=\"");
			buf.append(button.getOnclick());
			buf.append("\"/>");
		}		
		buf.append(LINESPACE);
	}
	

	
	/**
	 * 报表配置Map查找
	 */
	public Map<String,String> pageConfigProcess(PageConfigBean pageConfigBean,GridPageInfo pageInfo,String value,String path,String condStr)throws AppRunTimeException {		
		try {
			StringBuilder buf=new StringBuilder();
			Map<String,String> result=new HashMap<String,String>();
			if(pageConfigBean!=null){
				if(pageConfigBean.getForm()!=null){
					combinFormHtml(pageConfigBean.getForm(), buf,value,path,condStr);
					result.put("formHtml", buf.toString());
				}
			}
			return result;
		} catch (Exception e) {
			throw new AppRunTimeException(e);
		}
	}

	/**
	 * 对话框js生成
	 * @Title:	combinDialogScript
	 * @param path
	 * @param bean
	 * @param buf
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午04:13:56
	 */
	public void combinDialogScript(String path,DialogBean bean,StringBuilder buf)throws AppRunTimeException{
		buf.append("<script type=\"text/javascript\">");
		buf.append(LINESPACE);	
		for(DialogInfo info:bean.getDialogInfos()){
			
			if(info!=null&&(StringUtils.isNotBlank(info.getOpenMode())
					&&!info.getOpenMode().equals("_parent"))
					||info.getOpenMode()==null){
				buf.append(" function open_dialog_");
				buf.append(info.getDialogNumber());
				buf.append("(){");
				buf.append(LINESPACE);	
				
				buf.append("	var diag = new Dialog();");
				buf.append(LINESPACE);	
				buf.append("	diag.Width=");
				buf.append(info.getDialogWidth());
				buf.append(";");
				buf.append(LINESPACE);
				buf.append("	diag.Height=");
				buf.append(info.getDialogHeight());
				buf.append(";");
				buf.append(LINESPACE);			
				buf.append("	diag.Title=\"");
				buf.append(info.getDialogTitle());
				buf.append("\";");
				buf.append(LINESPACE);			
				buf.append("   diag.URL=\"");
				buf.append(path);
				buf.append(info.getDialogUrl());
				buf.append("\";");
				buf.append(LINESPACE);	
				buf.append("   diag.show(); ");
				buf.append(LINESPACE);	
				
				buf.append("}");
			}
		}
		buf.append(LINESPACE);	
		buf.append("</script>");
		buf.append(LINESPACE);
		
	}
	/**
	 * 对话框div生成
	 * @Title:	combinDialogDiv
	 * @param bean
	 * @param buf
	 * @throws AppRunTimeException
	 * @author:   jieketao
	 * Create at: 2012-1-18 下午04:14:09
	 */
	public void combinDialogDiv(DialogBean bean,StringBuilder buf,List<Sysright> sysrightList)throws AppRunTimeException{
		for(DialogInfo info:bean.getDialogInfos()){
			boolean rightOwnerFlag=false;
			//权限判断，有权限才展现对话框
			if(StringUtils.isNotBlank(info.getRightCode())){
				for(Sysright right:sysrightList){
					if(String.valueOf(right.getRightCode()).equals(info.getRightCode())){
						rightOwnerFlag=true;
						break;
					}
				}
				if(!rightOwnerFlag){
					continue;
				}
			}			
			if(StringUtils.isNotBlank(info.getHref())){
				buf.append("<a class=\"right-btn\" href=\"");
				buf.append(info.getHref());
				buf.append("\">");
				buf.append(info.getBtnText());
				buf.append("</a>");
				//buf.append("<span class=\"toolbar-btn-separator\"></span>");
			}else if(StringUtils.isNotBlank(info.getFunctionName())){
				buf.append("<a class=\"easyui-linkbutton\" iconCls=\""+info.getIconCls()+"\" plain=\"true\" href=\"javascript:");
				buf.append(info.getFunctionName()).append("();");
				buf.append("\">");
				buf.append(info.getBtnText());
				buf.append("</a>");
				//buf.append("<span class=\"toolbar-btn-separator\"></span>");
			}else{
				if(StringUtils.isNotBlank(info.getTarget())){
					if(info.getTarget().equals("dialog")){
						if(info.getOpenType().equals("max")){
							buf.append("<a class=\"easyui-linkbutton\" iconCls=\""+info.getIconCls()+"\"  plain=\"true\" href=\"javascript:menu.create_max_dialog_identy('");
							buf.append(info.getDialogId());
							buf.append("','");
							buf.append(info.getDialogTitle());
							buf.append("','");
							buf.append(info.getDialogUrl());
							buf.append("')\">");
							buf.append(info.getBtnText());
							buf.append("</a>");
						}else if(info.getOpenType().equals("remote")){
							buf.append("<a class=\"easyui-linkbutton\" iconCls=\""+info.getIconCls()+"\" plain=\"true\" href=\"javascript:menu.create_dialog_identy_remote('");
							buf.append(info.getDialogId());
							buf.append("','");
							buf.append(info.getDialogTitle());
							buf.append("','");
							buf.append(info.getDialogUrl());
							buf.append("',");
							buf.append(info.getDialogWidth());
							buf.append(",");
							buf.append(info.getDialogHeight());
							buf.append(",");
							buf.append(info.isLock());
							if(info.getOutLink()) {
								buf.append(",").append(info.getOutLink());
							}
							buf.append(")\">");
							buf.append(info.getBtnText());
							buf.append("</a>");
							buf.append(LINESPACE);

						}else if(info.getOpenType().equals("single")){
							buf.append("<a class=\"easyui-linkbutton\" iconCls=\""+info.getIconCls()+"\" plain=\"true\" href=\"javascript:menu.create_dialog_identy('");
							buf.append(info.getDialogId());
							buf.append("','");
							buf.append(info.getDialogTitle());
							buf.append("','");
							buf.append(info.getDialogUrl());
							buf.append("',");
							buf.append(info.getDialogWidth());
							buf.append(",");
							buf.append(info.getDialogHeight());
							buf.append(",");					
							buf.append(info.isLock());
							if(info.getOutLink()) {
								buf.append(",").append(info.getOutLink());
							}
							buf.append(")\">");
							buf.append(info.getBtnText());
							buf.append("</a>");
							buf.append(LINESPACE);
							
						}else if(info.getOpenType().equals("max_model")){
							buf.append("<a class=\"easyui-linkbutton\" iconCls=\""+info.getIconCls()+"\"  plain=\"true\" href=\"javascript:menu.create_model_max_dialog_identy('");
							buf.append(info.getDialogId());
							buf.append("','");
							buf.append(info.getDialogTitle());
							buf.append("','");
							buf.append(info.getDialogUrl());
							buf.append("')\">");
							buf.append(info.getBtnText());
							buf.append("</a>");
						}else if(info.getOpenType().equals("max_with_cancel")){//2014-04-22
							buf.append("<a class=\"easyui-linkbutton\" iconCls=\""+info.getIconCls()+"\"  plain=\"true\" href=\"javascript:menu.create_max_dialog_withCancel_identy('");
							buf.append(info.getDialogId());
							buf.append("','");
							buf.append(info.getDialogTitle());
							buf.append("','");
							buf.append(info.getDialogUrl());
							buf.append("')\">");
							buf.append(info.getBtnText());
							buf.append("</a>");
						}
					}
				}else{
					if(info.isMaximizable()){
						buf.append("<a class=\"easyui-linkbutton\" iconCls=\""+info.getIconCls()+"\"  plain=\"true\" href=\"javascript:menu.create_max_dialog_identy('");
						buf.append(info.getDialogId());
						buf.append("','");
						buf.append(info.getDialogTitle());
						buf.append("','");
						buf.append(info.getDialogUrl());
						buf.append("')\">");
						buf.append(info.getBtnText());
						buf.append("</a>");
						
					}else{
						buf.append("<a class=\"easyui-linkbutton\" iconCls=\""+info.getIconCls()+"\" plain=\"true\" href=\"javascript:menu.create_dialog_identy('");
						buf.append(info.getDialogId());
						buf.append("','");
						buf.append(info.getDialogTitle());
						buf.append("','");
						buf.append(info.getDialogUrl());
						buf.append("',");
						buf.append(info.getDialogWidth());
						buf.append(",");
						buf.append(info.getDialogHeight());
						buf.append(",");					
						buf.append(info.isLock());
						buf.append(")\">");
						buf.append(info.getBtnText());
						buf.append("</a>");
						buf.append(LINESPACE);
					}
				}
			}

		}
		buf.append(LINESPACE);
	}
	
	public String dialogBeanProcess(String path,DialogBean bean,List<Sysright> sysrightList)
			throws AppRunTimeException {
		
		try {
			if(bean!=null){
				StringBuilder buf=new StringBuilder();
				//this.combinDialogScript(path,bean, buf);
				combinDialogDiv(bean, buf,sysrightList);
				
				return buf.toString();
			}else return null;

		} catch (Exception e) {
			// TODO: handle exception
			throw new AppRunTimeException(e);
		}

	}

	public String conditionSilbingProcess(ConditionBean bean,String optionValue)
			throws AppRunTimeException {
		
		StringBuilder buf=new StringBuilder();
		List<ConditionInfo> conditionList=bean.getConditionInfos();
		
		for(ConditionInfo c:conditionList){
			if(c.getOption()!=null&&c.getOption().getValue().equals(optionValue)){
				List<Input> inputList=c.getInputList();
				if(inputList!=null){
					for(Input input:inputList){
						combinInput(buf, input);
					}
				}
				buf.append(LINESPACE);
			}
		}
		return buf.toString();
		
	}

	public void combinStateQueryBtn(Button button,StringBuilder buf){ 
		//buf.append("<div class=\"search-btn\">");
		//buf.append("<a class=\"fast-search\" href=\"javascript:");
		//buf.append("<a class=\"easyui-linkbutton\" href=\"javascript:");
		buf.append("<a class=\"btn\" id=\"btn_"+button.getBtnNo()+"\" href=\"javascript:");
		buf.append(button.getOnclick());
		buf.append("\"> ");
		buf.append(button.getBtnName());
		buf.append("</a>");
		//buf.append("</div>");
		buf.append(LINESPACE);
	}
	
	public String stateQueryBtnBeanProcess(StateQueryBtnBean bean)
			throws AppRunTimeException {		
		if(bean!=null){
			StringBuilder buf=new StringBuilder();
			List<Button> btnList=bean.getQueryBtnList();			
			for(Button btn:btnList){
				combinStateQueryBtn(btn, buf);
			}
			return buf.toString();
		}
		return null;
	}

}
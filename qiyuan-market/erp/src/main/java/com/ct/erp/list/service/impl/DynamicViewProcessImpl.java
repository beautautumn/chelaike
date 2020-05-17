package com.ct.erp.list.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import com.ct.erp.common.model.GridPageInfo;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.Sysright;
import com.ct.erp.list.model.Button;
import com.ct.erp.list.model.ConditionBean;
import com.ct.erp.list.model.ConditionInfo;
import com.ct.erp.list.model.CurInput;
import com.ct.erp.list.model.DialogBean;
import com.ct.erp.list.model.DialogInfo;
import com.ct.erp.list.model.Form;
import com.ct.erp.list.model.Input;
import com.ct.erp.list.model.OperateLink;
import com.ct.erp.list.model.Option;
import com.ct.erp.list.model.PageConfigBean;
import com.ct.erp.list.model.PageInfo;
import com.ct.erp.list.model.PageTableColBean;
import com.ct.erp.list.model.PageTableColInfo;
import com.ct.erp.list.model.PageTableInfo;
import com.ct.erp.list.model.Select;
import com.ct.erp.list.model.StateQueryBtnBean;
import com.ct.erp.list.service.DynamicViewProcess;
import com.ct.util.AppRunTimeException;
import com.ct.util.lang.ComUtils;
import com.ct.util.lang.StrUtils;

@Service
public class DynamicViewProcessImpl implements DynamicViewProcess {

	private static final String LINESPACE = " \n";

	private static final String DIV = "<DIV>";

	private static Set<String> pageSizeSet = new HashSet<String>();

	static {
		pageSizeSet.add("10");
		pageSizeSet.add("20");
		pageSizeSet.add("40");
		pageSizeSet.add("80");
		pageSizeSet.add("100");
	}

	/**
	 * 生成默认下拉框html
	 * 
	 * @Title: combinConditonDefSelectHtml
	 * @param buf
	 * @param bean
	 * @author: jieketao
	 *          Create at: 2012-1-18 下午04:07:54
	 */
	public void combinConditonDefSelectHtml(StringBuilder buf,
			ConditionBean bean) {
		buf
				.append(" <select name=\"mainSelect\"  onchange=\"changeSilblingDiv()\"");
		if (bean != null) {
			if (StringUtils.isNotEmpty(bean.getSelectStyle())) {
				buf.append(" style=\"");
				buf.append(bean.getSelectStyle());
				buf.append("\"");
			}
		}
		buf.append(">");
		List<ConditionInfo> conditionList = bean.getConditionInfos();
		for (ConditionInfo c : conditionList) {
			if ((c.getOption() != null) && (c.getDefaultFlag() != null)
					&& c.getDefaultFlag().equals("true")) {
				buf.append(" <option selected  value=\"");
				buf.append(c.getOption().getValue());
				buf.append("\">");
				buf.append(c.getOption().getText());
				buf.append("</option> \n");
			} else {
				buf.append(" <option  value=\"");
				buf.append(c.getOption().getValue());
				buf.append("\">");
				buf.append(c.getOption().getText());
				buf.append("</option> \n");
			}
		}
		buf.append("</select> ");
		buf.append(LINESPACE);
	}

	public void combinSelect(StringBuilder buf, Select select) {
		buf.append("<select");
		if (StringUtils.isNotEmpty(select.getName())) {
			buf.append(" name=\"");
			buf.append(select.getName());
			buf.append("\"");
		}
		buf.append(">");
		if ((select.getOptions() != null) && (select.getOptions().size() > 0)) {
			for (Option option : select.getOptions()) {
				buf.append("<option value=\"");
				buf.append(option.getValue());
				buf.append("\">");

				buf.append(option.getText());
				buf.append("</option>");
				buf.append(LINESPACE);
			}
		}
		buf.append("</select>");
		buf.append(LINESPACE);
	}

	public void combinConditionRowInputHtml(StringBuilder buf,
			ConditionBean bean, Map<String, String> formMap) {
		if (bean == null) {
			return;
		}
		List<ConditionInfo> conditionList = bean.getConditionInfos();
		// int len=conditionList.size();
		// int row=Double.valueOf(Math.ceil((double)len/4)).intValue();
		for (ConditionInfo info : conditionList) {
			List<Input> inputList = info.getInputList();
			Option option = info.getOption();
			if (info.getNodeType().equals("input")) {
				if (inputList != null) {
					buf.append("<div class=\"search-input\">");
					combinInputLavelText(buf, option.getText());
					for (Input input : inputList) {
						this.combinInput(buf, input, formMap);
					}
					buf.append("</div>");
					buf.append(LINESPACE);
				}
			} else if (info.getNodeType().equals("select")) {
				buf.append("<div class=\"input_select_div\">");
				combinInputLavelText(buf, option.getText());
				combinConditonRowSelectHtml(buf, info.getSecondSelect());
				buf.append("</div>");
				buf.append(LINESPACE);
			}
		}
	}

	public void combinConditionInfoInputHtml(StringBuilder buf,
			ConditionInfo info, Map<String, String> formMap) {
		List<Input> inputList = info.getInputList();
		Option option = info.getOption();
		if (info.getNodeType().equals("input")) {
			if (inputList != null) {
				for (Input input : inputList) {
					// buf.append("<div class=\"search-input\">");
					if (StringUtils.isNotEmpty(input.getText())) {
						combinInputLavelText(buf, input.getText());
					}
					this.combinInput(buf, input, formMap);
					// buf.append("</div>");
					buf.append(LINESPACE);
				}

			}
		} else if (info.getNodeType().equals("select")) {
			// buf.append("<div class=\"input_select_div\">");
			// combinInputLavelText(buf, option.getText());
			combinConditonRowSelectHtml(buf, info.getSecondSelect());
			// buf.append("</div>");
			buf.append(LINESPACE);

			if (inputList != null) {
				for (Input input : inputList) {
					// buf.append("<div class=\"search-input\">");
					if (StringUtils.isNotEmpty(input.getText())) {
						combinInputLavelText(buf, input.getText());
					}
					this.combinInput(buf, input, formMap);
					// buf.append("</div>");
					buf.append(LINESPACE);
				}

			}
		}
	}

	private void combinInputLavelText(StringBuilder buf, String text) {
		// buf.append(" <span class=\"search-span\">");
		buf.append(text);
		// buf.append("</span>");
	}

	public void combinConditonRowSelectHtml(StringBuilder buf, Select bean) {
		buf.append(" <select name=\"" + bean.getName() + "\" ");
		List<Option> optionList = bean.getOptions();

		if (bean != null) {
			if (StringUtils.isNotEmpty(bean.getStyle())) {
				buf.append(" style=\"");
				buf.append(bean.getStyle().concat(
						";height:20px;margin-top:3px;margin-left:3px;"));
				buf.append("\"");
			} else {
				buf.append(" style=\"");
				buf.append("height:20px;margin-top:3px;margin-left:3px;");
				buf.append("\"");
			}

			if (StringUtils.isNotEmpty(bean.getSelectClass())) {
				buf.append(" class=\"");
				// buf.append(bean.getSelectClass());
				buf.append("easyui-combobox");
				buf.append("\"");
			}
			buf.append(">");
			for (Option o : optionList) {
				buf.append(" <option  value=\"");
				buf.append(o.getValue());
				buf.append("\">");
				buf.append(o.getText());
				buf.append("</option> \n");
			}
		}

		buf.append("</select> ");
		buf.append(LINESPACE);
	}

	public void combinInput(StringBuilder buf, Input input,
			Map<String, String> formMap) {
		buf.append("<input type=\"text\" onFocus =\"clearObj(this);\"");
		if ((formMap != null) && formMap.containsKey(input.getName())) {
			buf.append(" value=\"");
			buf.append(formMap.get(input.getName()));
			buf.append("\"");
		}
		/**
		 * else if(StringUtils.isNotEmpty(input.getDefultValue())){
		 * buf.append(" value=\"");
		 * buf.append(input.getDefultValue());
		 * buf.append("\"");
		 * }
		 */
		if (StringUtils.isNotEmpty(input.getInputClass())) {
			buf.append(" class=\"");
			buf.append(input.getInputClass());
			buf.append("\"");
			if (input.getInputClass().equals("Wdate")) {
				buf.append(" value=\"");
				if (StringUtils.isNotBlank(input.getDefultValue())) {
					buf.append(ComUtils.format.format(ComUtils
							.getCurTimeByOffsetDay(Integer.valueOf(input
									.getDefultValue()))));
				} else {
					buf.append(ComUtils.format.format(new Date()));
				}
				buf.append("\"");
			}
		}
		if (StringUtils.isNotEmpty(input.getName())) {
			buf.append(" name=\"");
			buf.append(input.getName());
			buf.append("\"");
		}
		if (StringUtils.isNotEmpty(input.getOnclick())) {
			buf.append(" onclick=\"");
			buf.append(input.getOnclick());
			buf.append("\"");
		}
		if (StringUtils.isNotEmpty(input.getPattern())) {
			buf.append(" pattern=\"");
			buf.append(input.getPattern());
			buf.append("\"");
		}
		if (StringUtils.isNotEmpty(input.getStyle())) {
			buf.append(" style=\"");
			buf.append(input.getStyle().concat(
					";height:20px;margin-top:3px;margin-left:3px;"));
			buf.append("\"");
		}
		if (StringUtils.isNotEmpty(input.getWidth())) {
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
	 * 生成文本框html
	 * 
	 * @Title: combinInput
	 * @param buf
	 * @param input
	 * @author: jieketao
	 *          Create at: 2012-1-18 下午04:08:15
	 */
	public void combinInput(StringBuilder buf, Input input) {
		buf.append("<input type=\"text\" onFocus =\"clearObj(this);\"");
		if (StringUtils.isNotEmpty(input.getDefultValue())) {
			buf.append(" value=\"");
			buf.append(input.getDefultValue());
			buf.append("\"");
		}
		if (StringUtils.isNotEmpty(input.getInputClass())) {
			buf.append(" class=\"");
			buf.append(input.getInputClass());
			buf.append("\"");
		}
		if (StringUtils.isNotEmpty(input.getName())) {
			buf.append(" name=\"");
			buf.append(input.getName());
			buf.append("\"");
		}
		if (StringUtils.isNotEmpty(input.getOnclick())) {
			buf.append(" onclick=\"");
			buf.append(input.getOnclick());
			buf.append("\"");
		}
		if (StringUtils.isNotEmpty(input.getPattern())) {
			buf.append(" pattern=\"");
			buf.append(input.getPattern());
			buf.append("\"");
		}
		if (StringUtils.isNotEmpty(input.getStyle())) {
			buf.append(" style=\"");
			buf.append(input.getStyle());
			buf.append("\"");
		}
		if (StringUtils.isNotEmpty(input.getWidth())) {
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
	 * 生成默认条件文本框html
	 * 
	 * @Title: combinConditionDefInputHtml
	 * @param buf
	 * @param bean
	 * @author: jieketao
	 *          Create at: 2012-1-18 下午04:08:26
	 */
	public void combinConditionDefInputHtml(StringBuilder buf,
			ConditionBean bean) {
		List<ConditionInfo> conditionList = bean.getConditionInfos();
		// buf.append("<div id=\"sibId\">");
		for (ConditionInfo c : conditionList) {
			if ((c.getOption() != null) && (c.getDefaultFlag() != null)
					&& c.getDefaultFlag().equals("true")) {
				List<Input> inputList = c.getInputList();
				if (inputList != null) {
					for (Input input : inputList) {
						this.combinInput(buf, input);
					}
				}
				buf.append(LINESPACE);
			}
		}
		// buf.append("</div>");
	}

	/**
	 * 生成条件处理html
	 */
	public String conditionBeanProcess(ConditionBean bean)
			throws AppRunTimeException {
		// TODO Auto-generated method stub
		StringBuilder buf = new StringBuilder();
		combinConditonDefSelectHtml(buf, bean);
		combinConditionDefInputHtml(buf, bean);
		return buf.toString();
	}

	/**
	 * 生成条件列html
	 */
	public String pageTableColProcess(PageTableColBean colbean)
			throws AppRunTimeException {
		// TODO Auto-generated method stub
		try {
			if (colbean.getColInfos() != null) {
				StringBuilder colBuf = new StringBuilder();
				colBuf.append("<tr> ");
				colBuf.append(LINESPACE);
				for (PageTableColInfo col : colbean.getColInfos()) {
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
			throw new AppRunTimeException("表头列出错:" + e);
		}
		return null;
	}

	/**
	 * 根据列查找需要查询的colfiled域
	 */
	public List<String> findPageTableColProperty(PageTableColBean colbean,
			String type) throws AppRunTimeException {
		try {
			List<String> result = new ArrayList<String>();
			for (PageTableColInfo col : colbean.getColInfos()) {
				if (StringUtils.isNotEmpty(type)) {
					if (type.equals("1")) {
						result.add(col.getColField());
					}
				}
			}
			return result;
		} catch (Exception e) {
			// TODO: handle exception
			throw new AppRunTimeException(e);
		}
	}

	public Map<String, PageTableColInfo> findColFieldMap(
			PageTableColBean colbean) throws AppRunTimeException {
		try {
			Map<String, PageTableColInfo> result = new LinkedHashMap<String, PageTableColInfo>();
			for (PageTableColInfo col : colbean.getColInfos()) {
				result.put(col.getColField(), col);
			}
			return result;
		} catch (Exception e) {
			// TODO: handle exception
			throw new AppRunTimeException(e);
		}
	}

	/**
	 * 表头信息出错
	 */
	public String pageTableHeadProess(PageTableInfo table)
			throws AppRunTimeException {
		// TODO Auto-generated method stub
		try {
			if (table != null) {
				StringBuilder headBuf = new StringBuilder();
				headBuf.append("<table ");
				combinHeadProperyHtml(headBuf, table);

				return headBuf.toString();
			}
		} catch (Exception e) {
			throw new AppRunTimeException("表头属性出错:" + e);
		}
		return null;
	}

	public void combinHeadProperyHtml(StringBuilder headBuf, PageTableInfo table) {

		if (StringUtils.isNotEmpty(table.getBackground())) {
			headBuf.append(" background=\"");
			headBuf.append(table.getBackground());
			headBuf.append("\"");
		}
		if (StringUtils.isNotEmpty(table.getBgcolor())) {
			headBuf.append(" bgcolor=\"");
			headBuf.append(table.getBgcolor());
			headBuf.append("\"");
		}
		if (StringUtils.isNotEmpty(table.getBorder())) {
			headBuf.append(" border=\"");
			headBuf.append(table.getBorder());
			headBuf.append("\"");
		}
		if (StringUtils.isNotEmpty(table.getBordercolor())) {
			headBuf.append(" bordercolor=\"");
			headBuf.append(table.getBordercolor());
			headBuf.append("\"");
		}
		if (StringUtils.isNotEmpty(table.getBordercolorlight())) {
			headBuf.append(" bordercolorlight=\"");
			headBuf.append(table.getBordercolorlight());
			headBuf.append("\"");
		}
		if (StringUtils.isNotEmpty(table.getCellpading())) {
			headBuf.append(" cellpading=\"");
			headBuf.append(table.getCellpading());
			headBuf.append("\"");
		}
		if (StringUtils.isNotEmpty(table.getCellspacing())) {
			headBuf.append(" cellspacing=\"");
			headBuf.append(table.getCellspacing());
			headBuf.append("\"");
		}
		if (StringUtils.isNotEmpty(table.getHeight())) {
			headBuf.append(" height=\"");
			headBuf.append(table.getHeight());
			headBuf.append("\"");
		}
		if (StringUtils.isNotEmpty(table.getId())) {
			headBuf.append(" id=\"");
			headBuf.append(table.getId());
			headBuf.append("\"");
		}
		if (StringUtils.isNotEmpty(table.getStyle())) {
			headBuf.append(" style=\"");
			headBuf.append(table.getStyle());
			headBuf.append("\"");
		}
		if (StringUtils.isNotEmpty(table.getWidth())) {
			headBuf.append(" width=\"");
			headBuf.append(table.getWidth());
			headBuf.append("\"");
		}
		headBuf.append(">");
		headBuf.append(LINESPACE);
	}

	public void combinHeadColHtml(StringBuilder colBuf, PageTableColInfo col) {

		if (StringUtils.isNotEmpty(col.getColClass())) {
			colBuf.append(" class=\"");
			colBuf.append(col.getColClass());
			colBuf.append("\"");
		}
		if (StringUtils.isNotEmpty(col.getColWidth())) {
			colBuf.append(" width=\"");
			colBuf.append(col.getColWidth());
			colBuf.append("\"");
		}
		colBuf.append(">");
	}

	public void combinDataHtml(StringBuilder colBuf, PageTableColInfo col) {

		if (StringUtils.isNotEmpty(col.getColClass())) {
			colBuf.append(" class=\"");
			colBuf.append(col.getColClass());
			colBuf.append("\"");
		}
		if (StringUtils.isNotEmpty(col.getColWidth())) {
			colBuf.append(" width=\"");
			colBuf.append(col.getColWidth());
			colBuf.append("\"");
		}
		colBuf.append(">");
	}

	/**
	 * 表信息处理
	 */
	public String pageTableProess(PageTableInfo table,
			PageTableColBean colBean, List<Map<String, Object>> dataList,
			String path) throws AppRunTimeException {
		// TODO Auto-generated method stub
		String headHtml = pageTableHeadProess(table);
		String colHtml = pageTableColProcess(colBean);
		// colHtml+="</table><div class=\"tab_info\"> <table cellspacing=\"1px\" style=\"background:#c1c1c1;width:99.85%;*width:98.7%;\" >";
		String dataHtml = pageTableDataProcess(colBean, dataList, path);
		// dataHtml+="</div> </table>";
		return headHtml + colHtml + dataHtml;
	}

	/**
	 * 链接处理
	 * 
	 * @Title: combinLink
	 * @param info
	 * @param buf
	 * @param map
	 * @param path
	 * @author: jieketao
	 *          Create at: 2012-1-18 下午04:10:51
	 */
	public void combinLink(PageTableColInfo info, StringBuilder buf,
			Map<String, Object> map, String path) {
		buf.append("<td bgcolor=\"#ffffff\"");
		if (StringUtils.isNotEmpty(info.getColWidth())) {
			buf.append(" width=\"");
			buf.append(info.getColWidth());
			buf.append("\"");
		}
		buf.append(">");
		buf.append("<a href=\"javascript:toViewDialog('");
		buf.append(info.getDialogInfo().getDialogTitle());
		buf.append("','");
		String url = info.getDialogInfo().getDialogUrl().replaceAll("#",
				(String) map.get(info.getColField()));
		buf.append(path + url);
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
	 * 生成td
	 * 
	 * @Title: combinTd
	 * @param info
	 * @param buf
	 * @param map
	 * @param path
	 * @author: jieketao
	 *          Create at: 2012-1-18 下午04:11:04
	 */
	public void combinTd(PageTableColInfo info, StringBuilder buf,
			Map<String, Object> map, String path) {
		buf.append("<td bgcolor=\"#ffffff\"");
		if (StringUtils.isNotEmpty(info.getColWidth())) {
			buf.append(" width=\"");
			buf.append(info.getColWidth());
			buf.append("\"");
		}
		buf.append(">");
		buf.append(ComUtils.filterNull(map.get(info.getColField())));

		buf.append("</td>");
		buf.append(LINESPACE);
	}

	/**
	 * 标题数据处理
	 */
	public String pageTableDataProcess(PageTableColBean colbean,
			List<Map<String, Object>> dataList, String path)
			throws AppRunTimeException {
		// TODO Auto-generated method stub
		try {
			StringBuilder buf = new StringBuilder();
			if ((dataList != null) && (dataList.size() > 0)) {
				for (Map<String, Object> map : dataList) {
					buf.append("<tr>");
					for (PageTableColInfo info : colbean.getColInfos()) {
						if ((info.getDialogInfo() != null)
								&& !info.getDialogInfo().getDialogUrl().equals(
										"")) {
							combinLink(info, buf, map, path);
						} else {
							combinTd(info, buf, map, path);
						}
					}
					buf.append("</tr>");
					buf.append(LINESPACE);
				}
			} else {
				buf.append("<tr>");
				buf.append("<td bgcolor=\"#ffffff\" colspan=\"");
				buf.append(colbean.getColInfos().size());
				buf.append("\">");
				buf.append("暂无数据");
				buf.append("</td>");
				buf.append("</tr>");
			}

			buf.append("</table>");
			return buf.toString();
		} catch (Exception e) {
			// TODO: handle exception
		}
		return null;
	}

	public String pageTableDataEasyUiProcess(PageTableColBean colbean,
			String path) throws AppRunTimeException {
		// TODO Auto-generated method stub
		try {
			StringBuilder buf = new StringBuilder();
			if (colbean != null) {
				boolean xsum = false;
				for (PageTableColInfo info : colbean.getColInfos()) {
					if (info.isXsum()) {
						xsum = true;
					}
					buf.append("<th field=\"");
					buf.append(info.getColField());
					buf.append("\" width=\"");
					buf.append(info.getColWidth());
					buf.append("\"");
					if (info.getHidden()) {
						buf.append(" hidden=");
						buf.append(info.getHidden());
					}
					if ((info.getColStyle() != null)
							&& !"".equals(info.getColStyle())) {
						buf.append(" style=\"");
						buf.append(info.getColStyle());
						buf.append("\"");
					}
					if ((info.getColAlign() != null)
							&& !"".equals(info.getColAlign())) {
						buf.append(" align=\"");
						buf.append(info.getColAlign());
						buf.append("\"");
					}
					/**
					 * if(info.getSortable()!=null&&!"".equals(info.getSortable(
					 * ))){
					 * buf.append(" sortable=\"");
					 * buf.append(info.getSortable());
					 * buf.append("\"");
					 * }
					 */
					buf.append(" sortable=\"true\"");

					if ((info.getFormatter() != null)
							&& !info.getFormatter().equals("")) {
						buf
								.append(" formatter=\"" + info.getFormatter()
										+ "\"");
					} else if (info.getOperateLinkGroup() != null) {
						if (StringUtils.isNotBlank(info.getOperateLinkGroup()
								.getFormatFuncName())) {
							buf.append(" formatter=\""
									+ info.getOperateLinkGroup()
											.getFormatFuncName() + "\"");
						}
					}
					if (info.getDataOptions() != null) {
						buf.append(" data-options=\"");
						buf.append(info.getDataOptions());
						buf.append("\"");
					}
					buf.append(">");
					buf.append(ComUtils.filterNull(info.getColName()));
					buf.append("</th>");
				}

				if (xsum) {
					buf.append("<th field=\"");
					buf.append("xsum");
					buf.append("\" ");

					buf.append(">");
					buf.append("合计");
					buf.append("</th>");
				}

				buf.append(LINESPACE);

			} else {
				buf.append("<th bgcolor=\"#ffffff\" colspan=\"");
				buf.append(colbean.getColInfos().size());
				buf.append("\">");
				buf.append("暂无数据");
				buf.append("</th>");
			}
			return buf.toString();
		} catch (Exception e) {
			// TODO: handle exception
		}
		return null;
	}

	public String createOperateLinklJs(PageTableColBean colbean, String path)
			throws AppRunTimeException {
		StringBuilder js = new StringBuilder();
		js.append("<script type=\"text/javascript\">");
		for (PageTableColInfo info : colbean.getColInfos()) {
			if (info.getOperateLinkGroup() != null) {
				if (StringUtils.isNotBlank(info.getOperateLinkGroup()
						.getFormatFuncName())) {
					js.append("function ");
					js.append(info.getOperateLinkGroup().getFormatFuncName());
					js.append("(value,rowData,rowIndex){");
					js.append(" var result=\"\";");
					if (info.getOperateLinkGroup().getOperateLinkList() != null) {
						String br = "";
						if(info.getOperateLinkGroup()!=null&&info.getOperateLinkGroup().getVertical()!=null&&info.getOperateLinkGroup().getVertical()){
							br = "<br>";
						}
						SessionInfo sessionInfo = SecurityUtils
								.getCurrentSessionInfo();
						List<Sysright> sysrightList = sessionInfo
								.getSysrightList();
						if(info.getColumnShow()) {
                            js.append("result+=(\"<span class='format_btn'>\"+value+\"&nbsp;&nbsp;</span>\");");
                        }
						for (OperateLink link : info.getOperateLinkGroup()
								.getOperateLinkList()) {
							String newLine = "";
							if(link.getNewLine()){
								newLine = "<div class=\\\"over-line\\\"></div>";
							}
							boolean rightOwnerFlag = false;
							// 权限判断，有权限才显示对话框
							if (StringUtils.isNotBlank(link.getRightCode())) {
								for (Sysright right : sysrightList) {
									if (String.valueOf(right.getRightCode())
											.equals(link.getRightCode())) {
										rightOwnerFlag = true;
										break;
									}
								}
								if (!rightOwnerFlag) {
									continue;
								}
							}
							if (StringUtils.isNotBlank(link.getExpress())) {
								js.append("if(rowData." + link.getExpress()
										+ "){");

								js
										.append("result+=\"")
                                        .append(newLine)
                                        .append("<span class='format_btn'>\";");

								js
//										.append("result +=\"<a style=\\\"cursor:hand;cursor:pointer;color:#81BEF7;text-decoration:underline \\\" iconCls=\\\"icon-add\\\" plain=\\\"true\\\" onclick=\\\"");
										.append("result +=\"<a class=\\\""+link.getCssClass()+" \\\" iconCls=\\\"icon-add\\\" plain=\\\"true\\\" onclick=\\\"");
								if (StringUtils.isNotBlank(link.getText())) {
									js
											.append(
													createOperateLinkClick(link))
											.append("\\\">").append(
													link.getText()).append(
													"</a> &nbsp;&nbsp;")
											.append("\";");
								} else {
									js
											.append(
													createOperateLinkClick(link))
											.append("\\\">").append(
													"\"+value+\"").append(
													"</a> &nbsp;&nbsp;")
											.append("\";");
								}

								js.append("result+=\"</span>").append(br).append("\";");
								js.append("}");
							} else {
								js
										.append("result+=\"")
                                        .append(newLine)
                                        .append("<span class='format_btn'>\";");

								js
//										.append("result +=\"<a style=\\\"cursor:hand;cursor:pointer;color:#81BEF7;text-decoration:underline \\\" iconCls=\\\"icon-add\\\" plain=\\\"true\\\" onclick=\\\"");
										.append("result +=\"<a class=\\\""+link.getCssClass()+" \\\" iconCls=\\\"icon-add\\\" plain=\\\"true\\\" onclick=\\\"");
								if (StringUtils.isNotBlank(link.getText())) {
									js
											.append(
													createOperateLinkClick(link))
											.append("\\\">").append(
													link.getText()).append(
													"</a> &nbsp;&nbsp;")
											.append("\";");
								} else {
									js
											.append(
													createOperateLinkClick(link))
											.append("\\\">").append(
													"\"+value+\"").append(
													"</a> &nbsp;&nbsp;")
											.append("\";");
								}
								js.append("result+=\"</span>").append(br).append("\";");
							}
						}
					}
					js.append("\n return result;");

					js.append("}");
				}
			}
		}

		js.append("</script>");
		return js.toString();
	}

	private String createOperateLinkClick(OperateLink link) {
		StringBuilder js = new StringBuilder();
		String url = buildUrlByParam(link);
		if (link.getTarget().equals("tab")) {
			js.append("eu.addTab(window.parent.layout_center_tabs,'"
					+ link.getTitle() + "',");
			js.append("'").append(url);
			js.append(",true");
			if(link.getReload()) {
				js.append(",null, true");
			}
			js.append(");");
			if(StringUtils.isNotBlank(link.getMenuId())){
				js.append("parent.getMenu('"+link.getMenuId()+"');");
			}
		} else if (link.getTarget().equals("delete")) {
			//2014-05-20
			if(link.getDialogId().equals("user_dialog")){
				js.append("eu.confirmMsg('注意：删除数据后，就无法再恢复。请确认只有在垃圾数据的情况下，才进行删除！</br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您确认删除该条记录么？',");
			}else{
				js.append("eu.confirmMsg('确认要操作?',");
			}
			//end
			js.append("'").append(url);
			js.append(");");
		} else if (link.getTarget().equals("custom_js")) {
			js.append(link.getJsFunctionName()).append("();");
		} else if (link.getTarget().equals("dialog")) {
			if (link.getOpenType().equals("max")) {
				js.append("menu.create_max_dialog_identy(");
				js.append("'").append(link.getDialogId()).append("',");
				js.append("'").append(link.getTitle()).append("',");
				js.append("'").append(url).append(")");
			} else if (link.getOpenType().equals("remote")) {
				js.append("menu.create_dialog_identy_remote(");
				js.append("'").append(link.getDialogId()).append("',");
				js.append("'").append(link.getTitle()).append("',");
				js.append("'").append(url).append(",");
				js.append(link.getWidth()).append(",");
				js.append(link.getHeight()).append(",");
				js.append(link.getLock());
				if(link.getOutLink()) {
					js.append(",").append(link.getOutLink());
				}
				js.append(")");
			} else if (link.getOpenType().equals("single")) {
				js.append("menu.create_dialog_identy(");
				js.append("'").append(link.getDialogId()).append("',");
				js.append("'").append(link.getTitle()).append("',");
				js.append("'").append(url).append(",");
				js.append(link.getWidth()).append(",");
				js.append(link.getHeight()).append(",");
				js.append(link.getLock());
				if(link.getOutLink()) {
                    js.append(",").append(link.getOutLink());
                }
				js.append(")");
			} else if (link.getOpenType().equals("child")) {
				js.append("menu.create_child_dialog_identy(api,W,");
				js.append("'").append(link.getDialogId()).append("',");
				js.append("'").append(link.getTitle()).append("',");
				js.append("'").append(url).append(",");
				js.append(link.getWidth()).append(",");
				js.append(link.getHeight()).append(",");
				js.append(link.getLock()).append(")");
			} else if (link.getOpenType().equals("model")) {
				js.append("menu.create_model_dialog_identy(");
				js.append("'").append(link.getDialogId()).append("',");
				js.append("'").append(link.getTitle()).append("',");
				js.append("'").append(url).append(",");
				js.append(link.getWidth()).append(",");
				js.append(link.getHeight()).append(",");
				js.append(link.getLock()).append(")");
			} else if (link.getOpenType().equals("max_model")) {
				js.append("menu.create_model_max_dialog_identy(");
				js.append("'").append(link.getDialogId()).append("',");
				js.append("'").append(link.getTitle()).append("',");
				js.append("'").append(url);
				if(link.getOutLink()) {
					js.append(",").append(link.getOutLink());
				}
				js.append(")");
			} else if (link.getOpenType().equals("max_with_cancel")) {
				js.append("menu.create_max_dialog_withCancel_identy(");
				js.append("'").append(link.getDialogId()).append("',");
				js.append("'").append(link.getTitle()).append("',");
				js.append("'").append(url).append(")");
			}else if (link.getOpenType().equals("detail")) {
				js.append("menu.create_detail_dialog(");
				js.append("'").append(link.getDialogId()).append("',");
				js.append("'").append(link.getTitle()).append("',");
				js.append("'").append(url).append(",");
				js.append(link.getWidth()).append(",");
				js.append(link.getHeight()).append(",");
                js.append(link.getLock());
                if(link.getOutLink()) {
                    js.append(",").append(link.getOutLink());
                }
                js.append(")");
			}else if (link.getOpenType().equals("auth")) {
				js.append("menu.create_dialog_identy_cust(");
				js.append("'").append(link.getDialogId()).append("',");
				js.append("'").append(link.getTitle()).append("',");
				js.append("'").append(url).append(",");
				js.append(link.getWidth()).append(",");
				js.append(link.getHeight()).append(",");
				js.append(link.getLock());
				if(link.getOutLink()) {
					js.append(",").append(link.getOutLink());
				}else{
                    js.append(",'").append("'");
                }
				if(StringUtils.isNotBlank(link.getPassText())){
					js.append(",'").append(link.getPassText()).append("'");
				}else{
                    js.append(",'").append("'");
                }
				if(StringUtils.isNotBlank(link.getRejectText())){
					js.append(",'").append(link.getRejectText()).append("'");
				}else{
                    js.append(",'").append("'");
                }
				js.append(")");
			}
		}
		return js.toString();
	}

	private String buildUrlByParam(OperateLink link) {
		StringBuilder js = new StringBuilder();
		if (link.getParamMap() != null) {
            if (link.getTarget().equals("tab")
                    || link.getTarget().equals("delete")) {
                if (link.getOutLink()) {
                    js.append(link.getUrl()).append(
                            "'\"");
                } else {
                    js.append("\"+ctutil.bp()+\"").append(link.getUrl()).append(
                            "?1=1'\"");
                }
            } else if (link.getTarget().equals("dialog")) {
                if (link.getOutLink()) {
                    js.append(link.getUrl()).append(
                            "'\"");
                    ;
                } else {
                    if (!StrUtils.contains(link.getUrl(), "\\?")) {
                        js.append(link.getUrl()).append("?1=1'\"");
                    } else {
                        js.append(link.getUrl()).append("'\"");
                        ;
                    }
                }
            }
            if (!link.getOutLink()) {
                Iterator<Map.Entry<String, String>> it = link.getParamMap()
                        .entrySet().iterator();
                //jieketao modify on 2014-06-21,支持多参数传递
                int i = 0;
                int size = link.getParamMap().size();
                while (it.hasNext()) {
                    if (i == (size - 1)) {
                        Map.Entry<String, String> entry = it.next();
                        js.append("+\"+'&").append(entry.getKey()).append("='+'\"+")
                                .append("rowData.").append(entry.getValue());
                        js.append("+\"'");
                    } else {
                        Map.Entry<String, String> entry = it.next();
                        js.append("+\"+'&").append(entry.getKey()).append("='+'\"+")
                                .append("rowData.").append(entry.getValue());
                        js.append("+\"'\"");
                    }
                    i++;
                }
            }else{
                js.append("+\"");
            }
        }
        Iterator<Map.Entry<String, String>> it = link.getParamMap()
                .entrySet().iterator();
		String result = js.toString();
        while (it.hasNext()) {
            Map.Entry<String, String> entry = it.next();
            if(result.contains("#"+entry.getKey()+"#")){
                result = result.replaceAll("#"+entry.getKey()+"#", "\"+rowData."+entry.getValue()+"+\"");
            }
        }
		return result;
	}

	/**
	 * 从数据库中查询下一个跳转链接
	 */
	public String getFormatterUrl(PageTableColInfo info, String key)
			throws AppRunTimeException {
		try {
			String url = "";
			// if(info.getFmtTag().equals("true")){
			// if(key!=null){
			// Todo todo=commonService.findTodoByPk(key);
			// if(todo!=null){
			// String rightCode=todo.getSysright().getRightCode();
			// if(StringUtils.isNotEmpty(rightCode)){
			// url=commonService.findUrlByRightCode(rightCode);
			// String params=combinRequestParams(todo, info);
			// if(params.length()>0){
			// url+="?";
			// url+=params;
			// }
			// }
			//						
			// }
			// }
			// }else {
			url = info.getDialogInfo().getDialogUrl();
			url = url.replaceAll("#", key);
			DialogInfo dialog = info.getDialogInfo();
			dialog.setDialogUrl(url);
			JSONObject json = JSONObject.fromObject(dialog);
			url = json.toString();
			// }
			return url;
		} catch (Exception e) {
			// TODO: handle exception
			throw new AppRunTimeException(e);
		}
	}

	/**
	 * 链接格式化
	 * 
	 * @param path
	 * @param info
	 * @param buf
	 * @throws AppRunTimeException
	 */
	public void combinLinkUrlScript(String path, PageTableColInfo info,
			StringBuilder buf) throws AppRunTimeException {
		buf.append("<script type=\"text/javascript\">");
		buf.append(LINESPACE);
		buf.append(" function ");
		buf.append(info.getFormatter());
		buf.append("(value){");

		buf.append(LINESPACE);
		buf.append(" window.location.href=\"");
		buf.append(getFormatterUrl(info, "value"));
		buf.append(info.getDialogInfo().getDialogUrl());
		buf.append(LINESPACE);

		buf.append("\";");
		buf.append(LINESPACE);
		buf.append("   diag.show(); ");
		buf.append(LINESPACE);
		buf.append("}");
		buf.append(LINESPACE);
		buf.append("</script>");
		buf.append(LINESPACE);

	}

	/**
	 * formHtml生成
	 * 
	 * @Title: combinFormHtml
	 * @param form
	 * @param buf
	 * @param value
	 * @param path
	 * @param condStr
	 * @throws AppRunTimeException
	 * @author: jieketao
	 *          Create at: 2012-1-18 下午04:11:38
	 */
	public void combinFormHtml(Form form, StringBuilder buf, String value,
			String path, String condStr) throws AppRunTimeException {
		buf.append("<form  action=\"");
		buf.append(path);
		buf.append(form.getAction());
		buf.append("\"");
		if ((form.getFormClass() != null)
				&& StringUtils.isNotEmpty(form.getFormClass())) {
			buf.append(" class=\"");
			buf.append(form.getFormClass());
			buf.append("\"");
		}
		if ((form.getMethod() != null)
				&& StringUtils.isNotEmpty(form.getMethod())) {
			buf.append(" method=\"");
			buf.append(form.getMethod());
			buf.append("\"");
		}
		if ((form.getStyle() != null)
				&& StringUtils.isNotEmpty(form.getStyle())) {
			buf.append(" style=\"");
			buf.append(form.getStyle());
			buf.append("\"");
		}
		buf.append("/>");
		buf.append(LINESPACE);
		if ((form.getHiddenName() != null)
				&& StringUtils.isNotEmpty(form.getHiddenName())) {
			buf.append(" <input type=\"hidden\"  name=\"");
			buf.append(form.getHiddenName());
			buf.append("\" id=\"");
			buf.append(form.getHiddenName());
			buf.append("\"");
			if (StringUtils.isNotEmpty(value)) {
				buf.append(" value=\"");
				buf.append(value);
				buf.append("\"");
			}

			buf.append(" />");
		}

		buf.append(" <input type=\"hidden\"  name=\"condStr");
		buf.append("\" id=\"condStr");
		buf.append("\"");
		if (StringUtils.isNotEmpty(value)) {
			buf.append(" value=\"");
			buf.append(condStr);
			buf.append("\"");
		}
		buf.append(" />");
		buf.append(LINESPACE);

	}

	/**
	 * 下拉框html生成
	 * 
	 * @Title: combinPageSelect
	 * @param select
	 * @param pageInfo
	 * @param buf
	 * @throws AppRunTimeException
	 * @author: jieketao
	 *          Create at: 2012-1-18 下午04:11:56
	 */
	public void combinPageSelect(Select select, GridPageInfo pageInfo,
			StringBuilder buf) throws AppRunTimeException {
		buf
				.append(" <select name=\"pageSize\" onchange=\"changePageSize(this.value)\"");
		if (select != null) {
			if (StringUtils.isNotEmpty(select.getStyle())) {
				buf.append("style=\"");
				buf.append(select.getStyle());
				buf.append("\"");
			}
		}
		buf.append(">");
		for (String s : pageSizeSet) {
			if ((select.getDefPageSize() != null)
					&& select.getDefPageSize().equals(s)) {
				buf.append(" <option selected >");
				buf.append(s);
				buf.append("</option> \n");
			} else {
				buf.append(" <option >");
				buf.append(s);
				buf.append("</option> \n");
			}
		}
		buf.append("</select> ");
		buf.append(LINESPACE);
	}

	/**
	 * 页面input框生成
	 * 
	 * @Title: combinPageCurInput
	 * @param input
	 * @param pageInfo
	 * @param buf
	 * @throws AppRunTimeException
	 * @author: jieketao
	 *          Create at: 2012-1-18 下午04:12:15
	 */
	public void combinPageCurInput(CurInput input, GridPageInfo pageInfo,
			StringBuilder buf) throws AppRunTimeException {
		buf.append("<input type=\"text\" name=\"pageIndex\"");
		if (input.getStyle() != null) {
			buf.append(" style=\"");
			buf.append(input.getStyle());
			buf.append("\"");
		}
		buf.append(" value=\"");
		buf.append(pageInfo.getPage());
		buf.append("\"/>");
		buf.append("页  ");
		buf.append(LINESPACE);
	}

	/**
	 * 隐藏变量生成
	 * 
	 * @Title: combinPageCurInputHidden
	 * @param pageInfo
	 * @param buf
	 * @throws AppRunTimeException
	 * @author: jieketao
	 *          Create at: 2012-1-18 下午04:12:33
	 */
	public void combinPageCurInputHidden(GridPageInfo pageInfo,
			StringBuilder buf) throws AppRunTimeException {
		buf.append("<input type=\"hidden\" name=\"pageCount\"");
		buf.append(" value=\"");
		buf.append(pageInfo.getPageCount());
		buf.append("\"/>");
		buf.append(LINESPACE);
	}

	public void combinPageButton(Button button, GridPageInfo pageInfo,
			StringBuilder buf, String path) throws AppRunTimeException {
		buf.append("<input type=\"button\" value=\"");
		buf.append(button.getValue());
		buf.append("\"");
		if (button.getStyle() != null) {
			buf.append(" style=\"");
			buf.append(button.getStyle());
			buf.append("\"");
		}
		if (button.getOnclick() != null) {
			buf.append(" onclick=\"");
			buf.append(button.getOnclick());
			buf.append("\"/>");
		}
		buf.append(LINESPACE);
	}

	/**
	 * 分页组件生成
	 * 
	 * @Title: combinPageHtml
	 * @param page
	 * @param pageInfo
	 * @param path
	 * @return
	 * @throws AppRunTimeException
	 * @author: jieketao
	 *          Create at: 2012-1-18 下午04:13:00
	 */
	public String combinPageHtml(PageInfo page, GridPageInfo pageInfo,
			String path) throws AppRunTimeException {
		StringBuilder buf = new StringBuilder();
		buf.append(" <div class=\"page\">");
		buf.append("总数  ");
		buf.append(pageInfo.getTotal());
		buf.append("条     每页");
		combinPageSelect(page.getSelect(), pageInfo, buf);
		buf.append("条 共   ");
		buf.append(pageInfo.getPageCount());
		buf.append("页  当前    第");
		combinPageCurInput(page.getCurInput(), pageInfo, buf);
		combinPageButton(page.getGoButton(), pageInfo, buf, path);
		combinPageButton(page.getUpButton(), pageInfo, buf, path);
		combinPageButton(page.getDownButton(), pageInfo, buf, path);

		combinPageCurInputHidden(pageInfo, buf);
		buf.append(DIV);
		return buf.toString();
	}

	/**
	 * 报表配置Map查找
	 */
	public Map<String, String> pageConfigProcess(PageConfigBean pageConfigBean,
			GridPageInfo pageInfo, String value, String path, String condStr)
			throws AppRunTimeException {
		// TODO Auto-generated method stub
		try {
			StringBuilder buf = new StringBuilder();
			Map<String, String> result = new HashMap<String, String>();
			if (pageConfigBean != null) {
				if (pageConfigBean.getForm() != null) {
					combinFormHtml(pageConfigBean.getForm(), buf, value,
							path, condStr);
					result.put("formHtml", buf.toString());
				}
				if (pageConfigBean.getPage() != null) {
					buf.delete(0, buf.length());
					buf.append(combinPageHtml(pageConfigBean.getPage(),
							pageInfo, path));
					result.put("pageHtml", buf.toString());
				}
			}
			return result;
		} catch (Exception e) {
			// TODO: handle exception
			throw new AppRunTimeException(e);
		}
	}

	/**
	 * 对话框js生成
	 * 
	 * @Title: combinDialogScript
	 * @param path
	 * @param bean
	 * @param buf
	 * @throws AppRunTimeException
	 * @author: jieketao
	 *          Create at: 2012-1-18 下午04:13:56
	 */
	public void combinDialogScript(String path, DialogBean bean,
			StringBuilder buf) throws AppRunTimeException {
		buf.append("<script type=\"text/javascript\">");
		buf.append(LINESPACE);
		for (DialogInfo info : bean.getDialogInfos()) {
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
		buf.append(LINESPACE);
		buf.append("</script>");
		buf.append(LINESPACE);

	}

	/**
	 * 对话框div生成
	 * 
	 * @Title: combinDialogDiv
	 * @param bean
	 * @param buf
	 * @throws AppRunTimeException
	 * @author: jieketao
	 *          Create at: 2012-1-18 下午04:14:09
	 */
	public void combinDialogDiv(DialogBean bean, StringBuilder buf)
			throws AppRunTimeException {
		buf.append("<div class=\"top_right\">");
		for (DialogInfo info : bean.getDialogInfos()) {
			if (StringUtils.isNotBlank(info.getFunctionName())) {
				buf.append(" <a href=\"javascript:");
				buf.append(info.getFunctionName());
				buf.append("()\"");
				if (info.getStyle() != null) {
					buf.append(" style=\"");
					buf.append(info.getStyle());
					buf.append("\"  ");
				}
				buf.append(" class=\"");
				buf.append("btn1\">");
				buf.append(info.getDialogTitle());
				buf.append("</a> ");
				buf.append(LINESPACE);
			} else {
				buf.append(" <a href=\"javascript:open_dialog_");
				buf.append(info.getDialogNumber());
				buf.append("()\"");
				if (info.getStyle() != null) {
					buf.append(" style=\"");
					buf.append(info.getStyle());
					buf.append("\"  ");
				}
				buf.append(" class=\"");
				buf.append("btn1\">");
				buf.append(info.getBtnText());
				buf.append("</a> ");
				buf.append(LINESPACE);
			}

		}
		buf.append("</div>");
		buf.append(LINESPACE);
	}

	public String dialogBeanProcess(String path, DialogBean bean)
			throws AppRunTimeException {
		// TODO Auto-generated method stub
		try {
			if (bean != null) {
				StringBuilder buf = new StringBuilder();
				combinDialogScript(path, bean, buf);
				combinDialogDiv(bean, buf);

				return buf.toString();
			} else {
				return null;
			}

		} catch (Exception e) {
			// TODO: handle exception
			throw new AppRunTimeException(e);
		}

	}

	/**
	 * 根据第一个下拉框的optionvalue获取动态列表或者下拉框
	 * 实现级联下拉框和（文本框以及下拉框）的级联
	 */
	public String conditionSilbingProcess(ConditionBean bean,
			String optionValue, Map<String, String> formMap)
			throws AppRunTimeException {
		// TODO Auto-generated method stub
		StringBuilder buf = new StringBuilder();
		// combinConditionRowInputHtml(buf, bean, formMap);
		List<ConditionInfo> conditionList = bean.getConditionInfos();

		for (ConditionInfo c : conditionList) {
			if ((c.getOption() != null)
					&& c.getOption().getValue().equals(optionValue)) {
				combinConditionInfoInputHtml(buf, c, formMap);
				buf.append(LINESPACE);
			}
		}
		return buf.toString();
	}

	public void combinStateQueryBtn(Button button, StringBuilder buf) {
		buf.append("<div class=\"btn\" >");
		buf.append("<a href=\"javascript:");
		buf.append(button.getOnclick());
		buf.append("\" class=\"btn2\">");
		buf.append(button.getBtnName());
		buf.append("</a></div>");
	}

	public String stateQueryBtnBeanProcess(StateQueryBtnBean bean)
			throws AppRunTimeException {
		// TODO Auto-generated method stub
		if (bean != null) {
			StringBuilder buf = new StringBuilder();
			List<Button> btnList = bean.getQueryBtnList();
			for (Button btn : btnList) {
				combinStateQueryBtn(btn, buf);
			}
			return buf.toString();
		}
		return null;

	}

	@Override
	public String getFormatterParamUrl(PageTableColInfo info, String key)
			throws AppRunTimeException {
		try {
			String url = "";
			url = info.getDialogInfo().getDialogUrl();
			url = replaceUrlConfig(url, key);
			DialogInfo dialog = info.getDialogInfo();
			dialog.setDialogShowNo(getDialogShowKey(url, key));
			dialog.setDialogUrl(url);
			JSONObject json = JSONObject.fromObject(dialog);
			url = json.toString();
			// }
			return url;
		} catch (Exception e) {
			// TODO: handle exception
			throw new AppRunTimeException(e);
		}
	}

	private List<String> getParamsInUrl(String url) {
		List<String> result = new ArrayList<String>();
		String urlParts[] = url.split("\\#");
		for (int i = 0; i < urlParts.length; i++) {
			if (StrUtils.contains(urlParts[i], "\\?")
					|| StrUtils.contains(urlParts[i], "\\&")) {
				continue;
			}
			result.add(urlParts[i]);
		}
		return result;
	}

	public String replaceUrlConfig(String url, String parmas)
			throws AppRunTimeException {
		JSONObject data = JSONObject.fromObject(parmas);
		List<String> urlParamsValueList = getParamsInUrl(url);
		for (String value : urlParamsValueList) {
			url = url.replaceAll("#" + value + "#", data.getString(value));
		}
		return url;
	}

	public String getDialogShowKey(String url, String parmas) {
		JSONObject data = JSONObject.fromObject(parmas);
		List<String> urlParamsValueList = getParamsInUrl(url);
		for (String value : urlParamsValueList) {
			return data.getString(value);
		}
		return "";
	}

	public static void main(String args[]) {
		DynamicViewProcessImpl d = new DynamicViewProcessImpl();
		String url = "/warrantyMgr/warranty!toDispatchRepair.action?claimId=#claimId#&siteId=#siteId#";
		d.getParamsInUrl(url);

	}

}

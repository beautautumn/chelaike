package com.ct.erp.sys.service.base;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ct.erp.common.exception.DaoException;
import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.common.exception.SystemException;
import com.ct.erp.common.model.TreeNode;
import com.ct.erp.lib.entity.Sysmenu;
import com.ct.erp.lib.entity.Sysright;
import com.ct.erp.sys.dao.StaffRightDao;
import com.ct.erp.sys.dao.SysmenuDao;
import com.ct.erp.sys.dao.SysrightDao;
import com.ct.erp.sys.model.SysmenuBean;
import com.ct.erp.sys.model.SysrightBean;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

@Service
public class SysrightService {

	@Autowired
	private SysrightDao sysrightDao;
	@Autowired
	private SysmenuDao sysmenuDao;
	@Autowired
	private StaffRightDao staffRightDao;

	public List<Sysright> findSysrightListByStaffId(Long staffId)
			throws ServiceException {
		try {
			return sysrightDao.findSysrightListByStaffId(staffId);
		} catch (Exception e) {
			throw new ServiceException(
					"Error in method findSysrightByStaffId ;the staffId is:"
							+ staffId, e);
		}
	}
	
	public List<SysmenuBean> findFirstLevelSysmenu(List<Sysmenu> sysmenuList){
		List<SysmenuBean> result=Lists.newArrayList();
		for(Sysmenu sysmenu:sysmenuList){			
			if(sysmenu.getParentSysmenu()==null){
				SysmenuBean bean=new SysmenuBean(sysmenu);	
				result.add(bean);
			}
		}
		return result;
	}
	
	public List<SysrightBean> findFirstLevelSysright(List<Sysright> sysrightList){
		List<SysrightBean> result=Lists.newArrayList();
		for(Sysright sysright:sysrightList){			
			if(sysright.getParentSysright()==null){
				SysrightBean bean=new SysrightBean(sysright);	
				result.add(bean);
			}
		}
		return result;
	}
	
	public List<TreeNode> getSysmenuTreeByUserId(Long staffId){
		List<Sysmenu> sysmenuList=sysmenuDao.findByStaffId(staffId);
		List<SysmenuBean> firstLevelList=findFirstLevelSysmenu(sysmenuList);
		for(SysmenuBean sysmenu:firstLevelList){		
			sysmenuList.remove(sysmenu.getSysmenu());
		}			
		for(Sysmenu sysmenu:sysmenuList){
			for(SysmenuBean bean:firstLevelList){
				if(bean.getSysmenu().getId().equals(sysmenu.getParentSysmenu().getId())){
					bean.getSubSysmenuList().add(sysmenu);
				}
			}
		}		
		return getNavMenuTreeByList(firstLevelList);
	}
	
	
	public List<TreeNode> getSysrightTreeByList(List<Sysright> sysrightList)throws Exception{
		List<TreeNode> result=new ArrayList<TreeNode>();
		List<SysrightBean> firstLevelList=findFirstLevelSysright(sysrightList);
		for(SysrightBean sysmenu:firstLevelList){		
			sysrightList.remove(sysmenu.getSysright());
		}	
		for(SysrightBean bean:firstLevelList){
			TreeNode node = this.sysrightToTreeNode(bean.getSysright());
			List<TreeNode> children=new ArrayList<TreeNode>();
			for(Sysright sysright:sysrightList){
				if(bean.getSysright().getRightCode().equals(sysright.getParentSysright().getRightCode())){
					TreeNode child=sysrightToTreeNode(sysright);
					List<Sysright> childList=getChildSysright(sysright, sysrightList);
					if(childList.size()>0){
						List<TreeNode> ccList=new ArrayList<TreeNode>();
						for(Sysright cc:childList){
							ccList.add(this.sysrightToTreeNode(cc));
						}
						child.setChildren(ccList);
					}
					children.add(child);
				}
			}
			node.setChildren(children);
			result.add(node);
		}
		return result;			
	}
	
	public List<TreeNode> getSysrightTreeByUserId(Long staffId)throws Exception{
		List<Sysright> sysrightList=sysrightDao.findSysrightListByStaffId(staffId);
		return getSysrightTreeByList(sysrightList);		
	}
	
	public List<TreeNode> getSysrightTreeNodeList(Long staffId)throws Exception{
		List<TreeNode> result=new ArrayList<TreeNode>();
		List<Sysright> sysrightList=sysrightDao.findSysrightListByStaffId(staffId);
		for(Sysright sysright:sysrightList){
			result.add(sysrightToTreeNode(sysright));
		}
		return result;
	}
	
	
	private List<Sysright> getChildSysright(Sysright sysright,List<Sysright> sysrightList){
		List<Sysright> result=new ArrayList<Sysright>();
		for(Sysright right:sysrightList){
			if(right.getParentSysright()!=null
					&&right.getParentSysright().getRightCode().equals(sysright.getRightCode())){
				result.add(right);
			}
		}
		return result;
	}
	

	public List<TreeNode> getSysmenuTreeNodeListByUserId(Long staffId){
		List<Sysmenu> sysmenuList=sysmenuDao.findByStaffId(staffId);
		List<TreeNode> result = Lists.newArrayList();
		for (Sysmenu sysmenu : sysmenuList) {
			TreeNode node = this.sysmenuToTreeNode(sysmenu);
			result.add(node);
		}
		return result;
	}
	
	public List<TreeNode> getSysrightTreeNodeListByUserId(Long staffId)throws Exception{
		List<Sysright> sysrightList=sysrightDao.findSysrightByRightCode(staffId.intValue());
		List<TreeNode> result = Lists.newArrayList();
		for (Sysright sysmenu : sysrightList) {
			TreeNode node = this.sysrightToTreeNode(sysmenu);
			result.add(node);
		}
		return result;
	}


	public List<TreeNode> getNavMenuTreeByList(List<SysmenuBean> beanList)
			throws DaoException, SystemException, ServiceException {
		List<TreeNode> nodes = Lists.newArrayList();	
		for (SysmenuBean bean : beanList) {
			if (bean != null ) {
				TreeNode node = this.sysmenuToTreeNode(bean.getSysmenu());
				List<TreeNode> childrenTreeNodes = Lists.newArrayList();
				if(bean.getSubSysmenuList()!=null){
					for (Sysmenu subResource : bean.getSubSysmenuList()) {
						TreeNode cnode = sysmenuToTreeNode(subResource);
						if (cnode != null) {
							childrenTreeNodes.add(cnode);
						}
					}				
				}
				node.setChildren(childrenTreeNodes);				
				if (node != null) {
					nodes.add(node);
				}
				
			}
		}
		return nodes;
	}

	private TreeNode sysmenuToTreeNode(Sysmenu bean)
			throws DaoException, SystemException, ServiceException {
		TreeNode treeNode = new TreeNode(bean.getId().toString(), bean.getMenuText(), bean.getIconCls());
		// 自定义属性 url
		Map<String, Object> attributes = Maps.newHashMap();
		attributes.put("url", bean.getUrl());
		attributes.put("markUrl", bean.getMarkUrl());
		attributes.put("code", bean.getId());
		treeNode.setAttributes(attributes);
		return treeNode;
	}
	
	private TreeNode sysrightToTreeNode(Sysright bean) throws DaoException,
			SystemException, ServiceException {
		TreeNode treeNode = new TreeNode(bean.getRightCode(), bean.getRightName());
		// 自定义属性 url
		Map<String, Object> attributes = Maps.newHashMap();
		attributes.put("code", bean.getRightCode());
		treeNode.setAttributes(attributes);
		return treeNode;
	}

	
	
	public String getFunctionTreeStr(List<TreeNode> sessionTreeNode,List<TreeNode> assginTreeNode)throws Exception{
		StringBuilder sb=new StringBuilder();
		try {
			for(TreeNode node:sessionTreeNode){
				sb.append("<li id=\""+node.getId()+"\" ");
//				if(isNodeChecked(node.getId(), null, assginTreeNode)){
//					sb.append("class=\"jstree-checked\"");
//				}
				sb.append(">");				
				sb.append("<a href=\"#\">"+node.getText()+"</a>");
				
				if(node.getChildren()!=null){
					sb.append("<ul>");
					for(TreeNode cn:node.getChildren()){
						sb.append("<li id=\""+cn.getId()+"\" ");
						if(isNodeChecked(cn.getId(), node.getId(), assginTreeNode)){
							sb.append("class=\"jstree-checked\"");
						}
						sb.append(">");				
						sb.append("<a href=\"#\">"+cn.getText()+"</a>");
						//第三级
						if(cn.getChildren()!=null){
							sb.append("<ul>");
							for(TreeNode ccn:cn.getChildren()){
								sb.append("<li id=\""+ccn.getId()+"\" ");
								if(isNodeChecked(ccn.getId(), cn.getId(), assginTreeNode)){
									sb.append("class=\"jstree-checked\"");
								}
								sb.append(">");				
								sb.append("<a href=\"#\">"+ccn.getText()+"</a>");								
								
								sb.append("</li>");
							}
							sb.append("</ul>");
						}
						
						sb.append("</li>");
					}
					sb.append("</ul>");
				}
				sb.append("</li>");
			}
			return sb.toString();
		} catch (Exception e) {
			throw e;
		}
	}
	
	private boolean isNodeChecked(String id,String parentId,List<TreeNode> assginTreeNode){
		if(assginTreeNode==null)return false;
		for(TreeNode node:assginTreeNode){
			if(node.getId().equals(id)){
				return true;
			}
		}
		return false;
	}

}

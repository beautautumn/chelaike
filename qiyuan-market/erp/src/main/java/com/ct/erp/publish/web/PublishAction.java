package com.ct.erp.publish.web;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.lib.entity.PublishInfo;
import com.ct.erp.publish.service.PublishService;
import com.ct.erp.util.UcmsWebUtils;
import com.opensymphony.xwork2.util.logging.Logger;
import com.opensymphony.xwork2.util.logging.LoggerFactory;


@Scope("prototype")
@Controller("web.publishAction")
public class PublishAction extends SimpleActionSupport {

  private static final long serialVersionUID = 6020073250733178528L;
  private static final Logger log = LoggerFactory.getLogger(PublishAction.class);
  @Autowired
  private PublishService publishSerivce; 
  private PublishInfo publishInfo;
  private Long tradeId;
  private String ids;
  /**
   * to车辆发布页面
   * @return
   */
  public String toPublish(){
    try{
      
    }catch(Exception e)
    {
      log.error("toPublish", e);
      return "error";
    }
    return "toPublish";
  } 
  /**
   * do车辆发布
   */
  public void doPublish(){
    HttpServletResponse response = ServletActionContext.getResponse();
    try{
      publishSerivce.doPublish(publishInfo, ids);
       
    }catch(Exception e)
    {
      log.error("doPublish", e);
      UcmsWebUtils.ajaxOutPut(response, "error");
    }
    UcmsWebUtils.ajaxOutPut(response, "success");
  }
  
  
  /**
   * do车辆下架
   */
  public void doDown(){
    HttpServletResponse response = ServletActionContext.getResponse();
    try{
      publishSerivce.doDown(ids);
       
    }catch(Exception e)
    {
      log.error("doPublish", e);
      UcmsWebUtils.ajaxOutPut(response, "error");
    }
    UcmsWebUtils.ajaxOutPut(response, "success");
  }
    
  public void setPublishInfo(PublishInfo publishInfo) {
    this.publishInfo = publishInfo;
  }

  public PublishInfo getPublishInfo() {
    return publishInfo;
  }  
  
  public Long getTradeId() {
    return tradeId;
  }

  public void setTradeId(Long tradeId) {
    this.tradeId = tradeId;
  }

  public void setIds(String ids) {
    this.ids = ids;
  }
  public String getIds() {
    return ids;
  }
}

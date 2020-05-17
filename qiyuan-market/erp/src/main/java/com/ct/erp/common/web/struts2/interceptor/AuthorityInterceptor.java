package com.ct.erp.common.web.struts2.interceptor;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import com.ct.erp.util.RedirectConf;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.RedisTemplate;

import com.ct.erp.common.model.TreeNode;
import com.ct.erp.common.spring.SpringContextHolder;
import com.ct.erp.common.utils.Struts2Utils;
import com.ct.erp.constants.sysconst.Const;
import com.ct.erp.core.security.SecurityConstants;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.lib.entity.Sysright;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.sys.service.base.SysrightService;
import com.opensymphony.xwork2.Action;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.MethodFilterInterceptor;
import com.tianche.domain.StaffModel;
import com.tianche.domain.UserSession;

/**
 * 登录验证拦截器.
 */
@SuppressWarnings("serial")
public class AuthorityInterceptor extends MethodFilterInterceptor{

    protected Logger logger = LoggerFactory.getLogger(getClass());

    /**
     * 返回无权限页面 对应403页面 由struts.xml配置
     */
    private static final String RESULT_NOAUTHORITY = "noauthority";

	@Override
	protected String doIntercept(ActionInvocation actioninvocation) throws Exception {
	    //登录用户
		SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
        String requestUrl = Struts2Utils.getRequest().getRequestURI();
        String requestServer = Struts2Utils.getRequest().getServerName();
        logger.info(Struts2Utils.getRequest().getServerName() + "====serverName");
        HttpServletRequest request = Struts2Utils.getRequest();
        
        Cookie[] cookies = request.getCookies();
        String token = null;
        String u = null;
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("token")) {
                    token = cookie.getValue();
                }
                if (cookie.getName().equals("u")) {
                    u = cookie.getValue();
                }
            }
        }
    	RedisTemplate<String, UserSession> redisTemplate = SpringContextHolder.getBean("redisTemplate");
    	StaffService staffService = SpringContextHolder.getBean(StaffService.class);
    	SysrightService sysrightService = SpringContextHolder.getBean(SysrightService.class);
    	UserSession userSession = redisTemplate.opsForValue().get("token:"+token);
        if(sessionInfo == null || userSession == null || !sessionInfo.getStaffId().equals(userSession.getStaff().getId())){
        	boolean login = userSession != null && u.equals(DigestUtils.md5Hex(userSession.getStaff().getLoginName()));
        	if(userSession==null || !login){
        		Struts2Utils.getSession().setAttribute(SecurityConstants.SESSION_UNAUTHORITY_URL,requestUrl);
        		return RedirectConf.getRedirectByServerName(requestServer);
//    			return Action.LOGIN; //返回到登录页面
        	}else{
	        	StaffModel staffModel = userSession.getStaff();
	        	Staff staff = staffService.findById(staffModel.getId());
	        	List<Sysright> sysrightList = staffService
						.findStaffRightByStaffId(staffModel.getId());
				List<TreeNode> systreeNodeList = sysrightService
						.getSysmenuTreeByUserId(staffModel.getId());
				SecurityUtils.putUserToSession(staff, sysrightList, systreeNodeList, "",token);
				sessionInfo = SecurityUtils.getCurrentSessionInfo();
        	}
        }

		if(sessionInfo != null ){
            //清空session中清空未被授权的访问地址
            Object unAuthorityUrl = Struts2Utils.getSession().getAttribute(SecurityConstants.SESSION_UNAUTHORITY_URL);
            if(unAuthorityUrl != null){
                Struts2Utils.getSession().setAttribute(SecurityConstants.SESSION_UNAUTHORITY_URL,null);
            }

            String url = StringUtils.replaceOnce(requestUrl,  Struts2Utils.getRequest().getContextPath(), "");
//            //检查用户是否授权该URL
//            boolean isAuthority = resourceManager.isAuthority(url,sessionInfo.getUserId());
//            if(!isAuthority){
//                logger.warn("用户{}未被授权URL:{}！", sessionInfo.getLoginName(), requestUrl);
//                return RESULT_NOAUTHORITY;
//            }
            
			return actioninvocation.invoke(); //递归调用拦截器
		}else{
            Struts2Utils.getSession().setAttribute(SecurityConstants.SESSION_UNAUTHORITY_URL,requestUrl);
            return RedirectConf.getRedirectByServerName(requestServer);
//			return Action.LOGIN; //返回到登录页面
		}
		
	}
}

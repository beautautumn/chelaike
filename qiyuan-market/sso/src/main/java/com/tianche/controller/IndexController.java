package com.tianche.controller;


import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.tianche.core.exception.ErrorStatus;
import com.tianche.core.exception.TiancheException;
import com.tianche.domain.*;
import com.tianche.service.*;
import com.tianche.util.LocalMACUtil;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.codec.digest.Md5Crypt;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by jf on 15/5/13.
 */

@Controller
public class IndexController {

    @Autowired
    private IStaffService staffService;

    @Autowired
    private RedisTemplate<String, UserSession> redisTemplate;

    @Autowired
    private StringRedisTemplate stringRedisTemplate;

    @Autowired
    private SystemRightService systemRightService;

    @Autowired
    private SystemMenuService systemMenuService;

    @Autowired
    private LogService logService;

    @Autowired
    private MenuItemErpService menuItemErpService;

    @RequestMapping(value = "/", method = {RequestMethod.GET, RequestMethod.HEAD})
    public String index(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        String token = null;
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("token")) {
                    token = cookie.getValue();
                }
            }
        }
        UserSession sessionInfo = null;
        if (StringUtils.isNotBlank(token)) {
        	sessionInfo = redisTemplate.opsForValue().get("token:" + token);
        }
        if (sessionInfo != null) {
            request.setAttribute("sessionInfo", sessionInfo);
            return "index";
        } else {
            return "redirect:/login";
        }

    }
    @RequestMapping(value = "/7y", method = {RequestMethod.GET, RequestMethod.HEAD})
    public String index7y(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        String token = null;
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("token")) {
                    token = cookie.getValue();
                }
            }
        }
        UserSession sessionInfo = null;
        if (StringUtils.isNotBlank(token)) {
            sessionInfo = redisTemplate.opsForValue().get("token:" + token);
        }
        if (sessionInfo != null) {
            request.setAttribute("sessionInfo", sessionInfo);
            return "index7y";
        } else {
            return "redirect:/login7y";
        }

    }
    @RequestMapping(value = "/market", method = {RequestMethod.GET, RequestMethod.HEAD})
    public String indexMarket(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        String token = null;
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("token")) {
                    token = cookie.getValue();
                }
            }
        }
        UserSession sessionInfo = null;
        if (StringUtils.isNotBlank(token)) {
            sessionInfo = redisTemplate.opsForValue().get("token:" + token);
        }
        if (sessionInfo != null) {
            request.setAttribute("sessionInfo", sessionInfo);
            return "indexMarket";
        } else {
            return "redirect:/loginMarket";
        }

    }

    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String ssoLogin(HttpServletResponse response) { return "login"; }

    @RequestMapping(value = "/login", method = RequestMethod.POST)
    @ResponseBody
    public Result auth(HttpServletResponse response, HttpServletRequest request, @RequestParam("username") String username, @RequestParam("password") String password) throws Exception{
        String suffix = "";
        String urlSuffix ="";
        return getResult(response, request, username, password, suffix, urlSuffix);
    }

    private Result getResult(HttpServletResponse response, HttpServletRequest request, @RequestParam("username") String username, @RequestParam("password") String password, String suffix, String urlSuffix) throws Exception {
        Log log = new Log();
        UserSession userSession = new UserSession();
        StaffModel staff = staffService.getStaffByLoginName(username);
        if (staff != null && staff.getLoginPwd().equals(password)) {
            if(staff.getStatus() == null || staff.getStatus() == 0){
                throw new TiancheException(ErrorStatus.BAD_PARAM,"用户正处在注销或冻结状态！");
            }
        	List<SystemRight> systemRightList = this.systemRightService.findByStaffId(staff.getId());
        	List<SystemMenu> sysMenuList = this.systemMenuService.findByStaffId(staff.getId());
            String token = DigestUtils.md5Hex(DigestUtils.md5Hex(username) + DigestUtils.md5Hex(password));
            Cookie cookie = new Cookie("token", token);
            cookie.setPath("/"+suffix);
            response.addCookie(cookie);
            Cookie userCookie = new Cookie("u", DigestUtils.md5Hex(username));
            userCookie.setPath("/"+suffix);
            response.addCookie(userCookie);
            userSession.setStaff(staff);
            userSession.setSystemRightList(systemRightList);
            userSession.setSysMenuList(sysMenuList);
            redisTemplate.opsForValue().set("token:" + token, userSession);
            String resultUrl = request.getContextPath()+"/" + urlSuffix;

            stringRedisTemplate.opsForList().leftPush("chasqui:chasqui-inbox",
                "{\"channel\": \"pc_token_sync\", \"syn_source_id\": \"" + staff.getId() + "\"}");

            log.setUserId(staff.getId());
            log.setLogDescription("登录系统"+ LocalMACUtil.getLocalMacAndIp(request));
            log.setCreateTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
            this.logService.save(log);
            return Result.create().add("obj", resultUrl);
        }else if(staff == null){
            throw new TiancheException(ErrorStatus.BAD_PARAM,"无此用户！");
        }else {
            throw new TiancheException(ErrorStatus.BAD_PARAM,"用户名密码错误！");
        }
    }
    @RequestMapping(value = "/listMenus", method = {RequestMethod.POST, RequestMethod.GET})
    public @ResponseBody List<MenuItemErp> getMenus(HttpServletRequest request){
        Cookie[] cookies = request.getCookies();
        String token = null;
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("token")) {
                    token = cookie.getValue();
                }
            }
        }
        UserSession userSession = redisTemplate.opsForValue().get("token:"+token);
        return this.menuItemErpService.listItemByStaffId(userSession.getStaff().getId());
    }
}

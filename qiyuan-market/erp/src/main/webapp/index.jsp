 <%@page import="com.ct.erp.constants.sysconst.Const"%>
 <%@ page import="com.ct.erp.util.RedirectConf" %>
 <%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%
    String requestServer = request.getServerName();
    int serverPort = request.getServerPort();
    String redirect = RedirectConf.getRedirectByServerName(requestServer);
    String scheme = request.getScheme();
    String ssoServerAddress=scheme+"://"+requestServer+":"+serverPort+"/sso/"+redirect;//Const.SSO_LOGIN_URL;
    request.setAttribute("ssoServerAddress",ssoServerAddress);
%>
<script type="text/javascript">
	var mac = "${mac}";
	top.location.href = "${ssoServerAddress}";
</script>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
  response.setContentType("application/x-download");//设置为下载application/x-download
  String filedownload = "/upload/apk/crm_phone.apk";//即将下载的文件的相对路径
  String filedisplay = "erp-android.apk";//下载文件时显示的文件保存名称
  String filenamedisplay = java.net.URLEncoder.encode(filedisplay,"UTF-8");
  response.addHeader("Content-Disposition","attachment;filename=" + filedisplay);
   
  try
  {
  RequestDispatcher dis = application.getRequestDispatcher(filedownload);
  if(dis!= null)
  {
  dis.forward(request,response);
  }
  response.flushBuffer();
  }
  catch(Exception e)
  {
  e.printStackTrace();
  }
  finally
  {
   
  }
%>



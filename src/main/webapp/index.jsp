<%--
  Created by IntelliJ IDEA.
  User: dengzhihui
  Date: 19-6-11
  Time: 下午5:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*" %>
<html>
<html>
<head>
    <title>页面重定向</title>
</head>
<body>

<h1>页面重定向</h1>

<%
    // 重定向到新地址
    String site = new String("http://localhost:8080/s/jsp/login.jsp");
    response.setStatus(response.SC_MOVED_TEMPORARILY);
    response.setHeader("Location", site);
%>

</body>
</html>

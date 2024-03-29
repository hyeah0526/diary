<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@ page import="java.sql.*" %> --%>
<%@ page import="java.net.*" %>
<%
	// 아래처럼 removeAttribute()를 사용해서 loginMember변수를 지워서 로그아웃이라고 생각하게해도 되지만 
	// 이것보다 invalidate()를 사용해서 기존세션을 완전히 삭제하고 새로운 세션공간을 초기화
	// session.removeAttribute("loginMember"); 
	
	session.invalidate(); //기존 세션을 완전히 삭제하고, 새로운 세션 공간을 초기화
	System.out.println(session.getId() + "session.invalidate() 호출후");
	
	response.sendRedirect("/diary/loginForm.jsp"); //그리고 로그인페이지로 전송
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
	<h1>일기장</h1>
	<div>
		<a href="/diary/logout.jsp">로그아웃</a>
	</div>
</body>
</html>>
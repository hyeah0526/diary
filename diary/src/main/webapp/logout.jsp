<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
		
	String sql1 = "select my_session mySession from login";
	//my_session을 mySession의 이름으로 가져옴
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	stmt1 = conn.prepareStatement(sql1);
	rs1 = stmt1.executeQuery();
	
	String mySession = null;
	
	if(rs1.next()){
		mySession = rs1.getString("mySession");
		System.out.println(mySession + "<--mySession"); 
	}
	
	if(mySession.equals("OFF")){
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해주세요", "utf-8"); //한글 encode해주기
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg); //sendRedirect는 get방식이므로 errMsg는 주소뒤에 붙여서 가져가기
		//자원반납
		rs1.close();
		stmt1.close();
		conn.close();
		return; //코드 진행을 끝내는 문법 ex.메서드 바꿀 때return사용
	}
	
	//현재값이 OFF가 아니고 ON일 경우, OFF로 바꿔주고 loginForm으로 보내줌
	String sql2 = "update login set my_session='OFF', off_date=now()";
	PreparedStatement stmt2 = null;
	stmt2 = conn.prepareStatement(sql2);
	int row = stmt2.executeUpdate();
	System.out.println(row+" <-- row");
	response.sendRedirect("/diary/loginForm.jsp");
	
	//if문에 걸렸으면 if문에서 반납을하고, if문에 걸리지 않으면 여기서 반납
	rs1.close();
	stmt1.close();
	conn.close();
	
	
	
	// 한글
	//1. 임포트 먼저 해주고
	// page import="java.net.URLEncoder" 
	// 2. 한글은 encode해주기
	// URLEncoder.encode(변수명,"utf-8")
	
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
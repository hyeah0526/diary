<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	// 0. 로그인(인증) 분기
	// diary.login.my_session => 'ON' => redirect("diary.jsp")
	// DB이름.테이블이름.컬럼이름의 값이 'ON'이면 diary.jsp로 보냄
	
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
		mySession = rs1.getString("mySession"); // ON 혹은 OFF가 담기게 됨
	}
	
	if(mySession.equals("ON")){ 
		response.sendRedirect("/diary/diary.jsp"); //만약 로그인이 이미 되어있는 사람이면 diary.jsp로 보냄
		//자원반납
		rs1.close();
		stmt1.close();
		conn.close();
		return; //코드 진행을 끝내는 문법 ex.메서드 바꿀 때return사용
	}
	
	rs1.close();
	stmt1.close();
	conn.close();
	
	// 1. 요청값분석
	String errMsg = request.getParameter("errMsg");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
	<div>
		<%
			if(errMsg != null){
		%>
				<%=errMsg%>
		<%
			}
		%>
	</div>
	
	<h1>로그인</h1>
	<form method="post" action="/diary/loginAction.jsp">
		<div>memberId: <input type="text" name="memberId"> </div>
		<div>memberPw: <input type="password" name="memberPw"> </div>
		<div><button type="submit">로그인</button></div>
	</form>
	
</body>
</html>
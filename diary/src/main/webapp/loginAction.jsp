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
		mySession = rs1.getString("mySession"); //ON 혹은 OFF를 확인
	}
	
	if(mySession.equals("ON")){ //만약 로그인이 이미 되어있는 사람이면
		response.sendRedirect("/diary/loginForm.jsp");
		//자원반납
		rs1.close();
		stmt1.close();
		conn.close();
		return; //코드 진행을 끝내는 문법 ex.메서드 바꿀 때return사용
	}
	
	// 1. 요청값분석
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	String sql2 = "select member_id memberId from member where member_id = ? and member_pw = ?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, memberId);
	stmt2.setString(2, memberPw);
	rs2 = stmt2.executeQuery();
	
	
	if(rs2.next()){
		//로그인 성공
		System.out.println("로그인 성공");
		
		//diary.login.my_session 값을 on으로 바꿔줘야함 (로그인에 성공했으니까)
		String sql3 = "UPDATE login SET my_session = 'ON', on_date = now() where my_session='OFF'";
		PreparedStatement stmt3 = null;
		int row = 0;
		stmt3 = conn.prepareStatement(sql3);
		row = stmt3.executeUpdate();
		if(row == 1){
			System.out.println("my_session을 ON으로 변경 완료!");
		}else{
			System.out.println("my_session을 ON으로 변경 실패..");
		}
		response.sendRedirect("/diary/diary.jsp");
	}else{
		//로그인 실패
		System.out.println("로그인 실패");
		String errMsg = URLEncoder.encode("아이디와 비밀번호를 확인해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
	}
	
	
	//자원 반납
	rs1.close();
	stmt1.close();
	
	rs2.close();
	stmt2.close();
	
	conn.close();
%>
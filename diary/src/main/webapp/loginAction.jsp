<%@page import="dao.DBHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	String loginMember = (String)session.getAttribute("loginMember"); 
	System.out.println(loginMember + " <--loginMember loginForm.jsp"); //로그인 한적이 없으면 null, 있으면 다른 값이 들어감

	if(loginMember != null)
	{
		response.sendRedirect("/diary/diary.jsp"); //로그인 상태면 메인화면으로 보냄
		return; //코드 진행을 끝냄
	}
	
	// 1. 요청값분석
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	Connection conn = DBHelper.getConnection();
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
		
		//session 로그인 성공시 DB값 설정해서 session변수 설정
		session.setAttribute("loginMember", rs2.getString("memberId"));
		response.sendRedirect("/diary/diary.jsp");
	}else{
		//로그인 실패
		System.out.println("로그인 실패");
		String errMsg = URLEncoder.encode("아이디와 비밀번호를 확인해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
	}
	
	//자원 반납
	//rs2.close();
	//stmt2.close();
	//conn.close();
%>
<%@page import="dao.DBHelper"%>
<%@page import="org.apache.catalina.ha.backend.Sender"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//점심메뉴 투표 완료시 추가하기!
	
	//값 넘어오는지 확인
	String diaryDate = request.getParameter("diaryDate");
	String menu = request.getParameter("menu");
	System.out.println(diaryDate+" <--diaryDate addLunch.jsp");
	System.out.println(menu+" <--menu addLunch.jsp");
	
	//DB추가
	/*
		INSERT INTO lunch(lunch_date, menu, update_date, create_date)
		VALUES('2024-03-14', '기타', NOW(), NOW());
	*/
	Connection conn = DBHelper.getConnection();
	String sql = "insert into lunch(lunch_date, menu, update_date, create_date) values(?, ?, now(), now())";
	PreparedStatement stmt = null;
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, diaryDate);
	stmt.setString(2, menu);
	System.out.println(stmt);
	
	int row = 0;
	row = stmt.executeUpdate();
	
	if(row == 1){
		System.out.println("추가성공 addLunch.jsp");
		response.sendRedirect("/diary/lunchOne.jsp?diaryDate="+diaryDate);
	}else{
		System.out.println("추가실패 addLunch.jsp");
		response.sendRedirect("/diary/lunchOne.jsp?diaryDate="+diaryDate);
	}
	
%>


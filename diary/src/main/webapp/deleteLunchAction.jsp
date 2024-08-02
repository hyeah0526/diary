<%@page import="dao.DBHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	// 점심투표 삭제하기
	
	//넘어온 변수값 불러오기
	String diaryDate = request.getParameter("diaryDate");
	System.out.println(diaryDate+" <--diaryDate deleteLunchAction.jsp");
	
	//DB삭제
	/*
		DELETE FROM lunch
		WHERE lunch_Date = '2024-03-14';
	*/
	String sql = "delete from lunch where lunch_date = ?";
	Connection conn = DBHelper.getConnection();
	PreparedStatement stmt = null;
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, diaryDate);
	System.out.println(stmt);
	
	int row = 0;
	row = stmt.executeUpdate();
	String msg = null;
	
	if(row == 1){
		System.out.println("삭제성공 deleteLunchAction.jsp");
		msg = "delete done";
		response.sendRedirect("/diary/lunchOne.jsp?diaryDate="+diaryDate+"&msg="+msg);
		conn.close();
	}else{
		System.out.println("삭제실패 deleteLunchAction.jsp");
		msg = "delete false";
		response.sendRedirect("/diary/lunchOne.jsp?diaryDate="+diaryDate+"&msg="+msg);
		conn.close();
	}	
	
	
%>

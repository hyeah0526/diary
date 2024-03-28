<%@page import="org.apache.catalina.ha.backend.Sender"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	// 변수값 가져오기
	String diaryDate = request.getParameter("diaryDate");
	String title = request.getParameter("title");
	String weather = request.getParameter("weather");
	String content = request.getParameter("content");
	System.out.println(diaryDate+" <--diaryDate updateDiaryAction");
	System.out.println(title+" <--title updateDiaryAction");
	System.out.println(weather+" <--weather updateDiaryAction");
	System.out.println(content+" <--content updateDiaryAction");
	
	/*
		UPDATE diary
		SET title = '진지하지 않은 일기',
		weather = '비',
		content = '진지하게 살지 말자!',
		update_date = NOW()
		WHERE diary_date = '2024-03-22';
	*/
	Class.forName("org.mariadb.jdbc.Driver");
	String sql1 = "update diary set title = ?, weather = ?, content = ?, update_date = NOW() WHERE diary_date = ?";
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt1 = null;
	stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, title);
	stmt1.setString(2, weather);
	stmt1.setString(3, content);
	stmt1.setString(4, diaryDate);
	System.out.println(stmt1);
	
	int row = 0;
	row = stmt1.executeUpdate();
	
	if(row == 1){
		System.out.println("수정성공");
		response.sendRedirect("/diary/diary.jsp");
	}else{
		System.out.println("수정실패");
		response.sendRedirect("/diary/diaryOne.jsp?diaryDate="+diaryDate);
	}
	
%>

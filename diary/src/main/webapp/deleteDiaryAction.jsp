<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	// 변수값 가져오기
	String diaryDate = request.getParameter("diaryDate");
	System.out.println(diaryDate+" <--diaryDate deleteDiaryAction");
	
	Class.forName("org.mariadb.jdbc.Driver");
	String sql1 = "DELETE FROM diary WHERE diary_Date = ?";
	Connection conn = null;
	int row = 0;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt1 = null;
	stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, diaryDate);
	System.out.println(stmt1);
	
	row = stmt1.executeUpdate();
	
	if(row == 1){
		System.out.println("삭제성공");
		response.sendRedirect("/diary/diary.jsp");
	}else{
		System.out.println("삭제실패");
		response.sendRedirect("/diary/diaryOne.jsp?diaryDate="+diaryDate);
	}
	
%>
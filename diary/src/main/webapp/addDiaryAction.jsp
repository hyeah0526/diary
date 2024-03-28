<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	//변수값 가져오기
	String diaryDate = request.getParameter("checkDate"); //2024-03-26 형식으로 넘어옴
	String title = request.getParameter("title");
	String weather = request.getParameter("weather");
	String content = request.getParameter("content");
	System.out.println(diaryDate + "< --- diaryDate addDiraryAction");
	System.out.println(title + "< --- title addDiraryAction");
	System.out.println(weather + "< --- weather addDiraryAction");
	System.out.println(content + "< --- content addDiraryAction");

	String sql = "INSERT INTO diary(diary_date, title, weather, content, update_date, create_date) VALUES (?, ?, ?, ?, NOW(), NOW())";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt = null;
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, diaryDate);
	stmt.setString(2,title);
	stmt.setString(3, weather);
	stmt.setString(4, content);
	System.out.println(stmt);
	
	int row = stmt.executeUpdate();
	if(row == 1){//성공
		System.out.println("addDiaryAction 추가성공");
		response.sendRedirect("/diary/diary.jsp");
	}else{ //실패시 다시 작성페이지로 되돌아가기
		System.out.println("addDiaryAction 추가실패");
		response.sendRedirect("/diary/addDiaryForm.jsp?checkDate="+diaryDate);
	}
%>



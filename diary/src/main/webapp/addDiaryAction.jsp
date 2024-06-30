<%@ page import="dao.DBHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	//변수값 가져오기
	String diaryDate = request.getParameter("checkDate"); //2024-03-26 형식으로 넘어옴
	String title = request.getParameter("title");
	String weather = request.getParameter("weather");
	String content = request.getParameter("content");
	String feeling = request.getParameter("feeling");
	
	// 유효성
	if(diaryDate == null || feeling == null || title.equals("") || content.equals("") || diaryDate.equals("")){
		String enterErr = "fail";
		response.sendRedirect("/diary/addDiaryForm.jsp?enterErr="+enterErr);
		return;
	}
	
	System.out.println(diaryDate + "< --- diaryDate addDiraryAction");
	System.out.println(title + "< --- title addDiraryAction");
	System.out.println(weather + "< --- weather addDiraryAction");
	System.out.println(content + "< --- content addDiraryAction");
	System.out.println(feeling + "< --- feeling addDiraryAction");

	String sql = "INSERT INTO diary(diary_date, feeling,title, weather, content, update_date, create_date) VALUES (?, ?, ?, ?, ?, NOW(), NOW())";
	Connection conn = DBHelper.getConnection();
	PreparedStatement stmt = null;
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, diaryDate);
	stmt.setString(2, feeling);
	stmt.setString(3,title);
	stmt.setString(4, weather);
	stmt.setString(5, content);
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



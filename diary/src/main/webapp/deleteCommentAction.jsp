<%@page import="dao.DBHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String diaryDate = request.getParameter("diaryDate");
	System.out.println(commentNo + " <-- commentNo deleteCommentAction.jsp");
	System.out.println(diaryDate + " <-- diaryDate deleteCommentAction.jsp");
	
	Connection conn = DBHelper.getConnection();
	
	String sql = "delete from comment where comment_no = ?";
	PreparedStatement stmt = null;
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, commentNo);
	System.out.println(stmt);
	
	int row = 0;
	row = stmt.executeUpdate();
	
	if(row == 1){
		System.out.println(" 삭제성공 <--deleteCommentAction.jsp");
		response.sendRedirect("/diary/diaryOne.jsp?diaryDate="+diaryDate);
	}else{
		System.out.println(" 삭제실패 <--deleteCommentAction.jsp");
		response.sendRedirect("/diary/diaryOne.jsp?diaryDate="+diaryDate);
	}
%>
<%@page import="dao.DBHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String diaryDate = request.getParameter("diaryDate");
    String memo = request.getParameter("memo");
    System.out.println(diaryDate + " <--diaryDate addCommentAction.jsp");
    System.out.println(memo + " <--memo addCommentAction.jsp");
    
    Connection conn = null;
    PreparedStatement stmt = null;
        conn = DBHelper.getConnection(); // DBHelper에서 Connection을 가져옴
        String sql = "INSERT INTO comment(diary_date, memo, update_date, create_date) VALUES(?, ?, NOW(), NOW())";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, diaryDate);
        stmt.setString(2, memo);
        System.out.println(stmt);
        
        int row = stmt.executeUpdate(); // 쿼리 실행
        
        if(row == 1){
            System.out.println(" 추가성공 <--addCommentAction.jsp");
            response.sendRedirect("/diary/diaryOne.jsp?diaryDate="+diaryDate);
        }else{
            System.out.println(" 추가실패 <---addCommentAction.jsp");
            response.sendRedirect("/diary/diaryOne.jsp?diaryDate="+diaryDate);
        }
        // 자원 닫기
		conn.close();
%>

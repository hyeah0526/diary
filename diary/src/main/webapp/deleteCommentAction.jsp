<%@ page import="dao.DBHelper" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    int commentNo = Integer.parseInt(request.getParameter("commentNo"));
    String diaryDate = request.getParameter("diaryDate");
    System.out.println(commentNo + " <-- commentNo deleteCommentAction.jsp");
    System.out.println(diaryDate + " <-- diaryDate deleteCommentAction.jsp");

    Connection conn = null;
    PreparedStatement stmt = null;
        // DB 연결
        conn = DBHelper.getConnection();

        // SQL 실행 준비
        String sql = "DELETE FROM comment WHERE comment_no = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, commentNo);
        System.out.println(stmt);

        // 쿼리 실행
        int row = stmt.executeUpdate();

        if (row == 1) {
            System.out.println("삭제 성공 <--deleteCommentAction.jsp");
            response.sendRedirect("/diary/diaryOne.jsp?diaryDate=" + diaryDate);
        } else {
            System.out.println("삭제 실패 <--deleteCommentAction.jsp");
            response.sendRedirect("/diary/diaryOne.jsp?diaryDate=" + diaryDate);
        }
         // 자원 닫기
		conn.close();
%>

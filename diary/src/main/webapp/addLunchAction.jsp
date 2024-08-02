<%@ page import="dao.DBHelper" %>
<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 점심메뉴 투표 완료시 추가하기!

    // 값 넘어오는지 확인
    String diaryDate = request.getParameter("diaryDate");
    String menu = request.getParameter("menu");
    System.out.println(diaryDate + " <--diaryDate addLunch.jsp");
    System.out.println(menu + " <--menu addLunch.jsp");

    Connection conn = null;
    PreparedStatement stmt = null;
        // DB 연결
        conn = DBHelper.getConnection();
        
        // SQL 실행 준비
        String sql = "INSERT INTO lunch(lunch_date, menu, update_date, create_date) VALUES (?, ?, NOW(), NOW())";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, diaryDate);
        stmt.setString(2, menu);
        System.out.println(stmt);

        // 쿼리 실행
        int row = stmt.executeUpdate();

        if (row == 1) {
            System.out.println("추가성공 addLunch.jsp");
            response.sendRedirect("/diary/lunchOne.jsp?diaryDate=" + diaryDate);
        } else {
            System.out.println("추가실패 addLunch.jsp");
            response.sendRedirect("/diary/lunchOne.jsp?diaryDate=" + diaryDate);
        }
    	 // 자원 닫기
		conn.close();
%>


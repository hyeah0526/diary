<%@ page import="dao.DBHelper" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
    /* -------------------------여기부터 로그인 인증분기 코드---------------------------------- */
    String loginMember = (String)(session.getAttribute("loginMember"));
    if(loginMember == null){
        String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해주세요", "utf-8");
        response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
        return;
    }
    /* -------------------------여기까지 로그인 인증분기 코드---------------------------------- */

    /* --------------------여기부터가 진짜 check 코드------------------------- */
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
        // 날짜 가져오기
        String checkDate = request.getParameter("checkDate");

        // DB 연결
        conn = DBHelper.getConnection();

        // 해당 날짜에 일기가 존재하는지 확인하는 쿼리
        String sql = "SELECT diary_date FROM diary WHERE diary_date = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, checkDate);
        rs = stmt.executeQuery();

        if(rs.next()) {
            // 이미 해당 날짜에 일기가 존재함
            response.sendRedirect("/diary/addDiaryForm.jsp?checkDate="+checkDate+"&ck=false");
        } else {
            // 해당 날짜에 일기가 존재하지 않음
            response.sendRedirect("/diary/addDiaryForm.jsp?checkDate="+checkDate+"&ck=true");
        }
         // 자원 닫기
		conn.close();
%>

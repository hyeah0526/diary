<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	/* -------------------------여기부터 로그인 인증분기 코드---------------------------------- */
	String loginMember = (String)(session.getAttribute("loginMember"));
	if(loginMember == null){
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해주세요", "utf-8"); //한글 encode해주기
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg); //sendRedirect는 get방식이므로 errMsg는 주소뒤에 붙여서 가져가기
		return;
	}
	/* -------------------------여기까지 로그인 인증분기 코드---------------------------------- */
	/* --------------------여기부터가 진짜 check 코드------------------------- */
	//1. 날짜를 가져오고
	String checkDate = request.getParameter("checkDate");
	
	//2. 해당날짜에 일기가 존재하는지 확인
	// 결과가 있으면 이미 해당 날짜에 일기가 있는거니까 입력되면 안됨!!
	String sql2 = "select diary_date diaryDate from diary where diary_Date = ?";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, checkDate);
	rs2 = stmt2.executeQuery();
	
	//
	if(rs2.next()){ //ck가 없으면 아직 아무것도 확인하지 않은 상태인 것임!!!!
		// 이 날짜에는 일기가 있으니까 일기를 작성할 수 없음!
		// 그러니까 확인 후에 addDiaryForm으로 보내줄 건데, checkDate변수를 같이 넘기고 그거랑 같이
		// 일기를 쓸 수 있는지 없는지 확인해주는 ck값으로 False를 보낼 것 (작성 못한다는 뜻!)
		response.sendRedirect("/diary/addDiaryForm.jsp?checkDate="+checkDate+"&ck=false"); //존재하면 작성이 불가능하니까 false로 보내고
	}else{
		// 이 날짜에는 날짜가 없으니까 일기를 작성할 수 있음
		// 작성할 수 있으니까 ch를 true로 보내줌
		response.sendRedirect("/diary/addDiaryForm.jsp?checkDate="+checkDate+"&ck=true"); //존재하지않으면 작성이 가능하니까 true로 보냄
	}
	
	
	
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	/* -------------------------여기부터---------------------------------- */
	String sql1 = "select my_session mySession from login";
	//my_session을 mySession의 이름으로 가져옴
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	stmt1 = conn.prepareStatement(sql1);
	rs1 = stmt1.executeQuery();
	
	String mySession = null;
	
	if(rs1.next()){
	mySession = rs1.getString("mySession");
	System.out.println(mySession + "<--mySession"); 
	}
	
	if(mySession.equals("OFF")){
	String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해주세요", "utf-8"); //한글 encode해주기
	response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg); //sendRedirect는 get방식이므로 errMsg는 주소뒤에 붙여서 가져가기
	
	//자원반납
	//rs1.close();
	//stmt1.close();
	//conn.close();
	return; //코드 진행을 끝내는 문법 ex.메서드 바꿀 때return사용
	}
	
	/* --------------------여기까지는 인증분기코드------------------------- */
%>
<%
	/* --------------------여기부터 상세보기 코드------------------------- */
	//변수가져오기
	String diaryDate = request.getParameter("diaryDate");
	System.out.println(diaryDate+" <-- diaryDate diaryOne.jsp");	//2024-03-22
	
	//sql
	String sql2 = "SELECT * FROM diary WHERE diary_date=?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, diaryDate);
	System.out.println(stmt2);
	
	rs2 = stmt2.executeQuery();
	/* --------------------여기까지 상세보기 코드------------------------- */

%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>diaryOne</title>
	<!-- 부트스트랩 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
	<style>
		/* 강원교육체 */
		@font-face {
		    font-family: 'GangwonEdu_OTFBoldA';
		    src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2201-2@1.0/GangwonEdu_OTFBoldA.woff') format('woff');
		    font-weight: normal;
		    font-style: normal;
		}
		.fontAll {
			font-family: 'GangwonEdu_OTFBoldA';
			color: #CEB9AB;
		}
		
		.backImg{
			width: 100%;
			vertical-align: middle;
			background-image: url("/diary/img/wall1.png");
			background-color: rgba(0, 0, 0, 0.5);
		}
		.addDiaryBtn{
			background-color: transparent;
			color: #CEB9AB;
			border: 1px solid #CEB9AB;
			margin-top: 10px;
			border-radius: 5px;
		}
		.dateInput{
			background-color: transparent;
			color: #CEB9AB;
			border: 0px;
			border-bottom: 2px solid #CEB9AB;
		}
		.divBorder{
			border: 2px dotted #CEB9AB;
			border-radius: 10px;
			padding-top: 7px;
			width: 500px;
			display: inline-block;
			text-align: center;
		}
		.divContent{
			border: 2px dotted #CEB9AB;
			border-radius: 10px;
			padding: 7px;
			width: 500px;
			height: 400px;
			display: inline-block;
			text-align: center;
		}
		.icon{
			width: 40px;
			height: 40px;
		}
		.addDiaryBtn{
			background-color: transparent;
			color: #CEB9AB;
			border: 2px solid #CEB9AB;
			padding-top : 10px;
			border-radius: 10px;
		}
	</style>
</head>
<body class="backImg">
<div class="container fontAll">
	<!-- 시작윗부분 -->
	<div class="row text-center">
		<div class="col mt-5" style="text-align: center;">
			<h1>상세일기보기</h1>
			<a href="/diary/diary.jsp"><img src="/diary/img/dairy.png" class="icon"></a>&nbsp;&nbsp;&nbsp;
			<a href="/diary/diaryList.jsp"><img src="/diary/img/list.png" class="icon"></a>&nbsp;&nbsp;&nbsp;
			<a href="/diary/addDiaryForm.jsp"><img src="/diary/img/dairy_pen.png" class="icon"></a>&nbsp;&nbsp;&nbsp;
			<a href="/diary/statsLunch.jsp"><img src="/diary/img/lunch.png" class="icon"></a>&nbsp;&nbsp;&nbsp;
			<a href="/diary/logout.jsp"><img src="/diary/img/logout.png" class="icon"></a>
		</div><br>
	</div><br><br>
	
	<!-- 내용 -->
	<div class="row text-center">
		<div class="col"></div>
		<div class="col-8 fs-4">
	<%
			if(rs2.next()){
				String diaryDate2 = rs2.getString("diary_date");
				String year = diaryDate2.substring(0,4);
				String month = diaryDate2.substring(5,7);
				String day = diaryDate2.substring(8,10);
	%>
				<div class="row">
					<div class="col mt-3"><div class="divBorder"><%=rs2.getString("title")%></div></div>
				</div>
				<div class="row">
					<div class="col mt-3"><div class="divBorder">
						<%=year%>년 <%=month%>월 <%=day%>일&nbsp;
						<%=rs2.getString("weather")%>
					</div></div>
				</div><br>
				<div class="row">
					<div class="col mt-3"><div class="divContent"><%=rs2.getString("content")%></div></div>
				</div><br>
	<%
			}
	%>
		</div>
		
		<div class="col"></div>
	</div>
	
	<!-- 메인끝 -->
	<div class="row text-center">
		<div class="col"></div>
		<div class="col fs-4">
			<a class="addDiaryBtn btn" href="/diary/lunchOne.jsp?diaryDate=<%=diaryDate%>">점심투표</a>
			<a class="addDiaryBtn btn" href="/diary/updateDiaryForm.jsp?diaryDate=<%=diaryDate%>">수정하기</a>
			<a class="addDiaryBtn btn"  href="/diary/deleteDiaryAction.jsp?diaryDate=<%=diaryDate%>">삭제하기</a>
		</div>
		<div class="col"></div>
	</div>
</div>
</body>
</html>
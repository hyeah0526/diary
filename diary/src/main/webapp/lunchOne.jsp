<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %>
<%  
	/* -------------------------로그인(인증) 분기---------------------------------- */
	// diary.login.my_session => 'OFF' => redirect("loginForm.jsp")
	// DB이름.테이블이름.컬럼이름의 값이 'OFF'일때 loginForm.jsp로 보냄
	
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
	
	
	//if문에 걸렸으면 if문에서 반납을하고, if문에 걸리지 않으면 여기서 반납
	//rs1.close();
	//stmt1.close();
	//conn.close();
	/* -------------------------여기까지 로그인(인증)분기------------------------------ */
%>
<%
	/* -------------------------여기부터 런치 투표값이 있는지 확인------------------------------ */
	//변수값 가져오기
	String diaryDate = request.getParameter("diaryDate");
	String msg = request.getParameter("msg");
	System.out.println(diaryDate+" <--diaryDate lunchOne.jsp");
	
	//해당날짜에 런치투표했는지 확인하기
	/*
		SELECT * 
		FROM lunch
		WHERE lunch_date = '2024-03-14';
	*/
	String sql2 = "select * from lunch where lunch_date = ?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, diaryDate);
	rs2 = stmt2.executeQuery();
	System.out.println(stmt2);
	
	/* -------------------------여기까지 런치 투표값이 있는지 확인----------------------------- */
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>statsLunch.jsp</title>
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
		
		a { text-decoration: none; color: #CEB9AB;}
		a:hover { color:#444236; }
		a:visited { text-decoration: none;}
		
		.backImg{
			width: 100%;
			vertical-align: middle;
			background-image: url("/diary/img/wall1.png");
			background-color: rgba(0, 0, 0, 0.5);
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
	<div class="row">
		<div class="col mt-5" style="text-align: center;"><h1>런치 통계</h1></div>
	</div>
	
	<!-- 시작윗부분 -->
	<div class="row">
		<div class="col"></div>
		<div class="col-8" style="text-align: center;">
			<!-- 아이콘 -->
			<a href="/diary/diary.jsp"><img src="/diary/img/dairy.png" class="icon"></a>&nbsp;&nbsp;&nbsp;
			<a href="/diary/diaryList.jsp"><img src="/diary/img/list.png" class="icon"></a>&nbsp;&nbsp;&nbsp;
			<a href="/diary/addDiaryForm.jsp"><img src="/diary/img/dairy_pen.png" class="icon"></a>&nbsp;&nbsp;&nbsp;
			<a href="/diary/statsLunch.jsp"><img src="/diary/img/lunch.png" class="icon"></a>&nbsp;&nbsp;&nbsp;
			<a href="/diary/logout.jsp"><img src="/diary/img/logout.png" class="icon"></a><br><br>
			
			<%
				if(rs2.next()){ //만약 투표결과가 존재할 경우 투표결과 보여주기
					String year = diaryDate.substring(0,4);
					String month = diaryDate.substring(5,7);
					String day = diaryDate.substring(8,10);
			%>
					<div class="mt-3 fs-4">
						투표결과가 존재합니다!<br>
						<%=year%>년 <%=month%>월 <%=day%>일&nbsp;
						점심메뉴는 '<%=rs2.getString("menu")%>'입니다.
					</div><br>
					<div>
						<a class="addDiaryBtn btn" href="/diary/deleteLunchAction.jsp?diaryDate=<%=diaryDate%>">메뉴 삭제</a>&nbsp;&nbsp;
						<a class="addDiaryBtn btn" href="/diary/statsLunch.jsp">전체 통계</a>
					</div>
			<%
				}else{ //만약 투표 결과가 없다면 투표창 보여주기
			%>
					<div class="fs-4">점심메뉴 선택</div>
			<%
					if(msg == null){
			%>
						<div class="fs-5"></div>
			<%			
					}else if(msg.equals("delete done")){
			%>
						<div class="fs-5">삭제 성공하였습니다. 다시 선택해주세요.</div>
			<%
					}
			%>
					<div>
						<form method="post" action="/diary/addLunchAction.jsp?diaryDate=<%=diaryDate%>">
							<input type="radio" name="menu" class="m-3" value="양식" id="menu1">&nbsp;
								<label for="menu1" class="fs-5">양식</label><br>
								
							<input type="radio" name="menu" class="m-3 fs-3" value="일식" id="menu2">&nbsp;
								<label for="menu2" class="fs-5">일식</label><br>
								
							<input type="radio" name="menu" class="m-3 fs-3" value="중식" id="menu3">&nbsp;
								<label for="menu3" class="fs-5">중식</label><br>
							
							<input type="radio" name="menu" class="m-3 fs-3" value="한식" id="menu4">&nbsp;
								<label for="menu4" class="fs-5">한식</label><br>
							
							<input type="radio" name="menu" class="m-3 fs-3" value="기타" id="menu5">&nbsp;
								<label for="menu5" class="fs-5">기타</label><br><br>
								
							<button class="addDiaryBtn btn">선택 완료</button>
						</form>
					</div>
			<%
				}
			%>
			
		</div>
		<div class="col"></div>
	</div>
</div>
</body>
</html>
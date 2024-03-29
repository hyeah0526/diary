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
%>
<%
	/* --------------------여기부터가 진짜 작성 코드------------------------- */
	String checkDate = request.getParameter("checkDate");
	String ck = request.getParameter("ck");
	System.out.println(checkDate + " <-- checkDate");
	System.out.println(ck + " <-- ck");
	
	//만약 checkDate가 null이면 공백을 넣어줌
	if(checkDate == null){
		checkDate = "";
	}
	if(ck == null){
		ck = "";
	}
	
	String msg = "";
	if(ck.equals("true")){
		msg = "일기 작성 가능한 날짜입니다.";
	}else if(ck.equals("false")){
		msg = "이미 일기가 작성되어 입력이 불가능한 날짜입니다.";
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>addDiaryForm</title>
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
		.icon{
			width: 40px;
			height: 40px;
		}
		.contentTextarea{
			background-color: transparent;
			color: #CEB9AB;
			border: 2px solid #CEB9AB;
		}
	</style>
</head>
<body class="backImg">
<div class="container fontAll">
	<!-- 시작윗부분 -->
	<div class="row">
		<div class="col mt-5" style="text-align: center;"><h1>일기쓰기</h1></div>
	</div>
	
	<!-- 내용 -->
	<div class="row text-center">
		<div class="col"></div>
		<div class="col-8">
			<a href="/diary/diary.jsp"><img src="/diary/img/dairy.png" class="icon"></a>&nbsp;&nbsp;&nbsp;
			<a href="/diary/diaryList.jsp"><img src="/diary/img/list.png" class="icon"></a>&nbsp;&nbsp;&nbsp;
			<a href="/diary/addDiaryForm.jsp"><img src="/diary/img/dairy_pen.png" class="icon"></a>&nbsp;&nbsp;&nbsp;
			<a href="/diary/statsLunch.jsp"><img src="/diary/img/lunch.png" class="icon"></a>&nbsp;&nbsp;&nbsp;
			<a href="/diary/logout.jsp"><img src="/diary/img/logout.png" class="icon"></a><br><br>
			
			<br>디버깅 코드 확인용 <br>
			checkDate :: <%=checkDate%><br>
			ck값 :: <%=ck%><hr>
		
			<!-- 해당 날짜에 일기가 있는지 확인하는 폼 -->
			<h5>작성 가능 날짜 확인</h5>
			<form method="post" action="/diary/checkDateAction.jsp">
				<div>
						<input class="dateInput" type="date" name="checkDate" value="<%=checkDate%>">
						<span><%=msg%></span>
						&nbsp;<button class="addDiaryBtn p-1" type="submit"> &#10004; 날짜 확인</button>
				</div>
			</form>
			
			<hr>
			<!-- 일기작성이 가능하다면 작성하는 폼 -->
			<h3>일기 작성하기</h3>
			<form method="post" action="/diary/addDiaryAction.jsp">
					<div class="col">날짜&nbsp;&nbsp;
					<%
						if(ck.equals("true")){
					%>
							<input type="text" value="<%=checkDate%>" name="checkDate" readonly="readonly" class="dateInput mb-2">
							<br><span><%=msg%></span><br><br>
					<%	
						}else{
					%>
							<input type="text" value="" name="checkDate" readonly="readonly" class="dateInput mb-2">
							<br><span><%=msg%></span><br><br>
					<%
						}
					%>
				</div>
				<div class="col">제목&nbsp;&nbsp;<input type="text" name="title" class="dateInput"></div><br>
				
				<div class="col">날씨&nbsp;&nbsp;
					<select class="btn addDiaryBtn mb-2" name="weather" style="width: 100px;height: 40px;">
						<option value="맑음">맑음</option>
						<option value="흐림">흐림</option>
						<option value="비">비</option>
						<option value="눈">눈</option>
					</select>
				</div><br>
				
				<div class="col">내용
					<textarea rows="7" cols="50" name="content" style="width: 100%;" class="contentTextarea fs-5"></textarea>
				</div>
				
				<div>
					<button class="addDiaryBtn btn" type="submit">작성 완료</button>
				</div>
			</form>
		</div>
		<div class="col"></div>
	</div>
	<!-- 메인끝 -->
	<div class="row">
	</div>
</div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	/* ---------------------------------session 사용 로그인---------------------------- */
	
	// 1. 로그인 인증분기 (session사용)
	// 로그인 성공시 세션에 loginMember 라는 변수 만들고 값으로 로그인 아이디를 저장
	String loginMember = (String)session.getAttribute("loginMember"); 
	//session.getAttribute()는 찾는 변수가 없으면 null을 반환함
	System.out.println(loginMember + " <--loginMember loginForm.jsp"); //로그인 한적이 없으면 null, 있으면 다른 값이 들어감
	
	// null이면 로그아웃상태이고, null이 아니면 로그인상태
	//loginForm.jsp는 로그아웃 상태체서만 출력됨
	if(loginMember != null)
	{
		response.sendRedirect("/diary/diary.jsp"); //로그인 상태면 메인화면으로 보냄
		return;//코드 진행을 끝냄
	}
	
	// 1. 요청값분석
	String errMsg = request.getParameter("errMsg");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
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
			background-color: #594a47;
			/*
			background-image: url("/diary/img/wall1.png");
			background-color: rgba(0, 0, 0, 0.5);
			*/
		}
		
		#memberInput{
			background-color: transparent;
			color: #CEB9AB;
			border: none;
			border-bottom: 2px dotted #CEB9AB;
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
	<div class="row">
		<div class="col"></div>
		
		<div class="col-8" style="text-align: center;">
			<div>
		<%
				if(errMsg != null){
		%>
					<%=errMsg%>
		<%
				}
		%>
		<div class="col mt-5" style="text-align: center;"><h1>일기장 로그인</h1></div>
		<form method="post" action="/diary/loginAction.jsp">
			<div class="fs-4">memberId <input type="text" name="memberId" id="memberInput" value="admin"></div><br>
			<div class="fs-4">memberPw <input type="password" name="memberPw" id="memberInput" value="1234"> </div><Br>
			<div><button type="submit" class="btn addDiaryBtn">로그인</button></div>
		</form>
	</div>
		</div>
		
		<div class="col"></div>
	</div>
	
</div>
</body>
</html>
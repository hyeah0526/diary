<%@page import="dao.DBHelper"%>
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
	/* --------------------여기부터 상세보기 코드------------------------- */
	//변수가져오기
	String diaryDate = request.getParameter("diaryDate");
	System.out.println(diaryDate+" <-- diaryDate diaryOne.jsp");	//2024-03-22
	
	//sql
	Connection conn = DBHelper.getConnection();
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
		
		a { text-decoration: none; color: #ff6f72;}
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
		
		.deleteBtn{
			color: red;
		}
		
		.commentWrite{
			background-color: transparent;
			color: #CEB9AB;
			border: 2px dotted #CEB9AB;
			border-radius: 10px;
			padding-top: 7px;
			width: 500px;
			display: inline-block;
			text-align: center;
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
					<div class="col mt-3"><div class="divBorder"><%=rs2.getString("title")%>&nbsp;<%=rs2.getString("feeling")%></div></div>
				</div>
				<div class="row">
					<div class="col mt-3"><div class="divBorder">
						<%=year%>년 <%=month%>월 <%=day%>일&nbsp;
						<%=rs2.getString("weather")%>
					</div></div>
				</div><br>
				
				<div class="row">
					<%
						//엔터 치환하기 .replace("\r\n", "<br>")
						String contentChange = rs2.getString("content");
						contentChange = contentChange.replace("\r\n", "<br>");
					%>
					<div class="col mt-3"><div class="divContent"><%=contentChange%></div></div>
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
			<a class="addDiaryBtn btn"  href="/diary/deleteDiaryAction.jsp?diaryDate=<%=diaryDate%>">삭제하기</a><br><br>
		
	<!-- 댓글추가 폼 -->
			<form method="post" action="/diary/addCommentAction.jsp">
				<input type="hidden" name="diaryDate" value="<%=diaryDate%>">
				<textarea rows="2" cols="50" name="memo" class="commentWrite"></textarea>
				<button type="submit" class="addDiaryBtn btn">댓글입력</button>
			</form><hr>
			
	<!-- 댓글리스트 -->
		<%
			String sql3 = "select comment_no commentNo, memo, create_date createDate from comment where diary_date = ? order by update_date DESC";
			PreparedStatement stmt3 = null;
			ResultSet rs3 = null;
			stmt3 = conn.prepareStatement(sql3);
			stmt3.setString(1, diaryDate);
			
			rs3 = stmt3.executeQuery();
		%>
		<%
			while(rs3.next()){
		%>	
				<div class="row">
					<div class="col-7 fs-5">
						<%=rs3.getString("memo")%>
					</div>
						
					<div class="col fs-6">
						<%=rs3.getString("createDate")%>
					</div>
						
					<div class="col fs-4 deleteBtn">
						<a href="/diary/deleteCommentAction.jsp?commentNo=<%=rs3.getInt("commentNo")%>&diaryDate=<%=diaryDate%>">X</a>
					</div>
				</div>
		<%
			}
		conn.close();
		%>
		</div>
		<div class="col"></div>
	</div>
</div>
</body>
</html>
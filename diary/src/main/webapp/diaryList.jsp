<%@page import="java.util.Set"%>
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
	/* --------------------여기부터 리스트코드------------------------- */
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){ //넘어온 페이지값이 있으면 그걸 담아줌
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10; //한페이지에 10페이지를 볼 것
	
	/*
	if(request.getParameter("currentPage") != null){ //넘어온 페이지값이 있으면 그걸 담아줌
		rowPerPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	*/
	
	int startRow = (currentPage-1)*rowPerPage; //1페이지일때 0 / 2페이지일때 10 / 3페이지일때 20 
	
	String serachWord = ""; //검색어가 없으면 공백을 넣고 검색어가 있으면 아래 if문에서 담아줌 //null이 절대로 들어갈 수 없음
	if(request.getParameter("serachWord") != null){ //넘어온 페이지값이 있으면 그걸 담아줌
		serachWord = request.getParameter("serachWord");
	}
	
	
	/*
		SELECT diary_date diaryDate, title
		FROM diary
		WHERE title LIKE '%구디%'
		ORDER BY diary_date DESC
		LIMIT 0, 10
	*/
	String sql2 = "select diary_date diaryDate, title from diary where title like ? order by diary_date desc limit ?, ?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, "%"+serachWord+"%");
	stmt2.setInt(2, startRow);
	//stmt2.setInt(3, rowPerPage);
	String rw = request.getParameter("selectRow");
	int selectRow = 0;
	
	if(rw == null){
		rw = "10";
		selectRow = Integer.parseInt(rw);
		stmt2.setInt(3, 10);
	}else{
		selectRow = Integer.parseInt(rw);
		stmt2.setInt(3, selectRow);
	}
	
	System.out.println(selectRow+" <--selectRow");
	
	System.out.println(stmt2);
	rs2 = stmt2.executeQuery();
	/* --------------------여기까지 리스트코드------------------------- */
	/* --------------------여기부터 리스트페이지 코드------------------------- */
	String sql3 ="select count(*) cnt from diary where title like ?"; //총 전체 다이어리 개수가 나옴
	PreparedStatement stmt3 = null;
	ResultSet rs3 = null;
	stmt3 = conn.prepareStatement(sql3);
	stmt3.setString(1, "%"+serachWord+"%");
	rs3 = stmt3.executeQuery();
	int totalRow = 0;
	if(rs3.next()){
		totalRow = rs3.getInt("cnt");
	}
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0){
		lastPage = lastPage+1;
	}
	
	//System.out.println(currentPage + " <--currentPage");
	//System.out.println(rowPerPage + " <--rowPerPage");
	//System.out.println(startRow + " <--startRow");
	//System.out.println(lastPage + " <--lastPage");
	//System.out.println(totalRow + " <--totalRow");
	/* --------------------여기까지 리스트페이지 코드------------------------- */
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
			background-image: url("/diary/img/wall1.png");
			background-color: rgba(0, 0, 0, 0.5);
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
		.searchInput{
			background-color: transparent;
			color: #CEB9AB;
			border: 2px dotted #CEB9AB;
			border-radius: 10px;
			padding-top: 5px;
		}
		.searchInputBtn{
			background-color: transparent;
			color: #CEB9AB;
			border: 2px dotted #CEB9AB;
			border-radius: 10px;
			padding-top: 5px;
		}
		.selectPage{
			background-color: transparent;
			width: 100px;
			height: 40px;
			color: #CEB9AB;
			border: 2px dotted #CEB9AB;
			border-radius: 10px;
			text-align: center;
		}
	</style>
</head>
<body class="backImg">
<div class="container fontAll">
	<!-- 시작윗부분 -->
	<div class="row text-center">
		<div class="col mt-5" style="text-align: center;">
			<h1>일기 목록</h1>
			<a href="/diary/diary.jsp"><img src="/diary/img/dairy.png" class="icon"></a>&nbsp;&nbsp;&nbsp;
			<a href="/diary/diaryList.jsp"><img src="/diary/img/list.png" class="icon"></a>&nbsp;&nbsp;&nbsp;
			<a href="/diary/addDiaryForm.jsp"><img src="/diary/img/dairy_pen.png" class="icon"></a>&nbsp;&nbsp;&nbsp;
			<a href="/diary/statsLunch.jsp"><img src="/diary/img/lunch.png" class="icon"></a>&nbsp;&nbsp;&nbsp;
			<a href="/diary/logout.jsp"><img src="/diary/img/logout.png" class="icon"></a>
		</div><br>
	</div><br><br>
	
	<!-- 내용 -->
	<div class="row text-center">
	<div class="row">
		<div class="col"></div>		
		<div class="col-8">
			<div class="row">
					<div class="col fs-4 mb-2" style="border-bottom: 2px dotted #CEB9AB;">날짜</div>&nbsp;
					<div class="col fs-4 mb-2" style="border-bottom: 2px dotted #CEB9AB;">제목</div>
			<%
					while(rs2.next()){
			%>
						<div class="row">
							<div class="col fs-5"><a href="/diary/diaryOne.jsp?diaryDate=<%=rs2.getString("diaryDate")%>"><%=rs2.getString("diaryDate")%></a></div>
							<div class="col fs-5"><%=rs2.getString("title")%></div>
						</div>
			<%
					}
			%>
			</div><br><br>
			
			<div>
			<!-- 이전 페이지 -->
			<%
				if(currentPage <= 1){
			%>
					<a style="color: gray;">&lt;&lt;처음</a>&nbsp;&nbsp;
					<a style="color: gray;">&lt;이전</a>
			<%
				}else{
			%>
					<a href="/diary/diaryList.jsp?currentPage=1&serachWord=<%=serachWord%>&selectRow=<%=rw%>">&lt;&lt;처음</a>&nbsp;&nbsp;
					<a href="/diary/diaryList.jsp?currentPage=<%=currentPage-1%>&serachWord=<%=serachWord%>&selectRow=<%=rw%>">&lt;이전</a>
			<%
				}
			%>
			
			<!-- 다음 페이지 -->
			<%
				if(currentPage >= lastPage){
			%>
					<a style="color: gray;">다음&gt;</a>
					<a style="color: gray;">마지막&gt;&gt;</a>&nbsp;&nbsp;
			<%
				}else{
			%>
					<a href="/diary/diaryList.jsp?currentPage=<%=currentPage+1%>&serachWord=<%=serachWord%>&selectRow=<%=rw%>">다음&gt;</a>&nbsp;&nbsp;
					<a href="/diary/diaryList.jsp?currentPage=<%=lastPage%>&serachWord=<%=serachWord%>&selectRow=<%=rw%>">마지막&gt;&gt;</a>
			<%
				}
			%>
			</div><br>
			<form method="get" action="/diary/diaryList.jsp?currentPage=<%=currentPage%>">
				<div>
					<select class="selectPage" name="selectRow" onchange="this.form.submit()">
						<option value="10">&nbsp;현재<%=rw%>&nbsp;</option>
						<option value="10">&nbsp;10&nbsp;</option>
						<option value="20">&nbsp;20&nbsp;</option>
						<option value="30">&nbsp;30&nbsp;</option>
					</select><br>
				</div><br>
				<div style="height: 100px;">
					제목 검색&nbsp;
					<input type="text" name="serachWord" class="searchInput" value="<%=serachWord%>">
					<button type="submit" class="searchInputBtn">검색</button>
				</div>
			</form>
		</div>		
		<div class="col"></div>		
	</div>
	</div>
	</div>
</body>
</html>
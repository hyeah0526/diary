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
	/* -------------------------캘린더 코드 시작------------------------- */
	String targetYear = request.getParameter("targetYear"); //출력할 년도
	String targetMonth = request.getParameter("targetMonth"); //출력할 월
	System.out.println(targetYear + " <-- targetYear diary.jsp");
	System.out.println(targetMonth + " <-- targetMonth diary.jsp");

	// 1. 디폴트로 오늘 날짜가 들어감
	Calendar target = Calendar.getInstance();
	
	// 2. 만약 값을 받은 targetYear/targetMonth가 있으면 target을 그날짜로 변경
	if(targetYear != null || targetMonth != null){
		target.set(Calendar.YEAR, Integer.parseInt(targetYear)); //꼭 년도 먼저 설정!
		target.set(Calendar.MONTH, Integer.parseInt(targetMonth));
	}
	//System.out.println(target+" <--target diary.jsp");
	
	// 3. 시작 공백의 개수 구하기 -> 1일이 무슨 요일인지 필요 target의 날짜를 1로 변경
	target.set(Calendar.DATE, 1);
	
	// 4. 달력 타이틀로 출력할 변수
	int tYear = target.get(Calendar.YEAR);
	int tMonth = target.get(Calendar.MONTH);
	
	// 5. 요일은 매핑된 숫자값으로 구해야함. (1-일, 2-월, 3-화, 4-수, 5-목, 6-금, 7-토)
	int yoNum = target.get(Calendar.DAY_OF_WEEK);
	System.out.println(yoNum + " <-- yoNum diary.jsp");
	
	// 6. 시작 공뱁 개수 구하기 일-0칸, 월-1칸, 화-2칸, 수-3칸, 목-4칸, 금-5칸, 토-6칸
	int startBlank = yoNum - 1;
	System.out.println(startBlank + " <-- startBlank diary.jsp");
	
	
	// 7. 타겟달의 마지막 날짜 가져오기 (31일이 마지막이면 31 / 30일이 마지막이면 30이 들어감)
	int lastDate = target.getActualMaximum(Calendar.DATE);
	System.out.println(lastDate + " <-- lastDate diary.jsp"); 
	
	// 8.
	int endBlank = 7 - ((startBlank + lastDate) % 7);
	System.out.println(endBlank + " <-- endBlank diary.jsp");
	
	// 9. 총 Div갯수 구하기
	int countDiv = startBlank + lastDate;
	System.out.println(countDiv + " <-- countDiv diary.jsp"); 
	
	/* -------------------------캘린더 코드 끝------------------------- */
	/* -------------------------다이어리 목록 추출하기------------------------- */
	// 1. DB에서 tYear와 tMonth에 해당되는 diary목록을 추철
	String sql2 = "select diary_date diaryDate, day(diary_date) day, left(title,5) title from diary where year(diary_date)=? and month(diary_date)=?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setInt(1, tYear);
	stmt2.setInt(2, tMonth+1); 
	System.out.println(stmt2);
	
	rs2 = stmt2.executeQuery();
	
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
		
		.yearMonthTitle{
			font-size: 30pt;
		}
		
		.calendarTb{
			background-color: transparent; 
			margin-left: auto; 
			margin-right: auto;"
		}
		.sun{
			color: #ff6f72;
			display:inline-block;	
			width: 100px; height: 100px; 
			border: 1px dotted #CEB9AB;		
		}
		
		.sat{
			color: #6f8eff;
			display:inline-block;	
			width: 100px; height: 100px;
			border: 1px dotted #CEB9AB;
		}
		
		.week{
			color: #CEB9AB;
			display:inline-block;	
			width: 100px; height: 100px;
			border: 1px dotted #CEB9AB;
		}
		
		.yo{
			text-align: center;
			height: 50px;
			font-size: 13pt;
		}
		
		.CalendarBlank{
			color: #CEB9AB;
			display:inline-block;	
			width: 100px; height: 100px;
			border: 1px dotted #CEB9AB;
		}
		
		.icon{
			width: 40px;
			height: 40px;
		}
	</style>
	
	</head>
<body class="backImg">
<div class="container fontAll">
	<!-- 시작윗부분 -->
	<div class="row">
		<div class="col mt-5" style="text-align: center;"><h1>일기장</h1></div>
	</div>
	
	<!-- 내용 -->
	<div class="row">
		<div class="col"></div>
		
		<div class="col-8" style="text-align: center;">
			<a href="/diary/diary.jsp"><img src="/diary/img/dairy.png" class="icon"></a>&nbsp;&nbsp;&nbsp;
			<a href="/diary/diaryList.jsp"><img src="/diary/img/list.png" class="icon"></a>&nbsp;&nbsp;&nbsp;
			<a href="/diary/addDiaryForm.jsp"><img src="/diary/img/dairy_pen.png" class="icon"></a>&nbsp;&nbsp;&nbsp;
			<a href="/diary/logout.jsp"><img src="/diary/img/logout.png" class="icon"></a><br><br>
			
			<!-- 캘린더 -->
			<div style="text-align: center;">
				<div>
				<a href="/diary/diary.jsp?targetYear=<%=tYear%>&targetMonth=<%=tMonth-1%>" class="fontAll">◀ 이전달</a>
				&nbsp;&nbsp; <span class="yearMonthTitle"><%=tYear%>년 <%=tMonth+1%>월</span> &nbsp;&nbsp;
				<a href="/diary/diary.jsp?targetYear=<%=tYear%>&targetMonth=<%=tMonth+1%>" class="fontAll">다음달 ▶</a>
				</div>
				
				<div style="display: inline-block;">
					<table class="calendarTb">
					<tr class="yo">
						<th style="color: #ff6f72;">일요일</th>
						<th>월요일</th>
						<th>화요일</th>
						<th>수요일</th>
						<th>목요일</th>
						<th>금요일</th>
						<th style="color: #6f8eff;">토요일</th>
					</tr>
					<tr>
					<%
						for(int i=1; i<=countDiv; i=i+1){
					%>
						<td>
						<%
							if(i>startBlank && i<=startBlank+lastDate) {
								if(i%7 == 0) {
						%>
								<span class="sat"><%=i-startBlank%><br>
						<%			
									while(rs2.next()){
										if(rs2.getInt("day") == (i-startBlank)){
						%>
											<a href='/diary/diaryOne.jsp?diaryDate=<%=rs2.getString("diaryDate")%>' class="fontAll">
												<%= rs2.getString("title")%>...
											</a></span><br> 
						<%
										break;
										}
									}
									rs2.beforeFirst();
								} else if(i%7 == 1) {
						%>
									<span class="sun"><%=i-startBlank%><br>
						<%					
									//현재 날짜(i-startBlank)의 일기가 rs2목록에 있는지 비교
									while(rs2.next()){
										//날짜에 일기가 존재하면 출력함
										if(rs2.getInt("day") == (i-startBlank)){
						%>
											<a href='/diary/diaryOne.jsp?diaryDate=<%=rs2.getString("diaryDate")%>' class="fontAll">
												<%= rs2.getString("title")%>...
											</a></span> 
						<%
											break;
										}
									}
									rs2.beforeFirst();
								}else {
						%>
									<span class="week"><%=i-startBlank%><br>
						<%		
									while(rs2.next()){
										if(rs2.getInt("day") == (i-startBlank)){
						%>
											<a href='/diary/diaryOne.jsp?diaryDate=<%=rs2.getString("diaryDate")%>' class="fontAll">
												<%= rs2.getString("title")%>...
											</a></span><br> 
						<%
										break;
										}
									}
									rs2.beforeFirst();
								}	
							} else {
						%>
								<span class="CalendarBlank">&nbsp;</span>
						<%
							}
						%>		
						</td>
						<%
							if(i!=countDiv && i%7 == 0) {
						%>
									</tr><tr>
						<%
								}
						}
					%>
					</tr>
				</table>
				</div>
		</div>
		</div>
		<div class="col"></div>
	</div>
	
	<!-- 메인끝 -->
	<div class="row">
		<div></div>
	</div>
</div>
</body>
</html>
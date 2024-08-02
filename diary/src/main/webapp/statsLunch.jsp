<%@page import="dao.DBHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %>
<%  
	/* -------------------------여기부터 session 로그인(인증) 분기---------------------------------- */
	String loginMember = (String)(session.getAttribute("loginMember"));
	if(loginMember == null){
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해주세요", "utf-8"); //한글 encode해주기
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg); //sendRedirect는 get방식이므로 errMsg는 주소뒤에 붙여서 가져가기
		return;
	}
	/* -------------------------여기까지 session 로그인(인증) 분기---------------------------------- */
%>
<%
	/* -------------------------여기부터 통계데이터 가져오기------------------------------ */
	/*
		SELECT menu, COUNT(*) 
		FROM lunch
		WHERE YEAR(lunch_Date) = 2024
		GROUP BY menu
		ORDER BY COUNT(*) DESC;
	*/
	Connection conn = DBHelper.getConnection();
	String sql2 = "select menu, count(*) cnt from lunch group by menu";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	rs2 = stmt2.executeQuery();
	
	conn.close();
	/* -------------------------여기까지 통계데이터 가져오기------------------------------ */
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
			background-color: #594a47;
			/*
			background-image: url("/diary/img/wall1.png");
			background-color: rgba(0, 0, 0, 0.5);
			*/
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
		<div class="col mt-5" style="text-align: center;"><h1>점심 통계</h1></div>
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
			
			<!-- 런치 전체 투표 수 -->
			<%
				double maxHeight = 300; //최대 세로길이 설정
				double totalCnt = 0; //전체 Cnt 수
				while(rs2.next()){ //전체 투표수 구하기
					totalCnt = totalCnt+rs2.getInt("cnt");
				}
				rs2.beforeFirst(); //초기값으로 초기화!
			%>
			<div class="fs-4">전체 투표수 : <%=(int)totalCnt%></div>
			
			<!-- 런치 통계 -->
			<div class="" style="text-align: center;">
			<table style="width: 500px; margin-left: auto; margin-right: auto;">
				<tr>
					<%	
						String[] c = {"#FF4848", "#FFF136", "#53FF4C", "#36FFFF", "#2524FF"};
						int i = 0;
						int maxCnt = 0;
						String maxLunch = null;
						while(rs2.next()){
							int h = (int)(maxHeight * (rs2.getInt("cnt")/totalCnt));
							
					%>
							<td style="vertical-align: bottom;">
								<div style="height: <%=h%>px;
											 background-color: <%=c[i]%>;
											 text-align: center;">
									<%=rs2.getInt("cnt")%>
								</div>
							</td>
					<%		
						if(maxCnt == 0){
							maxCnt = maxCnt+rs2.getInt("cnt");
							maxLunch = rs2.getString("menu");
						}else if(rs2.getInt("cnt") > maxCnt){
							maxCnt = rs2.getInt("cnt");
							maxLunch = rs2.getString("menu");
						}else if(rs2.getInt("cnt") == maxCnt){
							maxCnt = rs2.getInt("cnt");
							maxLunch = maxLunch+"과(와) "+rs2.getString("menu");
						}
							i = i+1;		
							
						}
						System.out.println(maxCnt);
					%>
				</tr>
				<tr>
					<%
						rs2.beforeFirst(); //다시 처음으로 초기치 셋팅
						while(rs2.next()){
					%>
							<td class="fs-5"><%=rs2.getString("menu")%></td>
					<%		
						}
						rs2.beforeFirst(); //다시 처음으로 초기치 셋팅
					%>
				</tr>
			</table>
			<div class="fs-5"><br>
				<%
					while(rs2.next()){
				%>
						<div><%=rs2.getString("menu")%> -  <%=rs2.getInt("cnt")%>번<br></div>
						
				<%
					} 
				%>
				식사하였으며, '<%=maxLunch%>'이(가) <%=maxCnt%>번으로 제일 많은 투표를 받았습니다.
			</div>
			</div>
			
		</div>
		<div class="col"></div>
	</div>
</div>
</body>
</html>
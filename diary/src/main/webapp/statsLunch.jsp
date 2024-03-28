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
	/* -------------------------여기부터 통계데이터 가져오기------------------------------ */
	/*
		SELECT menu, COUNT(*) 
		FROM lunch
		WHERE YEAR(lunch_Date) = 2024
		GROUP BY menu
		ORDER BY COUNT(*) DESC;
	*/
	String sql2 = "select menu, count(*) cnt from lunch group by menu";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	rs2 = stmt2.executeQuery();
		
	
	/* -------------------------여기까지 통계데이터 가져오기------------------------------ */
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>statsLunch.jsp</title>
</head>
<body>
	<h1>statsLunch</h1>
	<%
		double maxHeight = 300; //최대 세로길이 설정
		double totalCnt = 0; //
		while(rs2.next()){
			totalCnt = totalCnt+rs2.getInt("cnt");
		}
		rs2.beforeFirst();
	%>
					<div>전체 투표수 <%=(int)totalCnt %></div>
	<table border="1" style="width: 300px;">
		<tr>
			<%	
				String[] c = {"#FF0000", "#FF5E00", "#FFE400", "#1DDB16", "#0054FF"};
				int i = 0;
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
					i = i+1;		
				}
			%>
		</tr>
		<tr>
			<%
				rs2.beforeFirst(); //다시 처음으로 초기치 셋팅
				while(rs2.next()){
			%>
					<td><%=rs2.getString("menu")%></td>
			<%		
				}
			%>
		</tr>
	</table>
	
</body>
</html>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="DailyWrite_Java.*" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>Daily Write</title>
		<link rel="stylesheet" href="DailyWrite-Style.css">
	</head>
	<body>
<%
	request.setCharacterEncoding("utf-8");
	String userkey="";
	String reqlogin;
	
	try{
		if(session.getAttribute("User.key").toString().equals(null)==false){
			userkey = session.getAttribute("User.key").toString();
			
			if(userkey.equals("none")){
				reqlogin = "<script>alert('일치하는 회원 정보가 없습니다.');</script>";
				session.setAttribute("reqlogin", reqlogin);
				session.setAttribute("Login.key", "NO");
				response.sendRedirect("index.jsp");
			}
			else if(userkey.equals("failed")){
				reqlogin = "<script>alert('로그인에 실패하였습니다. 비밀번호를 확인하세요.');</script>";
				session.setAttribute("reqlogin", reqlogin);
				session.setAttribute("Login.key", "NO");
				response.sendRedirect("index.jsp");
			}
			else if(userkey.equals("NOT")){
				reqlogin = "<script>alert('로그인이 필요한 서비스입니다.');</script>";
				session.setAttribute("reqlogin", reqlogin);
				session.setAttribute("Login.key", "NO");
				response.sendRedirect("index.jsp");
			}
			else if (userkey.equals("regi")){
				response.sendRedirect("index.jsp");
			}
			else{
				// 해당 페이지에 머물게함 
			}
		}
		else{
			response.sendRedirect("index.jsp");
		}
	}catch(Exception e){
		System.out.println("DailyWrite-Main.jsp오류: "+e);
		response.sendRedirect("index.jsp");
	}
	
	Database db = Database.getInstance();
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null; 
	String sql = "";
	
	Member user = new Member();
	
	try{
		conn = db.getConnection();
		stmt = conn.createStatement();
		
	/* ===========================================================
	 * ==================== 사용자 정보 취하기 ========================
	 * ===========================================================	*/	
		
		sql = "SELECT * FROM MEMBER WHERE ID ='"
				+userkey+"';";
		System.out.println(sql);
		rs = stmt.executeQuery(sql);
		
		while(rs.next()){ //rs.next()가 없으면 Before start of result set ++ 한줄이라 if 문으로 처리도 가능
			user.setName(rs.getString("NAME"));
			user.setBirth(rs.getString("BIRTHDAY"));
			user.setEmail(rs.getString("EMAIL"));
			user.setAdmin(rs.getString("ADMIN"));
			user.setDate(rs.getString("DATE"));
		}
	}
	catch(Exception e){
		System.out.println("Db참조오류: "+e);
	}
	finally{
		try{
			if(rs!=null){
				rs.close();
			}
			if(stmt!=null){
				stmt.close();
			}
			if(conn!=null){
				conn.close();
			}
		}
		catch(Exception e){
			System.out.println("Conn.Close 오류: "+e);
		}	
	}
%>
		<div id="wrap">
			<jsp:include page="Header.jsp"></jsp:include>
			<jsp:include page="Header-Menu.jsp"></jsp:include>
			<div id="wbody">
				<div>
					<div class="condiv">
						<div class="conimg-big">
							<img src="./contentimage/notebook1.png">
						</div>
					</div>
					<hr class="shortLine">
					<span class="headlight-middle"><%=user.getName() %>님, 안녕하세요?</span>	
					<span class="headlight-sub-middle">오늘 하루는 어떠셨나요?</span>
					<hr class="shortLine">
				</div>
				<div class="condiv">
					<span class="conspan">
						오늘 하루를 생각해보고 <br>
						짧게 일기를 남겨보세요. <br>
						인상깊은 사진이 있다면 사진을 첨부해보세요.
					</span>
					<br>
					<ul class="St-conul">
							<li class="conli">
								<span class="conimg">
									<img src="./contentimage/logo-diary.png" class="conliimg">
								</span>
								<br>
								<span class="conspan-main" onclick="location.href='Paragraph-Write.jsp'">
									<b>일기 쓰기</b>
									<br>
									오늘 있었던 일을 기록하고 감정 상태를 남겨보세요.
								</span>
							</li>
							<li class="St-conliBetween"></li>
							<li class="conli">
								<span class="conimg">
									<img src="./contentimage/logo-chart.png" class="conliimg">
								</span>
								<br>
								<span class="conspan-main" onclick="location.href='Paragraph-Research.jsp'">
									<b>통계 보기</b>
									<br>
									당신의 사용기록을 확인해보세요. 당신의 경향성을 파악할 수 있어요.
								</span>
							</li>
							<li class="St-conliBetween"></li>
							<li class="conli">
								<span class="conimg">
									<img src="./contentimage/logo-list.png" class="conliimg">
								</span>
								<br>
								<span class="conspan-main"  onclick="location.href='Paragraph-List.jsp'">
									<b>일기보기</b>
									<br>
									당신이 작성한 일기를 확인해보세요. 최근 3주에 집중하기를 추천드려요.
								</span>
							</li>
						</ul>
						<hr class="shortLine">
						<span class="conspan">
							오늘의 당신도 행복했기를 진심으로 바라요.
						</span>
					<br><br>
				</div>
				<jsp:include page="Footer.jsp"></jsp:include>
			</div>
		</div>
	</body>
</html>
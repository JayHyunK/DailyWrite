<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="DailyWrite_Java.Member" %>
<%@ page import="DailyWrite_Java.Database" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>My Info</title>
		<link rel="stylesheet" href="DailyWrite-Style.css">
	</head>
	<body>
	<%
		request.setCharacterEncoding("utf-8");
		
		String uid="";
		
		try{
			uid = session.getAttribute("User.key").toString();
		}
		catch(Exception e){
			
		}
	/*	======================================================
		==================== 로그인 세션 확인 =====================
		====================================================== */	
		String reqlogin;

		try{
			if(session.getAttribute("User.key").toString().equals(null)==false){
				String userkey = session.getAttribute("User.key").toString();
				
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
		}
		catch(Exception e){
			System.out.println("로그인 세션 오류: "+e);
			response.sendRedirect("index.jsp");
		}	
		
		try{
			String checkinfo = session.getAttribute("Check.pw").toString();
			
			if(checkinfo.equals("NO")){
				session.removeAttribute("Check.pw");
				out.print("<script>alert('비밀번호가 일치하지 않습니다.')</script>");
			}
			else{
				session.removeAttribute("Check.pw");
				out.print("<script>alert('예기치 않은 오류가 발생하였습니다. 새로고침해주세요.')</script>");
			}
		}
		catch(Exception e){
			System.out.println("세션 참조 값 오류: "+e);
		}
		
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null; 
		
		Database db = Database.getInstance();
		String dbid = null;
		String dbname = null;
		boolean adminflag = false; 
		
		try{
			conn = db.getConnection();
			stmt = conn.createStatement();
			String sql;
			sql = db.getUSE_DB();
			stmt.execute(sql);
			
		/*	======================================================
			====================== 권한 확인 =======================
			====================================================== */	
				
			String userkey = session.getAttribute("User.key").toString();
			String adminkey = "MEMBER";
			
			sql = "SELECT ADMIN FROM MEMBER WHERE ID= '";
			sql += userkey+"';";
			rs = stmt.executeQuery(sql);
			
			while(rs.next()){
				adminkey = rs.getString("ADMIN");
			}
			
			if(adminkey.equals("MEMBER")){
				
			}
			else {
				adminflag= true;
			}
		}
		catch(Exception e){
			System.out.println("Paragraph-List.jsp 오류: "+e);
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
				<div class="formdiv TopObject">
					<div>
						<img src="./contentimage/main-logo-Text2.png" class="nomalimg">
					</div>
					<br>
					<form method="post" action="Member-Control.jsp">
						<input type="hidden" name="userId" value="<%=uid%>">
						<input type="text" name="userinfoPw" placeholder="비밀번호를 입력하세요." class="inputsize"> 
						<input type="hidden" name="flag" value="userinfo">
						<input type="submit" value="회원 정보 수정 및 탈퇴" class="input-submit">
					</form>
				</div>
				<div id="adminGo" class="formdiv">
					<div id="adminIndiv" style="width: 50%; margin: 0 auto; display: block;">
						<button id="delButton" onclick="location.href='http://localhost:8080/DailyWrite_Design/Admin-Management.jsp'">회원 관리 페이지</button>
					</div>
				</div>
			</div>
			<br><br>
			<jsp:include page="Footer.jsp"></jsp:include>
			<script>
				let adminGo = document.getElementById("adminGo");
				
				let adminflag = <%=adminflag %>;
				
				if(adminflag==true){
					adminGo.setAttribute("style", "display: block");
				}
				else{
					adminGo.setAttribute("style", "display: none");
				}
			</script>
		</div>
	</body>
</html>
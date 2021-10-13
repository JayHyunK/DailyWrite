<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>Login</title>
		<link rel="stylesheet" href="DailyWrite-Style.css">
	</head>
	<body>
	<%
		request.setCharacterEncoding("utf-8");
	
		try{	
			String userkey = session.getAttribute("User.key").toString();

			if(session.getAttribute("User.key").toString().equals(null)==false){
					
				if(userkey.equals("none")){
					out.print("<script>alert('일치하는 회원 정보가 없습니다.');</script>");
					session.removeAttribute("User.key");
				}
				else if(userkey.equals("failed")){
					out.print("<script>alert('로그인에 실패하였습니다. 비밀번호를 확인하세요.');</script>");
					session.removeAttribute("User.key");
				}
				else if(userkey.equals("regi")){
					session.removeAttribute("User.key");
				}
				else{
					response.sendRedirect("DailyWrite-Main.jsp");
				}
			}else{
				response.sendRedirect("DailyWrite-Main.jsp");
			}
		}
		catch(Exception e){
			System.out.println("login.jsp 오류: "+e);
		}
	%>
		<div id="wrap">
			<jsp:include page="Header.jsp"></jsp:include>
			<jsp:include page="Header-Menu.jsp"></jsp:include>
			<div id="wbody">
				<div id="login">
					<div>
						<img src="./contentimage/main-logo-Text2.png" class="nomalimg">
					</div>
					<br>
					<form method="post" action="Member-Control.jsp" name="frm" onsubmit="return check()">
						<input type="text" name="userId" placeholder="아이디" class="inputsize">
						<input type="password" name="userPw" placeholder="비밀번호" class="inputsize"> <!-- 눈모양 추가 -->
						<input type="hidden" name="flag" value="login" class="inputsize">
						<input type="submit" value="로그인" class="input-submit">
						<br>
					</form>
					<div id="loginbottom">
						<a href="Member-Register.jsp">회원 가입</a>
						<a href="Member-FindId.jsp">아이디 찾기</a>
						<a href="Member-FindPw.jsp">비밀번호 찾기</a>
					</div>
				</div>
				<div></div>
			</div>
			<jsp:include page="Footer.jsp"></jsp:include>
		</div>
		<script>
			function check(){
				if(document.frm.userId.value==0){
					alert("아이디를 입력하세요.");
					frm.userId.focus();
					return false
				}
				if(document.frm.userPw.value==""){
					alert("비밀번호를 입력하세요.");
					frm.userPw.focus();
					return false
				}
				return true;
			}
		</script>
	</body>
</html>
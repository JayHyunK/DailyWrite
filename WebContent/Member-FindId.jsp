<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>Find ID</title>
		<link rel="stylesheet" href="DailyWrite-Style.css">
	</head>
	<body>
	<%
		request.setCharacterEncoding("utf-8");
		
		try{
			String message = session.getAttribute("findId").toString();
			System.out.println(message);
			out.print("<script>alert('"+message+"');</script>");
		}
		catch(Exception e){
			System.out.println("세션 참조 오류: "+e);
		}
		session.removeAttribute("findId");
	
	%>
		<div id="wrap">
			<jsp:include page="Header.jsp"></jsp:include>
			<jsp:include page="Header-Menu.jsp"></jsp:include>
			<div id="wbody">
				<div id="findpwdiv">
					<div>
						<img src="./contentimage/main-logo-Text2.png" class="nomalimg">
					</div>
					<br>
					<form method="post" action="Member-Control.jsp" name="frm" onsubmit="return check()">
						<input type="text" name="userEmail" placeholder="가입 시 기입한 이메일을 입력하세요." class="inputsize"> 
						<input type="hidden" name="flag" value="findId">
						<input type="submit" value="아이디 찾기" class="input-submit">
					</form>
					<br>
				</div>
			</div>
			<jsp:include page="Footer.jsp"></jsp:include>
		</div>
		<script>
			function check(){
				if(document.frm.userEmail.value==0){
					alert("가입시 기입한 이메일을 입력하세요.");
					frm.userEmail.focus();
					return false
				}
				return true;
			}
		</script>
	</body>
</html>
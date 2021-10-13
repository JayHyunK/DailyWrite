<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>Find Password</title>
		<link rel="stylesheet" href="DailyWrite-Style.css">
	</head>
	<body>
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
						<input type="text" name="userId" placeholder="아이디" class="inputsize"> 
						<select name="pwQuestion" class="selectsize">
							<option>비밀번호 찾기 질문</option>
							<option>출신 초등학교는 어디입니까?</option>
							<option>아버지의 성함은 무엇입니까?</option>
							<option>어머니의 성함은 무엇입니까?</option>
							<option>당신의 보물 1호는 무엇입니까?</option>
							<option>제일 좋아하는 요리는 무엇입니까?</option>
						</select>
						<input type="text" name="pwAnswer" placeholder="질문의 답을 입력하세요." class="inputsize">
						<input type="hidden" name="flag" value="findPw"><br>
						<input type="submit" value="비밀번호 찾기" class="input-submit">
					</form>
					<br>
				</div>
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
				if(document.frm.pwQuestion.value=="비밀번호 찾기 질문"){
					alert("비밀번호 찾기 길문을 설정해주세요.");
					return false
				}
				re
				if(document.frm.pwAnswer.value==0){
					alert("비밀번호 찾기에 대한 답을 입력해주세요.");
					frm.pwAnswer.focus();
					return false
				}
				return true;
			}
		</script>
	</body>
</html>
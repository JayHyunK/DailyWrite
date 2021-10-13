<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>Sign Up</title>
		<link rel="stylesheet" href="DailyWrite-Style.css">
	</head>
	<body>
	<%
		request.setCharacterEncoding("utf-8");
	
		String id="";
		String name="";
		String birth="";
		String email="";
		String pwq="";
		String pwa="";
		String check="";
		
		try{
			check = request.getParameter("checkid");
			
			if(check.equals("")!=true){
				id = request.getParameter("userId");
				name = request.getParameter("useName");
				birth = request.getParameter("userBirth");
				email = request.getParameter("userEmail");
				pwq = request.getParameter("pwQuestion");
				pwa = request.getParameter("pwAnswer");
			
				if(check.equals("none")){
					%>
					<script>
						alert("사용이 가능한 아이디입니다.");
					</script>
					<%
				}
				else if(check.equals("already")){
					%>
					<script>
						alert("중복되는 아이디가 존재합니다.");
					</script>
					<%
				}
				check="";
			}
			else{
				
			}
		}
		catch(Exception e){
			System.out.println("리퀘스트 값 오류: "+e);
		}
	%>
		<div id="wrap">
			<jsp:include page="Header.jsp"></jsp:include>
			<jsp:include page="Header-Menu.jsp"></jsp:include>
			<div id="wbody">
				<div id="register">
					<div>
						<img src="./contentimage/main-logo-Text2.png" class="nomalimg">
					</div>
					<br>
					<form method="post" action="Member-Control.jsp" id="checkform" name="frm" onsubmit="return CheckForm()">
						<div id="regiid">
							<input type="text" name="userId" placeholder="아이디" value="<%=id %>" class="inputsize" id="FormId"> 
							<input type="button" id="checkidbtn" value="중복 체크">
						</div>
						<input type="password" name="userPw" placeholder="비밀번호" class="inputsize" class="inputsize" id="FormPw"> 
						<input type="password" name="userPwCheck" placeholder="비밀번호 확인" class="inputsize" id="FormPwC">
						<hr class="shortLine">
						
						<input type="text" name="userName" placeholder="이름을 입력하세요."  value="<%=name %>" class="inputsize">
						<addr title="생일을 입력해주세요"><input type="date" name="userBirth" value="<%=birth %>" class="inputsize"></addr>
						<input type="text" name="userEmail" placeholder="이메일을 입력하세요." value="<%=email %>" class="inputsize" id="FormEmail">
						<hr class="shortLine">
						
						<select name="pwQuestion" class="selectsize">
							<option>비밀번호 찾기 질문</option>
							<option>출신 초등학교는 어디입니까?</option>
							<option>아버지의 성함은 무엇입니까?</option>
							<option>어머니의 성함은 무엇입니까?</option>
							<option>당신의 보물 1호는 무엇입니까?</option>
							<option>제일 좋아하는 요리는 무엇입니까?</option>
						</select>
						<input type="text" name="pwAnswer" placeholder="질문의 답을 입력하세요." value="<%=pwa %>" class="inputsize">
						<input type="hidden" name="flag" value="register">
						<input type="submit" value="가입하기" class="input-submit">
					</form>
					<br>
				</div>
			</div>
			<jsp:include page="Footer.jsp"></jsp:include>
		</div>
		<script>
	//		
			let checkidbtn = document.getElementById("checkidbtn");
			let checkform = document.getElementById("checkform");
			
			checkidbtn.addEventListener("click", function check(){
				if(document.frm.userId.value==""){//frm 네임 안네 유저 아이디 네임의 밸류 
					alert("아이디를 입력해주세요.");
					document.frm.userId.focus();
					return
				}
				else{
					checkform.setAttribute("action", "Member-CheckId.jsp")
					checkform.submit();
				}
				
			});
		
			let option = document.getElementsByTagName("option");
			
			let reop = "";
			try{
				reop = "<%=pwq %>";
			}catch(e){
				console.log(e);
			}
			
			for(let i = 0; i < option.length; i++){
				if(reop==option[i].outerText){
					option[i].setAttribute("selected", "true");
				}
			}
			
			window.onkeydown = function() { // F5 막음, 잘못 눌러서 데이터 안날아가게
				var kcode = event.keyCode;
				if(kcode == 116) {
					event.returnValue = false;
				}
			}
			
			if(frm.userName.value="null"){
				frm.userName.value="";
			}
			
			
		// 적합성 검증 
			
		    
		    function CheckForm(){
			
		    	let CheckFormId = /^[A-Za-z]{1}[A-Za-z0-9]{5,19}$/;
				let CheckFormPassword = /^[A-Za-z0-9]{8,24}$/;
				let CheckFormEmail = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
				let FormId = document.getElementById("FormId");
				let FormPw = document.getElementById("FormPw");
				let FormPwC = document.getElementById("FormPwC");
				let FormEmail = document.getElementById("FormEmail");
				
				
			    if(!check(CheckFormId, FormId, "아이디는 6~20자의 영문 대소문자, 숫자로만 입력이 가능합니다.")){
			    	return false;
			    }
			    if(!check(CheckFormPassword, FormPw, "비밀번호는 8~24자의 영문 대소문자와 숫자로 입력해주세요.")){
			    	return false;
			    }
			    if(FormPw.value != FormPwC.value){
			    	alert("입력하신 비밀번호와 비밀번호 확인이 다릅니다. 다시 확인해 주세요.");
			    	frm.userPwCheck.value = "";
			    	frm.userPwCheck.focus();
			        return false;
			    }
			    if(FormEmail.value==""||FormEmail.value.length==0){
			    	alert("이메일을 입력해 주세요");
			    	FormEmail.focus();
			        return false;
			    }
			    if(!check(CheckFormEmail, FormEmail, "적합하지 않은 이메일 형식입니다.")) {
			    	return false;
			   	}
			  	if(frm.userName.value==""){
			  		alert("이름을 입력해 주세요");
			  		frm.userName.focus();
			        return false;
			  	}
			  	if(frm.pwQuestion.value=="비밀번호 찾기 질문"){
			  		alert("비밀번호 찾기 질문을 선택해주세요.");
			        return false;
			  	}
			  	if(frm.pwAnswer.value==""){
			  		alert("비밀번호 찾기 답을 입력해주세요.");
			        return false;
			  	}
		    }
		function check(constraint, element, message){
			if(constraint.test(element.value)) {
				return true;
			}
		    alert(message);
		    element.value = "";
		    element.focus();
		}
		</script>
	</body>
</html>
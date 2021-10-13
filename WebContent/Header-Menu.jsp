<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<!-- 모달 팝업처럼 띄우기 - 네이버 블로그 참조 -->
<%
	String oklogin = "none";
	String nologin = "inline=block";
	
	try{
		String loginstmt = session.getAttribute("Login.key").toString();
		
		if(loginstmt.equals("OK")){
			oklogin = "inline=block";
			nologin = "none";	
		}
		else{
			oklogin = "none";	
			nologin = "inline=block";
		}
	}
	catch(Exception e){
	
	}
	
	String name= "사용자";
	
	try{
		name=session.getAttribute("User.name").toString();
	}
	catch(Exception e){
		
	}
%>
<div id="menuback">
<div id="menu">
	<div id="menuheader">
		<div id="menuin">
			<div class="menuheader" style="display:<%=oklogin %>;">
				<div class="menuheadertxt">
					 <div style="margin-bottom: 0.5vw;">안녕하세요? <%=name %>님, </div>
					 <div>오늘하루는 어떠셨나요?</div>
				</div>
			</div>
			<div class="menuheader" style="display:<%=nologin %>;">
				<a href="Member-Login.jsp">
				<div class="menuheadertxt">
					 로그인 해주세요.
				</div>
				</a>
			</div>
			<hr class="normalLine" style="display:<%=oklogin %>;">
			<div class="menuline" style="display:<%=oklogin %>;"></div>
			<div id="menubar" style="display:<%=oklogin %>;">
				<ul id="menuicon">
					<li class="icon" id="logom">
						<a href="Member-Info.jsp">
							<img src="./icon/profile-icon.png" style="width:60%; display:block; margin: 0 auto; margin-bottom: 1vw; opacity: 0.8;">
							<span style="font-size:1.1vw; letter-spacing: -0.1vw;">
								회원관리
							</span>
						</a>
					</li>
					<li class="icon" id="txtresearch">
						<a href="Paragraph-Research.jsp">
							<img src="./icon/chart-icon.png" style="width:60%; display:block; margin: 0 auto; margin-bottom: 1vw; opacity: 0.8;">
							<span style="font-size:1.1vw; letter-spacing: -0.1vw;">
								통계
							</span>
						</a>
					</li>
					<li class="icon" id="txtlist">
						<a href="Paragraph-List.jsp">
							<img src="./icon/diary-icon.png" style="width:60%; display:block; margin: 0 auto; margin-bottom: 1vw; opacity: 0.8;">
							<span style="font-size:1.1vw; letter-spacing: -0.1vw;">
								내가 쓴 일기
							</span>
						</a>
					</li>
					<li class="icon" id="txtwrite">
						<a href="Paragraph-Write.jsp">
							<img src="./icon/write-icon.png" style="width:60%; display:block; margin: 0 auto; margin-bottom: 1vw; opacity: 0.8;">
							<span style="font-size:1.1vw; letter-spacing: -0.1vw;">
								일기 쓰기
							</span>
						</a>
					</li>
				</ul>
			</div>
			<hr class="normalLine">
			<a href="DailyWrite-Service.jsp"><div id="infodw">서비스 소개</div></a>
			<hr class="normalLine">
			</div>
		</div>
		<div id="menubody">
		
		</div>
		<div id="menufooter">
			<a href="Member-Login.jsp" style="display:<%=nologin %>;"><div style="display:<%=nologin %>;">로그인</div></a>
			<a href="Member-Register.jsp" style="display:<%=nologin %>;"><div style="display:<%=nologin %>;">회원가입</div></a>
			<div id="logoutbtn" style="display:<%=oklogin %>;">로그아웃</div>
			<a href="mailto:starlightsora@gmail.com"><div>개발자에게 문의하기</div></a>
		</div>
		<form method="post" action="Member-Control.jsp" id="logout" style="display:none;">
			<input type="hidden" name="flag" value="logout">
		</form>
	</div>
</div>
	<script>
	//
		let logoutform = document.getElementById("logout");
		let logoutbtn = document.getElementById("logoutbtn");
		
		logoutbtn.addEventListener("click",function(){
			logout.submit();
		});
	
	// ============================================================
	// ======================= menu 컨트롤 ==========================
	// ============================================================
		
		let menubtn = document.getElementById("hambergerMenu");
		let menuback = document.getElementById("menuback");
		let menu = document.getElementById("menu");
		let menuin = document.getElementById("menuin");
		let opacityEl = document.getElementsByClassName("input-submit");
		
		let menuflag = false; 
		
		menubtn.addEventListener("click", popmenu);
		menuback.addEventListener("click", popmenu);
		
	// 비동기 지연 - async/await, 
	
		async function popmenu(){
			if (menuflag == false){
				menuback.setAttribute("style", "visibility: visible;");
				menu.setAttribute("style", "visibility: visible;");
				menuin.setAttribute("style", "visibility: visible;");
				menu.setAttribute("class", "menuslidein");
				menuin.setAttribute("class", "slideinside");
				opacityFu();
				stickyFu()
				menuflag = true;
			}
			else{
				menu.setAttribute("class", "menuslideout");
				menuin.setAttribute("class", "slideoutside");
				menuin.setAttribute("style", "visibility: hidden;");
				await sleep(350);
				closemenu();
				opacityFu();
				stickyFu()
				menuflag = false;
			}
		};
		
		function closemenu(){
			menuback.setAttribute("style", "visibility: hidden;");
			menu.setAttribute("style", "visibility: hidden;");
		}
		
		function sleep(ms) {
			  return new Promise((r) => setTimeout(r, ms));
		}
		
	// ======================== 메뉴 누를시 오파시티 없음 =======================
		
		function opacityFu(){
			if (menuflag == false){
				for(let i = 0; i<opacityEl.length; i++){
					opacityEl[i].setAttribute("style", "opacity: 1;");
				}
			}
			else{
				for(let i = 0; i<opacityEl.length; i++){
					opacityEl[i].setAttribute("style", "opacity: 0.7;");
				}
			}
		}
	// ======================= 메뉴 누를시 스티기 없음 ========================
		
		
		function stickyFu(){
			let sticky = document.getElementById("txtmenu");
			if(sticky!=null){
				if (menuflag == false){
					sticky.setAttribute("style", "position: static;");
				}
				else{
					sticky.setAttribute("style", "position: sticky;");
				}
			}
		}
		
	</script>

<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<div id="headerBack">
<div id="header">
	<div class="headlayout">
		<a href="index.jsp">
			<div id="gohome" style="color:white;"><!-- 테스트용 스타일 -->
			</div>
		</a>
	</div>
	<div class="headlayout">
		<div id="headerbanner">
			
		</div>
	</div>
	<div class="headlayout">
		<div  id="hambergerMenu"><!-- 메뉴 -->
		</div >
		<div  id="musicNext" style="color:white;"><!-- 다음 음악 듣기 -->
		</div >
		<div id="musicButton" style="color:white;"><!-- 뮤직끄기/키기 -->
			<audio id="music" src="BackGroundMusic.mp3" hidden="true" loop autoplay></audio> 
		</div >
		<div  id="musicBefore" style="color:white;"><!-- 이전 음악 듣기 -->
		</div >
	</div>
</div>
<div id="header-botoom">
<div>
	
</div>
<div id="headText">
	Daily Write
</div>
<div>
	
</div>
</div>
	<script>
		
		let cookie; 
		
	// ============================================================
	// ================= 쿠키 생성 및 가져오기 함수 ======================
	// ============================================================	
		
		function setCookie(cookie_name, cookie_value, cookie_time) {
			var date = new Date();
			date.setTime(date.getTime() + (cookie_time)); //쿠키 만료 기한 설정함
			var expires = "expires="+ date.toUTCString();
			document.cookie = cookie_name + "=" + cookie_value + ";" + expires + ";path=/";
			} 
		
		function getCookie(cookie_name) {
			var name = cookie_name + "=";
			var decodedCookie = decodeURIComponent(document.cookie);
			var dco = decodedCookie.split(';');

			for(var i = 0; i <dco.length; i++) {
				var c = dco[i];
				while (c.charAt(0) == ' ') {
					c = c.substring(1);
				}
				if (c.indexOf(name) == 0) {
					return c.substring(name.length, c.length);
				}
			}
			return "";
		}
	 
		// ============================================================
		// =================== audio Music 컨트롤 =======================
		// ============================================================
			
			let mubtn = document.getElementById("musicButton");
			let mu = document.getElementById("music");
			let muflag = false;
			
			cookie = getCookie("playstate");
			
			if(cookie=='OK'){
				muflag = false;
				mubtn.setAttribute("style", "background-image: url(./icon/Music-pause.png);");
			}
			else if(cookie=='NO'){
				muflag = true;
				mubtn.setAttribute("style", "background-image: url(./icon/Music-paly.png);");
			}
			
			mubtn.addEventListener("click", musicplayer);
			
			function musicplayer(){
				if(muflag==false){
					pauseMusic();
					muflag=true;
				}
				else{
					playMusic();
					muflag=false;
				}
			}
			
			function playMusic() {
				setCookie("playstate", "OK", 60*60*24*1000);// 쿠키 혼선 있어서 기존 쿠키 지우고 셋 필요할 것으로 보임 
				mu.play();
				mubtn.setAttribute("style", "background-image: url(./icon/Music-pause.png);");
			}

			function pauseMusic() {
				setCookie("playstate", "NO", 60*60*24*1000);
				mu.pause();
				mubtn.setAttribute("style", "background-image: url(./icon/Music-paly.png);");
			}

			
		// ============================================================
		// =============== 음악 현재 정보 세션 저장 및 넘김 ===================
		// ============================================================
			
			let musicnow = document.getElementsByTagName("html")[0];
		
			let munn = mu.getAttribute("src");
			sessionStorage.setItem("musicName", munn);
			
			musicnow.addEventListener("click", nowMu);
			
			function nowMu(){
				let munow = mu.currentTime;
				munn = mu.getAttribute("src");
				
				setCookie("musicSec", munow);
				setCookie("musicName", munn);
				
				console.log(munow);
				console.log(munn)
			}
			
			// 세션 정보로 뮤직 데이터 정보 확인 > 해당 시점으로 실행
			// 쿠키로 음악 재생 여부 확인 
			let muname;
			let musec;
			
			try{
				muname = getCookie("musicName");
				musec = getCookie("musicSec");
				
				if(muname!="BackGroundMusic.mp3"&&muname!="BackGroundMusic2.mp3"&&muname!="BackGroundMusic3.mp3"){
					muname = "BackGroundMusic.mp3"
				}

			}
			catch(e){
				
			}
			if(muname!=null){
				cookie = getCookie("playstate");
				if(cookie=='OK'){
					mu.setAttribute("autoplay", "true");
				}else{
					mu.removeAttribute("autoplay");	
				}
				
				if(cookie!='OK'&&cookie!='NO'){
					mu.setAttribute("autoplay", "true");
				}
				if(muname!=null&&musec!=null){
					mu.setAttribute("src", muname);
					mu.currentTime= musec;
				}
			}
			else if(muname!=undefinde){
				mu.setAttribute("src", "BackGroundMusic.mp3");	
			}	
		// ============================================================
		// ====================== 다른 음악 듣기 ==========================
		// ============================================================
			
			let mun = document.getElementById("musicNext");
			let mub = document.getElementById("musicBefore");
			let muliflag = 1; 
			
			if(muname=="BackGroundMusic2.mp3"){
				muliflag = 2; 
			}else if(muname=="BackGroundMusic3.mp3"){
				muliflag = 3;
			}else if(muname=="BackGroundMusic.mp3"){
				muliflag = 1;
			}
				
			mun.addEventListener("click", musicnext);
		
			function musicnext(){
				if(muliflag==1){
					mu.setAttribute("src", "BackGroundMusic2.mp3");
					muliflag = 2;
					playMusic();
				}
				else if(muliflag==2){
					mu.setAttribute("src", "BackGroundMusic3.mp3");
					muliflag = 3;
					playMusic();
				}
				else if(muliflag==3){
					mu.setAttribute("src", "BackGroundMusic.mp3");
					muliflag = 1;
					playMusic();
				}
			}
			
			mub.addEventListener("click", musicbefore);
			
			function musicbefore(){
				if(muliflag==3){
					mu.setAttribute("src", "BackGroundMusic2.mp3");
					muliflag = 2;
					playMusic();
				}
				else if(muliflag==2){
					mu.setAttribute("src", "BackGroundMusic.mp3");
					muliflag = 1;
					playMusic();
				}
				else if(muliflag==1){
					mu.setAttribute("src", "BackGroundMusic3.mp3");
					muliflag = 3;
					playMusic();
				}
			}
			
			let title = document.getElementsByTagName("title")[0].innerHTML;
			let bannertext = document.getElementById("headText");
			
			bannertext.innerHTML = title;
	</script>
</div>
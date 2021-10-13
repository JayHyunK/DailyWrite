<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="DailyWrite_Java.*" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>Rewrite</title>
		<link rel="stylesheet" href="DailyWrite-Style.css">
	</head>
	<body>
<%
	request.setCharacterEncoding("utf-8");

/*	======================================================
	====================== SQL 설정 =======================
	====================================================== */	
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null; 
	
	Database db = Database.getInstance();
	String dbid = null;
	String dbname = null;
	
/*	======================================================
	=============== 자바에서 패러그래프 객체 생성 ================
	====================================================== */
	
	Paragraph fixing = new Paragraph();
	
	try{
		fixing.setNum(request.getParameter("num"));
		System.out.println(request.getParameter("num"));
	}
	catch(Exception e){
		System.out.println("글 고유키 확인 불가: "+e);
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
	}catch(Exception e){
		System.out.println("로그인 세션 오류: "+e);
		response.sendRedirect("index.jsp");
	}
	
/*	======================================================
	===================== DB 사용 =========================
	====================================================== */
	
	try{
		conn = db.getConnection();
		stmt = conn.createStatement();
		String sql;
		
		sql = db.getUSE_DB();
		stmt.execute(sql); // DB 사용 지정 
		
		sql = "SELECT * FROM PARAGRAPH WHERE NUM ='";
		sql += fixing.getNum()+"';";
		
		System.out.println(sql);
		
		rs = stmt.executeQuery(sql);
		
		while(rs.next()){
			fixing.setDate(rs.getString("NAME"));
			fixing.setTitle(rs.getString("TITLE"));
			fixing.setDate(rs.getString("DATE"));
			fixing.setContent(rs.getString("CONTENT"));
			fixing.setFile(rs.getString("FILE"));
			fixing.setEmotion(rs.getString("EMOTION"));
			System.out.println(fixing.getTitle());
		}
	}
	catch(Exception e){
		System.out.println("fix 오류: "+e);
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

/*	======================================================
	================ 업로드한 이미지 path 추출 =================
	====================================================== */	
	
	String imgpath = "";
	String imgtag = "";
	
	try{
		
		imgpath = session.getAttribute("User.image").toString();
		imgtag = "<img src='"+imgpath+"' style='width:80%; display:block; margin: 0 auto; margin-bottom: 1vw;'>";
		session.removeAttribute("User.image");
	}
	catch(Exception e){
		System.out.println("이미지 경로 참조 중 오류"+e);
	}

	System.out.println(fixing.getEmotion());
%>
	<div id="wrap">
			<jsp:include page="Header.jsp"></jsp:include>
			<jsp:include page="Header-Menu.jsp"></jsp:include>
			<div id="wbody">
				<div id="txtmenu">
					<div id="editorMenu"> 
						<button id="boldBtn">
							<b>B</b>
						</button> 
						<button id="italicBtn"> 
							<i>I</i> 
						</button> 
						<button id="underlineBtn"> 
							<u>U</u> 
						</button> 
						<button id="strikeBtn"> 
							<s>S</s> 
						</button> 
						<button id="olBtn"> 
							OL 
						</button> 
						<button id="ulBtn"> 
							UL 
						</button> 
						<button id="imgBtn"> 
							IMG 
						</button> 
						</div>
					</div>
				<div id="txtwrap">
					<div id="txtbody">
						<div>
							<form method="post" action="Paragraph-Control.jsp" id="paragraph">
								<input type="text" name="title" placeholder="제목을 입력해주세요." id="editorTitle" value="<%=fixing.getTitle() %>"><br>
								<hr>
								<div id="editor" contenteditable="true">
									<%=imgtag %>
									<%=fixing.getContent() %>
								</div>
								<br>
								<div id="emotionstate">
									<div class="emotionchoosebtn">
										<img src="./icon/happy.png" class="emoIcon" style="width:80%;">
										<div>행복해요</div>
									</div>
									<div class="emotionchoosebtn">
										<img src="./icon/fun.png" class="emoIcon" style="width:80%;">
										<div>즐거워요</div>
									</div>
									<div class="emotionchoosebtn">
										<img src="./icon/exciting.png" class="emoIcon" style="width:80%;">
										<div>신나요</div>
									</div>
									<div class="emotionchoosebtn">
										<img src="./icon/sosoColor.png" class="emoIcon" style="width:80%;">
										<div>그저 그래요</div>
									</div>
									<div class="emotionchoosebtn">
										<img src="./icon/worried.png" class="emoIcon" style="width:80%;">
										<div>걱정되요</div>
									</div>
									<div class="emotionchoosebtn">
										<img src="./icon/upset.png" class="emoIcon" style="width:80%;">
										<div>짜증나요</div>
									</div>
									<div class="emotionchoosebtn">
										<img src="./icon/sad.png" class="emoIcon" style="width:80%;">
										<div>슬퍼요</div>
									</div>
									<div class="emotionchoosebtn">
										<img src="./icon/angry.png" class="emoIcon" style="width:80%;">
										<div>화가나요</div>
									</div>
									<div class="emotionchoosebtn">
										<img src="./icon/trashcan.png" class="emoIcon" style="width:80%;">
										<div>감정쓰레기통</div>
									</div>
								</div>
								<input type="hidden" name="emotion" id="emotion" value="<%=fixing.getEmotion()%>">
								<input type="text" name="content" class="hideinput" id="textin" style="display:none;">
								<div id="txtfootbar">
									<div id="gotoList">글목록</div>
									<div></div>
									<div id="submittxt">작성하기</div>
								</div>
								<input type="hidden" name="flag" value="fix">
								<input type="hidden" name="num" value="<%=fixing.getNum() %>">
							</form>
							<form method="post" action="Paragraph-ImageUpload.jsp" id="imgupload" enctype="multipart/form-data">
								<input type="file" name="imgFile" class="hideinput" id="imgSelector" accept="img/*">
							</form>
						</div>
					</div>
				</div>
			</div>
			<jsp:include page="Footer.jsp"></jsp:include>
		</div>
		<script>
		// =======================================================================
		// ============================== 글 편집기 ==============================
		// =======================================================================
			
			let editor = document.getElementById('editor'); 
			let boldBtn = document.getElementById('boldBtn'); 
			let italicBtn = document.getElementById('italicBtn'); 
			let underlineBtn = document.getElementById('underlineBtn'); 
			let strikeBtn = document.getElementById('strikeBtn'); 
			let olBtn = document.getElementById('olBtn'); 
			let ulBtn = document.getElementById('ulBtn'); 
			let imgBtn = document.getElementById('imgBtn'); 
			let imgSelector = document.getElementById('imgSelector');
			let imgupload = document.getElementById("imgupload");
			
			boldBtn.addEventListener('click', function () { 
				setStyle("bold");
				
				let btstmtflag = boldBtn.getAttribute("style");
				if(btstmtflag==null){
					boldBtn.setAttribute("style", "background-color:#fbf3ff");
				}
				else{
					boldBtn.removeAttribute("style");
				}
			}); 
			
			italicBtn.addEventListener('click', function () { 
				setStyle('italic'); 
				
				let btstmtflag = italicBtn.getAttribute("style");
				if(btstmtflag==null){
					italicBtn.setAttribute("style", "background-color:#fbf3ff");
				}
				else{
					italicBtn.removeAttribute("style");
				}
			}); 
			
			underlineBtn.addEventListener('click', function () { 
				setStyle('underline'); 
				
				let btstmtflag = underlineBtn.getAttribute("style");
				if(btstmtflag==null){
					underlineBtn.setAttribute("style", "background-color:#fbf3ff");
				}
				else{
					underlineBtn.removeAttribute("style");
				}
			}); 
			
			strikeBtn.addEventListener('click', function () { 
				setStyle('strikeThrough') 
				
				let btstmtflag = strikeBtn.getAttribute("style");
				if(btstmtflag==null){
					strikeBtn.setAttribute("style", "background-color:#fbf3ff");
				}
				else{
					strikeBtn.removeAttribute("style");
				}
			}); 
			
			olBtn.addEventListener('click', function () { 
				setStyle('insertOrderedList'); 
				
				let btstmtflag = olBtn.getAttribute("style");
				if(btstmtflag==null){
					olBtn.setAttribute("style", "background-color:#fbf3ff");
				}
				else{
					olBtn.removeAttribute("style");
				}
			}); 
			
			ulBtn.addEventListener('click', function () { 
				setStyle('insertUnorderedList'); 
				
				let btstmtflag = ulBtn.getAttribute("style");
				if(btstmtflag==null){
					ulBtn.setAttribute("style", "background-color:#fbf3ff");
				}
				else{
					ulBtn.removeAttribute("style");
				}
			}); 
			
			imgBtn.addEventListener('click', function () { 
				imgSelector.click();
				
				let btstmtflag = imgBtn.getAttribute("style");
				if(btstmtflag==null){
					imgBtn.setAttribute("style", "background-color:#fbf3ff");
				}
				else{
					imgBtn.removeAttribute("style");
				}
			}); 
			
			imgSelector.addEventListener('change', function (e) { 
				let files = e.target.files; 
				
				if (!!files) { 
					insertImageDate(files[0]); 
					console.log(files[0])
					} 
				}
			); 
			
			function insertImageDate(file) { 
				let reader = new FileReader(); 
				reader.addEventListener('load', function (e) { 
					focusEditor(); 
					document.execCommand('insertImage', false, `${reader.result}`); 
					}
				); 
				reader.readAsDataURL(file); 
			}
			
			function setStyle(style, btn) { 
				document.execCommand(style); 

				focusEditor(); 
			} 
			
			
			// 버튼 클릭 시 에디터가 포커스를 잃기 때문에 다시 에디터에 포커스를 해줌 
			
			function focusEditor() { 
				editor.focus({
					preventScroll: true
					}
				); 
			}
			
		// =======================================================================
		// ============================== 이미지 업로드 ==============================
		// =======================================================================	
			
			imgSelector.addEventListener("change", function(){
				let tv = document.getElementById("editorTitle").value;
				let ev = document.getElementById("emotion").value;
				
				sessionStorage.setItem("Temporary.title", tv);
				sessionStorage.setItem("Temporary.emotion", ev);
				sessionStorage.setItem("Temporary.text", editor.innerHTML);
				
				imgupload.submit();
				
			});
		// ============================ 업로드후 데이터 유지 ===============================
			
			try{
				let temptitle = sessionStorage.getItem("Temporary.title");
				let tempemotion = sessionStorage.getItem("Temporary.emotion");
				let temptext = sessionStorage.getItem("Temporary.text");
		
				if(temptext!=null){
					editor.innerHTML+=temptext; 
				}
				if(tempemotion!=null){
					document.getElementById("emotion").value = tempemotion;
				}
				if(temptext!=null){
					document.getElementById("editorTitle").value = temptext;
				}
				
				sessionStorage.removeItem("Temporary.title");
				sessionStorage.removeItem("Temporary.emotion");
				sessionStorage.removeItem("Temporary.text");
			}
			catch(e){
				console.log(e);
			}

		// =======================================================================
		// ============================== 감정상태 체크 ==============================
		// =======================================================================
		
			let emobtn = document.getElementsByClassName("emotionchoosebtn");
			let emo = document.getElementById("emotion");
			let emoIcon = document.getElementsByClassName("emoIcon");
			
			emobtn[0].addEventListener("click", function(){
				emo.setAttribute("value", "happy");
				changeEmo();
				emoIcon[0].setAttribute("src", "./icon/happyColor.png");
				console.log(emo);
			});
			emobtn[1].addEventListener("click", function(){
				emo.setAttribute("value", "fun");
				changeEmo();
				emoIcon[1].setAttribute("src", "./icon/funColor.png");
				console.log(emo);
			});
			emobtn[2].addEventListener("click", function(){
				emo.setAttribute("value", "exciting");
				changeEmo();
				emoIcon[2].setAttribute("src", "./icon/excitingColor.png");
				console.log(emo);
			});
			emobtn[3].addEventListener("click", function(){
				emo.setAttribute("value", "soso");
				changeEmo();
				emoIcon[3].setAttribute("src", "./icon/sosoColor.png");
				console.log(emo);
			});
			emobtn[4].addEventListener("click", function(){
				emo.setAttribute("value", "worried");
				changeEmo();
				emoIcon[4].setAttribute("src", "./icon/worriedColor.png");
				console.log(emo);
			});
			emobtn[5].addEventListener("click", function(){
				emo.setAttribute("value", "upset");
				changeEmo();
				emoIcon[5].setAttribute("src", "./icon/upsetColor.png");
				console.log(emo);
			});
			emobtn[6].addEventListener("click", function(){
				emo.setAttribute("value", "sad");
				changeEmo();
				emoIcon[6].setAttribute("src", "./icon/sadColor.png");
				console.log(emo);
			});
			emobtn[7].addEventListener("click", function(){
				emo.setAttribute("value", "angry");
				changeEmo();
				emoIcon[7].setAttribute("src", "./icon/angryColor.png");
				console.log(emo);
			});
			emobtn[8].addEventListener("click", function(){
				emo.setAttribute("value", "trashcan");
				changeEmo();
				emoIcon[8].setAttribute("src", "./icon/trashcanColor.png");
				console.log(emo);
			});
			// 선택  > Radio 로 연동해서 check 일때 모양 바뀌도록 설정 필요. 혹은 해당 태그 안에 안보이는 Radio 태그 만들고 모양만 바꿈 
			
		
			function changeEmo(){
				emoIcon[0].setAttribute("src", "./icon/happy.png");
				emoIcon[1].setAttribute("src", "./icon/fun.png");
				emoIcon[2].setAttribute("src", "./icon/exciting.png");
				emoIcon[3].setAttribute("src", "./icon/soso.png");
				emoIcon[4].setAttribute("src", "./icon/worried.png");
				emoIcon[5].setAttribute("src", "./icon/upset.png");
				emoIcon[6].setAttribute("src", "./icon/sad.png");
				emoIcon[7].setAttribute("src", "./icon/angry.png");
				emoIcon[8].setAttribute("src", "./icon/trashcan.png");
			}
			
			let tempemo = document.getElementById("emotion").value;
			
			if(tempemo=="happy"){
				emo.setAttribute("value", "happy");
				changeEmo();
				emoIcon[0].setAttribute("src", "./icon/happyColor.png");
			}
			else if(tempemo=="fun"){
				emo.setAttribute("value", "fun");
				changeEmo();
				emoIcon[1].setAttribute("src", "./icon/funColor.png");
			}
			else if(tempemo=="exciting"){
				emo.setAttribute("value", "exciting");
				changeEmo();
				emoIcon[2].setAttribute("src", "./icon/excitingColor.png");
			}
			else if(tempemo=="soso"){
				emo.setAttribute("value", "soso");
				changeEmo();
				emoIcon[3].setAttribute("src", "./icon/sosoColor.png");
			}
			else if(tempemo=="worried"){
				emo.setAttribute("value", "worried");
				changeEmo();
				emoIcon[4].setAttribute("src", "./icon/worriedColor.png");
			}
			else if(tempemo=="upset"){
				emo.setAttribute("value", "upset");
				changeEmo();
				emoIcon[5].setAttribute("src", "./icon/upsetColor.png");
			}
			else if(tempemo=="sad"){
				emo.setAttribute("value", "sad");
				changeEmo();
				emoIcon[6].setAttribute("src", "./icon/sadColor.png");
			}
			else if(tempemo=="angry"){
				emo.setAttribute("value", "angry");
				changeEmo();
				emoIcon[7].setAttribute("src", "./icon/angryColor.png");
			}
			else if(tempemo=="trashcan"){
				emo.setAttribute("value", "trashcan");
				changeEmo();
				emoIcon[8].setAttribute("src", "./icon/trashcanColor.png");
			}
			
				
				
		// =======================================================================
		// ============================== submit ==============================
		// =======================================================================
			
			let formtxt = document.getElementById("paragraph");
			let submit = document.getElementById("submittxt");
			
			submit.addEventListener("click", function(){
				let textin = document.getElementById("textin");
				textin.setAttribute("value", editor.innerHTML);
				formtxt.submit();
			});
			
		// =======================================================================
		// ============================== 글목록 ==============================
		// =======================================================================	
			
			let gotolist = document.getElementById("gotoList");
		
			gotolist.addEventListener("click", function(){
				location.href = "http://localhost:8080/DailyWrite_Design/Paragraph-List.jsp";
			});
		

		</script>	
	</body>
</html>
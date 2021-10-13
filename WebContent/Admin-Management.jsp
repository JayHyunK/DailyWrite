<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="DailyWrite_Java.*" %>
<%@ page import="java.text.*" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<link rel="stylesheet" href="DailyWrite-Style.css">
		<title>Management</title> 
	</head>
	<body>
		<% 
			request.setCharacterEncoding("utf-8");
			
			String memberList="";
			String memberDiv = "";
			String pagelist = "";
			double paragnum=0;
			double pagenum=1;
			String dateAlignFlag = "DESC"; // 날짜 따라 정렬 기능 
			
			System.out.println(dateAlignFlag);
			
		/*	======================================================
			============ Request 현재 보는 페이지넘버 설정 ==============
			====================================================== */
			
			int pgNow = 1;
			double pgMax = 10;
			double pgTen = 10;
			double pgChapNow = 1;
			double pgChapFlag; 
			boolean pgnn=true;;//페이지 글 수가 딱 70개이고, 페이지 수가 10개일때 다음 버튼이 표시되면 안됨 그릴 위한 변수 
			
			try{	
				pgMax = Double.parseDouble(request.getParameter("pgMax"));	
			}
			catch(Exception e){
				
			}
			try{
				pgNow = Integer.parseInt(request.getParameter("pgNow"));	
			}
			catch(Exception e){
				
			}
			try{
				pgChapNow = Double.parseDouble(request.getParameter("pgChapNow"));	
			}
			catch(Exception e){
				
			}
			
			try{
				dateAlignFlag = request.getParameter("dateAlign");
				//리퀘스트가 일어나지 않았음에도 데이터를 null로 저장하고 예외처리 안함 > 이에 따라 별도로 if 조건 지정 
				
				if(dateAlignFlag==null){
					dateAlignFlag = "DESC";
				}
			}
			catch(Exception e){
				
			}
			System.out.println(dateAlignFlag);
		/*	=======================================================
			======================= 검색 설정 =======================
			======================================================= */	

			Member user = new Member();
			
		/*	=======================================================
			======================= 검색 설정 =======================
			======================================================= */
			
			String searchWord = ""; 
			String searchRange = ""; 

			try{
				searchWord=request.getParameter("searchWord");	
			}
			catch(Exception e){
				
			}
			try{
				searchRange=request.getParameter("searchRange");	
			}
			catch(Exception e){
				
			}

			
		/*	=======================================================
			======================= SQL 설정 =======================
			======================================================= */
			
			Connection conn = null;
			Statement stmt = null;
			ResultSet rs = null; 
			
			Database db = Database.getInstance();
			String dbid = null;
			String dbname = null;
			String uid = "";
			String reqlogin;
			
		/*	======================================================
			==================== 로그인 세션 확인 =====================
			====================================================== */	
			
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
					else{
						// 해당 페이지에 머물게함 
					}
				}
				else{
					response.sendRedirect("index.jsp");
				}
			}catch(Exception e){
				System.out.println("Paragraph-List.jsp 오류: "+e);
				response.sendRedirect("index.jsp");
			}
			
		
		//
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
					reqlogin = "<script>alert('접근 권한이 없습니다.');</script>";
					session.setAttribute("reqlogin", reqlogin);
					response.sendRedirect("index.jsp");
				}		
			
			
			/*	======================================================
				===================== 회원 수 확인 =====================
				====================================================== */	
				
				
				if(searchWord==null||searchWord.equals("null")){
					sql = "SELECT COUNT(*) FROM MEMBER";
				}
				else if(searchWord!=null&&searchRange==null){
					sql = "SELECT COUNT(*) FROM MEMBER WHERE ID LIKE '%";
					sql += searchWord;
					sql += "%' or NAME LIKE '%";
					sql += searchWord;
					sql += "%'";
				}
				else if(searchWord!=null&&(searchRange.equals("ID-NAME")==true)){
					sql = "SELECT COUNT(*) FROM MEMBER WHERE ID LIKE '%";
					sql += searchWord;
					sql += "%' or NAME LIKE '%";
					sql += searchWord;
					sql += "%'";
				}
				else if(searchWord!=null&&(searchRange.equals("ID-NAME")==false)){
					sql = "SELECT COUNT(*) FROM MEMBER WHERE ";
					sql += searchRange;
					sql += " LIKE '%";
					sql += searchWord;
					sql += "%'";
				}
				
				sql+= ";";
				
				System.out.println(sql);
				rs = stmt.executeQuery(sql);
				
				while(rs.next()){
					paragnum = Integer.parseInt(rs.getString("COUNT(*)"));
				}
				if(paragnum>pgMax){
					pagenum = Math.ceil(paragnum/pgMax);
				}
				
				
				
			/*	======================================================
				============== 게시글 수에 따라 필터 수대로 나눔 ==============
				====================================================== */	
				
				pgChapFlag = pgChapNow*pgTen;
			
				try{
					for(int i = 1; i<=pgChapFlag; i++){
						if(pagenum>=i){//Pagenum을 변수로 잡고 태그 수를 조절
							if(i>(pgChapNow-1)*pgTen){
								String pagestr = "<div class='pagelist' onclick='pageNumSelect("+i+")'>"+i+"</div>";
								pagelist+= pagestr ;
							}							
						}
					}
					
					if (pagenum==1||pagenum==0){
						pagelist = "";
					}
					
					if(paragnum<=(pgMax*pgChapFlag)){
						pgnn = false;
					}
						
						
				}
				catch(Exception e){
					System.out.println("pgChapFlag 오류");
				}

			/*	======================================================
				===================== DB 사용 =========================
				====================================================== */
				
				if(searchWord==null||searchWord.equals("null")){
					sql = "SELECT * FROM MEMBER";
				}
				else if(searchWord!=null&&searchRange==null){
					sql = "SELECT * FROM MEMBER WHERE ID LIKE '%";
					sql += searchWord;
					sql += "%' or NAME LIKE '%";
					sql += searchWord;
					sql += "%')";
				}
				else if(searchWord!=null&&(searchRange.equals("ID-NAME")==true)){
					sql = "SELECT * FROM MEMBER WHERE ID LIKE '%";
					sql += searchWord;
					sql += "%' or NAME LIKE '%";
					sql += searchWord;
					sql += "%'";
				}
				else if(searchWord!=null&&(searchRange.equals("ID-NAME")==false)){
					sql = "SELECT * FROM MEMBER WHERE ";
					sql += searchRange;
					sql += " LIKE '%";
					sql += searchWord;
					sql += "%'";
				}
			
			
		
				if(dateAlignFlag.equals("DESC")){
					sql += " ORDER BY DATE DESC;";
				}
				else if(dateAlignFlag.equals("ASC")){
					sql += " ORDER BY DATE ASC;";
				}
				else{
					sql += ";";
				}
				
				System.out.println(sql);
				rs = stmt.executeQuery(sql);
				
				int pageflag= 1;
				int vwflag = 0;
				
				try{
					while(rs.next()&&pageflag<(pgMax*pgNow)){
						user.setId(rs.getString("ID"));
						user.setName(rs.getString("NAME"));
						user.setPw(rs.getString("PASSWORD"));
						user.setEmail(rs.getString("EMAIL"));
						user.setDate(rs.getString("DATE"));
						
						memberDiv = "<div class='memberList' onclick='viewFix("+vwflag+")'>"
								+"<div class='memberId'>"+user.getId()
								+"</div><div class='memberName'>"+user.getName()
								+"</div><div class='memberDate'>"+user.getDate()+"</div>"
								+"</div>"
								+"<div class='memberFix'>"
								+"<form method='post' action='Member-Control.jsp' class='memberFixLayout'>"
								+"<div class='memberFixLayout1'>수정할 비밀번호: </div>"
								+"<input name='FixPw' type='text' value='"+user.getPw()+"' class='memberFixInput memberFixLayout2'>"
								+"<div class='memberFixLayout1'>수정할 이름: </div>"
								+"<input name='FixName' type='text' value='"+user.getName()+"' class='memberFixInput memberFixLayout2'>"
								+"<div class='memberFixLayout1'>수정할 이메일: </div>"
								+"<input name='FixEmail' type='text' value='"+user.getEmail()+"' class='memberFixInput memberFixLayout2''>"
								+"<input type='hidden' name='flag' value='Admin-Fix'>"
								+"<input type='hidden' name='FixId' value='"+user.getId()+"'>"
								+"<div class='memberFixLayout3'></div>"
								+"<button type='button' class='memberFixSubmit memberFixLayout5' onclick='deleteMember("+vwflag+")'>삭제하기</button>"
								+"<div class='memberFixLayout4'></div>"
								+"<input type='submit' value='수정하기' class='memberFixSubmit memberFixLayout5'>"
								+"</form>"
								+"</div>"
								+"<hr>";
						vwflag++;
								
						if(pgNow>=2){
							if(pgMax*(pgNow-1)>=pageflag){
								memberDiv="";
							}
						}
						memberList += memberDiv;
						pageflag++;
						
						if(pagenum==0){
							memberList = "게시글이 없습니다.";
						}
					}
				}
				catch(Exception e){
					System.out.println("게시글 불러오기 오류: "+e);
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
				<div id="listlayout">
					<div id="listlayoutHeader">
					</div>
					<div id="listLayoutBody">
						<div class="memberList">
							<div class="memberId">
								<b>아이디</b>
							</div>
							<div class="memberName">
								<b>이름</b>
							</div>
							<div class="memberDate" id="dateAl"><b>가입일</b>
								<span style="display:none;" id="dateASC">
									<addr title="오래된 글부터 정렬합니다.">ㅤ△</addr>
								</span>
								<span style="display:inline-block;" id="dateDESC">
									<addr title="최근에 작성된 글부터 정렬합니다.">ㅤ▽</addr>
								</span>
							</div>
						</div>
						<hr>
						
						<div class="txtlistBack">
							<%=memberList %>
						</div>
					</div>
					<div id="listLayoutFooter">
						<div class="ButtonRegular" onclick="location.href='DailyWrite-Main.jsp'">메인</div>
						<div></div>
						<div>
							<select id="searchSelect">
								<option value="ID-NAME" class="Fsearch">아이디+이름</option>
								<option value="ID" class="Fsearch">아이디</option>
								<option value="NAME" class="Fsearch">이름</option>
								<option value="EMAIL" class="Fsearch">이메일</option>
							</select>
							<input type="text" id="searchText" value="<%=searchWord %>">
							<button onclick="ftPgMax()" id="searchBtn">검색</button>
						</div>
						<div></div>
						<div>
							<form method="post" action="Admin-Management.jsp" id="formFilterPgMax">
							<select name="pgMax" id="filter" onchange="ftPgMax()">
								<option value="10" class="pageFilter">10개 단위로 보기</option>
								<option value="20" class="pageFilter">20개 단위로 보기</option>
								<option value="25" class="pageFilter">25개 단위로 보기</option>
								<option value="50" class="pageFilter">50개 단위로 보기</option>
							</select>
							<input type="hidden" name="pgNow" value="1" id="pgNowInput">
							<input type="hidden" name="pgChapNow" value="1" id="pgChapNowInput">
							<input type="hidden" name="dateAlign" value="<%=dateAlignFlag %>" id="DateAlignInput">
							<input type="hidden" name="searchWord" value="<%=searchWord %>" id="searchWord">
							<input type="hidden" name="searchRange" value="<%=searchRange %>" id="searchRange">
							</form>
						</div>	
					</div>
					<div id="pageNum">
						<div class="pageNumDiv">
							<div id="beforPage" onclick="BeforeChaper()">◁ 이전</div>
						</div>
						<div class="pageNumDiv">
						</div>
						<div id="pageNumIn">
							<div>
							<%=pagelist %>
							</div>
						</div>
						<div class="pageNumDiv">
						</div>
						<div class="pageNumDiv">
							<div id="nextPage" Style="display:none;" onclick="NextChaper()">다음 ▷</div>
						</div>
					</div>
					</div>
					<form method="post" action="Member-Control.jsp" id="delform">
						<input type="hidden" name="flag" value="Admin-Delete">
						<input type="hidden" name="userId" value="" id="delUserId">
					</form>
				</div>
				<jsp:include page="Footer.jsp"></jsp:include>
			</div>
		<script>
			let formFilterPgMax = document.getElementById("formFilterPgMax");
			let memberList = document.getElementsByClassName("memberList");
			let pageFilter = document.getElementsByClassName("pageFilter");
			
			let nextPage = document.getElementById("nextPage");
			let beforPage = document.getElementById("beforPage");
			let pgNowInput = document.getElementById("pgNowInput");
			let pgChapNowInput = document.getElementById("pgChapNowInput");
			let DateAlignInput = document.getElementById("DateAlignInput");
			let dateASC = document.getElementById("dateASC");
			let dateDESC = document.getElementById("dateDESC");
			let dateAl = document.getElementById("dateAl");
				
			let searchWord = document.getElementById("searchWord");
			let searchRange = document.getElementById("searchRange");
			let Fsearch = document.getElementsByClassName("Fsearch");
			
			let delform = document.getElementById("delform");
			let delUserId = document.getElementById("delUserId");
				
		//======================================================
		//==================== 회원정보 보기 =======================
		//======================================================	
				
			let memberFix = document.getElementsByClassName("memberFix");
				
			let viewFlag=[];
				
			for(let i=0; i <memberList.length; i++){
				viewFlag.push(false);
			}
			
			function viewFix(viewNumber){
				if(viewFlag[viewNumber]==false){
					memberFix[viewNumber].setAttribute("style", "display: block");
					viewFlag[viewNumber]=true;	
				}
				else{
					console.log(memberFix[viewNumber]);
					memberFix[viewNumber].setAttribute("style", "display: none");
					viewFlag[viewNumber]=false;	
				}
			}
			
			function deleteMember(num){
				let memberIds = document.getElementsByClassName("memberId");
				let fnum = num+1
				delUserId.value = memberIds[fnum].innerHTML;
				console.log(delUserId);
				delform.submit();
			}
			
		//======================================================
		//================= 필터가 변경되는 경우 =====================
		//======================================================		
				
			function ftPgMax(){
				pgNowInput.setAttribute("value", "1");
				pgChapNowInput.setAttribute("value", "1");
					
				let searchSelect = document.getElementById("searchSelect").value;
				let searchText = document.getElementById("searchText").value;
				
				searchWord.setAttribute("value", searchText);
				searchRange.setAttribute("value", searchSelect);
				
				formFilterPgMax.submit();
			}
			
		//======================================================
		//================ 페이지 넘버에 따른 이동 ====================
		//======================================================	
				
			function pageNumSelect(num){
				pgNowInput.setAttribute("value", num);
				formFilterPgMax.submit();
			}
			
		//======================================================
		//================= 현재 필터 상태 설정 =====================
		//======================================================	
				
			try{
				let a = <%=pgMax%> ;
				for(let i = 0; i<pageFilter.length; i++){
					if(pageFilter[i].value==a){
						pageFilter[i].setAttribute("selected", "true");
					}
				}
			}catch(e){
				console.log(e);
			}
				
				
			try{
				let a = "<%=searchRange %>";
				for(let i = 0; i<Fsearch.length; i++){
					if(Fsearch[i].value==a){
						Fsearch[i].setAttribute("selected", "true");
					}
				}
			}
			catch(e){
				console.log(e);
			}
				
				
		// 자바에서 검색 단어 값을 null로 반환 - 리퀘스트로 인항 항상성 문제 >> 때문에 자바 연산 뒤에 처리하느 자바스크립트로 값을 초기화시킴
			let checkin = document.getElementById("searchText");
				
			if(checkin.value=="null"){
				checkin.setAttribute("value", "");		
			}
		//======================================================
		//================ 페이지가 10개 이상인 경우===================
		//======================================================
		//페이지 표시 DIV를 클래스 네임으로 가져와서, 현재 페이지에 몇개 있는지로 판단, 및 특정 값 밸류 추출 >> 이전 및 다음 구현 	
				
			let pagenumflag = document.getElementsByClassName("pagelist");
			let pgnn = <%=pgnn%>;
			let pagenumLastvalue; 
				
			for(let i = 0; i<pagenumflag.length; i++){
				pagenumLastvalue = pagenumflag[i].innerHTML;
			}
				
			if(pagenumflag.length>9){
				nextPage.setAttribute("style", "display: block;");
			}
			else{
				nextPage.setAttribute("style", "display: none;");
			}
			if(pagenumLastvalue>10){
					beforPage.setAttribute("style", "display: block;");
			}
			else{
				beforPage.setAttribute("style", "display: none;");
			}
				
			if(pgnn==false){
				nextPage.setAttribute("style", "display: none;");
				// 전체 페이지 수 <=필터*현재 페이지 최대 값 
				// 즉 전페 페이지 수가 현재 페이지 최대값 *글 수 보다 적으면 다음이 표시될 이유가 없음
			}
				
		//======================================================
		//=============== 페이지가 10개 단위로 표기 ===================
		//======================================================	

			pgChapNowInput.setAttribute("value", "<%=pgChapNow%>");
			let pgChapFlag = pgChapNowInput.getAttribute("value");
			let pgChapStart;
				
			function NextChaper(){
				pgChapFlag++;
				pgChapNowInput.setAttribute("value", pgChapFlag);
				pgChapStart = ((pgChapFlag-1)*10)+1;
				pgNowInput.setAttribute("value", pgChapStart);
				formFilterPgMax.submit();
			}
			function BeforeChaper(){
				pgChapFlag--;
				pgChapNowInput.setAttribute("value", pgChapFlag);
				pgChapNext = ((pgChapStart-1)*10)+1;
				pgNowInput.setAttribute("value", pgChapNext);
				formFilterPgMax.submit();
			}
				
		//======================================================
		//===================== 차순 정렬 =========================
		//======================================================		
				
			if(DateAlignInput.value=="ASC"){
				dateDESC.setAttribute("style", "display: none;");
				dateASC.setAttribute("style", "display: inline-block;");
			}
			else{
				dateDESC.setAttribute("style", "display: inline-block;");
				dateASC.setAttribute("style", "display: none;");
			}
			
		//======================================================
		//=================== 차순 정렬 변경 =======================
		//======================================================	
				
			dateAl.addEventListener("click", function(){
				if(DateAlignInput.value=="ASC"){
					DateAlignInput.setAttribute("value", "DESC");
				}else{
					DateAlignInput.setAttribute("value", "ASC");
				}
				formFilterPgMax.submit();
			});
		</script>
	</body>
</html>
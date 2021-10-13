<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="DailyWrite_Java.Member" %>
<%@ page import="DailyWrite_Java.Database" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>Modify My Info</title>
		<link rel="stylesheet" href="DailyWrite-Style.css">
	</head>
	<body>
	<%
		request.setCharacterEncoding("utf-8");
		
		String uid = "";
		
		try{
			uid=session.getAttribute("User.key").toString();
		}
		catch(Exception e){
			System.out.println("세션 오류: "+e);
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
		==================== SQL 설정 =====================
		====================================================== */
		
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null; 
		
		Database db = Database.getInstance();
		
	/*	======================================================
		================= 자바에서 멤버 객체 생성 ==================
		====================================================== */
		
		Member user = new Member();

	/*	======================================================
		======================= 접속 설정 ========================
		====================================================== */
		
		String userkey=null;
		
		
		try{
			conn = db.getConnection();
			stmt = conn.createStatement();
			String sql;
			
		/*	======================================================
			================= DB 생성 및 테이블 생성 ==================
			====================================================== */
			
			sql = db.getCREATE_DB_DAILYWRITE();
			stmt.execute(sql);
			
			sql = db.getUSE_DB();
			stmt.execute(sql);
			
			sql = db.getCREATE_TB_MEMBER();
			stmt.execute(sql);
			
			sql = db.getCREATE_TB_PARAGRAPH();
			stmt.execute(sql);
			
			sql = db.getCREATE_TB_MEDIA();
			stmt.execute(sql);
			
		/*	======================================================
			================== DB의 데이터 추출 ===================
			====================================================== */
			
			sql = "SELECT * FROM MEMBER WHERE ID ='"
					+uid+"';";
			System.out.println(sql);
			rs = stmt.executeQuery(sql);
			
			while(rs.next()){ //rs.next()가 없으면 Before start of result set
				user.setId(rs.getString("ID"));
				user.setName(rs.getString("NAME"));
				user.setBirth(rs.getString("BIRTHDAY"));
				user.setEmail(rs.getString("EMAIL"));
				user.setPwquestion(rs.getString("PW_QUESTION"));
				user.setPwanswer(rs.getString("PW_ANSWER"));
				user.setAdmin(rs.getString("ADMIN"));
				user.setDate(rs.getString("DATE"));
			}
		}
		catch(Exception e){
			System.out.println("오류 발생: Member-FixInfo.jsp: "+e);
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
					<input type="text" name="userId" value="<%=user.getId()%>" class="inputsize" readonly>
					
					<input type="password" name="userPw" placeholder="비밀번호" class="inputsize"> 
					<input type="password" name="userPwCheck" placeholder="비밀번호 확인" class="inputsize">  
					<hr class="shortLine">
					
					<input type="text" name="useName" placeholder="이름을 입력하세요." class="inputsize" value="<%=user.getName() %>">
					<input type="text" name="userBirth" placeholder="생일을 입력하세요." class="inputsize" value="<%=user.getBirth() %>">
					<input type="text" name="userEmail" placeholder="이메일을 입력하세요." class="inputsize" value="<%=user.getEmail() %>">
					<hr class="shortLine">
					
					<select name="pwQuestion" class="selectsize">
						<option>비밀번호 찾기 질문</option>
						<option>당신의 출신 초등학교는 어디입니까?</option>
						<option>아버지의 성함은 무엇입니까?</option>
						<option>어머니의 성함은 무엇입니까?</option>
						<option>당신의 보물 1호는 무엇입니까?</option>
						<option>당신이 제일 좋아하는 요리는 무엇입니까?</option>
					</select>
					<input type="text" name="pwAnswer" placeholder="질문의 답을 입력하세요." class="inputsize" value="<%=user.getPwanswer() %>">
					<input type="hidden" name="flag" value="fixMember">
					<input type="submit" value="수정하기" class="input-submit">
				</form>
			</div>
				<div class="formdiv BottomObject">
					<form method="post" action="Member-Control.jsp" id="delform">
						<input type="hidden" name="Id" value="<%=uid%>" class="inputsize">
						<input type="hidden" name="flag" value="deleteMember" class="inputsize">
						<input type="button" value="탈퇴하기" id="delButton">
					</form>
				</div>
			</div>
		<jsp:include page="Footer.jsp"></jsp:include>
	</div>
		<script>
			let pq = "<%=user.getPwquestion() %>";
			let option = document.getElementsByTagName("option");
			
            console.log(pq);
            console.log(option);
            
            for(let i = 0; i < option.length; i++){
				if(option[i].outerText==pq){
					option[i].setAttribute("selected", "true");
					console.log(option[i]);
				}
			}
            
       
            let delbtn = document.getElementById("delButton");
            let delform = document.getElementById("delform");
            
         	delbtn.addEventListener("click", function(){
         		let con = confirm("탈퇴하실 경우, 해당 아이디로 작성된 일기를 비롯한 모든 데이터가 삭제되며 복구가 불가능합니다. 회원을 탈퇴하시겠습니다?");
         		
         		if(con==true){
         			delform.submit();
         		}
         		else{
         				
         		}
         	});   
            

		</script>
	</body>
</html>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="DailyWrite_Java.Member" %>
<%@ page import="DailyWrite_Java.Database" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
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
	 *	==================== Request 설정 =====================
	 *	====================================================== */
	 
		
		request.setCharacterEncoding("utf-8");
		
		user.setId(request.getParameter("userId"));
		user.setPw(request.getParameter("userPw"));
		user.setName(request.getParameter("useName"));
		user.setBirth(request.getParameter("userBirth"));
		user.setEmail(request.getParameter("userEmail"));
		user.setPwquestion(request.getParameter("pwQuestion"));
		user.setPwanswer(request.getParameter("pwAnswer"));
		
		String flag = request.getParameter("flag");

	/*	======================================================
		======================= 접속 설정 ========================
		====================================================== */
		
		String dbid=null;
		String checkid="";
		
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
			
			sql = "SELECT ID FROM MEMBER WHERE ID ='"
					+user.getId()+"';";
			System.out.println(sql);
			rs = stmt.executeQuery(sql);
			
			while(rs.next()){ //rs.next()가 없으면 Before start of result set
				dbid=rs.getString("ID");
			}
			
			
		/*	======================================================
			====================== 중복 확인 =======================
			====================================================== */
			
			if(user.getId().equals(dbid)){
				checkid="already";
				
			}
			else{
				checkid="none";
			}
		}
		catch(Exception e){
			System.out.println("예외 발생: "+e);
		}
		conn.close();
		
%>
<form method="post" action="Member-Register.jsp" id="checkform" style="visibility:hidden;">
	<input type="text" name="userId" placeholder="아이디" class="forminfo" value="<%=user.getId() %>">
	<input type="button" id="checkidbtn" value="중복 체크">
	<input type="text" name="useName" placeholder="이름을 입력하세요." class="forminfo" value="<%=user.getName() %>"><br>
	<input type="text" name="userBirth" placeholder="생일을 입력하세요." class="forminfo" value="<%=user.getBirth() %>"><br>
	<input type="text" name="userEmail" placeholder="이메일을 입력하세요." class="forminfo" value="<%=user.getEmail() %>"><br>
	<input type="text" name="pwQuestion" value="<%=user.getPwquestion() %>">
	<input type="text" name="pwAnswer" placeholder="질문의 답을 입력하세요." class="forminfo" value="<%=user.getPwanswer() %>">
	<input type="text" name="checkid" value="<%=checkid %>">
	<input type="submit" value="중복체크">
</form>
<script>
	let checkform = document.getElementById("checkform");

	checkform.submit();
</script>
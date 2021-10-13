<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="DailyWrite_Java.Member" %>
<%@ page import="DailyWrite_Java.Database" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
	/*	======================================================
		====================== SQL 설정 =======================
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
		user.setName(request.getParameter("userName"));
		user.setBirth(request.getParameter("userBirth"));
		user.setEmail(request.getParameter("userEmail"));
		user.setPwquestion(request.getParameter("pwQuestion"));
		user.setPwanswer(request.getParameter("pwAnswer"));
		
		String flag = request.getParameter("flag");

	/*	======================================================
		====================== 접속 설정 ========================
		====================================================== */
		
		String dbid=null;
		String dbpw=null;
		String dbname=null;
		String dbbirth=null;
		String dbemail=null;
		String dbpwq = null;
		String dbpwa = null;
		String dbadmin = null;
		String dbdate = null;
		String userkey=null;
		String resend = "DailyWrite-Main.jsp";
		
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
			=================== DB의 데이터 추출 =====================
			====================================================== */
			
			sql = "SELECT * FROM MEMBER WHERE ID ='"
					+user.getId()+"';";
			System.out.println(sql);
			rs = stmt.executeQuery(sql);
			
			while(rs.next()){ //rs.next()가 없으면 Before start of result set ++ 한줄이라 if 문으로 처리도 가능
				dbid=rs.getString("ID");
				dbpw=rs.getString("PASSWORD");
				dbname=rs.getString("NAME");
				dbbirth=rs.getString("BIRTHDAY");
				dbemail=rs.getString("EMAIL");
				dbpwq=rs.getString("PW_QUESTION");
				dbpwa=rs.getString("PW_ANSWER");
				dbadmin=rs.getString("ADMIN");
				dbdate=rs.getString("DATE");
				
			}
			
		/*	======================================================
			====================== 로그인 설정 =======================
			====================================================== */
			
			if(flag.equals("login")){
				
				if(user.getId().equals(dbid)&&user.getPw().equals(dbpw)){
					userkey = user.getId();
					session.setAttribute("User.key", userkey);
					session.setAttribute("Login.key", "OK");
					session.setAttribute("User.name", dbname);
					String a = session.getAttribute("User.name").toString();
					System.out.println(a);
				}
				else if(user.getId().equals(dbid)==false){
					session.setAttribute("User.key", "none");
					String a = session.getAttribute("User.key").toString();
					System.out.println(a);
				}
				else if(user.getId().equals(dbid)==true&&user.getPw().equals(dbpw)==false){
					session.setAttribute("User.key", "failed");
					String a = session.getAttribute("User.key").toString();
					System.out.println(a);
				}
			}
			
		/*	======================================================
			======================= 회원가입 ========================
			====================================================== */
				
			if(flag.equals("register")){
				SimpleDateFormat format = new SimpleDateFormat ( "yyyy-MM-dd HH:mm:ss");
						
				String udate = format.format (System.currentTimeMillis());
				
				sql = "INSERT INTO MEMBER (ID, PASSWORD, NAME, BIRTHDAY, EMAIL, PW_QUESTION, PW_ANSWER, DATE, ADMIN) VALUES (";
				sql += "'"+user.getId()+"', ";
				sql += "'"+user.getPw()+"', ";
				sql += "'"+user.getName()+"', ";
				sql += "'"+user.getBirth()+"', ";
				sql += "'"+user.getEmail()+"', ";
				sql += "'"+user.getPwquestion()+"', ";
				sql += "'"+user.getPwanswer()+"', ";
				sql += "'"+udate+"', ";
				sql += "'MEMBER"+"');";
				
				System.out.println("register: "+sql);
				stmt.execute(sql);
				
				session.setAttribute("User.key", "regi");
			}	
			
		/*	======================================================
			===================== 비밀번호 찾기 ======================
			====================================================== */
				
			if(flag.equals("findPw")){
				//https://shxrecord.tistory.com/168
				
				if(user.getId().equals(dbid)&&user.getPwanswer().equals(dbpwa)){
					
					String chpw = ""; 
					char ch;
					int bf;
					
					//새로운 PW 설정의 난수 처리> 랜덤으로 값 할당 
					for(int i = 0; i < 9; i++){
						bf = (int)((Math.random()*3));
						
						if(bf==0){
							ch = (char)((Math.random()*26)+97); 
							chpw += ch;
						}
						else if(bf==1){
							ch = (char)((Math.random()*26)+65); 
							chpw += ch;
						}
						else{
							int num = (int)((Math.random()*10));
							chpw += num;
						}
					}
					
					sql = "UPDATE MEMBER SET PASSWORD='";
					sql += chpw+"' ";
					sql += "WHERE ID = '";
					sql += user.getId()+"';";
					System.out.println(sql);
					stmt.executeUpdate(sql);
					
					session.setAttribute("PwFindPW", chpw);
					session.setAttribute("PwFindID", user.getId());
					session.setAttribute("PwFindName", user.getName());
					session.setAttribute("PwFindEM", user.getEmail());
					
					String a = session.getAttribute("PwFindID").toString();
					System.out.println(a);
				}
				else if(user.getId().equals(dbid)){
					session.setAttribute("PwFind", "findpwfailed");
					String a = session.getAttribute("PwFind").toString();
					System.out.println(a);
				}
				else{
					session.setAttribute("PwFind", "findpwidnone");
					String a = session.getAttribute("PwFind").toString();
					System.out.println(a);
				}
				// 결과 세션에 따라 전송 후 정보 처리 진행 
			}	
		
	/*	======================================================
		===================== 유저정보관리 =======================
		====================================================== */		
		
		if(flag.equals("userinfo")){
			String userinfoPw = request.getParameter("userinfoPw");
			
			if(userinfoPw.equals(dbpw)){
				resend = "Member-FixInfo.jsp";
			}
			else{
				resend = "Member-Info.jsp";
				session.setAttribute("Check.pw","NO");
			}
		}
			
	/*	======================================================
		===================== 회원정보수정 =======================
		====================================================== */
			
		if(flag.equals("fixMember")){
			
			sql = "UPDATE MEMBER SET PASSWORD='";
			sql += user.getPw()+"', ";
			sql += "NAME='";
			sql += user.getName()+"', ";
			sql += "EMAIL='";
			sql += user.getEmail()+"', ";
			sql += "BIRTHDAY='";
			sql += user.getBirth()+"', ";
			sql += "PW_QUESTION='";
			sql += user.getPwquestion()+"', ";
			sql += "PW_ANSWER='";
			sql += user.getPwanswer()+"' ";
			sql += "WHERE ID='";
			sql += user.getId()+"';";
				
			System.out.println("fixMember: "+sql);
			stmt.execute(sql);
		}
	/*	======================================================
		================== 회원정보수정- 관리자 ====================
		====================================================== */
		
		if(flag.equals("Admin-Fix")){
			
			String FixId = request.getParameter("FixId");
			String FixPw = request.getParameter("FixPw");
			String FixName = request.getParameter("FixName");
			String FixEmail = request.getParameter("FixEmail");
			
			
			sql = "UPDATE MEMBER SET PASSWORD='";
			sql += FixPw+"', ";
			sql += "NAME='";
			sql += FixName+"', ";
			sql += "EMAIL='";
			sql += FixEmail+"' ";
			sql += "WHERE ID='";
			sql += FixId+"';";
				
			System.out.println("Admin-Fix: "+sql);
			stmt.execute(sql);
		}	
	
	/*	======================================================
		===================== 아이디 찾기 =======================
		====================================================== */
		
		if(flag.equals("findId")){
			sql = "SELECT ID FROM MEMBER WHERE EMAIL ='"
					+user.getEmail()+"';";
			System.out.println(sql);
			rs = stmt.executeQuery(sql);
			String fdid="초기값입니다.";
			String msg="";
			
			while(rs.next()){
					fdid=rs.getString("ID");
			}
				
			if(fdid.equals("초기값입니다.")){
				msg = "해당 이메일로 가입된 아이디가 존재하지 않습니다. 이메일 철자를 재차 확인해보세요.";
				session.setAttribute("findId", msg);
			}
			else{
				msg = "해당 이메일로 가입된 아이디는 "+fdid+"입니다. 다수의 아이디가 존재할 경우 가장 최근에 가입한 ID만 표시됩니다.";
				session.setAttribute("findId", msg);
			}
		}	
		
	/*	======================================================
		======================== 탈퇴 =========================
		====================================================== */
		
		if(flag.equals("deleteMember")){
		
			sql = "DELETE FROM MEMBER WHERE ID='";
			sql += dbid+"';";
			System.out.println("Delete: "+sql);
			stmt.execute(sql);
			
			sql = "DELETE FROM PARAGRAPH WHERE ID='";
			sql += dbid+"';";
			System.out.println("DeletePARA: "+sql);
			stmt.execute(sql);
			
			session.removeAttribute("User.key");
			session.removeAttribute("User.name");
			session.removeAttribute("Login.key");
		}	
	/*	======================================================
		======================== 탈퇴 =========================
		====================================================== */
		
		if(flag.equals("Admin-Delete")){
		
			sql = "DELETE FROM MEMBER WHERE ID='";
			sql += dbid+"';";
			System.out.println("Delete: "+sql);
			stmt.execute(sql);
			
			sql = "DELETE FROM PARAGRAPH WHERE ID='";
			sql += dbid+"';";
			System.out.println("DeletePARA: "+sql);
			stmt.execute(sql);
		}
	
	/*	======================================================
		======================= 로그아웃 ========================
		====================================================== */
		
		if(flag.equals("logout")){
			session.removeAttribute("User.key");
			session.removeAttribute("User.name");
			session.removeAttribute("Login.key");
		}	
	}
	catch(Exception e){
		System.out.println("예외 발생: "+e);
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
		===================== resend 설정 ======================
		====================================================== */		
	
		if(flag.equals("logout")){
			resend = "DailyWrite-Main.jsp";
		}
		else if(flag.equals("login")){
			resend = "Member-Login.jsp";
		}
		else if(flag.equals("findPw")){
			resend = "Member-FindPw-SendEmail.jsp";
		}
		else if(flag.equals("findId")){
			resend = "Member-FindId.jsp";
		}
		else if(flag.equals("fixMember")){
			resend = "Member-FixInfo.jsp";
		}
		else if(flag.equals("Admin-Fix")){
			resend = "Admin-Management.jsp";
		}
		else if(flag.equals("Admin-Delete")){
			resend = "Admin-Management.jsp";
		}
		
		response.sendRedirect(resend);
%>
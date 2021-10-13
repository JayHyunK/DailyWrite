<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="DailyWrite_Java.*" %>
<%@ page import="java.sql.*" %>
<%@ page import= "javax.mail.*"%>
<%@ page import= "javax.mail.internet.*"%>
<%@ page import="java.util.*"%>

<%
// SSL 처리가 안된 경우 메일 발송이 실패함, 반드시 처리 진행할 것

	request.setCharacterEncoding("utf-8");

/*	======================================================
	==================== SQL 설정 =====================
	====================================================== */
	 
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null; 
	
	Database db = Database.getInstance();
	String sqlid = db.getId();
	String sqlpw = db.getPw();
	String sqlurl = db.getUrl();
	
/*	======================================================
	================= 자바에서 멤버 객체 생성 ==================
	====================================================== */
	
	Member user = new Member();

/*	======================================================
	======================= db 설정 ========================
	====================================================== */
		
	String dbid=null;
	String dbpw=null;
	String dbname=null;
	String dbemail=null;
	
/*	======================================================
	==================== smtp 접속 설정 =====================
	====================================================== */
	
	
	//String host = "smtp.naver.com";
	String host = "smtp.gmail.com";
	// SMTP 서버 정보를 설정한다. 
	Properties prop = new Properties(); 
	prop.put("mail.smtp.host", host); 
	prop.put("mail.smtp.port", 587); 
	prop.put("mail.smtp.starttls.enable", "true");
	prop.put("mail.smtp.auth", "true"); 
	prop.put("mail.smtp.ssl.enable", "false"); //ssl : true,
	//prop.put("mail.smtp.ssl.trust", host); 
	//javax.net.ssl.SSLException: Unrecognized SSL message, plaintext connection
	//prop.put("mail.smtp.socketFactory.fallback", "true"); // Should be true
	
	Authenticator auth = new MailAuth();	
	Session se = Session.getDefaultInstance(prop, auth);

/*	==================================================
	============== 메일 발송 정보 데이터 ===================
	===================================================*/
	String mail_id = "programmer.jonghyun";
	String uid="";
	try{
		uid = session.getAttribute("PwFindID").toString();
	} 	
	catch(Exception e){
		e.printStackTrace();
		out.println("<script>alert('가입된 정보가 없습니다. 재차 확인해주세요. ');history.back();</script>");
	}
	
	try { 
		conn = db.getConnection();
		stmt = conn.createStatement();
		
		String sql;
		
		sql = db.getUSE_DB();
		stmt.execute(sql);
		
	/*	======================================================
		================== DB의 데이터 추출 ===================
		====================================================== */
		
		sql = "SELECT * FROM MEMBER WHERE ID ='"
				+uid+"';";
		System.out.println(sql);
		
		rs = stmt.executeQuery(sql);
		
		
		while(rs.next()){ //rs.next()가 없으면 Before start of result set
			dbid=rs.getString("ID");
			dbpw=rs.getString("PASSWORD");
			dbname=rs.getString("NAME");
			dbemail=rs.getString("EMAIL");
		}
	}catch(Exception e){
		e.printStackTrace();
	}
	
	/*	======================================================
		================== 이메일 내욜 및 제목 ===================
		====================================================== */	
		
		String subjectEmail = "안녕하세요?"+dbname+"님, 비밀번호를 재설정하였습니다. 로그인을 시도해주세요.";
		String content = "안녕하세요? 당신을 위한 작은 일기장, Daily Write입니다.\n사용하시는 아이디 "+uid+" 로 로그인이 어려워 문의하신 내용을 확인하였습니다.\n"+
						"\n로그인이 가능하도록 비밀번호를 ["+dbpw+"]로 변경하였으니, 해당 비밀번호로 로그인하시고 보안을 위해 '비밀번호 변경'을 부탁드립니다.\n"+
						"\n감사합니다. DailyWrite 드림. ";
		
	/*	======================================================
		================== 이메일 내욜 및 제목 ===================
		====================================================== */	
		
	try{
		MimeMessage msg = new MimeMessage(se);
		
		msg.setFrom(new InternetAddress(mail_id, "관리자"));
		//Address from = new InternetAddress(fromEmail); 
		//ms.setFrom(from); // 보내는 사람
		
		msg.setRecipient(Message.RecipientType.TO, new InternetAddress(dbemail));
		//Address to = new InternetAddress(dbemail);
		
		msg.setSubject(subjectEmail); // 제목
		msg.setText(content);// 내용
		
		Transport.send(msg);
		System.out.println("이메일 전송 성공");
	}
	
	catch(Exception e){
		e.printStackTrace();
		out.println("<script>alert('Send Mail Failed..');history.back();</script>");
		// 오류 발생시 뒤로 돌아가도록
	    return;
	}
	conn.close();
	
	response.sendRedirect("Member-Login.jsp");
%>
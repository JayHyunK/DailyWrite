<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="DailyWrite_Java.*" %>
<%@ page import="java.text.*" %>
<%
/*	======================================================
	==================== SQL 설정 =====================
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
	
	Paragraph writing = new Paragraph();
	String res="";
		
/*	======================================================
 *	==================== Request 설정 =====================
 *	====================================================== */
					
	request.setCharacterEncoding("utf-8");
	String flag="";
	
	try{
		writing.setTitle(request.getParameter("title"));
		writing.setContent(request.getParameter("content"));
		writing.setEmotion(request.getParameter("emotion"));
		writing.setId(session.getAttribute("User.key").toString());
	
		flag = request.getParameter("flag");
	}
	catch(Exception e){
		System.out.println("리퀘스트- 글 오류: "+e);
	}
	String uid = writing.getId();
	
	try{
		writing.setNum(request.getParameter("num"));
		//num은 따로 수취해아함 > 사용하는 곳이 fix 및 delete 뿐인데 fix는 별도 페이지에서 진행 
	}
	catch(Exception e){
		System.out.println("번호 넘버 리퀘스트 오류: "+e);
	}
	

/*	======================================================
	======================= 접속 설정 ========================
	====================================================== */
	
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
		==================== DB 아이디 추출 =====================
		====================================================== */
		
		sql = "SELECT ID, NAME FROM MEMBER WHERE ID ='"
					+uid+"';";
		System.out.println(sql);
		rs = stmt.executeQuery(sql);
		
		while(rs.next()){
			dbid=rs.getString("ID");
			writing.setName(rs.getString("Name"));
		}
		
		System.out.println("dbid: "+dbid);
		
	/*	======================================================
		================= Request 값에 따른 처리 ==================
		====================================================== */	
		
		if(uid.equals(dbid)){// 세션 정보와 아이디 정보 불일치할 경우, 조회 불가 
			
			if(flag.equals("write")){
				
				SimpleDateFormat format = new SimpleDateFormat ( "yyyy-MM-dd HH:mm:ss");
				
				writing.setDate(format.format (System.currentTimeMillis()));
				
				sql = "INSERT INTO PARAGRAPH (ID, NAME, TITLE, DATE, CONTENT, EMOTION, FILE, VIEW ) VALUES (";
				sql += "'"+writing.getId()+"', ";
				sql += "'"+writing.getName()+"', ";
				sql += "'"+writing.getTitle()+"', ";
				sql += "'"+writing.getDate()+"', ";
				sql += "'"+writing.getContent()+"', ";
				sql += "'"+writing.getEmotion()+"', ";
				sql += "'"+writing.getFile()+"', ";
				sql += "'1');";
				
				System.out.println("write: "+sql);
				stmt.execute(sql);
				
				res = "Paragraph-List.jsp";
			}
		
			if(flag.equals("fix")){
				System.out.println("con: "+writing.getContent());
				
				sql = "UPDATE PARAGRAPH SET TITLE='";
				sql += writing.getTitle()+"', ";
				sql += "CONTENT='";
				sql += writing.getContent()+"', ";
				sql += "EMOTION='";
				sql += writing.getEmotion()+"' ";
				sql += "WHERE NUM='";
				sql += writing.getNum()+"';";
			
				stmt.executeUpdate(sql);
				System.out.println("fixpara: "+ sql);
				res = "Paragraph-List.jsp";
			}
			
			if(flag.equals("delete")){
			
				sql = "DELETE FROM PARAGRAPH WHERE NUM= '";
				sql += writing.getNum()+"';";
				
				System.out.println("delete: "+sql);
				stmt.executeUpdate(sql);
				res = "Paragraph-List.jsp";
			}
			
			response.sendRedirect(res);
		}
		else{
			System.out.println("세션 정보 만료");
			out.println("<script>alert('세션 정보가 만료되었습니다.');history.back();</script>");
			session.setAttribute("User.key", null);
		}
	}
	catch(Exception e){
		
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
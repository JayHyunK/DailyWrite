<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="DailyWrite_Java.*" %>
<%@ page import="java.text.*" %>
<!DOCTYPE html>
<html>
	<head> 
		<meta charset="utf-8">
		<title>Read</title>
		<link rel="stylesheet" href="DailyWrite-Style.css">
	</head>
	<body>
<%
	request.setCharacterEncoding("utf-8");
	String myemo="";
	String textNum="";	

	try{
		textNum = request.getParameter("num");	
	}
	catch(Exception e){
		System.out.println("리퀘스트값 오류"+e);
	}

	
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
	
	Paragraph reading = new Paragraph();

	reading.setNum(textNum);

	try{
		String uid = session.getAttribute("User.key").toString();
	}
	catch(Exception e){
		response.sendRedirect("index.jsp");
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
	

	try{
		conn = db.getConnection();
		stmt = conn.createStatement();
		
		String sql;
		sql = db.getUSE_DB();
		stmt.execute(sql);

	/*	======================================================
		===================== DB 사용 =========================
		====================================================== */
		
		sql = "SELECT * FROM PARAGRAPH WHERE NUM ='";
		sql += reading.getNum()+"';";
		
		rs = stmt.executeQuery(sql);
		
		while(rs.next()){
			reading.setName(rs.getString("NAME"));
			reading.setTitle(rs.getString("TITLE"));
			reading.setDate(rs.getString("DATE"));
			reading.setContent(rs.getString("CONTENT"));
			reading.setFile(rs.getString("FILE"));
			reading.setEmotion(rs.getString("EMOTION"));
		}
		if(reading.getEmotion().equals("happy")){
			myemo="행복한 ";
		}
		else if(reading.getEmotion().equals("fun")){
			myemo="즐거운 ";
		}
		else if(reading.getEmotion().equals("exciting")){
			myemo="신이난 ";
		}
		else if(reading.getEmotion().equals("soso")){
			myemo="그저 그런 기분인 ";
		}
		else if(reading.getEmotion().equals("worried")){
			myemo="걱정으로 불안한 ";
		}
		else if(reading.getEmotion().equals("upset")){
			myemo="짜증난 ";
		}
		else if(reading.getEmotion().equals("sad")){
			myemo="슬픈 ";
		}
		else if(reading.getEmotion().equals("angry")){
			myemo="화가난 ";
		}
		else if(reading.getEmotion().equals("trashcan")){
			myemo="감정이 복잡한 ";
		}
	}
	catch(Exception e){
		System.out.println("Paragraph-Viewer.jsp: "+e);
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
				<div id="textViewContent">
					<div id="textV">
						<div id="textVhead">
							<div id="textVheadlight"><%=reading.getTitle() %></div>
							<div id="textVheadSub">
								<div><%=myemo %><%=reading.getName() %></div>
								<div></div>
								<div id="textVheadDate"><%=reading.getDate() %></div>
							</div>
						</div>
						<div id="textVbody">
							<div><%=reading.getContent() %></div>
						</div>
						<div id="textVfooter">
							<div id="DeleteButton" class="tvfflex">
								삭제
							</div>
							<div>
							</div>
							<div id="FixButton" class="tvfflex">
								수정
							</div>
							<div class="tvfflex">
								<a href="Paragraph-List.jsp"><div>글목록</div></a>
							</div>
							<div class="tvfflex">
								<a href="Paragraph-Write.jsp"><div>글쓰기</div></a>
							</div>
						</div>
					</div>
				</div>	
			</div>
			<form method="get" action="Paragraph-Fix.jsp" id="FormFix">
				<input type="hidden" name="num" value="<%=reading.getNum()%>">
			</form>
			<form method="post" action="Paragraph-Control.jsp" id="FormDelete">
				<input type="hidden" name="num" value="<%=reading.getNum()%>">
				<input type="hidden" name="flag" value="delete">
			</form>
			<jsp:include page="Footer.jsp"></jsp:include>
		</div>
		<script>
			let fd = document.getElementById("FormDelete");
			let fdbtn = document.getElementById("DeleteButton");
			fdbtn.addEventListener("click", function(){
				fd.submit();
			});
			
			let ffbtn = document.getElementById("FixButton");
			let ff = document.getElementById("FormFix");
			ffbtn.addEventListener("click", function(){
				ff.submit();
			});
		</script>
	</body>
</html>

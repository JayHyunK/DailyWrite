<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>Daily Write</title>
		<link rel="stylesheet" href="DailyWrite-Style.css">
	</head>
	<body>
	<%
		request.setCharacterEncoding("utf-8");
	
		try{	
			String userkey = session.getAttribute("User.key").toString();
			String loginst = session.getAttribute("Login.key").toString();
			
			if(loginst.equals("OK") ==true){
				response.sendRedirect("DailyWrite-Main.jsp");
			}
			else if(loginst.equals("NO")==true){
				String reqlogin = session.getAttribute("reqlogin").toString();
				if(userkey.equals("NOT")==true||userkey.equals("none")==true||userkey.equals("failed")==true){
					out.print(reqlogin);
				}
			}
		}
		catch(Exception e){
			System.out.println("index.jsp 오류: "+e);
		}
		
	%>
		<div id="wrap">
			<jsp:include page="Header.jsp"></jsp:include>
			<jsp:include page="Header-Menu.jsp"></jsp:include>
			<div>
				
			</div>
			<div id="wbody">
				<div>
				<jsp:include page="DailyWrite-Content1.jsp"/>
				</div>
			</div>
			<jsp:include page="Footer.jsp"></jsp:include>
		</div>
	</body>
</html>
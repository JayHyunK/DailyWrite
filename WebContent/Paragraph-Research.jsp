<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="DailyWrite_Java.*" %>
<% 
	String userkey = ""; 	 
	String reqlogin;
	String mostEmo = "";
	String mostEmoEng = "";
	
	double temp = 0;
	
	try{
		if(session.getAttribute("User.key").toString().equals(null)==false){
			userkey = session.getAttribute("User.key").toString();
			
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
	
	Database db = Database.getInstance();
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null; 
	String sql = "";
	
	Member user = new Member();
	user.setId(userkey);
	
	double allParanum = 0; // 전체 게시글 수
	
	String[] emo = {"HAPPY", "EXCTING", "FUN", "SOSO", "WORRIED", "UPSET", "SAD", "ANGRY", "TRASHCAN"};
	String[] emokor = {"행복함", "흥미로움", "즐거움", "평범함", "걱정", "짜증남", "슬픔", "화남", "감정 쓰레기통"};
	double[] numEmo = new double[9];
	
	try{
		conn = db.getConnection();
		stmt = conn.createStatement();
		
	/* ===========================================================
	 * ==================== 사용자 정보 취하기 ========================
	 * ===========================================================	*/	
		
		sql = "SELECT * FROM MEMBER WHERE ID ='"
				+user.getId()+"';";
		System.out.println(sql);
		rs = stmt.executeQuery(sql);
		
		while(rs.next()){ //rs.next()가 없으면 Before start of result set ++ 한줄이라 if 문으로 처리도 가능
			user.setName(rs.getString("NAME"));
			user.setBirth(rs.getString("BIRTHDAY"));
			user.setEmail(rs.getString("EMAIL"));
			user.setAdmin(rs.getString("ADMIN"));
			user.setDate(rs.getString("DATE"));
		}
	 	 
	/* ===========================================================
	 * ==================== 사용자 정보 취하기 ========================
	 * ===========================================================	*/			
	 
		sql = "SELECT COUNT(*) FROM PARAGRAPH WHERE ID ='";
		sql += user.getId()+"';";
		rs = stmt.executeQuery(sql);
	 
	/* ===========================================================
	 * ===================== 전체 글 수 확인 =========================
	 * ===========================================================	*/		
	 
		sql = "SELECT COUNT(*) FROM PARAGRAPH WHERE ID ='";
		sql += user.getId()+"';";
		rs = stmt.executeQuery(sql);
		
	/* ===========================================================
	 * ================= 감정 상태 별로 변수 취하기 =====================
	 * ===========================================================	*/	
	 
		if(rs.next()){
			allParanum = Double.parseDouble(rs.getString("COUNT(*)"));
		}
		
		for(int i = 0; i < emo.length; i++){
			
			sql = "SELECT COUNT(CASE WHEN EMOTION='"+emo[i]+"' THEN 1 END) FROM PARAGRAPH WHERE ID ='";
			sql += user.getId()+"';";
			rs = stmt.executeQuery(sql);
			
			if(rs.next()){
				numEmo[i]= Double.parseDouble(rs.getString("COUNT(CASE WHEN EMOTION='"+emo[i]+"' THEN 1 END)"));
			}
			if(temp<numEmo[i]){
				temp=numEmo[i];
				mostEmo = emokor[i];
				mostEmoEng = emo[i];
			}	
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
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>Statistics</title>
		<link rel="stylesheet" href="DailyWrite-Style.css">
	</head>
	<body>
	<!-- 통계 개괄 설명 -->
	<div id="wrap">
		<jsp:include page="Header.jsp"></jsp:include>
		<jsp:include page="Header-Menu.jsp"></jsp:include>
		<div id="wbody">
			<div id="Statistics">
				<div class="hello">
					<span class="St-headlight">
						<b><%=user.getName() %>님, 안녕하세요?</b>
					</span>
					<span class="St-headlight-sub">
						매일 써내려가는 삶의 발자국,
						<br>Daily Write를 이용해 주셔서 감사드립니다.
						<br>
						<br>지금까지 <%=user.getName() %>님이 Daily Write를 통해 남기신 발자국들의 자취를 알려드리겠습니다.
					</span>
					<hr class="shortLine">
					<div class="conimg-big">
						<img src="./contentimage/notebook1.png">
					</div>
				</div>
				<br>
				<hr class="shortLine">
				<br>
				<div class="content">
					<span class="St-headlight">
						<b>일기의 갯수</b>
					</span>
					<span class="St-conspan">
						<%=user.getName() %>님은 Daily Write에 
						<br><b><%=(int)allParanum %>개</b>의 발자국을 남기셨어요.
						<br><%=user.getName() %>님의 삶의 발자취를 <br>Daily Write와 함께해 주셔서 감사드려요.
					</span>
					<br>
					<hr class="shortLine">
					<br>
					<span class="St-headlight">
						<b>일기에 표현한 감정들</b>
					</span>
					<span class="St-conspan">
						<%=user.getName() %>님이 Daily Write에 남기신 
						<br>감정상태에 대한 비율은 다음과 같아요.
					</span>
					<!-- 그래프 -->
					<div id="graphAll">
						<div id="piechart" style="width: 100%; height: 50vh;"></div>
					</div>
					<span class="St-conspan">
						감정 상태의 비율은 사람마다 달라요.
						<br>
						<br>
						감정의 상태는 자신의 경험이나 
						<br>
						해결하지 못한 고민, 
						<br>
						관심사에 따라 다르게 나타나요.
						<br>
						<br>
						일기장에 남겨두신 감정 상태는 <br>당시의 감정 상태를 나타낼 뿐,<br>
						<%=user.getName() %>님을 단정짓는 수식어는 아니에요.
					</span>
					<span class="St-conspan">
						하지만 두드러지는 경향성을 확인된다면, <br>
						그 감정을 느끼게 한 사건이 무엇인지, <br>
						인물이 누구인지를 알 필요는 있어요.
					</span>
					<br>
					<hr class="shortLine">
					<br>
					<span class="St-headlight">
						<b>감정 알기</b>
					</span>
					<span class="St-conspan">
						<%=user.getName() %>님의 감정에 영향을 주는 것은 무엇인가요? 
						<br>
						<br>
						같은 사건에서 같은 감정을 느끼고 있다면, 
						<br>
						이를 피할 수도 더욱 맞이할수도 있어요.
						<br>
						Daily Write는 감정을 각기 다른 색으로 표시해요.<br><br>
					</span>
					<span class="St-conspan">
						<ul class="St-conul">
							<li class="St-conli">
								<span class="St-conimg">
									<img src="./icon/happyColor.png" class="St-conliimg">
								</span>
								<br>
								<br>
								<span class="St-conliSubtitle">
									<b>노랑</b>
									<br>
									노란색은 행복, 즐거움, 흥미로움 등을 나타내는 색깔이에요. <br>
								</span>
							</li>
							<li class="St-conliBetween"></li>
							<li class="St-conli">
								<span class="St-conimg">
									<img src="./icon/sosoColor.png" class="St-conliimg">
								</span>
								<br>
								<br>
								<span class="St-conliSubtitle">
									<b>초록</b>
									<br>
									초록색은 그저 그런 하루, 어찌보면 평범한 오늘을 나타내는 색깔이에요.
								</span>
							</li>
						</ul>
						<br>
						<ul class="St-conul">
							<li class="St-conli">
								<span class="St-conimg">
									<img src="./icon/sadColor.png" class="St-conliimg">
								</span>
								<br>
								<br>
								<span class="St-conliSubtitle">
									<b>파랑</b>
									<br>
									파란색은 슬픔, 걱정, 짜증 등을 나타내는 색깔이에요.
								</span>
							</li>
							<li class="St-conliBetween"></li>
							<li class="St-conli">
								<span class="St-conimg">
									<img src="./icon/angryColor.png" class="St-conliimg">
								</span>
								<br>
								<br>
								<span class="St-conliSubtitle">
									<b>빨강</b>
									<br>
									빨간색은 분노, 감정 쓰레기통에 사용되는 색갈이에요.
								</span>
							</li>
						</ul>
					</span>
					<br>
					<hr class="shortLine">
					<br>
					<span class="St-headlight">
						<b>확인하기</b>
					</span>
					<span class="St-conspan">
						<%=user.getName() %>님의 일기에서 <br>
						가장 많이 언급된 감정은 '<%=mostEmo %>'이에요.<br>
						최근에 작성하신 일기를 보면서 어떤일이 있었는지 확인해보세요.<br>
					</span>
					<br>
					<hr class="shortLine">
					<div class="conimg-big">
						<img src="./contentimage/tea.jpg">
					</div>
					<hr class="shortLine">
					<br>
					<span class="St-headlight">
						<b>휴식</b>
					</span>
					<span class="St-conspan">
						감정을 정리하고,
						<br>
						삶에 대해 생각하였다면 오늘은 푹쉬셔야해요.
						<br>
						괜찮으시다면 다음 음악을 들어보세요.
						<br><br><br>
						<ul class="St-conul">
							<li class="suggestBtn">
								<span class="St-conliSubtitle">
									<b>잔잔한 음악</b>
									<br>
									'<%=mostEmo %>'을 정리하는 잔잔한 음악이에요.
								</span>
							</li>
							<li class="St-conliBetween"></li>
							<li class="suggestBtn">
								<span class="St-conliSubtitle">
									<b>편안한 음악</b>
									<br>
									감정을 정리하고 쉬고 싶을 때 듣는 음악이에요.
								</span>
							</li>
							</li>
						</ul>
						<br><br>
						<ul class="St-conul">
							<li class="suggestBtn">
								<span class="St-conliSubtitle">
									<b>신나는 음악</b>
									<br>
									'<%=mostEmo %>'를 느끼실때 기분전환으로 좋은 음악이에요.
								</span>
							</li>
							<li class="St-conliBetween"></li>
							<li class="suggestBtn">
								<span class="St-conliSubtitle">
									<b>트렌디한 음악</b>
									<br>
									'<%=mostEmo %>'을 잊게하는 트렌디한 음악이에요.
								</span>
							</li>
						</ul>
					</span>
				</div>
				<br>
				<hr class="shortLine">
				<br>
				<div id="St-conimg-foot">
				<img src="./contentimage/main-logo-Text2.png">
					<br>
					매일 써내려가는 당신의 발자국.
				</div>
			</div>
		</div>
		<jsp:include page="Footer.jsp"></jsp:include>
	</div>
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
    // 그래프 그리기
    
      google.charts.load('current', {'packages':['corechart']});
      google.charts.setOnLoadCallback(drawChart);

      function drawChart() {

        var data = google.visualization.arrayToDataTable([
          ['Task', 'Emotion'],
          ['<%=emokor[0] %>',     <%=numEmo[0]%>],
          ['<%=emokor[1] %>',     <%=numEmo[1]%>],
          ['<%=emokor[2] %>',     <%=numEmo[2]%>],
          ['<%=emokor[3] %>',     <%=numEmo[3]%>],
          ['<%=emokor[4] %>',     <%=numEmo[4]%>],
          ['<%=emokor[5] %>',     <%=numEmo[5]%>],
          ['<%=emokor[6] %>',     <%=numEmo[6]%>],
          ['<%=emokor[7] %>',     <%=numEmo[7]%>],
          ['<%=emokor[8] %>',     <%=numEmo[8]%>]
        ]);

        var options = {
          title: 'DailyWite-Emotion Chart'
        };

        var chart = new google.visualization.PieChart(document.getElementById('piechart'));

        chart.draw(data, options);
      }      
    </script>
    <script>
    // Suggest 버튼에 따른 동작
    	let suggestBtn = document.getElementsByClassName("suggestBtn");
    	let emotion = "<%=mostEmoEng %>";
    	let = "";
   
    	suggestBtn[0].addEventListener("click", function(){
    		if(emotion=="HAPPY"||emotion=="FUN"||emotion=="EXCTING"||emotion=="SOSO"){
    			url="https://www.youtube.com/watch?v=ESJ7TQvFFrA";
    		}
    		
			if(emotion=="SAD"||emotion=="WORRIED"||emotion=="UPSET"){
				url="https://www.youtube.com/watch?v=If3u9in5Nfo";
    		}
			
			if(emotion=="ANGRY"||emotion=="TRASHCAN"){
				url="https://www.youtube.com/watch?v=CTNLizHPgXo"; 
    		}  
			window.open(url);
    	});
    	suggestBtn[1].addEventListener("click", function(){
    		if(emotion=="HAPPY"||emotion=="FUN"||emotion=="EXCTING"||emotion=="SOSO"){
    			url = "https://www.youtube.com/watch?v=tAXjTnKQi8w";
    		}
    		
			if(emotion=="SAD"||emotion=="WORRIED"||emotion=="UPSET"){
				url = "https://www.youtube.com/watch?v=zpIgoy3Q1OE";
    		}
			
			if(emotion=="ANGRY"||emotion=="TRASHCAN"){
				url = "https://www.youtube.com/watch?v=MxlYb-aJUNU";
    		}
			window.open(url); 
    	});
    	suggestBtn[2].addEventListener("click", function(){
    		if(emotion=="HAPPY"||emotion=="FUN"||emotion=="EXCTING"||emotion=="SOSO"){
    			url = "https://www.youtube.com/watch?v=DGDyAb6pePo";
    		}
    		
			if(emotion=="SAD"||emotion=="WORRIED"||emotion=="UPSET"){
				url = "https://www.youtube.com/watch?v=yKNxeF4KMsY";
    		}
			
			if(emotion=="ANGRY"||emotion=="TRASHCAN"){
				url = "https://www.youtube.com/watch?v=DGDyAb6pePo";
    		} 
			window.open(url); 
    	});
    	suggestBtn[3].addEventListener("click", function (){
    		if(emotion=="HAPPY"||emotion=="FUN"||emotion=="EXCTING"||emotion=="SOSO"){
    			url = "https://www.youtube.com/watch?v=WMweEpGlu_U";
    		}
    		
			if(emotion=="SAD"||emotion=="WORRIED"||emotion=="UPSET"){
				url = "https://www.youtube.com/watch?v=BV2FdDmGiW0";
    		}
			
			if(emotion=="ANGRY"||emotion=="TRASHCAN"){
				url = "https://www.youtube.com/watch?v=CRHPclhtlN0";
    		}
			window.open(url); 
    	});
    	
    	
    </script>
	</body>
</html>
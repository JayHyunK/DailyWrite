package DailyWrite_Java;

import java.sql.Connection;
import java.sql.DriverManager;

public class Database {

	private Database() {
		// 생성자 못하게함 > 다른 곳에서 못 부름 
		// 때문에 메소드가 아닌 펑션 (메소드는 객체가 수행하는 것임) > static으로 만들어야함 
	}
	private static Database instance= new Database();
	
	public static Database getInstance() {
		return instance;
	}
	// 커넥션 연결 처리 
	public Connection getConnection() throws Exception{//오류가 나면 예외 처리 
		Connection conn=null;
		String url = "jdbc:mysql://127.0.0.1:3306/DAILYWRITE";
		String id = "root";
		String pw = "iotiot";
		
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn=DriverManager.getConnection(url, id, pw);
		return conn;
	}
	
	private final String id = "root";
	private final String pw = "iotiot";
	private final String dv = "com.mysql.cj.jdbc.Driver";
	private final String url = "jdbc:mysql://127.0.0.1:3306";
	private final String CREATE_DB_DAILYWRITE = "CREATE DATABASE IF NOT EXISTS DAILYWRITE;";
	
	private final String CREATE_TB_MEMBER = 
			"CREATE TABLE IF NOT EXISTS MEMBER ("
			+ "ID TEXT PRIMARY KEY, "
			+ "PASSWORD TEXT, "
			+ "NAME TEXT, "
			+ "BIRTHDAY TEXT,"
			+ "EMAIL TEXT, "
			+ "PW_QUESTION TEXT, "
			+ "PW_ANSWER TEXT, "
			+ "DATE TEXT, "
			+ "ADMIN VARCHAR(11) DEFAULT 'MEMBER'"
			+ ");";
	
	private final String CREATE_TB_PARAGRAPH = 
			"CREATE TABLE IF NOT EXISTS PARAGRAPH ("
			+ "NUM INT PRIMARY KEY AUTO_INCREMENT, "
			+ "ID TEXT, "
			+ "NAME TEXT, "
			+ "DATE TEXT, "
			+ "TITLE TEXT, "
			+ "CONTENT TEXT, "
			+ "EMOTION TEXT, "
			+ "FILE TEXT, "
			+ "VIEW INT"
			+ ");";
	
	private final String CREATE_TB_MEDIA = 
			"CREATE TABLE IF NOT EXISTS MEDIA ("
			+ "ID VARCHAR(30) PRIMARY KEY, "
			+ "MEDIA VARCHAR(30), "
			+ "MEMBER_VIEW VARCHAR(30), "
			+ "MEMBER_FIX VARCHAR(30)"
			+ ");";
	
	private final String USE_DB = "USE DAILYWRITE;";
	
	//싱글톤 패턴

	public String getId() {
		return id;
	}
	public String getPw() {
		return pw;
	}
	public String getUrl() {
		return url;
	}
	public String getDv() {
		return dv;
	}
	
	public String getCREATE_DB_DAILYWRITE() {
		return CREATE_DB_DAILYWRITE;
	}
	public String getCREATE_TB_MEMBER() {
		return CREATE_TB_MEMBER;
	}
	public String getCREATE_TB_PARAGRAPH() {
		return CREATE_TB_PARAGRAPH;
	}
	public String getUSE_DB() {
		return USE_DB;
	}
	public String getCREATE_TB_MEDIA() {
		return CREATE_TB_MEDIA;
	}
	
}


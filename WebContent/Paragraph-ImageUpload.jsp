<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.io.File" %>
<%
	request.setCharacterEncoding("utf-8");
	
	String path = request.getServletContext().getRealPath("UploadFiles"); // 파일 업로드 경로 
	int size = 1024*1024*10;//5mb, 1 당 1 byte 
	
	String str;
	String filename;
	String filenameOriginal;
	
	try{
		File dir = new File(path);
		if(!dir.exists()) dir.mkdir();
		
		MultipartRequest remul = new MultipartRequest(request, path, size, "utf-8", new DefaultFileRenamePolicy());
		
		Enumeration files = remul.getFileNames();
		str = files.nextElement().toString();
		filename = remul.getFilesystemName(str);
		filenameOriginal = remul.getOriginalFileName(str);
		
		System.out.println("str : "+str);
    	System.out.println("filename : "+filename);
    	System.out.println("original_filename : "+filenameOriginal);
    	System.out.println("path : "+path);
    	
    	String img = "./UploadFiles/"+filename;
    	session.setAttribute("User.image", img); 
	}
	catch(Exception e){
		System.out.println("업로드중 오류 발생"+e);
	}
	response.sendRedirect("Paragraph-Write.jsp");
%>
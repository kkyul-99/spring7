<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>로그인</title>
	</head>
	<body>
	  <h2>로그인</h2>
	  <form action="/member/doLogin" method="post" name="frm">
	    <input type="text" name="id" placeholder="아이디를 입력하세요">
	    <br>
	    <input type="text" name="pw" placeholder="비밀번호를 입력하세요">
	    <br>
	    <input type="submit" value="로그인">
	    
	  </form>
	  
	
	</body>
</html>
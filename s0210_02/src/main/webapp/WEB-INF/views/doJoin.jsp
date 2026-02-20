<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>회원가입완료페이지</title>
	</head>
	<body>
		<h2>회원가입완료페이지</h2>
		<h3>아이디: ${member.id}</h3>
		<h3>비밀번호: ${member.pw}</h3>
		<h3>이름: ${member.name}</h3>
		<h3>전화번호: ${member.phone}</h3>
		<h3>성별: ${member.gender}</h3>
		<h3>취미: ${member.hobby}</h3>
		<ul>
			<li><a href="/">홈으로</a></li>
		</ul>
	</body>
</html>
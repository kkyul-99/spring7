<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>메인페이지</title>
		<script>
			if("${flag}"==1) {
				alert("로그인이 되었습니다.")
			}
		</script>
	</head>
	<body>
		<h2>메인페이지</h2>
		<ul>
		    <li><a href="/mUpdate">회원정보수정</a></li>
		    <li><a href="/boardView/1">1번게시글</a></li>
			<!--
			<li><a href="/boardView?bno=1">1번게시글</a></li>
			-->
			<li><a href="/board">게시판</a></li>
			<li><a href="/login">로그인</a></li>
			<li><a href="/join">회원가입</a></li>
		</ul>
		<p>${now}</p>
		<p><fmt:formatDate value="${now}" pattern="YYYY-MM-dd HH:mm:ss"/></p>
		<p><fmt:formatDate value="${now}" pattern="MM"/></p>
		<p><fmt:formatNumber value="3.141592" pattern="000.##"/></p>
	</body>
</html>
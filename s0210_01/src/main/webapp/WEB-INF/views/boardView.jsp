<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>게시글 상세보기</title>
	</head>
	<body>
		<h2>게시글 상세보기</h2>
		<h3>번호: ${bno}</h3>
		<ul>
			<li><a href="/">홈으로</a></li>
		</ul>
		<%--
		<h2>게시판완료페이지</h2>
		<h3>번호: ${bno}</h3>
		<h3>제목: ${btitle}</h3>
		<h3>내용: ${bcontent}</h3>
		<h3>작성자: ${id}</h3>
		<ul>
			<li><a href="/">홈으로</a></li>
		</ul>
		--%>
	</body>
</html>
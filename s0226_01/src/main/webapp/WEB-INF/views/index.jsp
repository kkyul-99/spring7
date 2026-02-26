<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>    
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
	    <script src="http://code.jquery.com/jquery-latest.min.js"></script>
		<meta charset="UTF-8">
		<title>메인페이지</title>
		<script>
		  function logoutBtn(){
			  alert("로그아웃 되었습니다.");
			  location.href="/member/logout";
		  }
		</script>
		<style> a{cursor: pointer;}</style>
	</head>
	<body>
	  <h2>메인페이지</h2>
	  <c:if test="${session_id == null }">
	    <h3>로그인을 진행해 주세요.</h3>
	    <li><a href="/member/login">로그인</a></li>
	    <li><a href="/member/memberShip">회원가입</a></li>
	  </c:if>
	  <c:if test="${session_id != null }">
	    <h3>${session_id} 님 환영합니다.</h3>
	    <li><a onclick="logoutBtn()">로그아웃</a></li>
	    <li><a href="/member/mlist">전체회원리스트</a></li>
	  </c:if>
	    <li><a href="/board/blist">게시판</a></li>
	  <ul>
	  </ul>
	
	</body>
</html>
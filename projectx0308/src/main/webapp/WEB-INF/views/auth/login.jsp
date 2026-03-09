<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>NEXT DEBUT - 로그인</title>
  <%@ include file="/WEB-INF/views/fragments/head-common.jspf" %>
  <link rel="stylesheet" href="<c:url value='/css/auth.css'/>" />
</head>

<body class="page-main min-h-screen flex flex-col">
  <%@ include file="/WEB-INF/views/fragments/topnav.jspf" %>

  <main class="flex-1 px-6 pb-16" style="padding-top: calc(var(--nav-h) + 24px);">

    <c:if test="${not empty toast}">
      <div class="toast toast--ok"><c:out value="${toast}"/></div>
    </c:if>
    <c:if test="${not empty error}">
      <div class="toast toast--err"><c:out value="${error}"/></div>
    </c:if>

    <div class="auth-card premium-glass auth-card--login">
      <h2>로그인</h2>

      <form method="post" action="<c:url value='/login'/>">
        <c:if test="${not empty param.redirect}">
          <input type="hidden" name="redirect" value="<c:out value='${param.redirect}'/>" />
        </c:if>
        <div class="form-group">
          <label for="id_username">아이디</label>
          <input type="text" name="username" id="id_username" placeholder="아이디를 입력하세요" required value="<c:out value='${prev_username}'/>" />
        </div>
        <div class="form-group">
          <label for="id_password">비밀번호</label>
          <input type="password" name="password" id="id_password" placeholder="비밀번호를 입력하세요" required />
        </div>

        <div class="actions">
          <button type="submit" class="auth-submit" id="btnLoginSubmit">로그인 하기</button>
        </div>
      </form>

      <div class="login-links">
        <a href="<c:url value='/find-id'/>">아이디 찾기</a> |
        <a href="<c:url value='/find-pw'/>">비밀번호 찾기</a> |
        <a href="<c:url value='/signup'/>"><b>회원가입</b></a>
      </div>
    </div>
  </main>

  <%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
</body>
</html>

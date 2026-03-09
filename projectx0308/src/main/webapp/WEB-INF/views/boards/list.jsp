<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="loggedIn" value="${not empty sessionScope.LOGIN_MEMBER}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>UNIT-X - ${boardTitle}</title>

    <%@ include file="/WEB-INF/views/fragments/head-common.jspf" %>
</head>

<body class="page-main min-h-screen flex flex-col">
<%@ include file="/WEB-INF/views/fragments/topnav.jspf" %>

<main class="flex-1 px-6 pb-16" style="padding-top: calc(var(--nav-h) + 24px);">
    <div class="container mx-auto max-w-5xl">
        <section class="glass-card p-8 md:p-10">
            <div class="flex items-start justify-between gap-4">
                <div>
                    <h1 class="font-orbitron text-3xl md:text-5xl font-black text-white/90 drop-shadow mb-2">${boardTitle}</h1>
                    <p class="text-white/80">게시글 목록</p>
                </div>
                <a class="btn-primary" href="${ctx}/boards/${boardType}/write" id="btnWrite" data-logged-in="${loggedIn}" data-redirect="/boards/${boardType}/write">
                    <i class="fa-solid fa-pen"></i>
                    글쓰기
                </a>
            </div>

            <c:if test="${not empty success}">
                <div class="mt-6 px-4 py-3 rounded-xl bg-white/30 border border-white/40 text-white/90">
                    ${success}
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="mt-6 px-4 py-3 rounded-xl bg-red-500/20 border border-red-200/40 text-white/90">
                    ${error}
                </div>
            </c:if>

            <div class="mt-8 overflow-x-auto">
                <table class="w-full text-left text-sm text-white/90">
                    <thead class="text-white/80">
                    <tr class="border-b border-white/25">
                        <th class="py-3 pr-4 w-[70px]">번호</th>
                        <th class="py-3 pr-4 text-center">제목</th>
                        <th class="py-3 pr-4 w-[60px] text-center">조회</th>
                        <th class="py-3 pr-4 w-[60px] text-center">좋아요</th>
                        <th class="py-3 pr-4 w-[130px]">작성일</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty posts}">
                            <tr class="border-b border-white/15">
                                <td class="py-5 text-white/70" colspan="4">아직 글이 없어. 첫 글 써보자.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="p" items="${posts}" varStatus="vs">
                                <tr class="border-b border-white/15 hover:bg-white/10 transition-colors">
                                    <td class="py-4 pr-4 text-white/80">${fn:length(posts) - vs.index}</td>
                                    <td class="py-4 pr-4">
                                        <a class="underline decoration-white/30 hover:decoration-white/80" href="${ctx}/boards/${boardType}/${p.id}">
                                            ${p.title}
                                        </a>
                                        <c:if test="${not empty p.originalFilename}">
                                            <i class="fa-solid fa-paperclip text-white/40 ml-1" style="font-size:10px;"></i>
                                        </c:if>
                                    </td>
                                    <td class="py-4 pr-4 text-center text-white/55" style="font-size:12px;">${p.viewCount}</td>
                                    <td class="py-4 pr-4 text-center text-white/55" style="font-size:12px;color:rgba(233,176,196,0.70);">${p.likeCount}</td>
                                    <td class="py-4 pr-4 text-white/75" style="font-size:12px;">${p.createdAtStr}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </section>
    </div>
</main>

<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>

<script>
  (function(){
    const btn = document.getElementById('btnWrite');
    if (!btn) return;
    const loggedIn = btn.dataset.loggedIn === 'true';
    if (loggedIn) return;

    btn.addEventListener('click', function(e){
      e.preventDefault();
      alert('로그인해야 이용이 가능합니다.');
      const redirect = encodeURIComponent(btn.dataset.redirect || '/');
      window.location.href = '${ctx}/login?redirect=' + redirect;
    });
  })();
</script>

</body>
</html>

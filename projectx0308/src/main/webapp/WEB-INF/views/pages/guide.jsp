<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>NEXT DEBUT - 게임설명</title>

    <%@ include file="/WEB-INF/views/fragments/head-common.jspf" %>
</head>

<body class="page-main min-h-screen flex flex-col">
    <%@ include file="/WEB-INF/views/fragments/topnav.jspf" %>

    <main class="flex-1 px-6 pb-16" style="padding-top: calc(var(--nav-h) + 24px);">
        <div class="container mx-auto max-w-4xl">
            <section class="glass-card p-10">
                <h1 class="font-orbitron text-3xl md:text-5xl font-black text-white/90 drop-shadow mb-4">게임설명</h1>
                <p class="text-white/80 leading-relaxed">
                    규칙/플로우 설명 페이지 자리야. (1판=6개월, 능력치 5개, 데뷔 4인, 주간 랭킹 등)
                </p>
            </section>
        </div>
    </main>

    <%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
</body>
</html>

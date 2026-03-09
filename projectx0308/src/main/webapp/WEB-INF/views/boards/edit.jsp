<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>NEXT DEBUT - 글 수정</title>
    <%@ include file="/WEB-INF/views/fragments/head-common.jspf" %>
</head>

<body class="page-main min-h-screen flex flex-col">
<%@ include file="/WEB-INF/views/fragments/topnav.jspf" %>

<main class="flex-1 px-6 pb-16" style="padding-top: calc(var(--nav-h) + 24px);">
    <div class="container mx-auto max-w-3xl">
        <section class="glass-card p-8 md:p-10">

            <div class="flex items-start justify-between gap-4 mb-8">
                <h1 class="font-orbitron text-2xl md:text-4xl font-black text-white/90">글 수정</h1>
                <a class="nav-link shrink-0" href="${ctx}/boards/${boardType}/${post.id}">
                    <i class="fa-solid fa-arrow-left"></i> 돌아가기
                </a>
            </div>

            <form method="post" action="${ctx}/boards/${boardType}/${post.id}/edit" class="space-y-5">

                <div>
                    <label class="block text-white/60 text-xs font-orbitron tracking-widest mb-2">TITLE</label>
                    <input type="text" name="title" value="${post.title}" required maxlength="200"
                           style="width:100%; padding:13px 16px; border-radius:14px;
                                  background:rgba(255,255,255,0.07); border:1px solid rgba(255,255,255,0.18);
                                  color:#fff; font-size:15px; outline:none; box-sizing:border-box;
                                  transition:border 200ms ease;"
                           onfocus="this.style.borderColor='rgba(233,176,196,0.55)'"
                           onblur="this.style.borderColor='rgba(255,255,255,0.18)'" />
                </div>

                <div>
                    <label class="block text-white/60 text-xs font-orbitron tracking-widest mb-2">CONTENT</label>
                    <textarea name="content" required rows="14" maxlength="10000"
                              style="width:100%; padding:13px 16px; border-radius:14px; resize:vertical;
                                     background:rgba(255,255,255,0.07); border:1px solid rgba(255,255,255,0.18);
                                     color:#fff; font-size:14px; line-height:1.7; outline:none; box-sizing:border-box;
                                     transition:border 200ms ease; font-family:inherit;"
                              onfocus="this.style.borderColor='rgba(233,176,196,0.55)'"
                              onblur="this.style.borderColor='rgba(255,255,255,0.18)'">${post.content}</textarea>
                </div>

                <div class="flex gap-3 pt-2">
                    <button type="submit" class="btn-primary flex-1">
                        <i class="fas fa-check"></i> 수정 완료
                    </button>
                    <a href="${ctx}/boards/${boardType}/${post.id}" class="nav-link" style="padding:13px 24px;">
                        취소
                    </a>
                </div>
            </form>

        </section>
    </div>
</main>

<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
</body>
</html>

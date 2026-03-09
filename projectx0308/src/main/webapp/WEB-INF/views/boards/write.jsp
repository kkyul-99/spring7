<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>UNIT-X - ${boardTitle} 글쓰기</title>

    <%@ include file="/WEB-INF/views/fragments/head-common.jspf" %>
</head>

<body class="page-main min-h-screen flex flex-col">
<%@ include file="/WEB-INF/views/fragments/topnav.jspf" %>

<main class="flex-1 px-6 pb-16" style="padding-top: calc(var(--nav-h) + 24px);">
    <div class="container mx-auto max-w-4xl">
        <section class="glass-card p-8 md:p-10">
            <div class="flex items-start justify-between gap-4">
                <div>
                    <h1 class="font-orbitron text-3xl md:text-5xl font-black text-white/90 drop-shadow mb-2">${boardTitle}</h1>
                    <p class="text-white/80">글쓰기</p>
                </div>
                <a class="nav-link" href="${ctx}/boards/${boardType}">
                    <i class="fa-solid fa-arrow-left"></i>
                    목록
                </a>
            </div>

            <c:if test="${not empty error}">
                <div class="mt-6 px-4 py-3 rounded-xl bg-red-500/20 border border-red-200/40 text-white/90">
                    ${error}
                </div>
            </c:if>

            <form class="mt-8 space-y-5" action="${ctx}/boards/${boardType}/write" method="post" enctype="multipart/form-data">
                <div>
                    <label class="block text-white/85 mb-2 font-semibold" for="title">제목</label>
                    <input id="title" name="title" type="text" maxlength="120" required
                           class="w-full px-4 py-3 rounded-xl bg-white/25 border border-white/35 text-white placeholder:text-white/55 focus:outline-none focus:ring-2 focus:ring-white/40"
                           placeholder="제목을 입력" />
                </div>

                <div>
                    <label class="block text-white/85 mb-2 font-semibold" for="content">내용</label>
                    <textarea id="content" name="content" rows="10" required
                              class="w-full px-4 py-3 rounded-xl bg-white/25 border border-white/35 text-white placeholder:text-white/55 focus:outline-none focus:ring-2 focus:ring-white/40"
                              placeholder="내용을 입력"></textarea>
                </div>

                <div>
                    <label class="block text-white/85 mb-2 font-semibold" for="file">
                        이미지 / 파일 첨부 <span class="text-white/45 font-normal text-xs">(선택 · JPG·PNG·GIF·WEBP 등)</span>
                    </label>
                    <input id="file" name="file" type="file"
                           accept="image/*,.pdf,.zip,.txt,.doc,.docx"
                           onchange="previewImage(this)"
                           class="w-full text-white/85 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:bg-white/85 file:text-black/80 hover:file:bg-white cursor-pointer" />
                    <%-- 이미지 미리보기 --%>
                    <div id="preview-wrap" style="display:none; margin-top:14px;">
                        <div class="text-xs font-orbitron tracking-widest text-white/35 mb-2">▸ 미리보기</div>
                        <img id="preview-img" src="" alt="미리보기"
                             class="rounded-2xl border border-white/15 max-w-full"
                             style="max-height:300px; object-fit:contain;" />
                    </div>
                </div>

                <div class="pt-2 flex justify-end gap-3">
                    <a class="nav-link" href="${ctx}/boards/${boardType}">취소</a>
                    <button class="btn-primary" type="submit">
                        <i class="fa-solid fa-check"></i>
                        등록
                    </button>
                </div>
            </form>
        </section>
    </div>
</main>

<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
<script>
function previewImage(input) {
    var wrap = document.getElementById('preview-wrap');
    var img  = document.getElementById('preview-img');
    if (input.files && input.files[0]) {
        var file = input.files[0];
        if (file.type.startsWith('image/')) {
            var reader = new FileReader();
            reader.onload = function(e) {
                img.src = e.target.result;
                wrap.style.display = 'block';
            };
            reader.readAsDataURL(file);
        } else {
            wrap.style.display = 'none';
        }
    } else {
        wrap.style.display = 'none';
    }
}
</script>
</body>
</html>

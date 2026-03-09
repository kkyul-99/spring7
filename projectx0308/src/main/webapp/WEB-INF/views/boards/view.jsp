<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="isAuthor" value="${not empty loginMember and loginMember.nickname eq post.authorNick}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>NEXT DEBUT - ${boardTitle}</title>
    <%@ include file="/WEB-INF/views/fragments/head-common.jspf" %>
    <style>
        /* ── 메타 뱃지 ── */
        .meta-row { display:flex; align-items:center; gap:10px; flex-wrap:wrap; font-size:13px; color:rgba(255,255,255,0.55); margin-top:8px; }
        .meta-badge { display:inline-flex; align-items:center; gap:5px; padding:3px 10px; border-radius:999px; background:rgba(255,255,255,0.07); border:1px solid rgba(255,255,255,0.12); font-size:12px; }
        .meta-badge.views { color:rgba(186,198,220,0.85); }
        .meta-badge.likes { color:rgba(233,176,196,0.85); cursor:pointer; transition:all 200ms ease; user-select:none; }
        .meta-badge.likes:hover { background:rgba(233,176,196,0.15); border-color:rgba(233,176,196,0.35); }
        .meta-badge.likes.liked { background:rgba(233,176,196,0.18); border-color:rgba(233,176,196,0.50); color:rgba(233,176,196,1); }
        .meta-badge.likes.liked i { animation: heartPop 300ms cubic-bezier(.23,1.5,.46,.98); }
        @keyframes heartPop { 0%{transform:scale(1)} 50%{transform:scale(1.4)} 100%{transform:scale(1)} }

        /* ── 작성자 버튼 ── */
        .author-actions { display:flex; gap:8px; }
        .btn-edit, .btn-del {
            font-size:12px; padding:5px 14px; border-radius:999px;
            border:1px solid rgba(255,255,255,0.20); background:rgba(255,255,255,0.06);
            color:rgba(255,255,255,0.70); cursor:pointer; transition:all 200ms ease; text-decoration:none;
            display:inline-flex; align-items:center; gap:5px;
        }
        .btn-edit:hover { background:rgba(255,255,255,0.14); color:#fff; }
        .btn-del  { border-color:rgba(248,113,113,0.30); color:rgba(248,113,113,0.75); }
        .btn-del:hover { background:rgba(248,113,113,0.15); color:rgba(248,113,113,1); }

        /* ── 댓글 영역 ── */
        .comment-section { margin-top:32px; }
        .comment-section__title {
            font-family:"Orbitron",sans-serif; font-size:11px; letter-spacing:0.28em;
            color:rgba(255,255,255,0.45); margin-bottom:16px;
        }
        .comment-input-wrap {
            display:flex; gap:10px; margin-bottom:20px;
        }
        .comment-input-wrap textarea {
            flex:1; padding:12px 16px; border-radius:16px; resize:none; min-height:56px;
            background:rgba(255,255,255,0.07); border:1px solid rgba(255,255,255,0.15);
            color:#fff; font-size:14px; outline:none; transition:border 200ms ease;
            font-family:inherit;
        }
        .comment-input-wrap textarea:focus { border-color:rgba(233,176,196,0.50); }
        .comment-input-wrap textarea::placeholder { color:rgba(255,255,255,0.30); }
        .btn-comment-submit {
            padding:0 20px; border-radius:16px; border:none; cursor:pointer;
            background:linear-gradient(135deg,rgba(233,176,196,0.80),rgba(204,186,216,0.80));
            color:rgba(20,10,30,0.90); font-weight:700; font-size:13px;
            transition:all 200ms ease; white-space:nowrap; align-self:flex-end; height:44px;
        }
        .btn-comment-submit:hover { filter:brightness(1.1); transform:translateY(-2px); }

        .comment-item {
            padding:14px 16px; border-radius:16px; margin-bottom:10px;
            background:rgba(255,255,255,0.05); border:1px solid rgba(255,255,255,0.10);
            transition:background 200ms ease;
        }
        .comment-item:hover { background:rgba(255,255,255,0.08); }
        .comment-header { display:flex; align-items:center; justify-content:space-between; margin-bottom:6px; }
        .comment-nick { font-size:13px; font-weight:700; color:rgba(233,176,196,0.90); }
        .comment-date { font-size:11px; color:rgba(255,255,255,0.35); }
        .comment-content { font-size:14px; color:rgba(255,255,255,0.85); line-height:1.6; white-space:pre-wrap; }
        .btn-comment-del {
            font-size:11px; padding:3px 10px; border-radius:999px;
            border:1px solid rgba(248,113,113,0.25); background:transparent;
            color:rgba(248,113,113,0.60); cursor:pointer; transition:all 180ms ease;
        }
        .btn-comment-del:hover { background:rgba(248,113,113,0.12); color:rgba(248,113,113,1); }

        .no-comments { text-align:center; padding:28px 0; color:rgba(255,255,255,0.30); font-size:13px; }

        /* ── 에러/성공 토스트 ── */
        .flash-msg { padding:12px 16px; border-radius:14px; margin-bottom:16px; font-size:13px; }
        .flash-msg.ok  { background:rgba(134,239,172,0.12); border:1px solid rgba(134,239,172,0.30); color:rgba(134,239,172,0.90); }
        .flash-msg.err { background:rgba(248,113,113,0.12); border:1px solid rgba(248,113,113,0.30); color:rgba(248,113,113,0.90); }

        /* ── AJAX 로딩 스피너 ── */
        .like-spinner { display:none; width:12px; height:12px; border:2px solid rgba(233,176,196,0.3); border-top-color:rgba(233,176,196,1); border-radius:50%; animation:spin 600ms linear infinite; }
        @keyframes spin { to { transform:rotate(360deg); } }
    </style>
</head>

<body class="page-main min-h-screen flex flex-col">
<%@ include file="/WEB-INF/views/fragments/topnav.jspf" %>

<main class="flex-1 px-6 pb-16" style="padding-top: calc(var(--nav-h) + 24px);">
    <div class="container mx-auto max-w-4xl">
        <section class="glass-card p-8 md:p-10">

            <%-- 헤더 --%>
            <div class="flex items-start justify-between gap-4 mb-6">
                <h1 class="font-orbitron text-2xl md:text-4xl font-black text-white/90">${boardTitle}</h1>
                <a class="nav-link shrink-0" href="${ctx}/boards/${boardType}">
                    <i class="fa-solid fa-arrow-left"></i> 목록
                </a>
            </div>

            <%-- 플래시 메시지 --%>
            <c:if test="${not empty success}"><div class="flash-msg ok"><i class="fas fa-check-circle"></i> ${success}</div></c:if>
            <c:if test="${not empty error}"><div class="flash-msg err"><i class="fas fa-exclamation-circle"></i> ${error}</div></c:if>

            <%-- 제목 + 메타 --%>
            <div class="pb-4 border-b border-white/15">
                <h2 class="text-xl md:text-2xl font-bold text-white/95">${post.title}</h2>
                <div class="meta-row">
                    <span class="meta-badge"><i class="fas fa-user fa-xs"></i> ${post.authorNick}</span>
                    <span class="meta-badge"><i class="fas fa-clock fa-xs"></i> ${post.createdAtStr}</span>
                    <span class="meta-badge views"><i class="fas fa-eye fa-xs"></i> <span id="view-count">${post.viewCount}</span></span>
                    <%-- 좋아요 버튼 --%>
                    <span class="meta-badge likes ${liked ? 'liked' : ''}" id="like-btn"
                          onclick="toggleLike(${post.id}, '${boardType}')">
                        <span class="like-spinner" id="like-spinner"></span>
                        <i class="fas fa-heart fa-xs" id="like-icon"></i>
                        <span id="like-count">${post.likeCount}</span>
                    </span>
                    <%-- 본인 글: 수정/삭제 버튼 --%>
                    <c:if test="${isAuthor}">
                        <span class="author-actions ml-auto">
                            <a href="${ctx}/boards/${boardType}/${post.id}/edit" class="btn-edit"><i class="fas fa-pen fa-xs"></i> 수정</a>
                            <button class="btn-del" onclick="confirmDelete()"><i class="fas fa-trash fa-xs"></i> 삭제</button>
                            <form id="deleteForm" method="post" action="${ctx}/boards/${boardType}/${post.id}/delete" style="display:none;"></form>
                        </span>
                    </c:if>
                </div>
            </div>

            <%-- 본문 --%>
            <div class="mt-6 whitespace-pre-wrap text-white/90 leading-relaxed
                        bg-white/5 border border-white/10 rounded-2xl p-6 text-base">
                <c:out value="${post.content}" />
            </div>

            <%-- 이미지 첨부 --%>
            <c:if test="${post.image and not empty post.storedFilename}">
                <div class="mt-6">
                    <div class="text-xs font-orbitron tracking-widest text-white/35 mb-3">▸ 첨부 이미지</div>
                    <img src="${ctx}/boards/files/${post.storedFilename}?inline=true"
                         alt="${post.originalFilename}"
                         class="rounded-2xl max-w-full border border-white/15"
                         style="max-height:600px; object-fit:contain;" />
                </div>
            </c:if>

            <%-- 일반 파일 첨부 --%>
            <c:if test="${not post.image and not empty post.originalFilename}">
                <div class="mt-6 flex items-center justify-between gap-3 px-5 py-4 rounded-2xl bg-white/10 border border-white/15">
                    <span class="text-white/85 flex items-center gap-2"><i class="fa-solid fa-paperclip"></i> ${post.originalFilename}</span>
                    <a class="nav-link" href="${ctx}/boards/files/${post.storedFilename}"><i class="fa-solid fa-download"></i> 다운로드</a>
                </div>
            </c:if>

            <%-- 댓글 섹션 --%>
            <div class="comment-section" id="comments">
                <div class="comment-section__title">✦ &nbsp; COMMENTS &nbsp; (${fn:length(comments) > 0 ? fn:length(comments) : 0})</div>

                <%-- 댓글 입력창 (로그인 시) --%>
                <c:choose>
                    <c:when test="${not empty loginMember}">
                        <form method="post" action="${ctx}/boards/${boardType}/${post.id}/comments" class="comment-input-wrap">
                            <textarea name="content" placeholder="댓글을 입력하세요 (최대 500자)" maxlength="500" rows="2"></textarea>
                            <button type="submit" class="btn-comment-submit"><i class="fas fa-paper-plane"></i></button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div style="padding:14px 16px; border-radius:16px; background:rgba(255,255,255,0.04); border:1px solid rgba(255,255,255,0.10); text-align:center; color:rgba(255,255,255,0.40); font-size:13px; margin-bottom:20px;">
                            <a href="${ctx}/login" style="color:rgba(233,176,196,0.80); text-decoration:underline;">로그인</a> 후 댓글을 작성할 수 있습니다.
                        </div>
                    </c:otherwise>
                </c:choose>

                <%-- 댓글 목록 --%>
                <c:choose>
                    <c:when test="${empty comments}">
                        <div class="no-comments"><i class="fas fa-comment-slash"></i> 아직 댓글이 없어요. 첫 댓글을 남겨보세요!</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="c" items="${comments}">
                            <div class="comment-item">
                                <div class="comment-header">
                                    <span class="comment-nick"><i class="fas fa-user fa-xs" style="opacity:0.6;margin-right:4px;"></i>${c.authorNick}</span>
                                    <div style="display:flex;align-items:center;gap:8px;">
                                        <span class="comment-date">${c.createdAtStr}</span>
                                        <c:if test="${not empty loginMember and loginMember.mno eq c.authorMno}">
                                            <form method="post" action="${ctx}/boards/${boardType}/${post.id}/comments/${c.id}/delete" style="display:inline;">
                                                <button type="submit" class="btn-comment-del" onclick="return confirm('댓글을 삭제하시겠습니까?')">삭제</button>
                                            </form>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="comment-content"><c:out value="${c.content}" /></div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

        </section>
    </div>
</main>

<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
<script>
var CTX = '${ctx}';
var LIKED = ${liked};

/* ── 좋아요 토글 ── */
function toggleLike(postId, boardType) {
    var btn     = document.getElementById('like-btn');
    var spinner = document.getElementById('like-spinner');
    var icon    = document.getElementById('like-icon');
    var count   = document.getElementById('like-count');

    // 로그인 확인
    var isLoggedIn = ${not empty loginMember ? 'true' : 'false'};
    if (!isLoggedIn) {
        alert('로그인이 필요합니다.');
        window.location.href = CTX + '/login';
        return;
    }

    btn.style.pointerEvents = 'none';
    spinner.style.display   = 'inline-block';
    icon.style.display      = 'none';

    safeFetch(CTX + '/boards/' + boardType + '/' + postId + '/like', {
        method: 'POST',
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
    })
    .then(function(res) { return res.json(); })
    .then(function(data) {
        LIKED = data.liked;
        count.textContent = data.likeCount;
        if (data.liked) { btn.classList.add('liked'); showToast('좋아요를 눌렀어요 ♥', 'ok'); }
        else            { btn.classList.remove('liked'); showToast('좋아요를 취소했어요', 'info'); }
    })
    .catch(function(){})
    .finally(function() {
        spinner.style.display   = 'none';
        icon.style.display      = 'inline';
        btn.style.pointerEvents = 'auto';
    });
}

/* ── 글 삭제 확인 ── */
function confirmDelete() {
    if (confirm('정말로 삭제하시겠습니까? 댓글도 함께 삭제됩니다.')) {
        document.getElementById('deleteForm').submit();
    }
}


</script>
</body>
</html>

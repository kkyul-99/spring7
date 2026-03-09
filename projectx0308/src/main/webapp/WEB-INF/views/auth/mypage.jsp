<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>NEXT DEBUT - 마이페이지</title>
  <%@ include file="/WEB-INF/views/fragments/head-common.jspf" %>
  <link rel="stylesheet" href="<c:url value='/css/auth.css'/>"/>
  <style>
    /* ── 공통 변수 ── */
    :root {
      --pink:  rgb(233,176,196);
      --lav:   rgb(203,186,216);
      --blue:  rgb(186,198,220);
      --bg:    rgba(5,2,18,0.72);
      --card:  rgba(255,255,255,0.045);
      --border:rgba(255,255,255,0.08);
    }

    /* ── 래퍼 ── */
    .mp-page-wrap {
      max-width:520px; margin:0 auto;
      background:rgba(5,2,18,0.72);
      backdrop-filter:blur(28px) saturate(1.4);
      border:1px solid rgba(255,255,255,0.10);
      border-radius:28px;
      padding:36px 32px 32px;
      box-shadow:0 30px 80px rgba(0,0,0,0.55), 0 0 0 1px rgba(255,255,255,0.05) inset;
    }

    /* ── 환영 ── */
    .mp-page-header { text-align:center; margin-bottom:28px; }
    .mp-page-header__name {
      font-family:"Orbitron",sans-serif; font-size:clamp(18px,4vw,26px); font-weight:900;
      background:linear-gradient(110deg,#fff 0%,#f472b6 40%,#c084fc 60%,#60a5fa 100%);
      background-size:220%; -webkit-background-clip:text; background-clip:text;
      -webkit-text-fill-color:transparent;
      animation:mpShimmer 4s ease infinite alternate;
    }
    @keyframes mpShimmer { from{background-position:0%} to{background-position:100%} }
    .mp-page-header__sub {
      font-size:11px; color:rgba(255,255,255,0.35);
      letter-spacing:0.22em; font-family:"Orbitron",sans-serif; margin-top:4px;
    }

    /* ── 프로필 아바타 ── */
    .mp-page-avatar-wrap { display:flex; flex-direction:column; align-items:center; margin-bottom:24px; }
    .mp-page-avatar {
      position:relative; width:100px; height:100px; border-radius:50%; overflow:hidden;
      border:3px solid rgba(233,176,196,0.55);
      box-shadow:0 0 32px rgba(233,176,196,0.30), 0 0 0 7px rgba(233,176,196,0.07);
      cursor:pointer; transition:all 250ms ease;
    }
    .mp-page-avatar:hover { transform:scale(1.04); box-shadow:0 0 48px rgba(233,176,196,0.55), 0 0 0 9px rgba(233,176,196,0.13); }
    .mp-page-avatar img { width:100%; height:100%; object-fit:cover; }
    .mp-page-avatar__placeholder {
      width:100%; height:100%; display:flex; align-items:center; justify-content:center;
      background:linear-gradient(135deg,rgba(233,176,196,0.20),rgba(186,198,220,0.15));
      font-size:40px; color:rgba(255,255,255,0.40);
    }
    .mp-page-avatar__overlay {
      position:absolute; inset:0; background:rgba(0,0,0,0.48);
      display:flex; align-items:center; justify-content:center;
      opacity:0; transition:opacity 200ms; font-size:22px; color:#fff;
    }
    .mp-page-avatar:hover .mp-page-avatar__overlay { opacity:1; }
    .mp-page-avatar__hint { margin-top:8px; font-size:11px; color:rgba(255,255,255,0.40); letter-spacing:0.10em; }

    /* ── 통계 카드 행 ── */
    .mp-stat-row {
      display:grid; grid-template-columns:repeat(3,1fr); gap:10px; margin-bottom:20px;
    }
    .mp-stat-card {
      background:var(--card); border:1px solid var(--border);
      border-radius:14px; padding:14px 10px; text-align:center;
      position:relative; overflow:hidden;
      transition:transform 200ms ease, border-color 200ms ease;
    }
    .mp-stat-card:hover { transform:translateY(-2px); border-color:rgba(233,176,196,0.22); }
    .mp-stat-card::before {
      content:""; position:absolute; top:0; left:0; right:0; height:2px;
      background:var(--accent, linear-gradient(90deg,var(--pink),var(--lav)));
    }
    .mp-stat-card__val {
      font-family:"Orbitron",sans-serif; font-size:20px; font-weight:900;
      color:#fff; margin-bottom:3px;
    }
    .mp-stat-card__label {
      font-size:9px; letter-spacing:0.18em; color:rgba(255,255,255,0.35);
      font-family:"Orbitron",sans-serif;
    }

    /* ── 정보 카드 ── */
    .mp-info-card {
      background:var(--card); border:1px solid var(--border);
      border-radius:16px; padding:14px 18px; margin-bottom:10px;
      display:flex; align-items:center; gap:14px;
    }
    .mp-info-card__icon {
      width:32px; height:32px; border-radius:10px; flex-shrink:0;
      display:flex; align-items:center; justify-content:center; font-size:13px;
      background:linear-gradient(135deg,rgba(233,176,196,0.18),rgba(186,198,220,0.12));
      color:rgba(233,176,196,0.85);
    }
    .mp-info-card__label {
      font-family:"Orbitron",sans-serif; font-size:8px;
      letter-spacing:0.22em; color:rgba(255,255,255,0.30); margin-bottom:4px;
    }
    .mp-info-card__value { font-size:14px; font-weight:700; color:rgba(255,255,255,0.90); }
    .mp-info-card__badge {
      margin-left:auto; font-size:10px; padding:3px 10px; border-radius:999px;
      background:rgba(233,176,196,0.12); border:1px solid rgba(233,176,196,0.22);
      color:rgba(233,176,196,0.75); white-space:nowrap;
    }

    /* ── 구분선 ── */
    .mp-divider {
      height:1px; margin:22px 0;
      background:linear-gradient(90deg,rgba(233,176,196,0.30),transparent 80%);
    }

    /* ── 섹션 헤더 ── */
    .mp-section-title {
      font-family:"Orbitron",sans-serif; font-size:9px; letter-spacing:0.26em;
      color:rgba(255,255,255,0.35); margin-bottom:14px;
      display:flex; align-items:center; justify-content:space-between;
    }
    .mp-section-title button {
      font-family:"Orbitron",sans-serif; font-size:8px; letter-spacing:0.14em;
      padding:4px 12px; border-radius:999px;
      border:1px solid rgba(255,255,255,0.20);
      background:rgba(255,255,255,0.05); color:rgba(255,255,255,0.65);
      cursor:pointer; transition:all 180ms ease;
    }
    .mp-section-title button:hover { background:rgba(255,255,255,0.12); color:#fff; border-color:rgba(255,255,255,0.40); }

    /* ── 접이식 폼 ── */
    .mp-collapse { display:none; margin-bottom:12px; }
    .mp-collapse.open { display:block; }

    /* ── 게임 히스토리 카드 ── */
    .mp-game-card {
      background:rgba(0,0,0,0.28); border:1px solid var(--border);
      border-radius:14px; padding:13px 15px; margin-bottom:9px;
      transition:background 200ms;
    }
    .mp-game-card:hover { background:rgba(255,255,255,0.05); }
    .mp-game-card__header { display:flex; align-items:center; justify-content:space-between; margin-bottom:8px; }
    .mp-game-card__group {
      font-family:"Orbitron",sans-serif; font-size:9px; letter-spacing:0.12em;
      padding:3px 10px; border-radius:999px;
      background:rgba(233,176,196,0.12); border:1px solid rgba(233,176,196,0.22);
      color:rgba(233,176,196,0.85);
    }
    .mp-game-card__phase { font-size:11px; color:rgba(255,255,255,0.35); }
    .mp-game-card__phase.finished { color:rgba(134,239,172,0.75); }
    .mp-game-card__members { display:flex; gap:5px; flex-wrap:wrap; margin-bottom:8px; }
    .mp-game-card__member {
      font-size:11px; padding:2px 8px; border-radius:999px;
      background:rgba(255,255,255,0.06); border:1px solid rgba(255,255,255,0.10);
      color:rgba(255,255,255,0.65);
    }
    .mp-game-card__link {
      font-size:11px; color:rgba(186,198,220,0.70); text-decoration:underline; cursor:pointer;
      transition:color 180ms;
    }
    .mp-game-card__link:hover { color:rgba(186,198,220,1); }

    /* ── 액션 버튼 ── */
    .mp-action-btn {
      width:100%; padding:13px; border-radius:14px;
      font-family:"Orbitron",sans-serif; font-size:9px; font-weight:700; letter-spacing:0.18em;
      cursor:pointer; display:flex; align-items:center; justify-content:center; gap:8px;
      transition:all 220ms cubic-bezier(.22,1.4,.46,.98); margin-top:8px;
    }
    .mp-action-btn--danger {
      border:1px solid rgba(248,113,113,0.30); background:rgba(248,113,113,0.06);
      color:rgba(248,113,113,0.70);
    }
    .mp-action-btn--danger:hover {
      background:rgba(248,113,113,0.16); border-color:rgba(248,113,113,0.55);
      color:rgba(248,113,113,1); transform:translateY(-1px);
    }

    /* ── 토스트 ── */
    .mp-toast {
      padding:12px 18px; border-radius:14px; margin-bottom:16px; font-size:13px;
    }
    .mp-toast--ok { background:rgba(134,239,172,0.12); border:1px solid rgba(134,239,172,0.28); color:rgba(134,239,172,0.90); }
    .mp-toast--err{ background:rgba(248,113,113,0.12); border:1px solid rgba(248,113,113,0.28); color:rgba(248,113,113,0.90); }

    /* ── 빈 기록 ── */
    .mp-no-history { text-align:center; padding:20px 0; color:rgba(255,255,255,0.28); font-size:13px; }

    /* ── 회원탈퇴 모달 ── (기존 유지) ── */
    .withdraw-overlay {
      position:fixed; inset:0; z-index:10000;
      background:rgba(2,1,8,0.88); backdrop-filter:blur(24px);
      display:flex; align-items:center; justify-content:center;
      opacity:0; pointer-events:none; transition:opacity 350ms ease;
    }
    .withdraw-overlay.show { opacity:1; pointer-events:auto; }
    .withdraw-modal {
      position:relative; width:min(520px,94vw);
      border-radius:28px; overflow:hidden;
      background:linear-gradient(160deg,rgba(18,6,36,0.99),rgba(8,3,20,0.99));
      border:1px solid rgba(248,113,113,0.20);
      box-shadow:0 60px 120px rgba(0,0,0,0.90);
      transform:translateY(60px) scale(0.88);
      transition:transform 460ms cubic-bezier(.22,1.4,.46,.98);
    }
    .withdraw-overlay.show .withdraw-modal { transform:translateY(0) scale(1); }
    .withdraw-topbar { height:3px; background:linear-gradient(90deg,rgba(248,113,113,0.9),rgba(251,146,60,0.7)); }
    .withdraw-close {
      position:absolute; top:16px; right:16px; width:30px; height:30px; border-radius:50%;
      background:rgba(255,255,255,0.07); border:1px solid rgba(255,255,255,0.13);
      color:rgba(255,255,255,0.50); font-size:11px;
      display:flex; align-items:center; justify-content:center;
      cursor:pointer; transition:all 220ms ease;
    }
    .withdraw-close:hover { background:rgba(255,255,255,0.17); color:#fff; transform:rotate(90deg); }
    .withdraw-body { padding:28px 28px 24px; }
    .withdraw-title { font-family:"Orbitron",sans-serif; font-size:15px; font-weight:900; color:rgba(248,113,113,0.90); text-align:center; margin-bottom:4px; letter-spacing:0.10em; }
    .withdraw-sub { text-align:center; font-size:11px; color:rgba(255,255,255,0.30); letter-spacing:0.14em; margin-bottom:20px; font-family:"Orbitron",sans-serif; }
    .terms-box { height:220px; overflow-y:auto; background:rgba(255,255,255,0.04); border:1px solid rgba(255,255,255,0.10); border-radius:16px; padding:18px 20px; margin-bottom:16px; font-size:12px; line-height:1.85; color:rgba(255,255,255,0.65); }
    .terms-box::-webkit-scrollbar { width:4px; }
    .terms-box::-webkit-scrollbar-thumb { background:rgba(248,113,113,0.35); border-radius:4px; }
    .terms-box h4 { font-family:"Orbitron",sans-serif; font-size:10px; letter-spacing:0.20em; color:rgba(248,113,113,0.75); margin:16px 0 6px; }
    .terms-box h4:first-child { margin-top:0; }
    .terms-scroll-hint { text-align:center; font-size:10px; color:rgba(248,113,113,0.55); font-family:"Orbitron",sans-serif; letter-spacing:0.14em; margin-bottom:14px; transition:opacity 300ms ease; }
    .withdraw-agree { display:flex; align-items:center; gap:10px; padding:12px 16px; border-radius:12px; border:1px solid rgba(255,255,255,0.10); background:rgba(255,255,255,0.04); margin-bottom:16px; cursor:pointer; }
    .withdraw-agree input[type="checkbox"] { width:16px; height:16px; accent-color:rgba(248,113,113,0.9); cursor:pointer; flex-shrink:0; }
    .withdraw-agree label { font-size:12px; color:rgba(255,255,255,0.70); cursor:pointer; line-height:1.4; }
    .withdraw-agree label span { color:rgba(248,113,113,0.85); font-weight:700; }
    .withdraw-pw-wrap { margin-bottom:16px; display:none; }
    .withdraw-pw-wrap.show { display:block; }
    .withdraw-pw-wrap label { display:block; font-size:11px; color:rgba(255,255,255,0.50); margin-bottom:6px; letter-spacing:0.10em; }
    .withdraw-pw-wrap input { width:100%; padding:12px 16px; border-radius:12px; background:rgba(255,255,255,0.07); border:1px solid rgba(255,255,255,0.15); color:#fff; font-size:14px; outline:none; box-sizing:border-box; }
    .withdraw-pw-wrap input:focus { border-color:rgba(248,113,113,0.50); }
    .withdraw-submit { width:100%; padding:14px; border-radius:14px; background:rgba(248,113,113,0.10); border:1px solid rgba(248,113,113,0.30); color:rgba(248,113,113,0.60); font-family:"Orbitron",sans-serif; font-size:10px; font-weight:700; letter-spacing:0.20em; cursor:not-allowed; transition:all 250ms ease; display:flex; align-items:center; justify-content:center; gap:8px; }
    .withdraw-submit.ready { color:rgba(248,113,113,1); border-color:rgba(248,113,113,0.60); background:rgba(248,113,113,0.15); cursor:pointer; }
    .withdraw-submit.ready:hover { background:rgba(248,113,113,0.25); transform:translateY(-1px); }
  </style>
</head>

<body class="page-main min-h-screen flex flex-col">
  <%@ include file="/WEB-INF/views/fragments/topnav.jspf" %>

  <main class="flex-1 px-6 pb-16" style="padding-top:calc(var(--nav-h) + 32px);">
    <div class="mp-page-wrap">

      <%-- 토스트 --%>
      <c:if test="${not empty toast}">
        <div class="mp-toast mp-toast--ok"><i class="fas fa-check-circle"></i> <c:out value="${toast}"/></div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="mp-toast mp-toast--err"><i class="fas fa-circle-exclamation"></i> <c:out value="${error}"/></div>
      </c:if>

      <%-- 헤더 --%>
      <div class="mp-page-header">
        <div class="mp-page-header__name"><c:out value="${member.nickname}"/>님, 환영합니다 ✨</div>
        <div class="mp-page-header__sub">MY PAGE · PROFILE</div>
      </div>

      <%-- 아바타 --%>
      <div class="mp-page-avatar-wrap">
        <form id="avatarForm" method="post" action="${ctx}/mypage/profile-image"
              enctype="multipart/form-data" style="display:none;">
          <input type="file" id="avatarInput" name="file" accept="image/*"
                 onchange="document.getElementById('avatarForm').submit();" />
        </form>
        <div class="mp-page-avatar" onclick="document.getElementById('avatarInput').click();">
          <c:choose>
            <c:when test="${not empty member.profileImage}">
              <img src="${ctx}/profile-image/${member.profileImage}" alt="프로필"/>
            </c:when>
            <c:otherwise>
              <div class="mp-page-avatar__placeholder"><i class="fas fa-user"></i></div>
            </c:otherwise>
          </c:choose>
          <div class="mp-page-avatar__overlay"><i class="fas fa-camera"></i></div>
        </div>
        <div class="mp-page-avatar__hint">클릭하여 이미지 변경</div>
      </div>

      <%-- 통계 카드 3개 --%>
      <div class="mp-stat-row">
        <div class="mp-stat-card" style="--accent:linear-gradient(90deg,var(--pink),var(--lav));">
          <div class="mp-stat-card__val">${empty gameHistory ? 0 : gameHistory.size()}</div>
          <div class="mp-stat-card__label">TOTAL PLAYS</div>
        </div>
        <div class="mp-stat-card" style="--accent:linear-gradient(90deg,rgba(134,239,172,0.8),var(--lav));">
          <div class="mp-stat-card__val">
            <c:set var="finCount" value="0"/>
            <c:forEach var="r" items="${gameHistory}">
              <c:if test="${r.phase eq 'FINISHED'}"><c:set var="finCount" value="${finCount + 1}"/></c:if>
            </c:forEach>
            ${finCount}
          </div>
          <div class="mp-stat-card__label">COMPLETED</div>
        </div>
        <div class="mp-stat-card" style="--accent:linear-gradient(90deg,var(--lav),var(--blue));">
          <div class="mp-stat-card__val" style="font-size:13px;">${member.createdAtDay}</div>
          <div class="mp-stat-card__label">JOIN DATE</div>
        </div>
      </div>

      <%-- 정보 카드 --%>
      <div class="mp-info-card">
        <div class="mp-info-card__icon"><i class="fas fa-at"></i></div>
        <div>
          <div class="mp-info-card__label">NICKNAME</div>
          <div class="mp-info-card__value"><c:out value="${member.nickname}"/></div>
        </div>
      </div>
      <div class="mp-info-card">
        <div class="mp-info-card__icon"><i class="fas fa-id-badge"></i></div>
        <div>
          <div class="mp-info-card__label">ID</div>
          <div class="mp-info-card__value"><c:out value="${member.mid}"/></div>
        </div>
      </div>
      <div class="mp-info-card">
        <div class="mp-info-card__icon"><i class="fas fa-envelope"></i></div>
        <div>
          <div class="mp-info-card__label">EMAIL</div>
          <div class="mp-info-card__value"><c:out value="${member.email}"/></div>
        </div>
        <span class="mp-info-card__badge">인증됨</span>
      </div>

      <div class="mp-divider"></div>

      <%-- 닉네임 변경 --%>
      <div class="mp-section-title">
        ✦ &nbsp; NICKNAME CHANGE
        <button onclick="toggleCollapse('nickForm')">수정</button>
      </div>
      <div id="nickForm" class="mp-collapse">
        <form method="post" action="${ctx}/mypage/nickname" class="space-y-3 mb-4">
          <div class="form-group">
            <label for="nickname">새 닉네임</label>
            <input type="text" name="nickname" id="nickname"
                   placeholder="한글/영문/숫자, 3~12자" required minlength="3" maxlength="12"/>
          </div>
          <button type="submit" class="auth-submit">닉네임 변경</button>
        </form>
      </div>

      <%-- 이메일 변경 --%>
      <div class="mp-section-title">
        ✦ &nbsp; EMAIL CHANGE
        <button onclick="toggleCollapse('emailForm')">수정</button>
      </div>
      <div id="emailForm" class="mp-collapse">
        <form method="post" action="${ctx}/mypage/email" class="space-y-3 mb-4">
          <div class="form-group">
            <label for="newEmail">새 이메일</label>
            <input type="email" name="newEmail" id="newEmail"
                   placeholder="example@email.com" required/>
          </div>
          <div class="form-group">
            <label for="emailPw">현재 비밀번호 확인</label>
            <input type="password" name="currentPw" id="emailPw"
                   placeholder="비밀번호 입력" required/>
          </div>
          <button type="submit" class="auth-submit">이메일 변경</button>
        </form>
      </div>

      <%-- 비밀번호 변경 --%>
      <div class="mp-section-title">
        ✦ &nbsp; PASSWORD CHANGE
        <button onclick="toggleCollapse('pwForm')">수정</button>
      </div>
      <div id="pwForm" class="mp-collapse">
        <form method="post" action="${ctx}/mypage/password" class="space-y-3 mb-4">
          <div class="form-group">
            <label for="currentPw">현재 비밀번호</label>
            <input type="password" name="currentPw" id="currentPw" placeholder="현재 비밀번호 입력" required/>
          </div>
          <div class="form-group">
            <label for="newPw1">새 비밀번호</label>
            <input type="password" name="newPw1" id="newPw1" placeholder="6자 이상" required minlength="6" oninput="checkMatch()"/>
          </div>
          <div class="form-group">
            <label for="newPw2">새 비밀번호 확인</label>
            <input type="password" name="newPw2" id="newPw2" placeholder="비밀번호 재입력" required minlength="6" oninput="checkMatch()"/>
            <small id="pwMatchMsg" style="display:none;margin-top:6px;font-size:12px;"></small>
          </div>
          <button type="submit" class="auth-submit">비밀번호 변경</button>
        </form>
      </div>

      <div class="mp-divider"></div>

      <%-- 게임 히스토리 --%>
      <div class="mp-section-title">✦ &nbsp; GAME HISTORY</div>
      <c:choose>
        <c:when test="${empty gameHistory}">
          <div class="mp-no-history"><i class="fas fa-gamepad"></i> 아직 플레이 기록이 없어요</div>
        </c:when>
        <c:otherwise>
          <c:forEach var="run" items="${gameHistory}">
            <div class="mp-game-card">
              <div class="mp-game-card__header">
                <span class="mp-game-card__group">
                  <c:choose>
                    <c:when test="${run.groupType eq 'MALE'}"><i class="fas fa-mars fa-xs"></i> 남자 그룹</c:when>
                    <c:when test="${run.groupType eq 'FEMALE'}"><i class="fas fa-venus fa-xs"></i> 여자 그룹</c:when>
                    <c:otherwise><i class="fas fa-venus-mars fa-xs"></i> 혼성 그룹</c:otherwise>
                  </c:choose>
                </span>
                <span class="mp-game-card__phase ${run.phase eq 'FINISHED' ? 'finished' : ''}">
                  <c:choose>
                    <c:when test="${run.phase eq 'FINISHED'}">✔ 완료</c:when>
                    <c:otherwise>${run.phase}</c:otherwise>
                  </c:choose>
                </span>
              </div>
              <div class="mp-game-card__members">
                <c:forEach var="m" items="${run.roster}">
                  <span class="mp-game-card__member">${m.name}</span>
                </c:forEach>
              </div>
              <a href="${ctx}/game/run/${run.runId}/roster" class="mp-game-card__link">
                <i class="fas fa-arrow-right fa-xs"></i> 결과 보기
              </a>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>

      <div class="mp-divider"></div>

      <%-- 회원탈퇴 --%>
      <div class="mp-section-title" style="color:rgba(248,113,113,0.50);">
        ✦ &nbsp; WITHDRAWAL
        <button style="border-color:rgba(248,113,113,0.25);color:rgba(248,113,113,0.60);"
                onclick="openWithdrawModal()">탈퇴하기</button>
      </div>

    </div>
  </main>

  <%-- ═══ 회원탈퇴 모달 ═══ --%>
  <div class="withdraw-overlay" id="withdraw-overlay">
    <div class="withdraw-modal">
      <div class="withdraw-topbar"></div>
      <button class="withdraw-close" onclick="closeWithdrawModal()"><i class="fas fa-times"></i></button>
      <div class="withdraw-body">
        <div class="withdraw-title">⚠ 회원 탈퇴</div>
        <div class="withdraw-sub">WITHDRAWAL · 아래 약관을 끝까지 읽어주세요</div>
        <div class="terms-box" id="terms-box">
          <h4>제 1조 · 탈퇴 안내</h4>
          <p>NEXT DEBUT 서비스에서 탈퇴하시면 회원님의 계정과 관련된 모든 정보가 영구적으로 삭제됩니다. 삭제된 데이터는 복구할 수 없으니 신중하게 결정해 주세요.</p>
          <h4>제 2조 · 삭제되는 데이터</h4>
          <ul>
            <li>회원 계정 정보 (아이디, 이메일, 닉네임, 비밀번호)</li>
            <li>프로필 이미지 및 개인 설정 데이터</li>
            <li>게임 진행 기록 및 육성 결과</li>
            <li>작성한 게시글 및 댓글</li>
          </ul>
          <h4>제 3조 · 보존 기간</h4>
          <p>탈퇴 즉시 모든 개인정보는 파기됩니다. 단, 관계법령에 의해 보존이 필요한 경우 해당 기간 동안 별도 보관 후 파기됩니다.</p>
          <h4>제 4조 · 재가입 안내</h4>
          <p>탈퇴 후 동일한 아이디로 재가입이 가능하나, 이전 데이터는 복구되지 않습니다.</p>
          <h4>제 5조 · 주의사항</h4>
          <p>탈퇴 처리는 즉시 완료되며 취소가 불가능합니다.</p>
          <div style="height:8px;"></div>
          <p style="text-align:center;color:rgba(248,113,113,0.55);font-size:11px;">— 이상으로 탈퇴 약관 안내를 마칩니다 —</p>
        </div>
        <div class="terms-scroll-hint" id="scroll-hint"><i class="fas fa-chevron-down"></i> 아래로 스크롤하여 약관을 끝까지 읽어주세요</div>
        <div class="withdraw-agree" id="agree-wrap" style="opacity:0.35;pointer-events:none;">
          <input type="checkbox" id="agreeCheck" onchange="onAgreeChange()"/>
          <label for="agreeCheck">위 약관을 모두 읽었으며, <span>모든 데이터가 영구 삭제</span>됨에 동의합니다.</label>
        </div>
        <div class="withdraw-pw-wrap" id="pw-wrap">
          <label>비밀번호 확인</label>
          <input type="password" id="withdrawPw" placeholder="탈퇴 확인을 위해 비밀번호를 입력하세요"/>
        </div>
        <form method="post" action="${ctx}/mypage/delete" id="withdraw-form">
          <input type="hidden" name="password" id="withdrawPwHidden"/>
          <button type="button" class="withdraw-submit" id="withdraw-btn" onclick="submitWithdraw()">
            <i class="fas fa-triangle-exclamation"></i> 탈퇴 확인 (비활성)
          </button>
        </form>
      </div>
    </div>
  </div>

  <%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
  <script>
    /* ── 우와~ 효과음 ── */
    (function(){
      try {
        var ac = new (window.AudioContext || window.webkitAudioContext)();
        function beep(f1,f2,s,d,v,t){
          var o=ac.createOscillator(),g=ac.createGain();
          o.connect(g);g.connect(ac.destination);
          o.type=t||'sine';
          o.frequency.setValueAtTime(f1,ac.currentTime+s);
          o.frequency.exponentialRampToValueAtTime(f2,ac.currentTime+s+d);
          g.gain.setValueAtTime(0,ac.currentTime+s);
          g.gain.linearRampToValueAtTime(v,ac.currentTime+s+0.02);
          g.gain.exponentialRampToValueAtTime(0.001,ac.currentTime+s+d);
          o.start(ac.currentTime+s);o.stop(ac.currentTime+s+d+0.05);
        }
        setTimeout(function(){
          beep(300,680,0,.22,.25,'sine'); beep(300,680,0,.22,.10,'triangle');
          beep(680,420,.20,.30,.18,'sine'); beep(900,1100,.10,.12,.06,'sine');
        }, 300);
      } catch(e){}
    })();

    /* ── 접이식 폼 토글 ── */
    function toggleCollapse(id) {
      var el = document.getElementById(id);
      el.classList.toggle('open');
    }

    /* ── 비밀번호 일치 확인 ── */
    function checkMatch() {
      var pw1=document.getElementById('newPw1').value;
      var pw2=document.getElementById('newPw2').value;
      var msg=document.getElementById('pwMatchMsg');
      if(!pw2){msg.style.display='none';return;}
      msg.style.display='block';
      if(pw1===pw2){msg.textContent='✔ 비밀번호가 일치합니다';msg.style.color='rgba(134,239,172,0.9)';}
      else{msg.textContent='✖ 비밀번호가 일치하지 않습니다';msg.style.color='rgba(248,113,113,0.9)';}
    }

    /* ═══ 회원탈퇴 모달 ═══ */
    var termsRead = false;
    function openWithdrawModal() {
      termsRead = false;
      document.getElementById('agreeCheck').checked = false;
      document.getElementById('agree-wrap').style.opacity = '0.35';
      document.getElementById('agree-wrap').style.pointerEvents = 'none';
      document.getElementById('pw-wrap').classList.remove('show');
      document.getElementById('withdrawPw').value = '';
      document.getElementById('scroll-hint').style.opacity = '1';
      setWithdrawBtn(false);
      document.getElementById('terms-box').scrollTop = 0;
      document.getElementById('withdraw-overlay').classList.add('show');
      document.body.style.overflow = 'hidden';
    }
    function closeWithdrawModal() {
      document.getElementById('withdraw-overlay').classList.remove('show');
      document.body.style.overflow = '';
    }
    document.getElementById('terms-box').addEventListener('scroll', function() {
      if (termsRead) return;
      if (this.scrollTop + this.clientHeight >= this.scrollHeight * 0.90) {
        termsRead = true;
        document.getElementById('agree-wrap').style.opacity = '1';
        document.getElementById('agree-wrap').style.pointerEvents = 'auto';
        document.getElementById('scroll-hint').style.opacity = '0';
      }
    });
    function onAgreeChange() {
      var checked = document.getElementById('agreeCheck').checked;
      document.getElementById('pw-wrap').classList.toggle('show', checked);
      if (!checked) setWithdrawBtn(false);
      document.getElementById('withdrawPw').oninput = function() {
        setWithdrawBtn(checked && this.value.length >= 1);
      };
    }
    function setWithdrawBtn(ready) {
      var btn = document.getElementById('withdraw-btn');
      if (ready) {
        btn.classList.add('ready');
        btn.innerHTML = '<i class="fas fa-triangle-exclamation"></i> 최종 탈퇴 확인';
      } else {
        btn.classList.remove('ready');
        btn.innerHTML = '<i class="fas fa-triangle-exclamation"></i> 탈퇴 확인 (비활성)';
      }
    }
    function submitWithdraw() {
      var btn = document.getElementById('withdraw-btn');
      if (!btn.classList.contains('ready')) return;
      var pw = document.getElementById('withdrawPw').value;
      if (!pw) { alert('비밀번호를 입력해주세요.'); return; }
      if (!confirm('정말로 탈퇴하시겠습니까?\n이 작업은 되돌릴 수 없습니다.')) return;
      document.getElementById('withdrawPwHidden').value = pw;
      document.getElementById('withdraw-form').submit();
    }
    document.addEventListener('keydown', function(e){ if(e.key==='Escape') closeWithdrawModal(); });
    document.getElementById('withdraw-overlay').addEventListener('click', function(e){ if(e.target===this) closeWithdrawModal(); });
  </script>
</body>
</html>

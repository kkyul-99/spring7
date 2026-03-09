<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>NEXT DEBUT - 선발 결과</title>
    <%@ include file="/WEB-INF/views/fragments/head-common.jspf" %>
    <style>
        #glitter-canvas { position: fixed; inset: 0; z-index: 0; pointer-events: none; }
        .roster-wrapper { position: relative; z-index: 1; }

        #intro-overlay {
            position: fixed; inset: 0; z-index: 9999;
            display: flex; flex-direction: column; align-items: center; justify-content: center;
            background: #0d0a18;
            animation: overlayFadeOut 600ms ease 2200ms forwards; pointer-events: none;
        }
        @keyframes overlayFadeOut { to { opacity: 0; visibility: hidden; } }

        .spotlight-text {
            font-family: "Orbitron", sans-serif; font-size: clamp(1.4rem, 5vw, 3.2rem); font-weight: 900;
            color: transparent; letter-spacing: 0.18em; text-transform: uppercase;
            background: linear-gradient(120deg, #f9cce0, #d9c6f0, #b8c9e8, #f9cce0); background-size: 300%;
            -webkit-background-clip: text; background-clip: text;
            animation: shimmerText 1.8s linear infinite, textAppear 400ms ease forwards; opacity: 0; text-align: center;
        }
        @keyframes textAppear { to { opacity: 1; } }
        @keyframes shimmerText { 0% { background-position: 0% 50%; } 100% { background-position: 300% 50%; } }
        .spotlight-sub { margin-top: 16px; font-size: 13px; letter-spacing: 0.32em; color: rgba(255,255,255,0.45); font-family: "Orbitron", sans-serif; animation: subAppear 500ms ease 400ms forwards; opacity: 0; }
        @keyframes subAppear { to { opacity: 1; } }
        .spotlight-ray { position: absolute; width: 2px; height: 60vh; top: 0; background: linear-gradient(to bottom, rgba(233,176,196,0.0), rgba(233,176,196,0.45), rgba(204,186,216,0.35), rgba(233,176,196,0.0)); filter: blur(3px); animation: raySwing 2s ease-in-out infinite alternate; transform-origin: top center; }
        .spotlight-ray:nth-child(1) { left: 35%; animation-delay: 0ms; }
        .spotlight-ray:nth-child(2) { left: 50%; animation-delay: 300ms; width: 3px; opacity: 0.7; }
        .spotlight-ray:nth-child(3) { left: 65%; animation-delay: 150ms; }
        @keyframes raySwing { from { transform: rotate(-8deg) scaleY(0.8); opacity: 0.4; } to { transform: rotate(8deg) scaleY(1.1); opacity: 0.9; } }

        .result-kicker {
            font-family: "Orbitron", sans-serif; font-size: 11px; letter-spacing: 0.40em;
            color: rgba(255,255,255,0.45); text-transform: uppercase;
        }
        /* 타이틀 래퍼 */
        .result-title-wrap {
            position: relative; display: inline-block; margin-bottom: 4px;
        }
        /* 홀로그램 글리치 레이어 */
        .result-title-wrap::before, .result-title-wrap::after {
            content: attr(data-text); position: absolute; inset: 0;
            font-family: "Orbitron", sans-serif;
            font-size: clamp(2.2rem, 6vw, 4.8rem); font-weight: 900;
            -webkit-background-clip: text; background-clip: text;
            -webkit-text-fill-color: transparent; pointer-events: none;
        }
        .result-title-wrap::before {
            background: linear-gradient(120deg,#f9a8d4,#e879f9,#818cf8);
            -webkit-background-clip: text; background-clip: text;
            animation: glitch1 3.5s ease-in-out 3.2s infinite; opacity: 0;
        }
        .result-title-wrap::after {
            background: linear-gradient(120deg,#67e8f9,#a5f3fc,#38bdf8);
            -webkit-background-clip: text; background-clip: text;
            animation: glitch2 3.5s ease-in-out 3.2s infinite; opacity: 0;
        }
        @keyframes glitch1 {
            0%,90%,100%{opacity:0;transform:translate(0,0);}
            92%{opacity:0.7;transform:translate(-4px,1px) skewX(-2deg);clip-path:inset(20% 0 60% 0);}
            94%{opacity:0;transform:translate(0,0);}
            96%{opacity:0.5;transform:translate(3px,-1px) skewX(1deg);clip-path:inset(55% 0 10% 0);}
            98%{opacity:0;transform:translate(0,0);}
        }
        @keyframes glitch2 {
            0%,91%,100%{opacity:0;transform:translate(0,0);}
            93%{opacity:0.6;transform:translate(3px,-2px) skewX(2deg);clip-path:inset(40% 0 30% 0);}
            95%{opacity:0;transform:translate(0,0);}
            97%{opacity:0.4;transform:translate(-2px,2px);clip-path:inset(10% 0 75% 0);}
            99%{opacity:0;transform:translate(0,0);}
        }
        /* 메인 타이틀 */
        .result-title {
            font-family: "Orbitron", sans-serif;
            font-size: clamp(2.2rem, 6vw, 4.8rem); font-weight: 900; line-height: 1.05;
            background: linear-gradient(120deg,#fff 0%,#f9cce0 25%,#d9c6f0 50%,#b8c9e8 75%,#f9cce0 100%);
            background-size: 300%;
            -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;
            animation: titleSlideIn 700ms cubic-bezier(.23,1.2,.46,.98) 2400ms both,
                       shimmerTitle 3s linear 3100ms infinite;
            filter: drop-shadow(0 0 40px rgba(233,176,196,0.7)) drop-shadow(0 0 80px rgba(204,186,216,0.4));
            position: relative; z-index: 1;
        }
        @keyframes titleSlideIn {
            from{opacity:0;transform:translateY(32px) scale(0.92);}
            to{opacity:1;transform:translateY(0) scale(1);}
        }
        @keyframes shimmerTitle {
            0%{background-position:0% 50%;} 100%{background-position:300% 50%;}
        }
        /* 스캔라인 */
        .result-title-scanline {
            position:absolute; inset:-4px -8px;
            background:repeating-linear-gradient(0deg,transparent 0px,transparent 3px,rgba(233,176,196,0.04) 3px,rgba(233,176,196,0.04) 4px);
            pointer-events:none; border-radius:4px;
            animation:scanMove 8s linear infinite;
        }
        @keyframes scanMove{0%{background-position:0 0;}100%{background-position:0 100px;}}
        /* 빛나는 언더라인 */
        .result-title-underline {
            display:block; height:3px; margin:8px auto 0; border-radius:999px;
            background:linear-gradient(90deg,transparent 0%,rgba(233,176,196,0.8) 20%,rgba(204,186,216,1) 50%,rgba(186,198,220,0.8) 80%,transparent 100%);
            animation:underlineIn 600ms cubic-bezier(.23,1.2,.46,.98) 3000ms both,
                      underlinePulse 2.5s ease-in-out 3600ms infinite;
            width:0;
        }
        @keyframes underlineIn{from{width:0;opacity:0}to{width:100%;opacity:1}}
        @keyframes underlinePulse{
            0%,100%{box-shadow:0 0 8px rgba(233,176,196,0.4);}
            50%{box-shadow:0 0 24px rgba(233,176,196,0.9),0 0 48px rgba(204,186,216,0.5);}
        }
        /* 타이틀 주변 파티클 캔버스 */
        #title-burst{position:absolute;inset:-80px;pointer-events:none;z-index:0;}

        .group-badge {
            display: inline-flex; align-items: center; gap: 8px; padding: 8px 26px; border-radius: 999px;
            font-family: "Orbitron", sans-serif; font-size: 12px; font-weight: 700; letter-spacing: 0.12em;
            border: 1px solid rgba(255,255,255,0.35);
            background: linear-gradient(135deg, rgba(233,176,196,0.20), rgba(204,186,216,0.15), rgba(186,198,220,0.20));
            backdrop-filter: blur(14px); color: rgba(255,255,255,0.88);
            box-shadow: 0 0 0 1px rgba(255,255,255,0.10) inset, 0 8px 28px rgba(0,0,0,0.14);
            animation: badgeIn 600ms cubic-bezier(.23,1.2,.46,.98) 2700ms both;
        }
        @keyframes badgeIn { from { opacity:0; transform:scale(0.85); } to { opacity:1; transform:scale(1); } }

        .btn-new-game, .btn-start-game {
            display: inline-flex; align-items: center; gap: 10px; padding: 13px 34px; border-radius: 999px;
            font-family: "Orbitron", sans-serif; font-size: 13px; font-weight: 800; letter-spacing: 0.12em;
            border: none; cursor: pointer; text-decoration: none; position: relative; overflow: hidden;
            transition: transform 200ms ease, box-shadow 200ms ease;
            animation: badgeIn 600ms cubic-bezier(.23,1.2,.46,.98) 2900ms both;
        }
        .btn-new-game { color: rgba(255,255,255,0.80); background: rgba(255,255,255,0.08); border: 1px solid rgba(255,255,255,0.28) !important; backdrop-filter: blur(10px); }
        .btn-new-game:hover { background: rgba(255,255,255,0.14); transform: translateY(-3px); }
        .btn-start-game {
            color: rgba(20,10,30,0.90);
            background: linear-gradient(135deg, #f9cce0, #d9c6f0, #b8c9e8);
            box-shadow: 0 12px 36px rgba(233,176,196,0.50), 0 0 0 1px rgba(255,255,255,0.30) inset;
            animation: badgeIn 600ms cubic-bezier(.23,1.2,.46,.98) 2900ms both, startPulse 2.5s ease-in-out 3500ms infinite;
        }
        @keyframes startPulse { 0%,100% { box-shadow: 0 12px 36px rgba(233,176,196,0.50), 0 0 0 1px rgba(255,255,255,0.30) inset; } 50% { box-shadow: 0 18px 52px rgba(233,176,196,0.80), 0 0 0 1px rgba(255,255,255,0.45) inset; } }
        .btn-start-game:hover { transform: translateY(-3px) scale(1.04); }
        .btn-start-game::after { content:""; position:absolute; top:0; left:-80%; width:55%; height:100%; background:linear-gradient(90deg,transparent,rgba(255,255,255,0.40),transparent); transform:skewX(-20deg); animation:shimmer 2.5s ease-in-out 3500ms infinite; }
        @keyframes shimmer { 0%,35%{left:-80%} 100%{left:160%} }

        .roster-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 22px; }
        @media (max-width: 1024px) { .roster-grid { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 560px)  { .roster-grid { grid-template-columns: 1fr; } }

        /* ── 카드 초기: 숨김 상태 ── */
        .trainee-card {
            position: relative; border-radius: 24px; overflow: hidden;
            background: rgba(255,255,255,0.08); border: 1px solid rgba(255,255,255,0.18);
            backdrop-filter: blur(22px); -webkit-backdrop-filter: blur(22px);
            box-shadow: 0 20px 60px rgba(0,0,0,0.22), 0 0 0 1px rgba(255,255,255,0.06) inset;
            /* 초기: 투명 + 블러 + 아래 */
            opacity: 0;
            filter: blur(20px) brightness(0.25) saturate(0);
            transform: translateY(20px) scale(0.96);
            /* transition으로만 처리 — animation 사용 안 함 */
            transition:
                opacity     900ms cubic-bezier(.16,1,.3,1),
                filter      900ms cubic-bezier(.16,1,.3,1),
                transform   900ms cubic-bezier(.16,1,.3,1),
                box-shadow  340ms ease;
        }
        /* 등장: transition으로 부드럽게 */
        .trainee-card.card-show {
            opacity: 1;
            filter: blur(0px) brightness(1) saturate(1);
            transform: translateY(0) scale(1);
        }
        /* 호버 */
        .trainee-card.card-show:hover {
            transform: translateY(-12px) scale(1.03);
            box-shadow: 0 40px 80px rgba(0,0,0,0.32), 0 0 70px rgba(233,176,196,0.22), 0 0 0 1px rgba(255,255,255,0.20) inset;
        }

        /* 등장 직후 카드 위로 빛 스윕 */
        .trainee-card::before { content:""; position:absolute; top:0; left:0; right:0; height:2px; z-index:3; }
        .card-sweep {
            position:absolute; inset:0; z-index:10; pointer-events:none;
            background: linear-gradient(
                135deg,
                transparent 0%,
                transparent 38%,
                rgba(255,255,255,0.18) 48%,
                rgba(255,255,255,0.06) 52%,
                transparent 62%,
                transparent 100%
            );
            background-size: 300% 300%;
            background-position: -100% -100%;
            border-radius: 24px;
            animation: none;
        }
        .card-sweep.do-sweep {
            animation: lightSweep 700ms cubic-bezier(.4,0,.2,1) forwards;
        }
        @keyframes lightSweep {
            0%   { background-position: -100% -100%; opacity:1; }
            100% { background-position:  200%  200%; opacity:0; }
        }
        .trainee-card::before { content:""; position:absolute; top:0; left:0; right:0; height:2px; z-index:3; }
        .trainee-card--male::before   { background:linear-gradient(90deg,transparent,rgba(186,198,220,1),rgba(160,185,240,1),transparent); box-shadow:0 0 18px rgba(186,198,220,0.9),0 0 50px rgba(186,198,220,0.4); }
        .trainee-card--female::before { background:linear-gradient(90deg,transparent,rgba(233,176,196,1),rgba(255,160,210,1),transparent); box-shadow:0 0 18px rgba(233,176,196,0.9),0 0 50px rgba(233,176,196,0.4); }
        .trainee-card::after { content:""; position:absolute; inset:0; border-radius:24px; opacity:0; transition:opacity 340ms ease; pointer-events:none; z-index:1; }
        .trainee-card--male::after   { background: radial-gradient(ellipse at 50% 0%, rgba(186,198,220,0.15), transparent 65%); }
        .trainee-card--female::after { background: radial-gradient(ellipse at 50% 0%, rgba(233,176,196,0.15), transparent 65%); }
        .trainee-card:hover::after   { opacity: 1; }

        .card-image-wrap { position:relative; width:100%; aspect-ratio:3/4; overflow:hidden; }
        .card-image-wrap img { width:100%; height:100%; object-fit:cover; object-position:top center; display:block; transition:transform 500ms cubic-bezier(.23,1,.46,1); }
        .trainee-card:hover .card-image-wrap img { transform: scale(1.08); }
        .card-img-placeholder { width:100%; aspect-ratio:3/4; display:flex; align-items:center; justify-content:center; font-size:60px; color:rgba(255,255,255,0.20); }
        .trainee-card--male   .card-img-placeholder { background:linear-gradient(160deg,rgba(186,198,220,0.18),rgba(160,180,220,0.08)); }
        .trainee-card--female .card-img-placeholder { background:linear-gradient(160deg,rgba(233,176,196,0.18),rgba(220,160,190,0.08)); }
        .card-image-overlay { position:absolute; bottom:0; left:0; right:0; height:58%; background:linear-gradient(to top,rgba(8,6,18,0.92) 0%,rgba(8,6,18,0.45) 52%,transparent 100%); z-index:2; }

        .pick-num { position:absolute; top:12px; left:12px; z-index:4; width:34px; height:34px; border-radius:999px; display:flex; align-items:center; justify-content:center; font-family:"Orbitron",sans-serif; font-weight:900; font-size:13px; color:#fff; border:1.5px solid rgba(255,255,255,0.55); backdrop-filter:blur(10px); }
        .trainee-card--male   .pick-num { background:rgba(186,198,220,0.50); box-shadow:0 0 12px rgba(186,198,220,0.5); }
        .trainee-card--female .pick-num { background:rgba(233,176,196,0.50); box-shadow:0 0 12px rgba(233,176,196,0.5); }

        .card-star-glow { position:absolute; top:12px; right:12px; z-index:4; color:#FFD700; font-size:16px; filter:drop-shadow(0 0 6px rgba(255,215,0,0.9)) drop-shadow(0 0 18px rgba(255,180,0,0.6)); animation:starPulse 1.5s ease-in-out infinite alternate; }
        @keyframes starPulse { from { transform:scale(1); } to { transform:scale(1.25); } }

        .card-img-name { position:absolute; bottom:14px; left:14px; right:14px; z-index:4; }
        .card-img-name .name { font-weight:800; font-size:15px; color:#fff; text-shadow:0 2px 14px rgba(0,0,0,0.7); display:block; margin-bottom:6px; }
        .card-img-name .badges { display:flex; align-items:center; gap:6px; flex-wrap:wrap; }

        .grade-badge { display:inline-flex; align-items:center; justify-content:center; width:24px; height:24px; border-radius:7px; font-size:11px; font-weight:900; font-family:"Orbitron",sans-serif; }
        .grade-s { background:linear-gradient(135deg,#FFD700,#FF8C00); color:#fff; box-shadow:0 0 14px rgba(255,190,0,0.75); animation:gradeGlow 1.8s ease-in-out infinite alternate; }
        @keyframes gradeGlow { from { box-shadow:0 0 8px rgba(255,190,0,0.65); } to { box-shadow:0 0 20px rgba(255,190,0,1.0),0 0 40px rgba(255,150,0,0.5); } }
        .grade-a { background:linear-gradient(135deg,#E8E8F0,#A8A8C8); color:#333; }
        .grade-b { background:linear-gradient(135deg,#CD9B6A,#A0724A); color:#fff; }
        .grade-c { background:rgba(255,255,255,0.18); color:rgba(255,255,255,0.65); border:1px solid rgba(255,255,255,0.25); }
        .gender-badge { display:inline-flex; align-items:center; gap:4px; padding:2px 9px; border-radius:999px; font-size:10px; font-weight:600; border:1px solid rgba(255,255,255,0.28); backdrop-filter:blur(8px); color:rgba(255,255,255,0.88); }
        .gender-badge--male   { background:rgba(186,198,220,0.32); }
        .gender-badge--female { background:rgba(233,176,196,0.32); }

        .card-body { padding:16px; position:relative; z-index:2; }
        .stat-row { display:flex; align-items:center; gap:8px; margin-bottom:8px; }
        .stat-label { font-size:10px; color:rgba(255,255,255,0.50); width:36px; flex-shrink:0; display:flex; align-items:center; gap:4px; }
        .stat-bar-wrap { flex:1; height:5px; border-radius:999px; background:rgba(255,255,255,0.08); overflow:hidden; }
        .stat-bar { height:100%; border-radius:999px; width:0%; transition:width 1000ms cubic-bezier(.23,1,.46,1); position:relative; }
        .stat-bar--vocal    { background:linear-gradient(90deg,#f9cce0,#e890c0); }
        .stat-bar--dance    { background:linear-gradient(90deg,#d9c6f0,#b090e0); }
        .stat-bar--star     { background:linear-gradient(90deg,#ffe0a0,#ffc040); }
        .stat-bar--mental   { background:linear-gradient(90deg,#a0d8f8,#70b0f0); }
        .stat-bar--teamwork { background:linear-gradient(90deg,#a0f0c8,#50d8a0); }
        .stat-bar::after { content:""; position:absolute; right:0; top:0; bottom:0; width:6px; background:rgba(255,255,255,0.70); border-radius:999px; filter:blur(2px); opacity:0; transition:opacity 300ms ease 900ms; }
        .stat-bar.bar-filled::after { opacity:1; }
        .stat-val { font-size:11px; font-weight:700; color:rgba(255,255,255,0.78); width:24px; text-align:right; flex-shrink:0; }
        .card-total { display:flex; align-items:center; justify-content:space-between; margin-top:14px; padding-top:12px; border-top:1px solid rgba(255,255,255,0.08); }
        .total-label { font-size:10px; letter-spacing:0.14em; color:rgba(255,255,255,0.35); text-transform:uppercase; }
        .total-val { font-family:"Orbitron",sans-serif; font-weight:900; font-size:22px; background:linear-gradient(120deg,#f9cce0,#d9c6f0,#b8c9e8); -webkit-background-clip:text; -webkit-text-fill-color:transparent; background-clip:text; filter:drop-shadow(0 0 8px rgba(233,176,196,0.55)); }

        .btn-action { display:inline-flex; align-items:center; gap:9px; padding:13px 30px; border-radius:999px; font-weight:700; font-size:14px; letter-spacing:0.03em; border:1px solid rgba(255,255,255,0.28); transition:transform 200ms ease,box-shadow 200ms ease; animation:btnIn 600ms cubic-bezier(.23,1.2,.46,.98) 3400ms both; }
        @keyframes btnIn { from { opacity:0; transform:translateY(20px); } to { opacity:1; transform:translateY(0); } }
        .btn-action:hover { transform:translateY(-3px); }
        .btn-home { background:rgba(255,255,255,0.08); color:rgba(255,255,255,0.80); backdrop-filter:blur(10px); }
        .btn-home:hover { background:rgba(255,255,255,0.16); }
    </style>
</head>

<body class="page-main min-h-screen flex flex-col">
    <div id="intro-overlay">
        <div class="spotlight-ray"></div><div class="spotlight-ray"></div><div class="spotlight-ray"></div>
        <p class="spotlight-text">✦ 선발 완료 ✦</p>
        <p class="spotlight-sub">THE NEXT DEBUT</p>
    </div>

    <canvas id="glitter-canvas"></canvas>
    <%@ include file="/WEB-INF/views/fragments/topnav.jspf" %>

    <main class="roster-wrapper flex-1 px-4 pb-20" style="padding-top: calc(var(--nav-h) + 44px);">
        <div class="container mx-auto" style="max-width:1180px;">

            <div class="text-center mb-12">
                <p class="result-kicker mb-4">✦ &nbsp; DEBUT SELECTION RESULT &nbsp; ✦</p>
                <div class="result-title-wrap" data-text="선발된 멤버">
                    <canvas id="title-burst"></canvas>
                    <div class="result-title-scanline"></div>
                    <h1 class="result-title mb-2">선발된 멤버</h1>
                    <span class="result-title-underline" id="title-underline"></span>
                </div>
                <div class="mt-4">
                    <c:choose>
                        <c:when test="${result.groupType eq 'MIXED'}"><span class="group-badge"><i class="fas fa-venus-mars"></i> 혼성 그룹 &nbsp;·&nbsp; 남자 2 + 여자 2</span></c:when>
                        <c:when test="${result.groupType eq 'MALE'}"><span class="group-badge"><i class="fas fa-mars"></i> 남자 그룹 &nbsp;·&nbsp; 남자 4명</span></c:when>
                        <c:when test="${result.groupType eq 'FEMALE'}"><span class="group-badge"><i class="fas fa-venus"></i> 여자 그룹 &nbsp;·&nbsp; 여자 4명</span></c:when>
                        <c:otherwise><span class="group-badge"><i class="fas fa-users"></i> ${result.groupType}</span></c:otherwise>
                    </c:choose>
                </div>

                <div class="mt-6 flex items-center justify-center gap-4">
                    <a href="${ctx}/game" class="btn-new-game"><i class="fas fa-rotate-right"></i> NEW GAME</a>
                    <a href="${ctx}/game/run/${result.runId}/start" class="btn-start-game"><i class="fas fa-play"></i> GAME START</a>
                </div>
            </div>

            <div class="roster-grid mb-14">
                <c:forEach var="m" items="${result.roster}">
                    <div class="trainee-card ${m.gender == 'MALE' ? 'trainee-card--male' : 'trainee-card--female'}">
                        <div class="card-sweep"></div>
                        <div class="card-image-wrap">
                            <c:choose>
                                <c:when test="${not empty m.imagePath}">
                                    <img src="${ctx}${m.imagePath}" alt="${m.name}" onerror="this.parentNode.innerHTML='<div class=\'card-img-placeholder\'><i class=\'fas fa-user\'></i></div>'" />
                                </c:when>
                                <c:otherwise><div class="card-img-placeholder"><i class="fas fa-user"></i></div></c:otherwise>
                            </c:choose>
                            <div class="card-image-overlay"></div>
                            <span class="pick-num">${m.pickOrder}</span>
                            <c:if test="${m.grade == 'S'}"><span class="card-star-glow"><i class="fas fa-star"></i></span></c:if>
                            <div class="card-img-name">
                                <span class="name">${m.name}</span>
                                <div class="badges">
                                    <c:choose>
                                        <c:when test="${m.gender == 'MALE'}"><span class="gender-badge gender-badge--male"><i class="fas fa-mars" style="font-size:9px;"></i> 남자</span></c:when>
                                        <c:otherwise><span class="gender-badge gender-badge--female"><i class="fas fa-venus" style="font-size:9px;"></i> 여자</span></c:otherwise>
                                    </c:choose>
                                    <c:choose>
                                        <c:when test="${m.grade == 'S'}"><span class="grade-badge grade-s">S</span></c:when>
                                        <c:when test="${m.grade == 'A'}"><span class="grade-badge grade-a">A</span></c:when>
                                        <c:when test="${m.grade == 'B'}"><span class="grade-badge grade-b">B</span></c:when>
                                        <c:otherwise><span class="grade-badge grade-c">${m.grade}</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="stat-row"><span class="stat-label"><i class="fas fa-microphone-alt" style="color:#f9cce0;font-size:9px;"></i>보컬</span><div class="stat-bar-wrap"><div class="stat-bar stat-bar--vocal" data-width="${m.vocal}"></div></div><span class="stat-val">${m.vocal}</span></div>
                            <div class="stat-row"><span class="stat-label"><i class="fas fa-music" style="color:#d9c6f0;font-size:9px;"></i>댄스</span><div class="stat-bar-wrap"><div class="stat-bar stat-bar--dance" data-width="${m.dance}"></div></div><span class="stat-val">${m.dance}</span></div>
                            <div class="stat-row"><span class="stat-label"><i class="fas fa-star" style="color:#ffe0a0;font-size:9px;"></i>스타</span><div class="stat-bar-wrap"><div class="stat-bar stat-bar--star" data-width="${m.star}"></div></div><span class="stat-val">${m.star}</span></div>
                            <div class="stat-row"><span class="stat-label"><i class="fas fa-brain" style="color:#a0d8f8;font-size:9px;"></i>멘탈</span><div class="stat-bar-wrap"><div class="stat-bar stat-bar--mental" data-width="${m.mental}"></div></div><span class="stat-val">${m.mental}</span></div>
                            <div class="stat-row"><span class="stat-label"><i class="fas fa-users" style="color:#a0f0c8;font-size:9px;"></i>팀웍</span><div class="stat-bar-wrap"><div class="stat-bar stat-bar--teamwork" data-width="${m.teamwork}"></div></div><span class="stat-val">${m.teamwork}</span></div>
                            <div class="card-total"><span class="total-label">TOTAL</span><span class="total-val">${m.vocal + m.dance + m.star + m.mental + m.teamwork}</span></div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="flex justify-center gap-5">
                <a href="${ctx}/main" class="btn-action btn-home"><i class="fas fa-home"></i> 메인으로</a>
            </div>
        </div>
    </main>

    <%@ include file="/WEB-INF/views/fragments/footer.jspf" %>

    <script>
    (function(){
        const canvas=document.getElementById('glitter-canvas'); const ctx=canvas.getContext('2d'); let W,H,particles;
        const COLORS=['rgba(233,176,196,','rgba(204,186,216,','rgba(186,198,220,','rgba(255,225,240,','rgba(255,255,255,'];
        function resize(){W=canvas.width=innerWidth;H=canvas.height=innerHeight;}
        function makeP(){return{x:Math.random()*W,y:Math.random()*H,r:Math.random()*1.8+0.3,alpha:Math.random()*0.6+0.1,vx:(Math.random()-0.5)*0.22,vy:-(Math.random()*0.30+0.08),color:COLORS[Math.floor(Math.random()*COLORS.length)],ts:Math.random()*0.018+0.004,td:Math.random()>0.5?1:-1,isStar:Math.random()<0.12,rot:Math.random()*Math.PI,rotV:(Math.random()-0.5)*0.02};}
        function init(){resize();particles=Array.from({length:110},makeP);}
        let p;
        function draw(){ctx.clearRect(0,0,W,H);for(let i=0;i<particles.length;i++){p=particles[i];p.alpha+=p.ts*p.td;if(p.alpha>0.70||p.alpha<0.06)p.td*=-1;p.x+=p.vx;p.y+=p.vy;if(p.y<-8){p.y=H+4;p.x=Math.random()*W;}if(p.x<-8)p.x=W+4;if(p.x>W+8)p.x=-4;if(p.isStar){p.rot+=p.rotV;ctx.save();ctx.translate(p.x,p.y);ctx.rotate(p.rot);ctx.beginPath();for(let j=0;j<4;j++){const a=(j/4)*Math.PI*2;ctx.moveTo(0,0);ctx.lineTo(Math.cos(a)*p.r*3,Math.sin(a)*p.r*3);}ctx.strokeStyle=p.color+p.alpha+')';ctx.lineWidth=p.r*0.8;ctx.lineCap='round';ctx.stroke();ctx.restore();}else{ctx.beginPath();ctx.arc(p.x,p.y,p.r,0,Math.PI*2);ctx.fillStyle=p.color+p.alpha+')';ctx.fill();}}requestAnimationFrame(draw);}
        window.addEventListener('resize',resize);init();draw();
    })();
    /* ── 스탯바 채우기 ── */
    window.addEventListener('load', function(){
        setTimeout(function(){
            document.querySelectorAll('.stat-bar[data-width]').forEach(function(bar){
                bar.style.width = bar.getAttribute('data-width') + '%';
                setTimeout(function(){ bar.classList.add('bar-filled'); }, 950);
            });
        }, 200);
    });

    /* ── 우와~ 사운드 ── */
    function playRevealSound() {
        try {
            var ac = new(window.AudioContext || window.webkitAudioContext)();
            function tone(f1,f2,s,d,v,t) {
                var o=ac.createOscillator(), g=ac.createGain();
                o.connect(g); g.connect(ac.destination);
                o.type = t||'sine';
                o.frequency.setValueAtTime(f1, ac.currentTime+s);
                o.frequency.exponentialRampToValueAtTime(f2, ac.currentTime+s+d);
                g.gain.setValueAtTime(0, ac.currentTime+s);
                g.gain.linearRampToValueAtTime(v, ac.currentTime+s+0.025);
                g.gain.exponentialRampToValueAtTime(0.001, ac.currentTime+s+d);
                o.start(ac.currentTime+s);
                o.stop(ac.currentTime+s+d+0.06);
            }
            /* 카드 1 등장 */
            tone(180, 520, 0.00, 0.22, 0.18, 'sine');
            tone(180, 520, 0.00, 0.22, 0.07, 'triangle');
            /* 카드 2 */
            tone(260, 620, 0.28, 0.20, 0.14, 'sine');
            tone(260, 620, 0.28, 0.20, 0.05, 'triangle');
            /* 카드 3 */
            tone(320, 700, 0.56, 0.20, 0.13, 'sine');
            tone(320, 700, 0.56, 0.20, 0.05, 'triangle');
            /* 카드 4 — 클라이막스 */
            tone(400, 900, 0.84, 0.28, 0.18, 'sine');
            tone(400, 900, 0.84, 0.28, 0.07, 'triangle');
            tone(900, 600, 1.10, 0.35, 0.14, 'sine');   /* 내려오며 여운 */
            tone(1100,750, 1.00, 0.22, 0.06, 'sine');   /* 하이라이트 반짝 */
        } catch(e) {}
    }

    /* ── 카드 순차 등장 ── */
    setTimeout(function() {
        var cards = document.querySelectorAll('.trainee-card');
        var STEP = 280; /* 카드 간격 ms */

        playRevealSound();

        cards.forEach(function(card, i) {
            setTimeout(function() {
                /* transition으로 부드럽게 — animation 없음, 클래스 한 번만 추가 */
                card.classList.add('card-show');

                /* 선명해지는 타이밍(55%)에 빛 스윕 */
                var sweep = card.querySelector('.card-sweep');
                if (sweep) {
                    setTimeout(function() {
                        sweep.classList.add('do-sweep');
                    }, 900 * 0.55);
                }
            }, i * STEP);
        });
    }, 2350);
    </script>
</body>
</html>

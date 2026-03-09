<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>NEXT DEBUT - GAME START</title>
    <%@ include file="/WEB-INF/views/fragments/head-common.jspf" %>
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <style>
        :root {
            --pink:   #f472b6;
            --purple: #c084fc;
            --blue:   #60a5fa;
            --gold:   #fbbf24;
            --dark:   #07040f;
        }

        /* ══ 로딩 오버레이 ══ */
        #loading-overlay {
            position:fixed; inset:0; z-index:9999;
            background:var(--dark);
            display:flex; flex-direction:column;
            align-items:center; justify-content:center; gap:28px;
            animation:loadOut 600ms ease 2800ms forwards;
        }
        @keyframes loadOut { to { opacity:0; visibility:hidden; } }
        .load-ray {
            position:absolute; width:1px; height:60vh; top:0;
            background:linear-gradient(to bottom,transparent,rgba(196,132,252,0.35),transparent);
            filter:blur(1px);
            animation:raySwing 2.2s ease-in-out infinite alternate;
            transform-origin:top center;
        }
        .load-ray:nth-child(1){ left:25%; }
        .load-ray:nth-child(2){ left:50%; width:2px; animation-delay:500ms; }
        .load-ray:nth-child(3){ left:75%; animation-delay:250ms; }
        @keyframes raySwing { from{transform:rotate(-8deg);opacity:0.3;} to{transform:rotate(8deg);opacity:0.9;} }
        .load-title {
            font-family:"Orbitron",sans-serif;
            font-size:clamp(2rem,6vw,4rem); font-weight:900; letter-spacing:0.25em;
            background:linear-gradient(90deg,#f472b6,#c084fc,#60a5fa,#f472b6);
            background-size:300%; -webkit-background-clip:text; background-clip:text; color:transparent;
            animation:shimmer 1.8s linear infinite, fadeUp 500ms ease forwards; opacity:0;
        }
        .load-sub {
            font-family:"Orbitron",sans-serif; font-size:10px; letter-spacing:0.55em;
            color:rgba(255,255,255,0.25);
            animation:fadeUp 500ms ease 200ms forwards; opacity:0;
        }
        .load-bar-wrap {
            width:min(360px,80vw); height:3px; background:rgba(255,255,255,0.06);
            border-radius:999px; overflow:hidden;
            animation:fadeUp 400ms ease 300ms forwards; opacity:0;
        }
        .load-bar {
            height:100%; width:0%; border-radius:999px;
            background:linear-gradient(90deg,#f472b6,#c084fc,#60a5fa);
            box-shadow:0 0 16px rgba(196,132,252,0.8);
            animation:barFill 2400ms cubic-bezier(.4,0,.2,1) 400ms forwards;
        }
        .load-pct {
            font-family:"Orbitron",sans-serif; font-size:13px; letter-spacing:0.15em;
            color:rgba(255,255,255,0.35);
            animation:fadeUp 400ms ease 300ms forwards; opacity:0;
        }
        .load-hint {
            font-size:11px; color:rgba(255,255,255,0.15); letter-spacing:0.18em;
            animation:blink 1.6s ease-in-out infinite alternate;
        }
        @keyframes shimmer { 0%{background-position:0%;} 100%{background-position:300%;} }
        @keyframes fadeUp  { from{opacity:0;transform:translateY(10px);} to{opacity:1;transform:translateY(0);} }
        @keyframes barFill { to{width:100%;} }
        @keyframes blink   { from{opacity:0.15;} to{opacity:0.5;} }

        /* ══ 베이스 ══ */
        *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
        body {
            background:#0a0612;
            color:#fff;
            font-family:"Noto Sans KR",sans-serif;
            overflow:hidden;
        }

        /* 전체 래퍼 */
        .gs-wrapper {
            position:relative; z-index:1;
            height:calc(100vh - var(--nav-h, 68px));
            margin-top:var(--nav-h, 68px);
            display:flex;
            opacity:0;
            animation:screenIn 700ms cubic-bezier(.23,1.2,.46,.98) 3050ms forwards;
        }
        @keyframes screenIn { from{opacity:0;transform:translateY(12px);} to{opacity:1;transform:translateY(0);} }

        /* 뒤로가기 */
        .btn-back {
            position:fixed; top:calc(var(--nav-h,60px)+14px); right:20px; z-index:200;
            display:inline-flex; align-items:center; gap:7px;
            padding:8px 20px; border-radius:999px;
            font-size:11px; font-weight:700; letter-spacing:0.08em;
            color:rgba(255,255,255,0.60);
            background:rgba(255,255,255,0.07); border:1px solid rgba(255,255,255,0.14);
            backdrop-filter:blur(12px); text-decoration:none;
            transition:all 200ms ease;
            opacity:0; animation:fadeUp 400ms ease 3300ms forwards;
        }
        .btn-back:hover { background:rgba(255,255,255,0.13); color:#fff; }

        /* ════════════════════════════════
           LEFT PANEL — 멤버 카드
        ════════════════════════════════ */
        .panel-left {
            width:420px; flex-shrink:0;
            display:flex; flex-direction:column;
            justify-content:center;
            padding:16px 12px; gap:0;
            overflow-y:auto;
            background:linear-gradient(180deg,rgba(15,8,30,0.97) 0%,rgba(10,5,20,0.95) 100%);
            border-right:1px solid rgba(196,132,252,0.15);
        }
        .panel-left::-webkit-scrollbar { width:3px; }
        .panel-left-inner {
            display:flex; flex-direction:column;
            gap:8px; width:100%;
        }
        .panel-left::-webkit-scrollbar-thumb { background:rgba(196,132,252,0.30); border-radius:999px; }

        .panel-title {
            font-family:"Orbitron",sans-serif;
            font-size:9px; letter-spacing:0.45em;
            color:rgba(255,255,255,0.22); text-align:center;
            padding-bottom:10px;
            border-bottom:1px solid rgba(255,255,255,0.06);
            flex-shrink:0;
        }
        .member-card {
            display:flex; align-items:stretch;
            border-radius:16px; overflow:hidden;
            border:1px solid rgba(255,255,255,0.10);
            background:rgba(255,255,255,0.04);
            height:160px; position:relative;
            transition:transform 280ms cubic-bezier(.23,1.2,.46,.98),box-shadow 280ms ease,border-color 280ms ease;
            opacity:0; animation:cardSlide 500ms cubic-bezier(.23,1.2,.46,.98) forwards;
        }
        .member-card:nth-child(2){animation-delay:3120ms;}
        .member-card:nth-child(3){animation-delay:3200ms;}
        .member-card:nth-child(4){animation-delay:3280ms;}
        .member-card:nth-child(5){animation-delay:3360ms;}
        @keyframes cardSlide { from{opacity:0;transform:translateX(-22px);} to{opacity:1;transform:translateX(0);} }
        .member-card--female:hover { transform:translateX(6px); border-color:rgba(244,114,182,0.45); box-shadow:0 8px 32px rgba(244,114,182,0.18); }
        .member-card--male:hover   { transform:translateX(6px); border-color:rgba(96,165,250,0.45);  box-shadow:0 8px 32px rgba(96,165,250,0.18); }

        .card-photo { width:120px; flex-shrink:0; position:relative; overflow:hidden; }
        .card-photo img { width:100%; height:100%; object-fit:cover; object-position:center top; display:block; }
        .card-photo-placeholder { width:100%; height:100%; display:flex; align-items:center; justify-content:center; font-size:48px; color:rgba(255,255,255,0.15); background:rgba(255,255,255,0.04); }
        .card-photo::after { content:""; position:absolute; inset:0; background:linear-gradient(to right,transparent 60%,rgba(10,5,20,0.85) 100%); }
        .card-pick {
            position:absolute; top:8px; left:8px; z-index:2;
            width:26px; height:26px; border-radius:8px;
            display:flex; align-items:center; justify-content:center;
            font-family:"Orbitron",sans-serif; font-size:12px; font-weight:900; color:#fff;
        }
        .member-card--female .card-pick { background:rgba(244,114,182,0.85); box-shadow:0 0 10px rgba(244,114,182,0.6); }
        .member-card--male   .card-pick { background:rgba(96,165,250,0.85);  box-shadow:0 0 10px rgba(96,165,250,0.6); }

        .card-info { flex:1; padding:12px 14px; display:flex; flex-direction:column; gap:7px; min-width:0; }
        .card-top  { display:flex; align-items:center; justify-content:space-between; gap:6px; }
        .card-name { font-weight:800; font-size:14px; color:rgba(255,255,255,0.95); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; flex:1; }
        .card-total { display:flex; flex-direction:column; align-items:flex-end; flex-shrink:0; }
        .card-total-num {
            font-family:"Orbitron",sans-serif; font-weight:900; font-size:28px;
            background:linear-gradient(120deg,#f472b6,#c084fc,#60a5fa);
            -webkit-background-clip:text; -webkit-text-fill-color:transparent; background-clip:text;
            line-height:1;
        }
        .card-total-label { font-size:11px; color:rgba(255,255,255,0.40); letter-spacing:0.14em; margin-top:2px; }
        .card-badges { display:flex; align-items:center; gap:5px; flex-wrap:wrap; }
        .badge { padding:2px 8px; border-radius:999px; font-size:9px; font-weight:700; border:1px solid rgba(255,255,255,0.15); }
        .badge--female { background:rgba(244,114,182,0.20); color:rgba(244,114,182,0.90); }
        .badge--male   { background:rgba(96,165,250,0.20);  color:rgba(96,165,250,0.90); }
        .grade { width:30px; height:30px; border-radius:8px; display:flex; align-items:center; justify-content:center; font-family:"Orbitron",sans-serif; font-size:13px; font-weight:900; }
        .grade--s { background:linear-gradient(135deg,#fbbf24,#f59e0b); color:#fff; box-shadow:0 0 10px rgba(251,191,36,0.6); }
        .grade--a { background:linear-gradient(135deg,#e2e8f0,#94a3b8); color:#1e293b; }
        .grade--b { background:linear-gradient(135deg,#cd7f32,#a0522d); color:#fff; }
        .grade--c { background:rgba(255,255,255,0.10); color:rgba(255,255,255,0.45); border:1px solid rgba(255,255,255,0.18); }

        .card-stats { display:flex; flex-direction:column; gap:4px; flex:1; }
        .stat-row   { display:flex; align-items:center; gap:6px; }
        .stat-lbl   { font-size:9px; color:rgba(255,255,255,0.45); width:22px; flex-shrink:0; font-weight:600; }
        .stat-track { flex:1; height:5px; border-radius:999px; background:rgba(255,255,255,0.10); overflow:hidden; }
        .stat-fill  { height:100%; border-radius:999px; width:0; transition:width 900ms cubic-bezier(.23,1,.46,1); }
        .stat-fill--v { background:linear-gradient(90deg,#f472b6,#ec4899); }
        .stat-fill--d { background:linear-gradient(90deg,#c084fc,#a855f7); }
        .stat-fill--s { background:linear-gradient(90deg,#fbbf24,#f59e0b); }
        .stat-fill--m { background:linear-gradient(90deg,#60a5fa,#3b82f6); }
        .stat-fill--t { background:linear-gradient(90deg,#34d399,#10b981); }
        .stat-val { font-size:10px; color:rgba(255,255,255,0.65); width:22px; text-align:right; flex-shrink:0; font-weight:700; }

        /* ════════════════════════════════
           DIVIDER
        ════════════════════════════════ */
        .divider {
            width:1px; flex-shrink:0;
            background:linear-gradient(to bottom,transparent 0%,rgba(244,114,182,0.6) 20%,rgba(196,132,252,0.9) 50%,rgba(96,165,250,0.6) 80%,transparent 100%);
            position:relative;
        }
        .divider::before {
            content:"✦"; position:absolute; top:50%; left:50%;
            transform:translate(-50%,-50%);
            color:rgba(196,132,252,0.95); font-size:12px;
            text-shadow:0 0 16px rgba(196,132,252,1),0 0 40px rgba(196,132,252,0.6);
            animation:gem 2.2s ease-in-out infinite alternate;
        }
        @keyframes gem {
            from{opacity:0.6; text-shadow:0 0 16px rgba(196,132,252,0.8);}
            to  {opacity:1;   text-shadow:0 0 28px rgba(196,132,252,1),0 0 60px rgba(244,114,182,0.5);}
        }

        /* ════════════════════════════════
           RIGHT PANEL
        ════════════════════════════════ */
        .panel-right {
            flex:1;
            display:flex; flex-direction:column;
            overflow:hidden;
            background:#0d0920;
            position:relative;
        }

        /* ── DAY 뱃지 (상단 고정) ── */
        .day-bar {
            display:flex; align-items:center; justify-content:space-between;
            padding:10px 24px;
            background:rgba(13,9,32,0.95);
            border-bottom:1px solid rgba(255,255,255,0.07);
            flex-shrink:0; z-index:10;
        }
        .day-left { display:flex; align-items:center; gap:14px; }
        .day-num {
            font-family:"Orbitron",sans-serif; font-size:20px; font-weight:900;
            background:linear-gradient(120deg,#f472b6,#c084fc,#60a5fa);
            -webkit-background-clip:text; -webkit-text-fill-color:transparent; background-clip:text;
        }
        .day-time {
            padding:4px 14px; border-radius:999px;
            font-family:"Orbitron",sans-serif; font-size:9px; font-weight:700; letter-spacing:0.12em;
            background:rgba(251,191,36,0.18); border:1px solid rgba(251,191,36,0.40);
            color:rgba(255,220,80,1);
            animation:pulseBadge 2.4s ease-in-out infinite alternate;
        }
        @keyframes pulseBadge { from{box-shadow:none;} to{box-shadow:0 0 14px rgba(251,191,36,0.35);} }
        .day-dots { display:flex; align-items:center; gap:7px; }
        .day-dot  { width:8px; height:8px; border-radius:999px; background:rgba(255,255,255,0.14); }
        .day-dot.done    { background:linear-gradient(135deg,#f472b6,#60a5fa); }
        .day-dot.current { background:#fbbf24; box-shadow:0 0 10px rgba(251,191,36,0.8); animation:dotPulse 1.4s ease-in-out infinite; }
        @keyframes dotPulse { 0%,100%{transform:scale(1);} 50%{transform:scale(1.35);} }

        /* ════════════════════════════════════════
           씬 이미지 — 화면 꽉 채우는 메인 비주얼
           텍스트와 CHOOSE ACTION 레이블도 그 위에 오버레이
        ════════════════════════════════════════ */
        .scene-full {
            flex:1;
            position:relative;
            overflow:hidden;
            display:flex; flex-direction:column;
        }

        /* 배경 이미지/플레이스홀더 */
        .scene-bg {
            position:absolute; inset:0;
            background:linear-gradient(135deg,
                rgba(30,10,55,1) 0%,
                rgba(15,5,35,1) 40%,
                rgba(10,5,25,1) 100%);
            z-index:0;
        }
        /* 회전 광원 */
        .scene-bg::before {
            content:""; position:absolute; inset:-60%;
            background:conic-gradient(from 0deg at 50% 50%,
                rgba(244,114,182,0.08),rgba(196,132,252,0.14),
                rgba(96,165,250,0.08),rgba(196,132,252,0.14),
                rgba(244,114,182,0.08));
            animation:spinBg 25s linear infinite;
        }
        /* 하단 페이드 → 선택지 영역과 자연스럽게 연결 */
        .scene-bg::after {
            content:""; position:absolute; inset:0;
            background:linear-gradient(to bottom,
                transparent 0%,
                transparent 45%,
                rgba(13,9,32,0.70) 72%,
                rgba(13,9,32,0.96) 90%,
                rgba(13,9,32,1) 100%);
        }
        @keyframes spinBg { to{transform:rotate(360deg);} }

        /* SCENE IMAGE 플레이스홀더 아이콘 (중앙) */
        .scene-icon {
            position:absolute; top:50%; left:50%;
            transform:translate(-50%, -60%);
            display:flex; flex-direction:column; align-items:center; gap:14px;
            z-index:1; pointer-events:none;
        }
        .scene-icon i {
            font-size:72px;
            color:rgba(196,132,252,0.18);
        }
        .scene-icon span {
            font-family:"Orbitron",sans-serif; font-size:11px;
            letter-spacing:0.50em; color:rgba(255,255,255,0.15);
        }

        /* ── 텍스트 오버레이 (씬 위 상단) ── */
        .scene-overlay-top {
            position:relative; z-index:2;
            padding:24px 32px 0;
            flex-shrink:0;
        }
        .event-type {
            display:inline-flex; align-items:center; gap:6px;
            padding:4px 14px; border-radius:6px;
            font-family:"Orbitron",sans-serif; font-size:8px; font-weight:700; letter-spacing:0.22em;
            background:rgba(196,132,252,0.15);
            border:1px solid rgba(196,132,252,0.35);
            color:rgba(220,180,255,1);
            width:fit-content;
            margin-bottom:12px;
        }
        .event-title {
            font-size:20px; font-weight:900;
            color:#ffffff;
            line-height:1.35;
            text-shadow:0 2px 20px rgba(0,0,0,0.8);
            margin-bottom:10px;
        }
        .event-desc {
            font-size:13px;
            color:rgba(255,255,255,0.78);
            line-height:1.85;
            border-left:2px solid rgba(196,132,252,0.50);
            padding-left:16px;
            font-weight:400;
            text-shadow:0 1px 8px rgba(0,0,0,0.6);
            max-width:640px;
        }

        /* ── 하단 오버레이: CHOOSE ACTION 라벨 ── */
        .scene-overlay-bottom {
            position:relative; z-index:2;
            padding:0 32px 16px;
            margin-top:auto;
            display:flex; align-items:center; gap:12px;
        }
        .choices-label {
            font-family:"Orbitron",sans-serif; font-size:9px; letter-spacing:0.40em;
            color:rgba(255,255,255,0.45);
            white-space:nowrap;
        }
        .choices-line { flex:1; height:1px; background:rgba(255,255,255,0.12); }

        /* ════════════════════════════════════════
           ABCD 선택지 — 씬 이미지 아래에 쌓임
        ════════════════════════════════════════ */
        .choices-panel {
            flex-shrink:0;
            background:#0d0920;
            padding:12px 32px 16px;
            display:flex; flex-direction:column; gap:8px;
            border-top:1px solid rgba(196,132,252,0.10);
        }

        /* 각 버튼 — 기본 숨김, JS로 순차 등장 */
        .choice-btn {
            width:100%; display:flex; align-items:center; gap:14px;
            padding:13px 18px; border-radius:14px;
            border:1px solid rgba(255,255,255,0.11);
            background:rgba(255,255,255,0.05);
            cursor:pointer; text-align:left; position:relative;
            transition:all 240ms cubic-bezier(.23,1.2,.46,.98);
            overflow:hidden;
            /* 기본: 숨김 상태 */
            opacity:0;
            transform:translateY(18px);
        }
        /* JS가 .visible 클래스 추가 시 스르륵 등장 */
        .choice-btn.visible {
            animation:slideIn 500ms cubic-bezier(.23,1.2,.46,.98) forwards;
        }
        @keyframes slideIn {
            from { opacity:0; transform:translateY(18px); }
            to   { opacity:1; transform:translateY(0); }
        }
		
        .choice-btn::before {
            content:""; position:absolute; inset:0;
            background:linear-gradient(90deg,rgba(196,132,252,0.10) 0%,transparent 60%);
            opacity:0; transition:opacity 240ms ease;
        }
        .choice-btn:hover::before { opacity:1; }
        .choice-btn:hover {
            background:rgba(255,255,255,0.09);
            border-color:rgba(196,132,252,0.35);
            transform:translateX(5px);
            box-shadow:0 4px 20px rgba(196,132,252,0.14);
        }
        .choice-btn.selected {
            background:linear-gradient(135deg,rgba(244,114,182,0.14),rgba(96,165,250,0.12));
            border-color:rgba(244,114,182,0.55);
            transform:translateX(5px);
            box-shadow:0 6px 28px rgba(244,114,182,0.22);
        }
        .choice-btn.selected::before { opacity:0; }

        .choice-key {
            width:34px; height:34px; border-radius:10px; flex-shrink:0;
            display:flex; align-items:center; justify-content:center;
            font-family:"Orbitron",sans-serif; font-size:14px; font-weight:900;
            background:rgba(255,255,255,0.08); color:rgba(255,255,255,0.50);
            border:1px solid rgba(255,255,255,0.13);
            transition:all 240ms ease;
        }
        .choice-btn.selected .choice-key {
            background:linear-gradient(135deg,rgba(244,114,182,0.85),rgba(196,132,252,0.85));
            color:#fff; border-color:transparent;
            box-shadow:0 0 14px rgba(244,114,182,0.55);
        }
        .choice-btn:hover:not(.selected) .choice-key {
            background:rgba(196,132,252,0.18); color:rgba(255,255,255,0.80); border-color:rgba(196,132,252,0.30);
        }
        .choice-text {
            font-size:13.5px; color:rgba(255,255,255,0.78);
            line-height:1.50; flex:1;
            transition:color 220ms ease; font-weight:500;
        }
        .choice-btn:hover .choice-text    { color:rgba(255,255,255,0.95); }
        .choice-btn.selected .choice-text { color:#ffffff; }

        .choice-check {
            width:24px; height:24px; border-radius:999px; flex-shrink:0;
            display:flex; align-items:center; justify-content:center;
            border:1.5px solid rgba(255,255,255,0.18);
            color:transparent; font-size:11px;
            transition:all 240ms cubic-bezier(.23,1.2,.46,.98);
            background:rgba(255,255,255,0.05);
        }
        .choice-btn.selected .choice-check {
            background:linear-gradient(135deg,#f472b6,#60a5fa);
            border-color:transparent; color:#fff;
            box-shadow:0 0 14px rgba(244,114,182,0.60);
            animation:checkPop 300ms cubic-bezier(.23,1.8,.46,.98);
        }
        @keyframes checkPop { from{transform:scale(0.5);} to{transform:scale(1);} }

        /* ════════════════════════════════════════
           결정하기 버튼 — 선택 전 숨김, 선택 후 팡 등장
        ════════════════════════════════════════ */
        .confirm-wrap {
            flex-shrink:0;
            background:#0d0920;
            padding:0 32px 20px;
            display:flex; justify-content:flex-end;

            /* 기본: 완전 숨김 + 높이 0 */
            max-height:0;
            overflow:hidden;
            opacity:0;
            transition: max-height 500ms cubic-bezier(.23,1.2,.46,.98),
                        opacity    400ms ease,
                        padding    400ms ease;
        }
        /* JS가 .show 추가 시 슬라이드 다운 */
        .confirm-wrap.show {
            max-height:90px;
            opacity:1;
            padding:8px 32px 20px;
        }

        .btn-confirm {
            display:inline-flex; align-items:center; gap:10px;
            padding:16px 52px; border-radius:999px;
            font-family:"Orbitron",sans-serif; font-size:13px; font-weight:900; letter-spacing:0.18em;
            background:linear-gradient(135deg,#f472b6,#c084fc,#60a5fa);
            border:none;
            color:#fff; cursor:pointer;
            box-shadow:0 0 0 0 rgba(244,114,182,0.5);
            animation:btnPulse 1.8s ease-in-out infinite;
            text-shadow:0 1px 6px rgba(0,0,0,0.30);
            transition:transform 220ms ease, box-shadow 220ms ease;
        }
        @keyframes btnPulse {
            0%,100% { box-shadow:0 8px 30px rgba(244,114,182,0.40), 0 0 0 0   rgba(244,114,182,0.30); }
            50%      { box-shadow:0 12px 44px rgba(196,132,252,0.55),0 0 0 10px rgba(244,114,182,0); }
        }
        .btn-confirm:hover {
            transform:translateY(-3px) scale(1.04);
            box-shadow:0 18px 50px rgba(244,114,182,0.50);
        }

        /* ══ 확인 모달 ══ */
        .modal-overlay {
            position:fixed; inset:0; z-index:500;
            background:rgba(7,4,15,0.80); backdrop-filter:blur(8px);
            display:flex; align-items:center; justify-content:center;
            opacity:0; pointer-events:none; transition:opacity 250ms ease;
        }
        .modal-overlay.show { opacity:1; pointer-events:auto; }
        .modal-box {
            background:linear-gradient(145deg,rgba(25,15,48,0.98),rgba(15,8,30,0.99));
            border:1px solid rgba(244,114,182,0.32);
            border-radius:24px; padding:36px 40px;
            width:min(440px,92vw);
            display:flex; flex-direction:column; gap:22px;
            box-shadow:0 30px 80px rgba(0,0,0,0.60),0 0 0 1px rgba(196,132,252,0.08);
            transform:translateY(16px) scale(0.97);
            transition:transform 280ms cubic-bezier(.23,1.2,.46,.98);
        }
        .modal-overlay.show .modal-box { transform:translateY(0) scale(1); }
        .modal-icon  { font-size:36px; text-align:center; }
        .modal-title {
            font-family:"Orbitron",sans-serif; font-size:13px; font-weight:900;
            color:#fff; letter-spacing:0.08em; text-align:center; line-height:1.6;
        }
        .modal-preview {
            background:rgba(255,255,255,0.06); border:1px solid rgba(255,255,255,0.12);
            border-radius:14px; padding:16px 20px;
            font-size:13px; color:rgba(255,255,255,0.80); line-height:1.6; text-align:center;
        }
        .modal-preview strong {
            display:block; font-family:"Orbitron",sans-serif; font-size:10px;
            color:rgba(244,114,182,0.95); margin-bottom:7px; letter-spacing:0.12em;
        }
        .modal-btns   { display:flex; gap:10px; }
        .modal-cancel {
            flex:1; padding:13px; border-radius:14px;
            background:rgba(255,255,255,0.07); border:1px solid rgba(255,255,255,0.14);
            color:rgba(255,255,255,0.65); font-size:13px; font-weight:700;
            cursor:pointer; transition:all 200ms ease;
        }
        .modal-cancel:hover { background:rgba(255,255,255,0.12); color:#fff; }
        .modal-ok {
            flex:2; padding:13px; border-radius:14px;
            background:linear-gradient(135deg,rgba(244,114,182,0.92),rgba(196,132,252,0.92));
            border:1px solid rgba(255,255,255,0.22);
            color:#fff; font-size:13px; font-weight:900;
            cursor:pointer; transition:all 200ms ease;
            box-shadow:0 6px 20px rgba(244,114,182,0.30);
        }
        .modal-ok:hover { transform:translateY(-2px); box-shadow:0 12px 32px rgba(244,114,182,0.45); }

    /* ── 결과 팝업 오버레이 (스탯 변경 알림) ── */
    .result-overlay {
        position: fixed; inset: 0; z-index: 600;
        background: rgba(7,4,15,0.82); backdrop-filter: blur(10px);
        display: flex; align-items: center; justify-content: center;
        opacity: 0; pointer-events: none;
        transition: opacity 300ms ease;
    }
    .result-overlay.show { opacity: 1; pointer-events: auto; }

    .result-card {
        background: linear-gradient(145deg, rgba(22,12,44,0.98), rgba(13,8,28,0.99));
        border-radius: 28px; padding: 44px 48px;
        width: min(480px, 92vw);
        display: flex; flex-direction: column; align-items: center; gap: 24px;
        border: 1px solid rgba(196,132,252,0.30);
        box-shadow: 0 40px 100px rgba(0,0,0,0.65), 0 0 0 1px rgba(196,132,252,0.08);
        transform: translateY(20px) scale(0.96);
        transition: transform 350ms cubic-bezier(.23,1.2,.46,.98);
    }
    .result-overlay.show .result-card { transform: translateY(0) scale(1); }

    /* 연습생 사진 */
    .result-avatar {
        width: 90px; height: 90px; border-radius: 50%; overflow: hidden;
        border: 3px solid rgba(196,132,252,0.50);
        box-shadow: 0 0 24px rgba(196,132,252,0.40);
        flex-shrink: 0;
    }
    .result-avatar img { width: 100%; height: 100%; object-fit: cover; object-position: center top; }
    .result-avatar-placeholder {
        width: 100%; height: 100%; display: flex; align-items: center; justify-content: center;
        font-size: 36px; background: rgba(196,132,252,0.15);
    }

    /* 연습생 이름 */
    .result-name {
        font-size: 18px; font-weight: 900; color: #fff;
        letter-spacing: 0.04em; text-align: center;
    }

    /* 스탯 변화 표시 */
    .result-stat-box {
        display: flex; flex-direction: column; align-items: center; gap: 10px;
        width: 100%;
        padding: 20px 24px; border-radius: 16px;
        background: rgba(255,255,255,0.05);
        border: 1px solid rgba(255,255,255,0.10);
    }
    .result-stat-label {
        font-family: "Orbitron", sans-serif; font-size: 10px; letter-spacing: 0.30em;
        color: rgba(255,255,255,0.35);
    }
    .result-stat-name {
        font-size: 22px; font-weight: 900; color: rgba(255,255,255,0.90);
    }
    .result-stat-change {
        display: flex; align-items: center; gap: 16px;
    }
    .result-before {
        font-family: "Orbitron", sans-serif; font-size: 28px; font-weight: 900;
        color: rgba(255,255,255,0.40);
    }
    .result-arrow {
        font-size: 22px; color: rgba(255,255,255,0.25);
    }
    .result-after {
        font-family: "Orbitron", sans-serif; font-size: 36px; font-weight: 900;
        background: linear-gradient(120deg, #f472b6, #c084fc, #60a5fa);
        -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;
    }
    /* 변화량 뱃지 */
    .result-delta {
        padding: 5px 18px; border-radius: 999px;
        font-family: "Orbitron", sans-serif; font-size: 14px; font-weight: 900;
        animation: deltaPop 400ms cubic-bezier(.23,1.8,.46,.98) 200ms both;
    }
    .result-delta.up   { background: rgba(52,211,153,0.20); border: 1px solid rgba(52,211,153,0.50); color: #34d399; }
    .result-delta.down { background: rgba(248,113,113,0.20); border: 1px solid rgba(248,113,113,0.50); color: #f87171; }
    @keyframes deltaPop { from{transform:scale(0.5);opacity:0;} to{transform:scale(1);opacity:1;} }

    /* 다음 phase 표시 */
    .result-next-phase {
        font-family: "Orbitron", sans-serif; font-size: 10px; letter-spacing: 0.25em;
        color: rgba(255,220,80,0.80);
        padding: 4px 16px; border-radius: 999px;
        background: rgba(251,191,36,0.12); border: 1px solid rgba(251,191,36,0.25);
    }

        /* 파티클 버스트 */
        .burst { position:fixed; pointer-events:none; z-index:9998; }
        .burst-particle {
            position:absolute; width:6px; height:6px; border-radius:999px;
            animation:burst 600ms ease forwards;
        }
        @keyframes burst {
            0%   { transform:translate(0,0) scale(1); opacity:1; }
            100% { transform:translate(var(--tx),var(--ty)) scale(0); opacity:0; }
        }
    </style>
</head>

<body>

<%-- 로딩 오버레이 --%>
<div id="loading-overlay">
    <div class="load-ray"></div>
    <div class="load-ray"></div>
    <div class="load-ray"></div>
    <div class="load-title">NEXT DEBUT</div>
    <div class="load-sub">LOADING GAME . . .</div>
    <div class="load-bar-wrap"><div class="load-bar"></div></div>
    <div class="load-pct" id="load-pct">0%</div>
    <div class="load-hint">선발된 멤버와 함께 데뷔를 향해 달려가세요</div>
</div>

<a href="${ctx}/game/run/${result.runId}/roster" class="btn-back">
    <i class="fas fa-arrow-left"></i> 선발 결과로
</a>

<%@ include file="/WEB-INF/views/fragments/topnav.jspf" %>

<%-- ══ 스탯 변경 결과 오버레이 ══ --%>
<div class="result-overlay" id="result-overlay">
    <div class="result-card">
        <div class="result-avatar" id="res-avatar">
            <div class="result-avatar-placeholder"><i class="fas fa-user"></i></div>
        </div>
        <div class="result-name" id="res-name">연습생</div>
        <div class="result-stat-box">
            <div class="result-stat-label">STAT CHANGE</div>
            <div class="result-stat-name" id="res-stat-name">보컬</div>
            <div class="result-stat-change">
                <span class="result-before" id="res-before">0</span>
                <span class="result-arrow">→</span>
                <span class="result-after" id="res-after">0</span>
            </div>
            <span class="result-delta" id="res-delta">+0</span>
        </div>
        <div class="result-next-phase" id="res-next-phase">NEXT: DAY1_EVENING</div>
        <button class="result-next-btn" id="result-next-btn" class="btn-next-phase" onclick="goNextPhase()">
            다음으로 <i class="fas fa-chevron-right"></i>
        </button>
    </div>
</div>

<%-- ══ 메인 레이아웃 ══ --%>
<div class="gs-wrapper">

    <%-- LEFT: 멤버 카드 --%>
    <div class="panel-left">
        <div class="panel-left-inner">
        <p class="panel-title">✦ SELECTED MEMBERS ✦</p>
        <c:forEach var="m" items="${result.roster}">
            <div class="member-card member-card--${m.gender == 'MALE' ? 'male' : 'female'}" data-trainee-id="${m.traineeId}">
                <div class="card-photo">
                    <c:choose>
                        <c:when test="${not empty m.imagePath}">
                            <img src="${ctx}${m.imagePath}" alt="${m.name}"
                                 onerror="this.parentNode.innerHTML='<div class=\'card-photo-placeholder\'><i class=\'fas fa-user\'></i></div>'" />
                        </c:when>
                        <c:otherwise>
                            <div class="card-photo-placeholder"><i class="fas fa-user"></i></div>
                        </c:otherwise>
                    </c:choose>
                    <span class="card-pick">${m.pickOrder}</span>
                </div>
                <div class="card-info">
                    <div class="card-top">
                        <div class="card-name">${m.name}</div>
                        <div class="card-total">
                            <div class="card-total-num">${m.vocal + m.dance + m.star + m.mental + m.teamwork}</div>
                            <div class="card-total-label">TOTAL</div>
                        </div>
                    </div>
                    <div class="card-badges">
                        <c:choose>
                            <c:when test="${m.gender == 'MALE'}">
                                <span class="badge badge--male"><i class="fas fa-mars" style="font-size:9px;"></i> 남자</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge--female"><i class="fas fa-venus" style="font-size:9px;"></i> 여자</span>
                            </c:otherwise>
                        </c:choose>
                        <c:choose>
                            <c:when test="${m.grade == 'S'}"><span class="grade grade--s">S</span></c:when>
                            <c:when test="${m.grade == 'A'}"><span class="grade grade--a">A</span></c:when>
                            <c:when test="${m.grade == 'B'}"><span class="grade grade--b">B</span></c:when>
                            <c:otherwise><span class="grade grade--c">${m.grade}</span></c:otherwise>
                        </c:choose>
                    </div>
                    <div class="card-stats">
                        <div class="stat-row"><span class="stat-lbl">보컬</span><div class="stat-track"><div class="stat-fill stat-fill--v" data-w="${m.vocal}"></div></div><span class="stat-val" data-key="v">${m.vocal}</span></div>
                        <div class="stat-row"><span class="stat-lbl">댄스</span><div class="stat-track"><div class="stat-fill stat-fill--d" data-w="${m.dance}"></div></div><span class="stat-val" data-key="d">${m.dance}</span></div>
                        <div class="stat-row"><span class="stat-lbl">스타</span><div class="stat-track"><div class="stat-fill stat-fill--s" data-w="${m.star}"></div></div><span class="stat-val" data-key="s">${m.star}</span></div>
                        <div class="stat-row"><span class="stat-lbl">멘탈</span><div class="stat-track"><div class="stat-fill stat-fill--m" data-w="${m.mental}"></div></div><span class="stat-val" data-key="m">${m.mental}</span></div>
                        <div class="stat-row"><span class="stat-lbl">팀웍</span><div class="stat-track"><div class="stat-fill stat-fill--t" data-w="${m.teamwork}"></div></div><span class="stat-val" data-key="t">${m.teamwork}</span></div>
                    </div>
                </div>
            </div>
        </c:forEach>
        </div><%-- end panel-left-inner --%>
    </div>

    <%-- 구분선 --%>
    <div class="divider"></div>

    <%-- RIGHT PANEL --%>
    <div class="panel-right">

        <%-- DAY 뱃지 --%>
        <div class="day-bar">
            <div class="day-left">
                <c:choose>
                    <c:when test="${result.phase == 'DAY1_MORNING' || result.phase == 'DAY1_EVENING'}">
                        <div class="day-num">DAY 1</div>
                    </c:when>
                    <c:when test="${result.phase == 'DAY2_MORNING' || result.phase == 'DAY2_EVENING'}">
                        <div class="day-num">DAY 2</div>
                    </c:when>
                    <c:when test="${result.phase == 'DAY3_MORNING' || result.phase == 'DAY3_EVENING'}">
                        <div class="day-num">DAY 3</div>
                    </c:when>
                    <c:otherwise>
                        <div class="day-num">FINAL</div>
                    </c:otherwise>
                </c:choose>
                <c:choose>
                    <c:when test="${result.phase == 'DAY1_MORNING' || result.phase == 'DAY2_MORNING' || result.phase == 'DAY3_MORNING'}">
                        <div class="day-time">☀ MORNING</div>
                    </c:when>
                    <c:otherwise>
                        <div class="day-time" style="background:rgba(96,165,250,0.18);border-color:rgba(96,165,250,0.40);color:rgba(160,210,255,1);">🌙 EVENING</div>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="day-dots">
                <%-- DAY1_MORNING=1, DAY1_EVENING=2, DAY2_MORNING=3, DAY2_EVENING=4, DAY3_MORNING=5, DAY3_EVENING=6 --%>
                <c:set var="phaseNum" value="1"/>
                <c:if test="${result.phase == 'DAY1_EVENING'}"><c:set var="phaseNum" value="2"/></c:if>
                <c:if test="${result.phase == 'DAY2_MORNING'}"><c:set var="phaseNum" value="3"/></c:if>
                <c:if test="${result.phase == 'DAY2_EVENING'}"><c:set var="phaseNum" value="4"/></c:if>
                <c:if test="${result.phase == 'DAY3_MORNING'}"><c:set var="phaseNum" value="5"/></c:if>
                <c:if test="${result.phase == 'DAY3_EVENING'}"><c:set var="phaseNum" value="6"/></c:if>
                <c:forEach var="i" begin="1" end="6">
                    <c:choose>
                        <c:when test="${i < phaseNum}"><div class="day-dot done"></div></c:when>
                        <c:when test="${i == phaseNum}"><div class="day-dot current"></div></c:when>
                        <c:otherwise><div class="day-dot"></div></c:otherwise>
                    </c:choose>
                </c:forEach>
            </div>
        </div>

        <%-- 씬 이미지 (꽉 차게) + 텍스트 오버레이 --%>
        <div class="scene-full">
            <%-- 배경 --%>
            <div class="scene-bg"></div>

            <%-- 플레이스홀더 아이콘 --%>
            <div class="scene-icon">
                <i class="fas fa-image"></i>
                <span>SCENE IMAGE</span>
            </div>

            <%-- 상단 오버레이: 이벤트 텍스트 (DB 기반) --%>
		    <div class="scene-overlay-top">
		        <div class="event-type">${scene.eventType}</div>
		        <div class="event-title">${scene.title}</div>
		        <div class="event-desc">${scene.description}</div>
		    </div>
		
		    <%-- 하단 오버레이: CHOOSE YOUR ACTION 레이블 --%>
		    <div class="scene-overlay-bottom">
		        <div class="choices-label">▸ CHOOSE YOUR ACTION</div>
		        <div class="choices-line"></div>
		    </div>
		</div>

        <%-- ABCD 선택지 패널 (DB 기반) --%>
        <div class="choices-panel">
            <c:choose>
				<%-- 랜덤 이벤트일 때: 버튼 1개만 표시 --%>
		        <c:when test="${scene.randomEvent}">
		            <button type="button" class="choice-btn visible selected"
		                    id="choice-random"
		            		onclick="triggerRandomEvent()">
		                <div class="choice-key">!</div>
		                <div class="choice-text">랜덤 이벤트 결과보기</div>
		                <div class="choice-check">
		                    <i class="fas fa-bolt"></i>
		                </div>
		            </button>
		        </c:when>

		        <%-- 일반 씬일 때: DB에서 넘어온 선택지 표시 --%>
		        <c:otherwise>
		            <c:forEach var="choice" items="${scene.choices}">
		                <button type="button" class="choice-btn visible"
		                		id="choice-${choice.choiceKey}"
		                		data-label="${choice.choiceKey}"
        						data-text="${choice.choiceText}"
		                        onclick="selectChoice(this, this.dataset.label, this.dataset.text)">
		                    <div class="choice-key">${choice.choiceKey}</div>
		                    <div class="choice-text">${choice.choiceText}</div>
		                    <div class="choice-check">
		                        <i class="fas fa-check"></i>
		                    </div>
		                </button>
		            </c:forEach>
		        </c:otherwise>
            </c:choose>
        </div>

        <%-- 결정하기 버튼 (선택 전 숨김) --%>
        <div class="confirm-wrap" id="confirm-wrap">
            <button type="button" class="btn-confirm" onclick="openModal()">
                결정하기 <i class="fas fa-chevron-right"></i>
            </button>
        </div>

    </div><%-- end panel-right --%>
</div><%-- end gs-wrapper --%>

<script>
/* ── 로딩 퍼센트 ── */
(function(){
    const el = document.getElementById('load-pct');
    const total = 2400, start = Date.now();
    function tick(){
        const n = Math.min(100, Math.floor(((Date.now()-start)/total)*100));
        el.textContent = n + '%';
        if(n < 100) requestAnimationFrame(tick);
    }
    tick();
})();

/* ── 스탯 바 ── */
setTimeout(function(){
    document.querySelectorAll('.stat-fill[data-w]').forEach(function(el){
        el.style.width = el.getAttribute('data-w') + '%';
    });
}, 3200);

/* ── ABCD 순차 등장 ── */
const choiceIds = ['choice-A','choice-B','choice-C','choice-D'];
const APPEAR_START = 3000 + 1000;
choiceIds.forEach(function(id, i){
    setTimeout(function(){
        const el = document.getElementById(id);
        if(el) el.classList.add('visible');
    }, APPEAR_START + i * 160);
});

/* ════════════════════════════════════
   전역 상태
════════════════════════════════════ */
const RUN_ID = '${result.runId}';
const CTX    = '${ctx}';

/* traineeId → imagePath 맵 */
const imageMap = {};
<c:forEach var="m" items="${result.roster}">
imageMap['${m.traineeId}'] = '${m.imagePath}';
</c:forEach>

let selLabel     = '';
let selText      = '';
let nextPhaseVal = '';

/* ════════════════════════════════════
   선택지 클릭
════════════════════════════════════ */
function selectChoice(btn, label, text){
	console.log('selectChoice label =', label);
    console.log('selectChoice text =', text);
	
    document.querySelectorAll('.choice-btn').forEach(b => b.classList.remove('selected'));
    btn.classList.add('selected');
    selLabel = label;
    selText  = text;
    document.getElementById('confirm-wrap').classList.add('show');
    spawnBurst(btn);
}

/* ════════════════════════════════════
   결정하기 → API 호출
════════════════════════════════════ */
function openModal(){
    if(!selLabel) return;
    const confirmBtn = document.querySelector('.btn-confirm');
    confirmBtn.disabled = true;
    confirmBtn.textContent = '처리 중...';

    fetch(CTX + '/game/run/' + RUN_ID + '/choice?key=' + selLabel, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
    })
    .then(res => {
        if(!res.ok) throw new Error('서버 오류 ' + res.status);
        return res.json();
    })
    .then(data => {
        showResult(data);
    })
    .catch(err => {
        alert('오류: ' + err.message);
        confirmBtn.disabled = false;
        confirmBtn.innerHTML = '결정하기 <i class="fas fa-chevron-right"></i>';
    });
}

function triggerRandomEvent(){
    const confirmBtn = document.querySelector('.btn-confirm');
    confirmBtn.disabled = true;
    confirmBtn.textContent = '처리 중...';

    fetch(CTX + '/game/run/' + RUN_ID + '/random-event', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
    })
    .then(res => {
        if(!res.ok) throw new Error('서버 오류 ' + res.status);
        return res.json();
    })
    .then(data => {
        showResult(data);
    })
    .catch(err => {
        alert('오류: ' + err.message);
        confirmBtn.disabled = false;
        confirmBtn.innerHTML = '결정하기 <i class="fas fa-chevron-right"></i>';
    });
}

/* ════════════════════════════════════
   결과 오버레이 표시
════════════════════════════════════ */
function showResult(data){
    nextPhaseVal = data.nextPhase;

    /* 연습생 사진 */
    const imgPath  = imageMap[String(data.traineeId)] || '';
    const avatarEl = document.getElementById('res-avatar');
    if(imgPath){
        avatarEl.innerHTML =
            '<img src="' + CTX + imgPath + '" alt="' + data.traineeName + '" ' +
            'onerror="this.parentNode.innerHTML=\'<div class=\\\'result-avatar-placeholder\\\'><i class=\\\'fas fa-user\\\'></i></div>\'">';
    } else {
        avatarEl.innerHTML = '<div class="result-avatar-placeholder"><i class="fas fa-user"></i></div>';
    }

    /* 텍스트 */
    document.getElementById('res-name').textContent      = data.traineeName;
    document.getElementById('res-stat-name').textContent = data.statName;
    document.getElementById('res-before').textContent    = data.beforeVal;
    document.getElementById('res-after').textContent     = data.afterVal;

    const deltaEl = document.getElementById('res-delta');
    const isUp    = data.delta >= 0;
    deltaEl.textContent = (isUp ? '▲ +' : '▼ ') + data.delta + ' ' + data.statName;
    deltaEl.className   = 'result-delta ' + (isUp ? 'up' : 'down');

    /* 다음 phase */
    document.getElementById('res-next-phase').textContent = '▸ NEXT  ' + phaseToLabel(data.nextPhase);

    /* 왼쪽 카드 스탯 바 실시간 업데이트 */
    updateRosterStats(data.updatedRoster);

    /* 오버레이 표시 */
    document.getElementById('result-overlay').classList.add('show');
    
    const nextBtn = document.getElementById('result-next-btn');
    nextBtn.onclick = function () {
        location.href = CTX + '/game/run/' + RUN_ID + '/start';
    };
    
}

/* phase 코드 → 레이블 */
function phaseToLabel(phase){
    const map = {
        'DAY1_MORNING' : 'DAY 1  ☀ MORNING',
        'DAY1_EVENING' : 'DAY 1  🌙 EVENING',
        'DAY2_MORNING' : 'DAY 2  ☀ MORNING',
        'DAY2_EVENING' : 'DAY 2  🌙 EVENING',
        'DAY3_MORNING' : 'DAY 3  ☀ MORNING',
        'DAY3_EVENING' : 'DAY 3  🌙 EVENING',
        'FINISHED'     : '🎉 DEBUT DAY !'
    };
    return map[phase] || phase;
}

/* 왼쪽 멤버카드 스탯 바 업데이트 */
function updateRosterStats(roster){
    roster.forEach(function(m){
        const card = document.querySelector('.member-card[data-trainee-id="' + m.traineeId + '"]');
        if(!card) return;
        const statMap = { v: m.vocal, d: m.dance, s: m.star, m: m.mental, t: m.teamwork };
        Object.entries(statMap).forEach(function([key, val]){
            const bar   = card.querySelector('.stat-fill--' + key);
            const valEl = card.querySelector('.stat-val[data-key="' + key + '"]');
            if(bar){
                bar.style.transition = 'width 700ms cubic-bezier(.23,1,.46,1)';
                bar.style.width = val + '%';
            }
            if(valEl) valEl.textContent = val;
        });
    });
}

/* ════════════════════════════════════
   다음 씬으로 이동
════════════════════════════════════ */
function goNextPhase(){
    document.getElementById('result-overlay').classList.remove('show');

    if(nextPhaseVal === 'FINISHED'){
        alert('🎉 모든 훈련이 완료되었습니다! 데뷔를 향해 달려가세요!');
        window.location.href = CTX + '/game/run/' + RUN_ID + '/roster';
        return;
    }

    /* 페이드 아웃 후 재로딩 (서버에서 최신 스탯 반환) */
    const wrapper = document.querySelector('.gs-wrapper');
    wrapper.style.transition = 'opacity 500ms ease';
    wrapper.style.opacity    = '0';
    setTimeout(function(){
        window.location.href = CTX + '/game/run/' + RUN_ID + '/start';
    }, 500);
}

/* ── 파티클 버스트 ── */
function spawnBurst(btn){
    const rect   = btn.getBoundingClientRect();
    const cx     = rect.left + rect.width  / 2;
    const cy     = rect.top  + rect.height / 2;
    const colors = ['#f472b6','#c084fc','#60a5fa','#fbbf24','#34d399'];
    const wrap   = document.createElement('div');
    wrap.className = 'burst';
    wrap.style.left = cx + 'px';
    wrap.style.top  = cy + 'px';
    for(let i = 0; i < 16; i++){
        const p     = document.createElement('div');
        p.className = 'burst-particle';
        const angle = (i / 16) * Math.PI * 2;
        const dist  = 45 + Math.random() * 35;
        p.style.setProperty('--tx', Math.cos(angle) * dist + 'px');
        p.style.setProperty('--ty', Math.sin(angle) * dist + 'px');
        p.style.background     = colors[i % colors.length];
        p.style.animationDelay = Math.random() * 80 + 'ms';
        wrap.appendChild(p);
    }
    document.body.appendChild(wrap);
    setTimeout(() => wrap.remove(), 800);
}
</script>

<script>
/* 네비 높이 정확히 계산해서 여백 적용 */
(function(){
    function applyNavHeight(){
        const nav = document.querySelector('nav.premium-glass');
        const wrapper = document.querySelector('.gs-wrapper');
        const btn = document.querySelector('.gs-back-btn') || document.querySelector('[style*="top:calc"]');
        if(!nav || !wrapper) return;
        const h = nav.getBoundingClientRect().height;
        wrapper.style.marginTop = h + 'px';
        wrapper.style.height = 'calc(100vh - ' + h + 'px)';
    }
    if(document.readyState === 'loading'){
        document.addEventListener('DOMContentLoaded', applyNavHeight);
    } else {
        applyNavHeight();
    }
    window.addEventListener('resize', applyNavHeight);
})();
</script>
</body>
</html>

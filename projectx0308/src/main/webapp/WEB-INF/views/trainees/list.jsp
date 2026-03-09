<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>NEXT DEBUT - 아이돌 목록</title>
    <%@ include file="/WEB-INF/views/fragments/head-common.jspf" %>
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&family=Noto+Sans+KR:wght@300;400;700;900&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        /* ══ 이 페이지 전용 — 어두운 배경 오버라이드 ══ */
        body.page-main {
            background: linear-gradient(135deg, #1a0a2e 0%, #0d0618 52%, #0a0f1e 100%) !important;
            background-attachment: fixed !important;
        }
        body.page-main::before {
            background: linear-gradient(135deg, #1a0a2e 0%, #0d0618 52%, #0a0f1e 100%) !important;
            filter: none !important;
        }
        body.page-main::after {
            background:
                radial-gradient(circle at 18% 22%, rgba(233,176,196,0.12), transparent 58%),
                radial-gradient(circle at 78% 30%, rgba(204,186,216,0.10), transparent 60%),
                radial-gradient(circle at 62% 78%, rgba(186,198,220,0.10), transparent 62%) !important;
        }
        /* glass-card 어둡게 */
        .glass-card {
            background: rgba(15, 8, 30, 0.75) !important;
            border-color: rgba(255,255,255,0.10) !important;
            backdrop-filter: blur(24px) !important;
        }


        /* ══ 페이지 헤더 ══ */
        .page-header {
            margin-bottom: 36px;
            opacity: 0;
            animation: fadeUp 600ms cubic-bezier(.23,1.2,.46,.98) 100ms forwards;
        }
        @keyframes fadeUp { from{opacity:0;transform:translateY(18px);} to{opacity:1;transform:translateY(0);} }

        .page-eyebrow {
            font-family: "Orbitron", sans-serif;
            font-size: 9px; letter-spacing: 0.55em;
            color: rgba(233,176,196,0.80);
            margin-bottom: 14px;
            display: flex; align-items: center; gap: 12px;
        }
        .page-eyebrow::before {
            content: ""; width: 32px; height: 1px;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.25));
        }

        .page-title {
            font-family: "Orbitron", sans-serif;
            font-size: clamp(2rem, 5vw, 3.6rem);
            font-weight: 900; line-height: 1.1;
            letter-spacing: -0.02em; margin-bottom: 16px;
            background: linear-gradient(110deg, #fff 0%, #f0e6ff 25%, #f472b6 45%, #c084fc 60%, #60a5fa 78%, #fff 100%);
            background-size: 280%;
            -webkit-background-clip: text; background-clip: text;
            -webkit-text-fill-color: transparent;
            animation: titleShimmer 5s ease-in-out infinite alternate;
        }
        @keyframes titleShimmer { from{background-position:0%;} to{background-position:100%;} }

        .page-sub { font-size: 13px; color: rgba(255,255,255,0.80); line-height: 1.7; }
        .page-sub strong { color: rgba(255,255,255,1.0); font-weight:800; }

        /* ══ 통계 뱃지 ══ */
        .stat-row {
            display: flex; align-items: center; gap: 10px;
            flex-wrap: wrap; margin-top: 20px;
            opacity: 0;
            animation: fadeUp 500ms ease 250ms forwards;
        }
        .stat-chip {
            display: inline-flex; align-items: center; gap: 10px;
            padding: 10px 22px; border-radius: 16px;
            font-family: "Orbitron", sans-serif;
            font-size: 13px; font-weight: 700; letter-spacing: 0.14em;
            border: 1px solid;
            transition: transform 200ms cubic-bezier(.23,1.2,.46,.98), box-shadow 200ms ease;
            position: relative; overflow: hidden;
        }
        .stat-chip::before {
            content: ""; position: absolute; inset: 0;
            background: linear-gradient(110deg, rgba(255,255,255,0.10) 0%, transparent 60%);
            pointer-events: none;
        }
        .stat-chip:hover { transform: translateY(-4px) scale(1.04); }
        .stat-chip .chip-num {
            font-size: 22px; font-weight: 900; line-height: 1;
            display: block;
        }
        .stat-chip .chip-label {
            font-size: 9px; letter-spacing: 0.25em;
            opacity: 0.70; display: block; margin-top: 2px;
        }
        .stat-chip--total  {
            background:rgba(255,255,255,0.10); border-color:rgba(255,255,255,0.30);
            color:rgba(255,255,255,0.95);
            box-shadow: 0 4px 20px rgba(255,255,255,0.08);
        }
        .stat-chip--total:hover { box-shadow: 0 8px 30px rgba(255,255,255,0.15); }
        .stat-chip--s {
            background:rgba(251,191,36,0.14); border-color:rgba(251,191,36,0.45);
            color:rgba(255,220,80,1);
            box-shadow: 0 4px 20px rgba(251,191,36,0.12);
        }
        .stat-chip--s:hover { box-shadow: 0 8px 30px rgba(251,191,36,0.28); }
        .stat-chip--a {
            background:rgba(226,232,240,0.10); border-color:rgba(226,232,240,0.35);
            color:rgba(210,220,230,1);
            box-shadow: 0 4px 20px rgba(226,232,240,0.08);
        }
        .stat-chip--a:hover { box-shadow: 0 8px 30px rgba(226,232,240,0.18); }
        .stat-chip--b {
            background:rgba(205,127,50,0.14); border-color:rgba(205,127,50,0.40);
            color:rgba(220,160,80,1);
            box-shadow: 0 4px 20px rgba(205,127,50,0.10);
        }
        .stat-chip--b:hover { box-shadow: 0 8px 30px rgba(205,127,50,0.24); }
        .stat-chip--c {
            background:rgba(255,255,255,0.08); border-color:rgba(255,255,255,0.22);
            color:rgba(200,200,200,1.0);
        }

        /* ══ 필터 탭 ══ */
        .filter-bar {
            display: flex; align-items: center; gap: 8px;
            margin-bottom: 28px;
            opacity: 0;
            animation: fadeUp 500ms ease 350ms forwards;
        }
        .filter-tab {
            padding: 8px 22px; border-radius: 999px;
            font-family: "Orbitron", sans-serif;
            font-size: 10px; font-weight: 700; letter-spacing: 0.16em;
            border: 1px solid rgba(255,255,255,0.12);
            background: rgba(255,255,255,0.05);
            color: rgba(255,255,255,0.80);
            text-decoration: none;
            transition: all 220ms ease;
        }
        .filter-tab:hover { background:rgba(255,255,255,0.14); color:rgba(255,255,255,1.0); }
        .filter-tab.active {
            background: linear-gradient(135deg, rgba(233,176,196,0.30), rgba(186,198,220,0.25));
            border-color: rgba(203,186,216,0.65);
            color: #fff;
            box-shadow: 0 0 18px rgba(203,186,216,0.30);
            font-weight: 900;
        }
        .filter-tab--male.active   { background:rgba(186,198,220,0.28); border-color:rgba(186,198,220,0.65); color:#dce8f0; box-shadow:0 0 18px rgba(186,198,220,0.30); font-weight:900; }
        .filter-tab--female.active { background:rgba(233,176,196,0.28); border-color:rgba(233,176,196,0.65); color:#f5d0e0; box-shadow:0 0 18px rgba(233,176,196,0.30); font-weight:900; }

        /* ══ 카드 그리드 ══ */
        .trainee-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
            gap: 16px;
        }
        @media (max-width: 480px) { .trainee-grid { grid-template-columns: repeat(2, 1fr); } }

        /* ══ 연습생 카드 ══ */
        .trainee-card {
            position: relative;
            border-radius: 20px; overflow: hidden;
            border: 1px solid rgba(255,255,255,0.08);
            background: rgba(255,255,255,0.04);
            cursor: pointer;
            transition: transform 280ms cubic-bezier(.23,1.2,.46,.98),
                        box-shadow 280ms ease, border-color 280ms ease;
            opacity: 0;
            animation: cardIn 500ms cubic-bezier(.23,1.2,.46,.98) both;
        }
        @keyframes cardIn { from{opacity:0;transform:translateY(22px) scale(0.97);} to{opacity:1;transform:translateY(0) scale(1);} }
        .trainee-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 20px 50px rgba(0,0,0,0.35);
        }
        .trainee-card--male:hover   { border-color:rgba(96,165,250,0.35);  box-shadow:0 20px 50px rgba(0,0,0,0.35),0 0 28px rgba(96,165,250,0.14); }
        .trainee-card--female:hover { border-color:rgba(244,114,182,0.35); box-shadow:0 20px 50px rgba(0,0,0,0.35),0 0 28px rgba(244,114,182,0.14); }

        /* 카드 상단 빛줄기 */
        .card-beam {
            position: absolute; top: 0; left: 20%; right: 20%; height: 1.5px;
            border-radius: 999px; opacity: 0;
            transition: opacity 280ms ease, left 280ms ease, right 280ms ease;
        }
        .trainee-card--male   .card-beam { background:linear-gradient(90deg,transparent,#60a5fa,transparent); box-shadow:0 0 12px rgba(96,165,250,0.8); }
        .trainee-card--female .card-beam { background:linear-gradient(90deg,transparent,#f472b6,transparent); box-shadow:0 0 12px rgba(244,114,182,0.8); }
        .trainee-card:hover .card-beam { opacity:1; left:0; right:0; }

        /* 사진 영역 */
        .card-photo {
            width: 100%; aspect-ratio: 3/4;
            overflow: hidden; position: relative;
            background: rgba(255,255,255,0.04);
        }
        .card-photo img {
            width: 100%; height: 100%;
            object-fit: cover; object-position: center top;
            transition: transform 400ms ease;
        }
        .trainee-card:hover .card-photo img { transform: scale(1.06); }
        .card-photo-placeholder {
            width: 100%; height: 100%;
            display: flex; align-items: center; justify-content: center;
            font-size: 52px; color: rgba(255,255,255,0.10);
        }

        /* 사진 하단 그라디언트 오버레이 */
        .card-photo::after {
            content: "";
            position: absolute; inset: 0;
            background: linear-gradient(to bottom,
                transparent 40%,
                rgba(7,3,15,0.75) 80%,
                rgba(7,3,15,0.95) 100%);
        }

        /* 등급 뱃지 (사진 위 좌상단) */
        .card-grade {
            position: absolute; top: 10px; left: 10px; z-index: 2;
            width: 30px; height: 30px; border-radius: 9px;
            display: flex; align-items: center; justify-content: center;
            font-family: "Orbitron", sans-serif; font-size: 13px; font-weight: 900;
            color: #fff;
        }
        .grade-s { background:linear-gradient(135deg,#fbbf24,#f59e0b); box-shadow:0 0 14px rgba(251,191,36,0.70); animation:gradePulse 2s ease-in-out infinite alternate; }
        .grade-a { background:linear-gradient(135deg,#e2e8f0,#94a3b8); color:#1e293b; }
        .grade-b { background:linear-gradient(135deg,#cd7f32,#a0522d); box-shadow:0 0 8px rgba(205,127,50,0.50); }
        .grade-c { background:rgba(255,255,255,0.12); border:1px solid rgba(255,255,255,0.22); color:rgba(255,255,255,0.50); }
        @keyframes gradePulse {
            from { box-shadow:0 0 10px rgba(251,191,36,0.55); }
            to   { box-shadow:0 0 22px rgba(251,191,36,0.90), 0 0 40px rgba(251,191,36,0.30); }
        }

        /* 성별 뱃지 (사진 위 우상단) */
        .card-gender {
            position: absolute; top: 10px; right: 10px; z-index: 2;
            width: 24px; height: 24px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 11px;
        }
        .gender-male   { background:rgba(96,165,250,0.25);  border:1px solid rgba(96,165,250,0.50);  color:#93c5fd; }
        .gender-female { background:rgba(244,114,182,0.25); border:1px solid rgba(244,114,182,0.50); color:#f9a8d4; }

        /* 이름 (사진 위 하단 오버레이) */
        .card-name-overlay {
            position: absolute; bottom: 0; left: 0; right: 0; z-index: 2;
            padding: 10px 12px 12px;
            display: flex; flex-direction: column; gap: 2px;
        }
        .card-name {
            font-weight: 800; font-size: 15px;
            color: rgba(255,255,255,0.96);
            line-height: 1.2;
            text-shadow: 0 1px 8px rgba(0,0,0,0.6);
        }
        .card-number {
            font-family: "Orbitron", sans-serif;
            font-size: 9px; letter-spacing: 0.20em;
            color: rgba(255,255,255,0.35);
        }

        /* ══ 빈 상태 ══ */
        .empty-state {
            grid-column: 1 / -1;
            padding: 80px 24px; text-align: center;
        }
        .empty-icon { font-size: 56px; color: rgba(255,255,255,0.08); margin-bottom: 16px; }
        .empty-text { font-family:"Orbitron",sans-serif; font-size:12px; letter-spacing:0.20em; color:rgba(255,255,255,0.22); }

        /* ══ 섹션 구분선 (성별별 헤더) ══ */
        .section-divider {
            grid-column: 1 / -1;
            display: flex; align-items: center; gap: 12px;
            padding: 8px 0 4px;
            opacity: 0;
            animation: fadeUp 400ms ease both;
        }
        .section-divider-label {
            font-family: "Orbitron", sans-serif;
            font-size: 9px; letter-spacing: 0.40em;
            white-space: nowrap;
        }
        .section-divider--male   .section-divider-label { color:rgba(96,165,250,0.80); }
        .section-divider--female .section-divider-label { color:rgba(244,114,182,0.80); }
        .section-divider-line {
            flex: 1; height: 1px;
        }
        .section-divider--male   .section-divider-line { background:linear-gradient(90deg,rgba(96,165,250,0.40),transparent); }
        .section-divider--female .section-divider-line { background:linear-gradient(90deg,rgba(244,114,182,0.40),transparent); }

        /* ══ 모달 ══ */
        /* ══ 모달 오버레이 ══ */
        .idol-modal-overlay {
            position: fixed; inset: 0; z-index: 9999;
            background: rgba(2,1,8,0.92);
            backdrop-filter: blur(20px) saturate(1.4);
            display: flex; align-items: center; justify-content: center;
            padding: 20px;
            opacity: 0; pointer-events: none;
            transition: opacity 350ms ease;
        }
        .idol-modal-overlay.show { opacity: 1; pointer-events: auto; }

        /* ══ 모달 컨테이너 ══ */
        .idol-modal {
            position: relative;
            display: flex; gap: 0;
            border-radius: 32px; overflow: hidden;
            border: 1px solid rgba(255,255,255,0.10);
            box-shadow:
                0 0 0 1px rgba(255,255,255,0.05) inset,
                0 50px 120px rgba(0,0,0,0.80),
                0 0 80px rgba(233,176,196,0.08);
            max-width: 720px; width: 100%;
            max-height: 90vh;
            transform: translateY(40px) scale(0.92) rotateX(4deg);
            transition: transform 500ms cubic-bezier(.23,1.2,.46,.98);
        }
        .idol-modal-overlay.show .idol-modal {
            transform: translateY(0) scale(1) rotateX(0deg);
        }

        /* ══ 사진 패널 ══ */
        .modal-photo-panel {
            width: 300px; flex-shrink: 0;
            position: relative; overflow: hidden;
            background: #0a0612;
            min-height: 480px;
        }
        .modal-photo-panel img {
            width: 100%; height: 100%;
            object-fit: cover; object-position: center top;
            display: block;
            transition: transform 600ms ease;
        }
        .idol-modal-overlay.show .modal-photo-panel img {
            transform: scale(1.04);
        }

        /* 사진 하단 그라디언트 */
        .modal-photo-panel::after {
            content: ""; position: absolute;
            bottom: 0; left: 0; right: 0; height: 55%;
            background: linear-gradient(0deg, rgba(5,2,15,0.95) 0%, transparent 100%);
            pointer-events: none; z-index: 1;
        }

        /* 파티클 반짝임 (사진 위) */
        .modal-photo-sparkle {
            position: absolute; inset: 0; pointer-events: none; z-index: 2;
            overflow: hidden;
        }
        .modal-photo-sparkle i {
            position: absolute; border-radius: 50%;
            animation: modalSparkle 3s ease-in-out infinite;
            opacity: 0;
        }
        @keyframes modalSparkle {
            0%,100% { opacity:0; transform:scale(0.5) translateY(0); }
            50%     { opacity:1; transform:scale(1.4) translateY(-6px); }
        }

        .modal-photo-placeholder {
            width: 100%; height: 100%; min-height: 480px;
            display: flex; align-items: center; justify-content: center;
            font-size: 80px; color: rgba(255,255,255,0.06);
        }

        /* 등급 뱃지 (사진 위 왼쪽) */
        .modal-grade {
            position: absolute; top: 18px; left: 18px; z-index: 3;
            width: 44px; height: 44px; border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-family: "Orbitron", sans-serif; font-size: 18px; font-weight: 900;
            color: #fff;
            animation: gradeBadgePop 600ms cubic-bezier(.23,1.5,.46,.98) 300ms both;
        }
        @keyframes gradeBadgePop {
            from { transform: scale(0) rotate(-20deg); opacity:0; }
            to   { transform: scale(1) rotate(0deg);   opacity:1; }
        }

        /* ══ 정보 패널 ══ */
        .modal-info-panel {
            flex: 1;
            background: linear-gradient(160deg, rgba(12,6,28,0.99), rgba(6,3,16,1));
            padding: 36px 30px 28px;
            display: flex; flex-direction: column; gap: 18px;
            overflow-y: auto;
            color: #fff !important;
            position: relative;
        }

        /* 우측 상단 빛 오브 */
        .modal-info-panel::before {
            content: ""; position: absolute;
            top: -40px; right: -40px; width: 200px; height: 200px;
            border-radius: 50%;
            background: var(--modal-orb, radial-gradient(circle, rgba(233,176,196,0.15), transparent 70%));
            pointer-events: none;
            animation: orbPulse 4s ease-in-out infinite;
        }
        @keyframes orbPulse {
            0%,100% { transform: scale(1);    opacity:0.7; }
            50%     { transform: scale(1.15); opacity:1.0; }
        }

        /* 닫기 버튼 */
        .modal-close {
            position: absolute; top: 16px; right: 16px; z-index: 10;
            width: 34px; height: 34px; border-radius: 50%;
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.14);
            color: rgba(255,255,255,0.55); font-size: 13px;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer;
            transition: all 220ms cubic-bezier(.23,1.2,.46,.98);
            backdrop-filter: blur(8px);
        }
        .modal-close:hover {
            background: rgba(255,255,255,0.18); color: #fff;
            transform: scale(1.15) rotate(90deg);
            border-color: rgba(255,255,255,0.35);
        }

        /* 이름 */
        .modal-name {
            font-size: 28px; font-weight: 900;
            background: linear-gradient(120deg, #fff 0%, rgba(255,255,255,0.85) 100%);
            -webkit-background-clip: text; background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: 0.02em; line-height: 1.2;
            opacity: 0;
            animation: modalTextIn 400ms ease 150ms forwards;
        }
        .modal-number {
            font-family: "Orbitron", sans-serif; font-size: 10px;
            letter-spacing: 0.35em; color: rgba(255,255,255,0.25);
            margin-top: 2px;
        }

        /* 뱃지 */
        .modal-badges { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
        .modal-badge {
            padding: 5px 14px; border-radius: 999px;
            font-family: "Orbitron", sans-serif;
            font-size: 9px; font-weight: 700; letter-spacing: 0.16em;
            opacity: 0;
            animation: modalTextIn 400ms ease 250ms forwards;
        }
        .modal-badge--male   { background:rgba(96,165,250,0.18); border:1px solid rgba(96,165,250,0.45); color:#93c5fd; }
        .modal-badge--female { background:rgba(244,114,182,0.18); border:1px solid rgba(244,114,182,0.45); color:#f9a8d4; }
        .modal-badge--grade-s { background:rgba(251,191,36,0.22); border:1px solid rgba(251,191,36,0.55); color:gold; box-shadow:0 0 12px rgba(251,191,36,0.30); }
        .modal-badge--grade-a { background:rgba(226,232,240,0.12); border:1px solid rgba(226,232,240,0.35); color:rgba(210,220,230,1); }
        .modal-badge--grade-b { background:rgba(205,127,50,0.18); border:1px solid rgba(205,127,50,0.45); color:rgba(220,160,80,1); }
        .modal-badge--grade-c { background:rgba(255,255,255,0.06); border:1px solid rgba(255,255,255,0.16); color:rgba(180,180,180,0.80); }

        /* 구분선 */
        .modal-divider {
            height: 1px;
            background: linear-gradient(90deg, var(--modal-line,rgba(233,176,196,0.35)), transparent 80%);
        }

        /* 프로필 테이블 */
        .modal-profile-table { width:100%; border-collapse:collapse; font-size:13px; }
        .modal-profile-table tr { border-bottom:1px solid rgba(255,255,255,0.06); }
        .modal-profile-table tr:last-child { border-bottom:none; }
        .modal-profile-table td { padding:9px 4px; vertical-align:middle; line-height:1.5; color:#fff !important; }
        .modal-profile-table td:first-child {
            font-family:"Orbitron",sans-serif; font-size:8px; letter-spacing:0.22em;
            color:rgba(255,255,255,0.38) !important; white-space:nowrap; width:72px; padding-right:14px;
        }
        .modal-profile-empty { color:rgba(255,255,255,0.22) !important; font-style:italic; font-size:12px; }
        .modal-insta-link {
            color:rgba(203,186,216,0.90); text-decoration:none;
            display:inline-flex; align-items:center; gap:5px; transition:color 200ms ease;
        }
        .modal-insta-link:hover { color:rgba(233,176,196,1); }

        /* 힌트 */
        .modal-hint {
            margin-top: auto;
            font-size: 10px; color: rgba(255,255,255,0.15);
            letter-spacing: 0.12em; text-align: center;
        }

        /* 모달 빛 오브 */
        .modal-glow { display:none; }

        /* 등장 애니메이션 */
        @keyframes modalTextIn {
            from { opacity:0; transform:translateY(10px); }
            to   { opacity:1; transform:translateY(0); }
        }

        /* 반응형 */
        @media (max-width: 560px) {
            .idol-modal { flex-direction: column; max-height: 92vh; }
            .modal-photo-panel { width: 100%; min-height: 260px; max-height: 260px; }
            .modal-photo-panel::after { height:40%; }
            .modal-info-panel { padding: 22px 20px; }
        }
    </style>
</head>

<body class="page-main min-h-screen flex flex-col">
<%@ include file="/WEB-INF/views/fragments/topnav.jspf" %>

<main class="flex-1 px-6 pb-16" style="padding-top: calc(var(--nav-h) + 32px);">
    <div class="container mx-auto max-w-5xl">

        <section class="glass-card p-8 md:p-10">

            <%-- 페이지 헤더 --%>
            <div class="page-header">
                <div class="page-eyebrow">NEXT DEBUT</div>
                <h1 class="page-title">아이돌 명단</h1>
                <p class="page-sub">
                    데뷔를 꿈꾸는 연습생들입니다.
                    총 <strong>${totalCount}명</strong>이 등록되어 있습니다.
                </p>

                <%-- 통계 뱃지 --%>
                <div class="stat-row">
                    <span class="stat-chip stat-chip--total">
                        <i class="fas fa-users" style="font-size:14px;"></i>
                        <span><span class="chip-num">${totalCount}</span><span class="chip-label">TOTAL</span></span>
                    </span>
                    <c:if test="${cntS > 0}">
                        <span class="stat-chip stat-chip--s">
                            <i class="fas fa-crown" style="font-size:14px;"></i>
                            <span><span class="chip-num">${cntS}명</span><span class="chip-label">S GRADE</span></span>
                        </span>
                    </c:if>
                    <c:if test="${cntA > 0}">
                        <span class="stat-chip stat-chip--a">
                            <i class="fas fa-star" style="font-size:14px;"></i>
                            <span><span class="chip-num">${cntA}명</span><span class="chip-label">A GRADE</span></span>
                        </span>
                    </c:if>
                    <c:if test="${cntB > 0}">
                        <span class="stat-chip stat-chip--b">
                            <i class="fas fa-star-half-stroke" style="font-size:14px;"></i>
                            <span><span class="chip-num">${cntB}명</span><span class="chip-label">B GRADE</span></span>
                        </span>
                    </c:if>
                    <c:if test="${cntC > 0}">
                        <span class="stat-chip stat-chip--c">
                            <i class="fas fa-circle" style="font-size:10px;"></i>
                            <span><span class="chip-num">${cntC}명</span><span class="chip-label">C GRADE</span></span>
                        </span>
                    </c:if>
                </div>
            </div>

            <%-- 필터 탭 --%>
            <div class="filter-bar">
                <a href="${ctx}/trainees?gender=ALL"
                   class="filter-tab ${selectedGender == 'ALL' ? 'active' : ''}">
                    전체
                </a>
                <a href="${ctx}/trainees?gender=MALE"
                   class="filter-tab filter-tab--male ${selectedGender == 'MALE' ? 'active' : ''}">
                    <i class="fas fa-mars" style="font-size:9px;"></i> 남자
                </a>
                <a href="${ctx}/trainees?gender=FEMALE"
                   class="filter-tab filter-tab--female ${selectedGender == 'FEMALE' ? 'active' : ''}">
                    <i class="fas fa-venus" style="font-size:9px;"></i> 여자
                </a>
            </div>

            <%-- 카드 그리드 --%>
            <div class="trainee-grid">
                <c:choose>
                    <c:when test="${empty trainees}">
                        <div class="empty-state">
                            <div class="empty-icon"><i class="fas fa-user-slash"></i></div>
                            <div class="empty-text">등록된 연습생이 없습니다</div>
                        </div>
                    </c:when>
                    <c:otherwise>

                        <%-- 전체 보기일 때 남/여 구분선 표시 --%>
                        <c:if test="${selectedGender == 'ALL'}">
                            <%-- 남자 섹션 --%>
                            <c:set var="hasMale" value="false"/>
                            <c:forEach var="t" items="${trainees}">
                                <c:if test="${t.gender == 'MALE' && !hasMale}">
                                    <c:set var="hasMale" value="true"/>
                                </c:if>
                            </c:forEach>
                            <c:if test="${hasMale}">
                                <div class="section-divider section-divider--male" style="animation-delay:400ms">
                                    <span class="section-divider-label">♂ MALE TRAINEES</span>
                                    <div class="section-divider-line"></div>
                                </div>
                                <c:forEach var="t" items="${trainees}" varStatus="vs">
                                    <c:if test="${t.gender == 'MALE'}">
                                        <div class="trainee-card trainee-card--male"
                                             style="animation-delay:${450 + vs.index * 40}ms"
                                             onclick="openIdolModal(this)"
                                             data-id="${t.id}"
                                             data-name="${t.name}"
                                             data-gender="${t.gender}"
                                             data-grade="${t.grade != null ? t.grade.name() : 'C'}"
                                             data-image="${ctx}${t.imagePath}"
                                             data-age="${t.age}"
                                             data-height="${t.height}"
                                             data-weight="${t.weight}"
                                             data-hobby="${t.hobby}"
                                             data-motto="${t.motto}"
                                             data-instagram="${t.instagram}">
                                            <div class="card-beam"></div>
                                            <div class="card-photo">
                                                <c:choose>
                                                    <c:when test="${not empty t.imagePath}">
                                                        <img src="${ctx}${t.imagePath}" alt="${t.name}"
                                                             onerror="this.parentNode.innerHTML='<div class=\'card-photo-placeholder\'><i class=\'fas fa-user\'></i></div>'"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="card-photo-placeholder"><i class="fas fa-user"></i></div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <span class="card-grade grade-${t.grade != null ? t.grade.name().toLowerCase() : 'c'}">${t.grade != null ? t.grade.name() : 'C'}</span>
                                                <span class="card-gender gender-male"><i class="fas fa-mars"></i></span>
                                                <div class="card-name-overlay">
                                                    <div class="card-name">${t.name}</div>
                                                    <div class="card-number">#${t.id}</div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </c:if>

                            <%-- 여자 섹션 --%>
                            <c:set var="hasFemale" value="false"/>
                            <c:forEach var="t" items="${trainees}">
                                <c:if test="${t.gender == 'FEMALE' && !hasFemale}">
                                    <c:set var="hasFemale" value="true"/>
                                </c:if>
                            </c:forEach>
                            <c:if test="${hasFemale}">
                                <div class="section-divider section-divider--female" style="animation-delay:600ms">
                                    <span class="section-divider-label">♀ FEMALE TRAINEES</span>
                                    <div class="section-divider-line"></div>
                                </div>
                                <c:forEach var="t" items="${trainees}" varStatus="vs">
                                    <c:if test="${t.gender == 'FEMALE'}">
                                        <div class="trainee-card trainee-card--female"
                                             style="animation-delay:${650 + vs.index * 40}ms"
                                             onclick="openIdolModal(this)"
                                             data-id="${t.id}"
                                             data-name="${t.name}"
                                             data-gender="${t.gender}"
                                             data-grade="${t.grade != null ? t.grade.name() : 'C'}"
                                             data-image="${ctx}${t.imagePath}"
                                             data-age="${t.age}"
                                             data-height="${t.height}"
                                             data-weight="${t.weight}"
                                             data-hobby="${t.hobby}"
                                             data-motto="${t.motto}"
                                             data-instagram="${t.instagram}">
                                            <div class="card-beam"></div>
                                            <div class="card-photo">
                                                <c:choose>
                                                    <c:when test="${not empty t.imagePath}">
                                                        <img src="${ctx}${t.imagePath}" alt="${t.name}"
                                                             onerror="this.parentNode.innerHTML='<div class=\'card-photo-placeholder\'><i class=\'fas fa-user\'></i></div>'"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="card-photo-placeholder"><i class="fas fa-user"></i></div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <span class="card-grade grade-${t.grade != null ? t.grade.name().toLowerCase() : 'c'}">${t.grade != null ? t.grade.name() : 'C'}</span>
                                                <span class="card-gender gender-female"><i class="fas fa-venus"></i></span>
                                                <div class="card-name-overlay">
                                                    <div class="card-name">${t.name}</div>
                                                    <div class="card-number">#${t.id}</div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </c:if>

                        <%-- 필터 보기 (남자 or 여자만) --%>
                        <c:if test="${selectedGender != 'ALL'}">
                            <c:forEach var="t" items="${trainees}" varStatus="vs">
                                <div class="trainee-card trainee-card--${t.gender == 'MALE' ? 'male' : 'female'}"
                                     style="animation-delay:${400 + vs.index * 45}ms"
                                     onclick="openIdolModal(this)"
                                     data-id="${t.id}"
                                     data-name="${t.name}"
                                     data-gender="${t.gender}"
                                     data-grade="${t.grade != null ? t.grade.name() : 'C'}"
                                     data-image="${ctx}${t.imagePath}"
                                     data-age="${t.age}"
                                     data-height="${t.height}"
                                     data-weight="${t.weight}"
                                     data-hobby="${t.hobby}"
                                     data-motto="${t.motto}"
                                     data-instagram="${t.instagram}">
                                    <div class="card-beam"></div>
                                    <div class="card-photo">
                                        <c:choose>
                                            <c:when test="${not empty t.imagePath}">
                                                <img src="${ctx}${t.imagePath}" alt="${t.name}"
                                                     onerror="this.parentNode.innerHTML='<div class=\'card-photo-placeholder\'><i class=\'fas fa-user\'></i></div>'"/>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="card-photo-placeholder"><i class="fas fa-user"></i></div>
                                            </c:otherwise>
                                        </c:choose>
                                        <span class="card-grade grade-${t.grade != null ? t.grade.name().toLowerCase() : 'c'}">${t.grade != null ? t.grade.name() : 'C'}</span>
                                        <span class="card-gender ${t.gender == 'MALE' ? 'gender-male' : 'gender-female'}">
                                            <i class="fas ${t.gender == 'MALE' ? 'fa-mars' : 'fa-venus'}"></i>
                                        </span>
                                        <div class="card-name-overlay">
                                            <div class="card-name">${t.name}</div>
                                            <div class="card-number">#${t.id}</div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:if>

                    </c:otherwise>
                </c:choose>
            </div>

        </section>
    </div>
</main>


<%-- ══ 아이돌 상세 모달 ══ --%>
<div class="idol-modal-overlay" id="idol-modal-overlay" onclick="closeIdolModal(event)">
    <div class="idol-modal" id="idol-modal">
        <button class="modal-close" onclick="closeIdolModalDirect()">
            <i class="fas fa-times"></i>
        </button>

        <%-- 사진 패널 --%>
        <div class="modal-photo-panel" id="modal-photo-panel">
            <span class="modal-grade" id="modal-grade-badge"></span>
            <%-- 반짝임 파티클 --%>
            <div class="modal-photo-sparkle" id="modal-sparkle">
                <i style="width:4px;height:4px;top:18%;left:72%;background:rgba(233,176,196,0.9);animation-delay:0s;"></i>
                <i style="width:3px;height:3px;top:42%;left:85%;background:rgba(255,255,255,0.8);animation-delay:0.7s;"></i>
                <i style="width:5px;height:5px;top:65%;left:78%;background:rgba(203,186,216,0.9);animation-delay:1.4s;"></i>
                <i style="width:3px;height:3px;top:28%;left:60%;background:rgba(186,198,220,0.8);animation-delay:2.1s;"></i>
                <i style="width:4px;height:4px;top:80%;left:65%;background:rgba(233,176,196,0.7);animation-delay:0.4s;"></i>
            </div>
        </div>

        <%-- 정보 패널 --%>
        <div class="modal-info-panel">
            <div>
                <div class="modal-name" id="modal-name">이름</div>
                <div class="modal-number" id="modal-number">#000</div>
            </div>
            <div class="modal-divider"></div>
            <div class="modal-badges" id="modal-badges"></div>
            <div class="modal-divider"></div>
            <table class="modal-profile-table"><tbody id="modal-profile-body"></tbody></table>
            <div class="modal-divider"></div>
            <div class="modal-hint">ESC 또는 바깥 클릭으로 닫기</div>
        </div>
    </div>
</div>

<script>
/* ── 카드 클릭 시 모달 오픈 ── */
function openIdolModal(el) {
    // data-* 속성에서 안전하게 읽기
    const data = {
        id:        el.dataset.id,
        name:      el.dataset.name,
        gender:    el.dataset.gender,
        grade:     el.dataset.grade,
        imagePath: el.dataset.image,
        age:       el.dataset.age,
        height:    el.dataset.height,
        weight:    el.dataset.weight,
        hobby:     el.dataset.hobby,
        motto:     el.dataset.motto,
        instagram: el.dataset.instagram
    };
    const isMale = data.gender === 'MALE';

    /* 사진 */
    const photoPanel = document.getElementById('modal-photo-panel');
    const existImg   = photoPanel.querySelector('img, .modal-photo-placeholder');
    if (existImg) existImg.remove();

    if (data.imagePath) {
        const img = document.createElement('img');
        img.src   = data.imagePath;
        img.alt   = data.name;
        img.onerror = function(){
            this.replaceWith(makePlaceholder());
        };
        photoPanel.appendChild(img);
    } else {
        photoPanel.appendChild(makePlaceholder());
    }

    /* 등급 뱃지 */
    const gradeBadge = document.getElementById('modal-grade-badge');
    gradeBadge.textContent  = data.grade;
    gradeBadge.className    = 'modal-grade grade-' + data.grade.toLowerCase();

    /* 글로우 */
    /* 성별에 따라 info panel 오브 색상 변경 */
    const infoPanel = document.querySelector('.modal-info-panel');
    if (isMale) {
        infoPanel.style.setProperty('--modal-orb', 'radial-gradient(circle, rgba(96,165,250,0.18), transparent 70%)');
        infoPanel.style.setProperty('--modal-line', 'rgba(96,165,250,0.40)');
    } else {
        infoPanel.style.setProperty('--modal-orb', 'radial-gradient(circle, rgba(233,176,196,0.18), transparent 70%)');
        infoPanel.style.setProperty('--modal-line', 'rgba(233,176,196,0.40)');
    }

    /* 이름 / 번호 */
    document.getElementById('modal-name').textContent   = data.name;
    document.getElementById('modal-number').textContent = '#' + data.id;

    /* 뱃지 */
    const badgesEl = document.getElementById('modal-badges');
    badgesEl.innerHTML = '';

    const genderBadge = document.createElement('span');
    genderBadge.className   = 'modal-badge modal-badge--' + (isMale ? 'male' : 'female');
    genderBadge.innerHTML   = '<i class="fas fa-' + (isMale ? 'mars' : 'venus') + '" style="font-size:9px;"></i> ' + (isMale ? '남자' : '여자');
    badgesEl.appendChild(genderBadge);

    const gradeCls = document.createElement('span');
    gradeCls.className   = 'modal-badge modal-badge--grade-' + data.grade.toLowerCase();
    gradeCls.textContent = data.grade + '등급';
    badgesEl.appendChild(gradeCls);

    /* 프로필 테이블 렌더링 */
    const tbody = document.getElementById('modal-profile-body');
    tbody.innerHTML = '';
    const rows = [
        { label: '나이',       val: data.age      ? data.age + '세'  : null },
        { label: '키',    val: data.height   ? data.height + 'cm' : null },
        { label: '몸무게',    val: data.weight   ? data.weight + 'kg' : null },
        { label: '취미',     val: data.hobby    || null },
        { label: '좌우명',     val: data.motto    || null },
        { label: '인스타', val: data.instagram || null, isInsta: true },
    ];
    rows.forEach(function(r) {
        const tr  = document.createElement('tr');
        const th  = document.createElement('td');
        const td  = document.createElement('td');
        th.textContent = r.label;
        if (!r.val || r.val === 'null' || r.val === 'nullcm' || r.val === 'nullkg' || r.val === 'null세') {
            td.textContent = '미등록';
            td.className = 'modal-profile-empty';
        } else if (r.isInsta) {
            const a = document.createElement('a');
            a.href = 'https://instagram.com/' + r.val.replace('@','');
            a.target = '_blank';
            a.className = 'modal-insta-link';
            a.innerHTML = '<i class="fab fa-instagram"></i> @' + r.val.replace('@','');
            td.appendChild(a);
        } else {
            td.textContent = r.val;
        }
        tr.appendChild(th);
        tr.appendChild(td);
        tbody.appendChild(tr);
    });

    /* 모달 오픈 */
    document.getElementById('idol-modal-overlay').classList.add('show');
    document.body.style.overflow = 'hidden';
}

function makePlaceholder() {
    const div = document.createElement('div');
    div.className = 'modal-photo-placeholder';
    div.innerHTML = '<i class="fas fa-user"></i>';
    return div;
}

function closeIdolModal(e) {
    if (e.target === document.getElementById('idol-modal-overlay')) {
        closeIdolModalDirect();
    }
}

function closeIdolModalDirect() {
    document.getElementById('idol-modal-overlay').classList.remove('show');
    document.body.style.overflow = '';
}

/* ESC 키 닫기 */
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') closeIdolModalDirect();
});
</script>

<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
</body>
</html>

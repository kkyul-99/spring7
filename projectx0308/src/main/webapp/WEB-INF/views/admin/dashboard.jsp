<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ADMIN DASHBOARD</title>
    <%@ include file="/WEB-INF/views/fragments/head-common.jspf" %>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        :root {
            --pink:    rgb(233,176,196);
            --lav:     rgb(203,186,216);
            --blue:    rgb(186,198,220);
            --bg:      #07030f;
            --card-bg: rgba(255,255,255,0.04);
            --border:  rgba(255,255,255,0.08);
        }

        * { box-sizing: border-box; }

        body {
            background: var(--bg);
            color: #fff;
            font-family: "Pretendard Variable", "Pretendard", sans-serif;
            min-height: 100vh;
            padding-top: var(--nav-h, 68px);
        }

        /* ── 배경 오브 ── */
        body::before {
            content: "";
            position: fixed; inset: 0; pointer-events: none; z-index: 0;
            background:
                radial-gradient(ellipse 60% 40% at 15% 20%, rgba(233,176,196,0.09), transparent),
                radial-gradient(ellipse 50% 35% at 85% 75%, rgba(186,198,220,0.08), transparent);
        }

        .admin-wrap {
            position: relative; z-index: 1;
            max-width: 1360px; margin: 0 auto;
            padding: 36px 28px 60px;
        }

        /* ── 헤더 ── */
        .admin-header {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 36px;
        }
        .admin-header h1 {
            font-family: "Orbitron", sans-serif;
            font-size: clamp(20px, 3vw, 28px); font-weight: 900;
            letter-spacing: 0.18em;
            background: linear-gradient(135deg, var(--pink), var(--lav), var(--blue));
            -webkit-background-clip: text; background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .admin-header .sub {
            font-size: 11px; letter-spacing: 0.25em;
            color: rgba(255,255,255,0.35);
            margin-top: 4px;
            font-family: "Orbitron", sans-serif;
        }
        .admin-back {
            display: inline-flex; align-items: center; gap: 8px;
            padding: 8px 18px; border-radius: 999px;
            border: 1px solid var(--border);
            background: var(--card-bg);
            color: rgba(255,255,255,0.55);
            font-family: "Orbitron", sans-serif;
            font-size: 10px; letter-spacing: 0.15em;
            text-decoration: none;
            transition: all 200ms ease;
        }
        .admin-back:hover { color:#fff; border-color: rgba(233,176,196,0.40); background: rgba(233,176,196,0.08); }

        /* ── 스탯 카드 행 ── */
        .stat-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-bottom: 28px;
        }
        .stat-card {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 18px;
            padding: 22px 24px;
            position: relative; overflow: hidden;
            transition: transform 220ms ease, border-color 220ms ease;
        }
        .stat-card:hover { transform: translateY(-3px); border-color: rgba(233,176,196,0.25); }
        .stat-card::before {
            content: ""; position: absolute;
            top: 0; left: 0; right: 0; height: 2px;
            background: var(--accent, linear-gradient(90deg, var(--pink), var(--lav)));
            border-radius: 999px 999px 0 0;
        }
        .stat-card .icon {
            width: 38px; height: 38px; border-radius: 12px;
            background: var(--icon-bg, rgba(233,176,196,0.12));
            display: flex; align-items: center; justify-content: center;
            font-size: 16px; margin-bottom: 14px;
            color: var(--pink);
        }
        .stat-card .label {
            font-family: "Orbitron", sans-serif;
            font-size: 9px; letter-spacing: 0.25em;
            color: rgba(255,255,255,0.40);
            margin-bottom: 6px;
        }
        .stat-card .value {
            font-family: "Orbitron", sans-serif;
            font-size: clamp(26px, 4vw, 36px); font-weight: 900;
            background: linear-gradient(135deg, #fff 0%, rgba(255,255,255,0.70) 100%);
            -webkit-background-clip: text; background-clip: text;
            -webkit-text-fill-color: transparent;
            line-height: 1;
        }
        .stat-card .diff {
            font-size: 11px; color: rgba(255,255,255,0.35);
            margin-top: 6px;
        }

        /* ── 그리드 레이아웃 ── */
        .chart-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        .chart-grid-3 {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        @media(max-width:900px){
            .chart-grid, .chart-grid-3 { grid-template-columns: 1fr; }
        }

        /* ── 패널 (차트/테이블 공통) ── */
        .panel {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 24px;
            position: relative; overflow: hidden;
        }
        .panel-title {
            font-family: "Orbitron", sans-serif;
            font-size: 10px; font-weight: 700; letter-spacing: 0.25em;
            color: rgba(255,255,255,0.50);
            margin-bottom: 20px;
            display: flex; align-items: center; gap: 8px;
        }
        .panel-title i { color: var(--pink); }
        .panel-title::after {
            content: ""; flex: 1; height: 1px;
            background: linear-gradient(90deg, var(--border), transparent);
        }

        /* ── 차트 래퍼 ── */
        .chart-wrap { position: relative; }
        .chart-wrap canvas { width: 100% !important; }

        /* ── 회원 테이블 ── */
        .member-table { width:100%; border-collapse:collapse; font-size:13px; }
        .member-table th {
            font-family:"Orbitron",sans-serif; font-size:8px; letter-spacing:0.20em;
            color:rgba(255,255,255,0.35); font-weight:700;
            padding:8px 12px; text-align:left;
            border-bottom:1px solid var(--border);
        }
        .member-table td {
            padding:10px 12px; color:rgba(255,255,255,0.80);
            border-bottom:1px solid rgba(255,255,255,0.04);
            vertical-align:middle;
        }
        .member-table tr:last-child td { border-bottom:none; }
        .member-table tr:hover td { background:rgba(255,255,255,0.03); }

        .avatar-sm {
            width:28px; height:28px; border-radius:50%;
            background:linear-gradient(135deg, var(--pink), var(--blue));
            display:inline-flex; align-items:center; justify-content:center;
            font-family:"Orbitron",sans-serif; font-size:10px; font-weight:900;
            color:rgba(20,12,32,0.9); flex-shrink:0;
        }
        .badge-grade {
            display:inline-block; padding:2px 8px; border-radius:999px;
            font-family:"Orbitron",sans-serif; font-size:9px; font-weight:700;
        }
        .badge-s { background:rgba(255,215,0,0.15); color:gold; border:1px solid rgba(255,215,0,0.30); }
        .badge-a { background:rgba(192,192,192,0.15); color:silver; border:1px solid rgba(192,192,192,0.30); }
        .badge-b { background:rgba(205,127,50,0.15); color:#cd7f32; border:1px solid rgba(205,127,50,0.30); }
        .badge-c { background:rgba(255,255,255,0.06); color:rgba(255,255,255,0.40); border:1px solid rgba(255,255,255,0.12); }

        /* ── 진행바 ── */
        .progress-row { display:flex; align-items:center; gap:10px; margin-bottom:10px; }
        .progress-label {
            font-family:"Orbitron",sans-serif; font-size:9px; letter-spacing:0.15em;
            color:rgba(255,255,255,0.50); width:20px; text-align:center;
        }
        .progress-bar-wrap {
            flex:1; height:8px; background:rgba(255,255,255,0.07); border-radius:999px; overflow:hidden;
        }
        .progress-bar {
            height:100%; border-radius:999px;
            background:var(--bar-color, var(--pink));
            transition:width 1s cubic-bezier(.23,1.2,.46,.98);
        }
        .progress-count {
            font-family:"Orbitron",sans-serif; font-size:10px; font-weight:700;
            color:rgba(255,255,255,0.70); width:24px; text-align:right;
        }

        /* ── 애니메이션 ── */
        .panel { opacity:0; transform:translateY(18px); animation: panelIn 500ms ease forwards; }
        .panel:nth-child(1){animation-delay:0ms;}
        .panel:nth-child(2){animation-delay:80ms;}
        .panel:nth-child(3){animation-delay:160ms;}
        .stat-card { opacity:0; transform:translateY(14px); animation: panelIn 450ms ease forwards; }
        .stat-card:nth-child(1){animation-delay:0ms;}
        .stat-card:nth-child(2){animation-delay:60ms;}
        .stat-card:nth-child(3){animation-delay:120ms;}
        .stat-card:nth-child(4){animation-delay:180ms;}
        .stat-card:nth-child(5){animation-delay:240ms;}
        @keyframes panelIn {
            to { opacity:1; transform:translateY(0); }
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/fragments/topnav.jspf" %>

<div class="admin-wrap">

    <%-- 헤더 --%>
    <div class="admin-header">
        <div>
            <h1>ADMIN DASHBOARD</h1>
            <p class="sub">UNIT-X MANAGEMENT SYSTEM</p>
        </div>
        <a href="${ctx}/main" class="admin-back">
            <i class="fas fa-chevron-left"></i> BACK TO MAIN
        </a>
    </div>

    <%-- 스탯 카드 5개 --%>
    <div class="stat-row">
        <div class="stat-card" style="--accent:linear-gradient(90deg,var(--pink),var(--lav));">
            <div class="icon" style="--icon-bg:rgba(233,176,196,0.12); color:var(--pink);">
                <i class="fas fa-users"></i>
            </div>
            <div class="label">TOTAL MEMBERS</div>
            <div class="value">${totalMembers}</div>
            <div class="diff">전체 가입 회원 수</div>
        </div>
        <div class="stat-card" style="--accent:linear-gradient(90deg,var(--lav),var(--blue));">
            <div class="icon" style="--icon-bg:rgba(203,186,216,0.12); color:var(--lav);">
                <i class="fas fa-gamepad"></i>
            </div>
            <div class="label">TOTAL GAMES</div>
            <div class="value">${totalGames}</div>
            <div class="diff">전체 게임 플레이 수</div>
        </div>
        <div class="stat-card" style="--accent:linear-gradient(90deg,#4ade80,#22d3ee);">
            <div class="icon" style="--icon-bg:rgba(74,222,128,0.10); color:#4ade80;">
                <i class="fas fa-circle-check"></i>
            </div>
            <div class="label">FINISHED GAMES</div>
            <div class="value">${finishedGames}</div>
            <div class="diff">완료된 게임</div>
        </div>
        <div class="stat-card" style="--accent:linear-gradient(90deg,#f59e0b,#f97316);">
            <div class="icon" style="--icon-bg:rgba(245,158,11,0.10); color:#f59e0b;">
                <i class="fas fa-bolt"></i>
            </div>
            <div class="label">ACTIVE GAMES</div>
            <div class="value">${activeGames}</div>
            <div class="diff">진행 중인 게임</div>
        </div>
        <div class="stat-card" style="--accent:linear-gradient(90deg,var(--blue),var(--lav));">
            <div class="icon" style="--icon-bg:rgba(186,198,220,0.12); color:var(--blue);">
                <i class="fas fa-star"></i>
            </div>
            <div class="label">TOTAL IDOLS</div>
            <div class="value">${totalTrainees}</div>
            <div class="diff">등록된 아이돌 수</div>
        </div>
        <div class="stat-card" style="--accent:linear-gradient(90deg,rgba(74,222,128,0.8),var(--lav));">
            <div class="icon" style="--icon-bg:rgba(74,222,128,0.10); color:rgba(74,222,128,0.90);">
                <i class="fas fa-chart-pie"></i>
            </div>
            <div class="label">FINISH RATE</div>
            <div class="value">${finishRate}%</div>
            <div class="diff">게임 완료율</div>
        </div>
        <div class="stat-card" style="--accent:linear-gradient(90deg,rgba(251,146,60,0.8),var(--pink));">
            <div class="icon" style="--icon-bg:rgba(251,146,60,0.10); color:rgba(251,146,60,0.90);">
                <i class="fas fa-newspaper"></i>
            </div>
            <div class="label">TOTAL POSTS</div>
            <div class="value">${totalPosts}</div>
            <div class="diff">전체 게시글 수</div>
        </div>
    </div>

    <%-- 차트 행 1: 가입 추이 + 그룹 비율 --%>
    <div class="chart-grid">
        <div class="panel">
            <div class="panel-title"><i class="fas fa-chart-line"></i> MEMBER JOIN TREND (7 DAYS)</div>
            <div class="chart-wrap" style="height:220px;">
                <canvas id="joinChart"></canvas>
            </div>
        </div>
        <div class="panel">
            <div class="panel-title"><i class="fas fa-chart-pie"></i> GAME GROUP TYPE</div>
            <div class="chart-wrap" style="height:220px;">
                <canvas id="groupChart"></canvas>
            </div>
        </div>
    </div>

    <%-- 차트 행 2: 아이돌 등급 + 게임 완료율 + 최근 가입 --%>
    <div class="chart-grid-3">

        <%-- 아이돌 등급 분포 --%>
        <div class="panel">
            <div class="panel-title"><i class="fas fa-award"></i> IDOL GRADE DIST.</div>
            <div class="progress-row">
                <span class="progress-label" style="color:gold;">S</span>
                <div class="progress-bar-wrap">
                    <div class="progress-bar" id="barS" style="--bar-color:gold; width:0%"></div>
                </div>
                <span class="progress-count">${cntS}</span>
            </div>
            <div class="progress-row">
                <span class="progress-label" style="color:silver;">A</span>
                <div class="progress-bar-wrap">
                    <div class="progress-bar" id="barA" style="--bar-color:silver; width:0%"></div>
                </div>
                <span class="progress-count">${cntA}</span>
            </div>
            <div class="progress-row">
                <span class="progress-label" style="color:#cd7f32;">B</span>
                <div class="progress-bar-wrap">
                    <div class="progress-bar" id="barB" style="--bar-color:#cd7f32; width:0%"></div>
                </div>
                <span class="progress-count">${cntB}</span>
            </div>
            <div class="progress-row">
                <span class="progress-label" style="color:rgba(255,255,255,0.35);">C</span>
                <div class="progress-bar-wrap">
                    <div class="progress-bar" id="barC" style="--bar-color:rgba(255,255,255,0.25); width:0%"></div>
                </div>
                <span class="progress-count">${cntC}</span>
            </div>
            <div style="margin-top:16px;">
                <div class="chart-wrap" style="height:130px;">
                    <canvas id="gradeChart"></canvas>
                </div>
            </div>
        </div>

        <%-- 게임 완료율 도넛 --%>
        <div class="panel" style="display:flex; flex-direction:column; align-items:center; justify-content:center;">
            <div class="panel-title" style="width:100%;"><i class="fas fa-bullseye"></i> GAME CLEAR RATE</div>
            <div class="chart-wrap" style="height:180px; width:180px;">
                <canvas id="clearChart"></canvas>
            </div>
            <div style="text-align:center; margin-top:12px;">
                <div style="font-family:'Orbitron',sans-serif; font-size:28px; font-weight:900;
                     background:linear-gradient(135deg,#4ade80,#22d3ee);
                     -webkit-background-clip:text; background-clip:text; -webkit-text-fill-color:transparent;">
                    <c:choose>
                        <c:when test="${totalGames > 0}">
                            <fmt:formatNumber value="${finishedGames * 100 / totalGames}" maxFractionDigits="0"/>%
                        </c:when>
                        <c:otherwise>0%</c:otherwise>
                    </c:choose>
                </div>
                <div style="font-size:11px; color:rgba(255,255,255,0.35); margin-top:4px;">클리어율</div>
            </div>
        </div>

        <%-- 최근 가입 회원 --%>
        <div class="panel">
            <div class="panel-title"><i class="fas fa-user-plus"></i> RECENT MEMBERS</div>
            <table class="member-table">
                <thead>
                    <tr>
                        <th>USER</th>
                        <th>ID</th>
                        <th>가입일</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="m" items="${recentMembers}">
                    <tr>
                        <td>
                            <div style="display:flex; align-items:center; gap:8px;">
                                <div class="avatar-sm">
                                    ${fn:substring(empty m.nickname ? m.mname : m.nickname, 0, 1)}
                                </div>
                                <span>${empty m.nickname ? m.mname : m.nickname}</span>
                            </div>
                        </td>
                        <td style="color:rgba(255,255,255,0.45); font-size:12px;">${m.mid}</td>
                        <td style="color:rgba(255,255,255,0.40); font-size:11px;">
                            ${m.createdAtDay}
                        </td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <%-- 게시판 현황 + 게임 플레이 현황 --%>
    <div style="display:grid; grid-template-columns:1fr 1fr; gap:20px; margin-bottom:20px;">

        <%-- 게시판 현황 --%>
        <div class="panel">
            <div class="panel-title"><i class="fas fa-clipboard-list"></i> BOARD STATUS</div>
            <div style="display:grid; grid-template-columns:repeat(2,1fr); gap:12px; margin-bottom:16px;">
                <div class="stat-card" style="--accent:linear-gradient(90deg,var(--pink),var(--lav));">
                    <div class="stat-label">전체 게시글</div>
                    <div class="stat-value">${totalPosts}</div>
                </div>
                <div class="stat-card" style="--accent:linear-gradient(90deg,var(--lav),var(--blue));">
                    <div class="stat-label">공지사항</div>
                    <div class="stat-value">${noticePosts}</div>
                </div>
                <div class="stat-card" style="--accent:linear-gradient(90deg,var(--blue),var(--pink));">
                    <div class="stat-label">자유게시판</div>
                    <div class="stat-value">${freePosts}</div>
                </div>
                <div class="stat-card" style="--accent:linear-gradient(90deg,rgba(248,113,113,0.8),var(--lav));">
                    <div class="stat-label">버그/리포트</div>
                    <div class="stat-value">${reportPosts}</div>
                </div>
            </div>
            <div class="panel-title" style="font-size:10px; margin-bottom:10px;"><i class="fas fa-clock"></i> 최근 게시글</div>
            <table class="member-table">
                <thead><tr><th>게시판</th><th>제목</th><th>작성자</th><th>날짜</th></tr></thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty recentPosts}">
                        <tr><td colspan="4" style="text-align:center; color:rgba(255,255,255,0.30); padding:20px;">게시글 없음</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="p" items="${recentPosts}">
                        <tr>
                            <td>
                                <span style="font-size:10px; padding:2px 8px; border-radius:999px;
                                    background:rgba(233,176,196,0.15); border:1px solid rgba(233,176,196,0.25);
                                    color:rgba(233,176,196,0.85);">
                                    ${p.boardType eq 'notice' ? '공지' : p.boardType eq 'free' ? '자유' : '버그'}
                                </span>
                            </td>
                            <td>
                                <a href="${ctx}/boards/${p.boardType}/${p.id}"
                                   style="color:rgba(255,255,255,0.80); text-decoration:underline; font-size:12px;">
                                    ${p.title}
                                </a>
                            </td>
                            <td style="font-size:12px; color:rgba(255,255,255,0.50);">${p.authorNick}</td>
                            <td style="font-size:11px; color:rgba(255,255,255,0.35);">${p.createdAtStr}</td>
                        </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>

        <%-- 게임 플레이 현황 --%>
        <div class="panel">
            <div class="panel-title"><i class="fas fa-gamepad"></i> GAME PLAY STATUS</div>
            <div style="display:grid; grid-template-columns:repeat(2,1fr); gap:12px; margin-bottom:16px;">
                <div class="stat-card" style="--accent:linear-gradient(90deg,rgba(74,222,128,0.8),var(--lav));">
                    <div class="stat-label">완료율</div>
                    <div class="stat-value">${finishRate}%</div>
                </div>
                <div class="stat-card" style="--accent:linear-gradient(90deg,var(--pink),rgba(251,146,60,0.8));">
                    <div class="stat-label">인기 그룹</div>
                    <div class="stat-value" style="font-size:18px;">
                        ${topGroup eq 'MALE' ? '♂ 남자' : topGroup eq 'FEMALE' ? '♀ 여자' : topGroup eq 'MIXED' ? '⚥ 혼성' : topGroup}
                    </div>
                </div>
                <div class="stat-card" style="--accent:linear-gradient(90deg,var(--blue),var(--pink));">
                    <div class="stat-label">진행중</div>
                    <div class="stat-value">${activeGames}</div>
                </div>
                <div class="stat-card" style="--accent:linear-gradient(90deg,var(--lav),var(--blue));">
                    <div class="stat-label">완료</div>
                    <div class="stat-value">${finishedGames}</div>
                </div>
            </div>
            <%-- 그룹별 바 --%>
            <div class="panel-title" style="font-size:10px; margin-bottom:10px;"><i class="fas fa-chart-bar"></i> 그룹별 플레이 수</div>
            <c:forEach var="e" items="${groupTypeCnt}">
            <div style="margin-bottom:10px;">
                <div style="display:flex; justify-content:space-between; font-size:12px; margin-bottom:4px;">
                    <span style="color:rgba(255,255,255,0.65);">
                        ${e.key eq 'MALE' ? '♂ 남자' : e.key eq 'FEMALE' ? '♀ 여자' : '⚥ 혼성'}
                    </span>
                    <span style="color:rgba(255,255,255,0.40);">${e.value}회</span>
                </div>
                <div style="height:6px; background:rgba(255,255,255,0.07); border-radius:4px; overflow:hidden;">
                    <div style="height:100%; width:${totalGames > 0 ? e.value * 100 / totalGames : 0}%;
                                background:linear-gradient(90deg,var(--pink),var(--lav));
                                border-radius:4px; transition:width 800ms ease;"></div>
                </div>
            </div>
            </c:forEach>
            <c:if test="${empty groupTypeCnt}">
                <div style="text-align:center; color:rgba(255,255,255,0.30); padding:20px; font-size:13px;">게임 기록 없음</div>
            </c:if>
        </div>
    </div>

    <%-- 연습생 관리 --%>
    <div class="panel" id="trainees" style="margin-bottom:20px;">
        <div class="panel-title"><i class="fas fa-star"></i> TRAINEE MANAGEMENT</div>
        <c:if test="${not empty success}">
            <div style="padding:10px 16px; border-radius:12px; margin-bottom:12px;
                        background:rgba(134,239,172,0.12); border:1px solid rgba(134,239,172,0.30); color:rgba(134,239,172,0.90); font-size:13px;">
                <i class="fas fa-check-circle"></i> ${success}
            </div>
        </c:if>
        <div style="overflow-x:auto;">
        <table class="member-table">
            <thead>
                <tr>
                    <th>이름</th><th>성별</th><th>등급</th>
                    <th>보컬</th><th>댄스</th><th>스타</th><th>멘탈</th><th>팀워크</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="t" items="${allTrainees}">
                <tr>
                    <td>${t.name}</td>
                    <td style="font-size:12px;">
                        ${t.gender eq 'MALE' ? '♂ 남' : '♀ 여'}
                    </td>
                    <td>
                        <span style="font-size:11px; padding:2px 8px; border-radius:999px;
                            background:${t.grade eq 'S' ? 'rgba(255,215,0,0.15)' : t.grade eq 'A' ? 'rgba(192,192,192,0.15)' : 'rgba(255,255,255,0.08)'};
                            border:1px solid ${t.grade eq 'S' ? 'rgba(255,215,0,0.35)' : t.grade eq 'A' ? 'rgba(192,192,192,0.35)' : 'rgba(255,255,255,0.15)'};
                            color:${t.grade eq 'S' ? 'rgba(255,215,0,0.90)' : t.grade eq 'A' ? 'rgba(192,192,192,0.90)' : 'rgba(255,255,255,0.60)'};">
                            ${t.grade}
                        </span>
                    </td>
                    <td style="font-size:12px; color:rgba(233,176,196,0.80);">${t.vocal}</td>
                    <td style="font-size:12px; color:rgba(203,186,216,0.80);">${t.dance}</td>
                    <td style="font-size:12px; color:rgba(255,215,0,0.80);">${t.star}</td>
                    <td style="font-size:12px; color:rgba(134,239,172,0.80);">${t.mental}</td>
                    <td style="font-size:12px; color:rgba(186,198,220,0.80);">${t.teamwork}</td>
                    <td>
                        <div style="display:flex; gap:6px;">
                            <button onclick="openEditModal(${t.id},'${t.name}','${t.grade}',${t.vocal},${t.dance},${t.star},${t.mental},${t.teamwork})"
                                style="font-size:11px; padding:4px 10px; border-radius:999px;
                                       border:1px solid rgba(186,198,220,0.35); background:rgba(186,198,220,0.08);
                                       color:rgba(186,198,220,0.80); cursor:pointer; transition:all 180ms ease;">
                                수정
                            </button>
                            <form method="post" action="${ctx}/admin/trainees/${t.id}/delete"
                                  onsubmit="return confirm('${t.name}을(를) 삭제하시겠습니까?')">
                                <button type="submit"
                                    style="font-size:11px; padding:4px 10px; border-radius:999px;
                                           border:1px solid rgba(248,113,113,0.35); background:rgba(248,113,113,0.08);
                                           color:rgba(248,113,113,0.80); cursor:pointer; transition:all 180ms ease;">
                                    삭제
                                </button>
                            </form>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        </div>
    </div>

    <%-- 연습생 수정 모달 --%>
    <div id="editModal" style="display:none; position:fixed; inset:0; z-index:9999;
         background:rgba(2,1,8,0.85); backdrop-filter:blur(20px);
         align-items:center; justify-content:center;">
        <div style="width:min(460px,94vw); border-radius:24px; overflow:hidden;
                    background:linear-gradient(160deg,rgba(18,6,36,0.99),rgba(8,3,20,0.99));
                    border:1px solid rgba(186,198,220,0.20);
                    box-shadow:0 60px 120px rgba(0,0,0,0.90);">
            <div style="height:3px; background:linear-gradient(90deg,var(--pink),var(--lav),var(--blue));"></div>
            <div style="padding:28px;">
                <div style="font-family:'Orbitron',sans-serif; font-size:14px; font-weight:900;
                            color:rgba(186,198,220,0.90); margin-bottom:20px; letter-spacing:0.12em;">
                    ✦ 연습생 정보 수정
                </div>
                <form id="editForm" method="post" action="">
                    <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px; margin-bottom:12px;">
                        <div>
                            <label style="font-size:10px; color:rgba(255,255,255,0.45); letter-spacing:0.14em; display:block; margin-bottom:4px;">이름</label>
                            <input type="text" name="name" id="edit_name"
                                style="width:100%; padding:10px 14px; border-radius:12px;
                                       background:rgba(255,255,255,0.07); border:1px solid rgba(255,255,255,0.15);
                                       color:#fff; font-size:14px; outline:none; box-sizing:border-box;" />
                        </div>
                        <div>
                            <label style="font-size:10px; color:rgba(255,255,255,0.45); letter-spacing:0.14em; display:block; margin-bottom:4px;">등급</label>
                            <select name="grade" id="edit_grade"
                                style="width:100%; padding:10px 14px; border-radius:12px;
                                       background:rgba(255,255,255,0.07); border:1px solid rgba(255,255,255,0.15);
                                       color:#fff; font-size:14px; outline:none; box-sizing:border-box;">
                                <option value="S">S</option>
                                <option value="A">A</option>
                                <option value="B">B</option>
                                <option value="C">C</option>
                            </select>
                        </div>
                    </div>
                    <div style="display:grid; grid-template-columns:repeat(5,1fr); gap:10px; margin-bottom:20px;">
                        <c:forEach items="${{['vocal','VOCAL','보컬'],['dance','DANCE','댄스'],['star','STAR','스타'],['mental','MENTAL','멘탈'],['teamwork','TEAMWORK','팀워크']}}" var="s">
                        </c:forEach>
                        <%-- 스탯 입력 5개 --%>
                        <div>
                            <label style="font-size:9px; color:rgba(233,176,196,0.70); display:block; margin-bottom:4px; letter-spacing:0.1em;">VOCAL</label>
                            <input type="number" name="vocal" id="edit_vocal" min="0" max="100"
                                style="width:100%; padding:8px; border-radius:10px; background:rgba(255,255,255,0.07);
                                       border:1px solid rgba(255,255,255,0.12); color:#fff; font-size:13px; outline:none; box-sizing:border-box; text-align:center;" />
                        </div>
                        <div>
                            <label style="font-size:9px; color:rgba(203,186,216,0.70); display:block; margin-bottom:4px; letter-spacing:0.1em;">DANCE</label>
                            <input type="number" name="dance" id="edit_dance" min="0" max="100"
                                style="width:100%; padding:8px; border-radius:10px; background:rgba(255,255,255,0.07);
                                       border:1px solid rgba(255,255,255,0.12); color:#fff; font-size:13px; outline:none; box-sizing:border-box; text-align:center;" />
                        </div>
                        <div>
                            <label style="font-size:9px; color:rgba(255,215,0,0.70); display:block; margin-bottom:4px; letter-spacing:0.1em;">STAR</label>
                            <input type="number" name="star" id="edit_star" min="0" max="100"
                                style="width:100%; padding:8px; border-radius:10px; background:rgba(255,255,255,0.07);
                                       border:1px solid rgba(255,255,255,0.12); color:#fff; font-size:13px; outline:none; box-sizing:border-box; text-align:center;" />
                        </div>
                        <div>
                            <label style="font-size:9px; color:rgba(134,239,172,0.70); display:block; margin-bottom:4px; letter-spacing:0.1em;">MENTAL</label>
                            <input type="number" name="mental" id="edit_mental" min="0" max="100"
                                style="width:100%; padding:8px; border-radius:10px; background:rgba(255,255,255,0.07);
                                       border:1px solid rgba(255,255,255,0.12); color:#fff; font-size:13px; outline:none; box-sizing:border-box; text-align:center;" />
                        </div>
                        <div>
                            <label style="font-size:9px; color:rgba(186,198,220,0.70); display:block; margin-bottom:4px; letter-spacing:0.1em;">TEAMWORK</label>
                            <input type="number" name="teamwork" id="edit_teamwork" min="0" max="100"
                                style="width:100%; padding:8px; border-radius:10px; background:rgba(255,255,255,0.07);
                                       border:1px solid rgba(255,255,255,0.12); color:#fff; font-size:13px; outline:none; box-sizing:border-box; text-align:center;" />
                        </div>
                    </div>
                    <div style="display:flex; gap:10px;">
                        <button type="submit"
                            style="flex:1; padding:12px; border-radius:14px; cursor:pointer;
                                   background:linear-gradient(135deg,rgba(186,198,220,0.30),rgba(203,186,216,0.25));
                                   border:1px solid rgba(186,198,220,0.35); color:#fff;
                                   font-family:'Orbitron',sans-serif; font-size:10px; letter-spacing:0.15em;
                                   transition:all 200ms ease;">
                            수정 완료
                        </button>
                        <button type="button" onclick="closeEditModal()"
                            style="padding:12px 20px; border-radius:14px; cursor:pointer;
                                   background:rgba(255,255,255,0.05); border:1px solid rgba(255,255,255,0.15);
                                   color:rgba(255,255,255,0.60); font-size:13px; transition:all 200ms ease;">
                            취소
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%-- 전체 회원 목록 --%>
    <div class="panel">
        <div class="panel-title"><i class="fas fa-table-list"></i> ALL MEMBERS</div>
        <table class="member-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>USER</th>
                    <th>ID</th>
                    <th>이름</th>
                    <th>이메일</th>
                    <th>가입일시</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="m" items="${allMembers}" varStatus="vs">
                <tr>
                    <td style="color:rgba(255,255,255,0.30); font-size:12px;">${vs.count}</td>
                    <td>
                        <div style="display:flex; align-items:center; gap:8px;">
                            <div class="avatar-sm">
                                ${fn:substring(empty m.nickname ? m.mname : m.nickname, 0, 1)}
                            </div>
                            <span>${empty m.nickname ? m.mname : m.nickname}</span>
                        </div>
                    </td>
                    <td style="color:rgba(255,255,255,0.50);">${m.mid}</td>
                    <td>${m.mname}</td>
                    <td style="color:rgba(255,255,255,0.50); font-size:12px;">${m.email}</td>
                    <td style="color:rgba(255,255,255,0.40); font-size:12px;">
                        <c:if test="${m.createdAt != null}">
                            ${m.createdAtStr}
                        </c:if>
                    </td>
                    <td>
                        <form method="post" action="${ctx}/admin/members/${m.mno}/delete"
                              onsubmit="return confirm('${m.nickname}님을 강제 탈퇴하시겠습니까?\n이 작업은 되돌릴 수 없습니다.')">
                            <button type="submit"
                                style="font-size:11px; padding:4px 12px; border-radius:999px;
                                       border:1px solid rgba(248,113,113,0.35); background:rgba(248,113,113,0.08);
                                       color:rgba(248,113,113,0.80); cursor:pointer; transition:all 180ms ease;">
                                강제탈퇴
                            </button>
                        </form>
                    </td>
                </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

</div><%-- end admin-wrap --%>

<%-- Chart.js 데이터 (JSTL → JS) --%>
<script>
const joinLabels = [<c:forEach var="k" items="${joinByDayKeys}">"${k}",</c:forEach>];
const joinData   = [<c:forEach var="v" items="${joinByDayVals}">${v},</c:forEach>];

const groupLabels = [<c:forEach var="e" items="${groupTypeCnt}">"${e.key}",</c:forEach>];
const groupData   = [<c:forEach var="e" items="${groupTypeCnt}">${e.value},</c:forEach>];

const totalGames    = ${totalGames};
const finishedGames = ${finishedGames};
const cntS = ${cntS}, cntA = ${cntA}, cntB = ${cntB}, cntC = ${cntC};
const totalTrainees = ${totalTrainees};

/* Chart.js 공통 설정 */
Chart.defaults.color = 'rgba(255,255,255,0.45)';
Chart.defaults.font.family = '"Pretendard Variable","Pretendard",sans-serif';

const gridColor  = 'rgba(255,255,255,0.06)';
const tickColor  = 'rgba(255,255,255,0.35)';

/* ① 가입 추이 라인 차트 */
new Chart(document.getElementById('joinChart'), {
    type: 'line',
    data: {
        labels: joinLabels,
        datasets: [{
            label: '신규 가입',
            data: joinData,
            borderColor: 'rgb(233,176,196)',
            backgroundColor: 'rgba(233,176,196,0.10)',
            pointBackgroundColor: 'rgb(233,176,196)',
            pointBorderColor: '#07030f',
            pointBorderWidth: 2,
            pointRadius: 5,
            pointHoverRadius: 7,
            fill: true,
            tension: 0.45,
            borderWidth: 2,
        }]
    },
    options: {
        responsive: true, maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        scales: {
            x: { grid:{ color:gridColor }, ticks:{ color:tickColor } },
            y: { grid:{ color:gridColor }, ticks:{ color:tickColor, stepSize:1 }, beginAtZero:true }
        }
    }
});

/* ② 그룹 타입 도넛 */
new Chart(document.getElementById('groupChart'), {
    type: 'doughnut',
    data: {
        labels: groupLabels.length ? groupLabels : ['데이터 없음'],
        datasets: [{
            data: groupData.length ? groupData : [1],
            backgroundColor: [
                'rgba(233,176,196,0.80)',
                'rgba(203,186,216,0.80)',
                'rgba(186,198,220,0.80)',
                'rgba(255,255,255,0.20)'
            ],
            borderColor: '#07030f',
            borderWidth: 3,
            hoverOffset: 8
        }]
    },
    options: {
        responsive: true, maintainAspectRatio: false,
        plugins: {
            legend: {
                position: 'bottom',
                labels: { color:'rgba(255,255,255,0.55)', padding:12, font:{size:11} }
            }
        },
        cutout: '62%'
    }
});

/* ③ 게임 완료율 도넛 */
new Chart(document.getElementById('clearChart'), {
    type: 'doughnut',
    data: {
        labels: ['완료', '진행중'],
        datasets: [{
            data: [finishedGames || 0, (totalGames - finishedGames) || 1],
            backgroundColor: ['rgba(74,222,128,0.80)', 'rgba(255,255,255,0.08)'],
            borderColor: '#07030f', borderWidth: 3, hoverOffset: 6
        }]
    },
    options: {
        responsive: true, maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        cutout: '72%'
    }
});

/* ④ 등급 분포 바 차트 */
new Chart(document.getElementById('gradeChart'), {
    type: 'bar',
    data: {
        labels: ['S', 'A', 'B', 'C'],
        datasets: [{
            data: [cntS, cntA, cntB, cntC],
            backgroundColor: [
                'rgba(255,215,0,0.75)',
                'rgba(192,192,192,0.75)',
                'rgba(205,127,50,0.75)',
                'rgba(255,255,255,0.20)'
            ],
            borderRadius: 6, borderSkipped: false
        }]
    },
    options: {
        responsive: true, maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        scales: {
            x: { grid:{ display:false }, ticks:{ color:tickColor } },
            y: { grid:{ color:gridColor }, ticks:{ color:tickColor, stepSize:1 }, beginAtZero:true }
        }
    }
});

/* ⑤ 등급 진행바 애니메이션 */
window.addEventListener('load', function(){
    const max = Math.max(cntS, cntA, cntB, cntC, 1);
    setTimeout(()=>{ document.getElementById('barS').style.width = (cntS/max*100)+'%'; }, 100);
    setTimeout(()=>{ document.getElementById('barA').style.width = (cntA/max*100)+'%'; }, 200);
    setTimeout(()=>{ document.getElementById('barB').style.width = (cntB/max*100)+'%'; }, 300);
    setTimeout(()=>{ document.getElementById('barC').style.width = (cntC/max*100)+'%'; }, 400);
});

/* ── 연습생 수정 모달 ── */
const ctx = '${pageContext.request.contextPath}';
function openEditModal(id, name, grade, vocal, dance, star, mental, teamwork) {
    document.getElementById('edit_name').value     = name;
    document.getElementById('edit_grade').value    = grade;
    document.getElementById('edit_vocal').value    = vocal;
    document.getElementById('edit_dance').value    = dance;
    document.getElementById('edit_star').value     = star;
    document.getElementById('edit_mental').value   = mental;
    document.getElementById('edit_teamwork').value = teamwork;
    document.getElementById('editForm').action     = ctx + '/admin/trainees/' + id + '/edit';
    const modal = document.getElementById('editModal');
    modal.style.display = 'flex';
    requestAnimationFrame(() => { modal.style.opacity = '1'; });
}
function closeEditModal() {
    document.getElementById('editModal').style.display = 'none';
}
/* 모달 외부 클릭 시 닫기 */
document.getElementById('editModal').addEventListener('click', function(e) {
    if (e.target === this) closeEditModal();
});
</script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="loggedIn" value="${not empty sessionScope.LOGIN_MEMBER}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NEXT DEBUT</title>
    <%@ include file="/WEB-INF/views/fragments/head-common.jspf" %>
    <link rel="stylesheet" href="/css/pages/main.css" />
    <style>

        /* ══ 기본 세팅 ══ */
        .hero-full { min-height: 100vh; }

        .hero-overlay {
            background:
                linear-gradient(180deg, rgba(0,0,0,0.25) 0%, rgba(0,0,0,0.05) 40%, rgba(0,0,0,0.60) 100%),
                radial-gradient(ellipse at 20% 30%, rgba(233,176,196,0.18) 0%, transparent 55%),
                radial-gradient(ellipse at 80% 70%, rgba(186,198,220,0.14) 0%, transparent 55%);
        }

        /* ══ SM UNIVERSE PRESENTS ══ */
        .hero-kicker {
            font-family: "Orbitron", sans-serif;
            font-size: 10px; letter-spacing: 0.60em;
            color: rgba(255,255,255,0.50);
            display: flex; align-items: center; justify-content: center; gap: 16px;
            opacity: 0;
            animation: kickerIn 900ms cubic-bezier(.23,1,.32,1) 300ms forwards;
        }
        .hero-kicker::before, .hero-kicker::after {
            content: "";
            display: inline-block; height: 1px; width: 50px;
            background: linear-gradient(90deg, transparent, rgba(233,176,196,0.55));
        }
        .hero-kicker::after { transform: scaleX(-1); }
        @keyframes kickerIn {
            from { opacity:0; letter-spacing:1.2em; transform:translateY(8px); }
            to   { opacity:1; letter-spacing:0.60em; transform:translateY(0); }
        }

        /* ══ THE NEXT DEBUT ══ */
        .hero-title-wrap {
            font-size: clamp(2.6rem, 9vw, 7rem);
            display: flex; align-items: baseline; justify-content: center; gap: 0.22em;
            perspective: 1000px;
        }
        .hero-word { display: inline-flex; }
        .hero-word-gap { display: inline-block; width: 0.28em; }

        .hero-char {
            display: inline-block;
            background: linear-gradient(150deg, rgb(255,220,230) 0%, rgb(233,176,196) 35%, rgb(203,186,216) 65%, rgb(186,198,220) 100%);
            -webkit-background-clip: text; background-clip: text;
            -webkit-text-fill-color: transparent;
            opacity: 0;
            animation:
                charDrop  850ms cubic-bezier(.23,1.2,.46,.98) both,
                charFloat 3.4s  ease-in-out infinite;
            animation-delay:
                calc(var(--i) * 70ms),
                calc(1000ms + var(--i) * 70ms + 200ms);
        }
        .hero-char:nth-child(odd) {
            animation:
                charDrop  850ms cubic-bezier(.23,1.2,.46,.98) both,
                charFloat 3.4s  ease-in-out infinite,
                charGlow  5s    ease-in-out infinite;
            animation-delay:
                calc(var(--i) * 70ms),
                calc(1000ms + var(--i) * 70ms + 200ms),
                calc(1000ms + var(--i) * 70ms + 600ms);
        }
        @keyframes charDrop {
            0%   { opacity:0; transform:translateY(-70px) rotateX(-90deg) scale(0.5); }
            55%  { opacity:1; transform:translateY(9px) rotateX(12deg) scale(1.06); }
            75%  { transform:translateY(-4px) rotateX(-5deg) scale(0.98); }
            100% { opacity:1; transform:translateY(0) rotateX(0) scale(1); }
        }
        @keyframes charFloat {
            0%,100% { transform:translateY(0); }
            50%     { transform:translateY(-11px); }
        }
        @keyframes charGlow {
            0%,40%,100% { filter: drop-shadow(0 6px 16px rgba(0,0,0,0.5)); }
            70% {
                filter:
                    drop-shadow(0 0 16px rgba(255,200,215,1))
                    drop-shadow(0 0 40px rgba(203,186,216,0.8))
                    drop-shadow(0 0 80px rgba(186,198,220,0.4));
            }
        }

        /* ══ 부제 ══ */
        .hero-subtitle {
            color: rgba(255,255,255,0.78);
            opacity: 0;
            animation: fadeUp 700ms ease calc(1100ms + 12 * 70ms) forwards;
        }

        /* ══ 버튼 래퍼 — 등장 ══ */
        .stage-btn-wrap {
            position: relative;
            display: inline-flex; align-items: center; justify-content: center;
            opacity: 0;
            animation: fadeUp 600ms ease calc(1200ms + 12 * 70ms) forwards;
        }
        @keyframes fadeUp {
            from { opacity:0; transform:translateY(22px); }
            to   { opacity:1; transform:translateY(0); }
        }

        /* ══ ENTER THE STAGE 버튼 ══ */
        .stage-btn {
            position: relative; display: inline-flex; align-items: center; justify-content: center;
            padding: 20px 52px; border-radius: 999px;
            text-decoration: none; overflow: visible; cursor: pointer;
            background: linear-gradient(110deg,
                rgb(233,176,196) 0%, rgb(211,187,210) 35%,
                rgb(203,186,216) 55%, rgb(186,198,220) 100%);
            background-size: 200%;
            animation: stageBgShift 3s ease-in-out infinite alternate;
            font-family: "Orbitron", sans-serif; font-size: 15px;
            font-weight: 900; letter-spacing: 0.18em;
            color: rgba(20,12,32,0.92);
            box-shadow:
                0 0 0 1.5px rgba(255,255,255,0.35) inset,
                0 12px 40px rgba(203,186,216,0.55),
                0 0 80px rgba(233,176,196,0.22);
            transition: transform 250ms cubic-bezier(.23,1.2,.46,.98), box-shadow 250ms ease;
        }
        @keyframes stageBgShift { from{background-position:0%;} to{background-position:100%;} }
        .stage-btn:hover {
            transform: translateY(-5px) scale(1.06);
            box-shadow: 0 0 0 1.5px rgba(255,255,255,0.50) inset,
                0 20px 60px rgba(203,186,216,0.70),
                0 0 120px rgba(233,176,196,0.35);
        }
        .stage-btn:active { transform: scale(0.97); }

        .stage-btn__ring {
            position: absolute; border-radius: 999px;
            border: 1.5px solid rgba(203,186,216,0.60); pointer-events: none;
        }
        .stage-btn__ring--1 { inset:-6px; animation: ringPulse 2.2s ease-out infinite; }
        .stage-btn__ring--2 { inset:-6px; animation: ringPulse 2.2s ease-out infinite 1.1s; }
        @keyframes ringPulse { 0%{transform:scale(1);opacity:.7;} 100%{transform:scale(1.4);opacity:0;} }

        .stage-btn__shimmer {
            position: absolute; inset:0; border-radius:999px; pointer-events:none;
            background: linear-gradient(105deg, transparent 30%, rgba(255,255,255,0.50) 50%, transparent 70%);
            background-size:200%;
            animation: shimmerSweep 2.4s ease-in-out infinite;
        }
        @keyframes shimmerSweep { 0%,30%{background-position:150%;} 100%{background-position:-50%;} }

        .stage-btn__particles { position:absolute; inset:0; pointer-events:none; }
        .stage-btn__particles i { position:absolute; width:4px; height:4px; border-radius:50%; opacity:0; }
        .stage-btn__particles i:nth-child(1){top:10%;left:15%;animation:sparkle 2.8s ease-in-out infinite 0.0s;background:rgb(233,176,196);}
        .stage-btn__particles i:nth-child(2){top:15%;right:18%;animation:sparkle 2.8s ease-in-out infinite 0.5s;background:rgb(211,187,210);}
        .stage-btn__particles i:nth-child(3){bottom:12%;left:22%;animation:sparkle 2.8s ease-in-out infinite 0.9s;background:rgb(203,186,216);}
        .stage-btn__particles i:nth-child(4){bottom:10%;right:14%;animation:sparkle 2.8s ease-in-out infinite 1.3s;background:rgb(186,198,220);}
        .stage-btn__particles i:nth-child(5){top:50%;left:8%;animation:sparkle 2.8s ease-in-out infinite 1.7s;background:rgb(220,182,208);width:3px;height:3px;}
        .stage-btn__particles i:nth-child(6){top:50%;right:8%;animation:sparkle 2.8s ease-in-out infinite 2.1s;background:rgb(200,192,218);width:3px;height:3px;}
        @keyframes sparkle {
            0%,100%{opacity:0;transform:scale(.5) translateY(0);}
            40%,60%{opacity:1;transform:scale(1.2) translateY(-4px);}
        }
        .stage-btn__inner { position:relative; z-index:2; display:inline-flex; align-items:center; gap:14px; }
        .stage-btn__label { letter-spacing:0.18em; }
        .stage-btn__icon {
            display:inline-flex; align-items:center; justify-content:center;
            width:30px; height:30px; border-radius:50%;
            background:rgba(255,255,255,0.20); border:1px solid rgba(255,255,255,0.30); font-size:12px;
            transition:transform 250ms cubic-bezier(.23,1.2,.46,.98), background 250ms;
        }
        .stage-btn:hover .stage-btn__icon { transform:translateX(5px); background:rgba(255,255,255,0.35); }

        /* ══ 🆕 스포트라이트 — 마우스 따라오는 빛 원 ══ */
        .spotlight {
            position: absolute; inset: 0; pointer-events: none; z-index: 3;
            background: radial-gradient(circle 380px at var(--mx,50%) var(--my,50%),
                rgba(233,176,196,0.10) 0%,
                rgba(203,186,216,0.05) 40%,
                transparent 70%);
            transition: background 0.08s ease;
        }

        /* ══ 🆕 좌우 빛 기둥 ══ */
        .light-beam {
            position: absolute; top: 0; width: 1px; height: 100%;
            background: linear-gradient(180deg,
                transparent 0%,
                rgba(233,176,196,0.30) 25%,
                rgba(203,186,216,0.50) 50%,
                rgba(186,198,220,0.30) 75%,
                transparent 100%);
            pointer-events: none; z-index: 2;
            animation: beamPulse 5s ease-in-out infinite;
        }
        .light-beam--left  { left:10%; animation-delay:0s; }
        .light-beam--right { right:10%; animation-delay:2.5s; }
        @keyframes beamPulse {
            0%,100% { opacity:0.25; transform:scaleY(0.80); }
            50%     { opacity:0.90; transform:scaleY(1.0); }
        }

        /* ══ 🆕 코너 장식 ══ */
        .corner-deco {
            position: absolute; width: 44px; height: 44px;
            pointer-events: none; z-index: 5;
            opacity: 0; animation: fadeIn 600ms ease 2s forwards;
        }
        .corner-deco--tl { top:20px; left:24px;  border-top:1.5px solid rgba(233,176,196,0.55); border-left:1.5px solid rgba(233,176,196,0.55); }
        .corner-deco--tr { top:20px; right:24px;  border-top:1.5px solid rgba(186,198,220,0.55); border-right:1.5px solid rgba(186,198,220,0.55); }
        .corner-deco--bl { bottom:20px; left:24px;  border-bottom:1.5px solid rgba(186,198,220,0.55); border-left:1.5px solid rgba(186,198,220,0.55); }
        .corner-deco--br { bottom:20px; right:24px;  border-bottom:1.5px solid rgba(233,176,196,0.55); border-right:1.5px solid rgba(233,176,196,0.55); }
        @keyframes fadeIn { from{opacity:0;} to{opacity:1;} }

        /* ══ 🆕 스캔 라인 ══ */
        .scan-line {
            position: absolute; left:0; right:0; height:1.5px;
            background: linear-gradient(90deg,
                transparent 0%, rgba(203,186,216,0) 8%,
                rgba(203,186,216,0.55) 50%,
                rgba(203,186,216,0) 92%, transparent 100%);
            pointer-events: none; z-index: 6;
            animation: scanDown 7s linear infinite;
        }
        @keyframes scanDown {
            0%  { top:-2px; opacity:0; }
            3%  { opacity:1; }
            97% { opacity:1; }
            100%{ top:100%; opacity:0; }
        }

        /* ══ 🆕 스크롤 힌트 ══ */
        .scroll-hint {
            position: absolute; bottom:32px; left:50%; transform:translateX(-50%);
            display:flex; flex-direction:column; align-items:center; gap:8px;
            z-index:10; pointer-events:none;
            opacity:0; animation: fadeIn 700ms ease 2.5s forwards;
        }
        .scroll-hint__mouse {
            width:22px; height:34px;
            border:1.5px solid rgba(255,255,255,0.28); border-radius:999px;
            display:flex; justify-content:center;
        }
        .scroll-hint__wheel {
            width:3px; height:6px; margin-top:5px;
            background:rgba(255,255,255,0.50); border-radius:999px;
            animation: wheelScroll 1.7s ease-in-out infinite;
        }
        @keyframes wheelScroll {
            0%  { opacity:1; transform:translateY(0); }
            80% { opacity:0; transform:translateY(10px); }
            100%{ opacity:0; transform:translateY(0); }
        }
        .scroll-hint__label {
            font-family:"Orbitron",sans-serif; font-size:8px; letter-spacing:0.40em;
            color:rgba(255,255,255,0.30);
        }

        /* ══ 🆕 플로팅 파티클 ══ */
        .hero-particle {
            position: absolute; border-radius:50%; pointer-events:none;
            animation: floatUp linear infinite;
        }
        @keyframes floatUp {
            0%   { transform:translateY(0)   translateX(0)             scale(1);   opacity:var(--op); }
            50%  { transform:translateY(-40vh) translateX(var(--dx))    scale(0.7); opacity:calc(var(--op)*0.6); }
            100% { transform:translateY(-90vh) translateX(calc(var(--dx)*1.8)) scale(0.2); opacity:0; }
        }

        /* ══ 🆕 COUNTDOWN 배지 ══ */
        .countdown-badge {
            display: inline-flex; align-items: center; gap: 10px;
            padding: 8px 20px; border-radius: 999px;
            border: 1px solid rgba(233,176,196,0.35);
            background: rgba(0,0,0,0.30);
            backdrop-filter: blur(8px);
            font-family: "Orbitron", sans-serif;
            font-size: 10px; letter-spacing: 0.22em;
            color: rgba(255,255,255,0.65);
            opacity: 0;
            animation: fadeUp 600ms ease calc(1400ms + 12 * 70ms) forwards;
        }
        .countdown-badge__dot {
            width: 6px; height: 6px; border-radius: 50%;
            background: rgb(233,176,196);
            box-shadow: 0 0 8px rgba(233,176,196,0.9);
            animation: dotBlink 1.2s ease-in-out infinite;
        }
        @keyframes dotBlink {
            0%,100% { opacity:1; transform:scale(1); }
            50%     { opacity:0.3; transform:scale(0.6); }
        }
        .countdown-badge__time { color: rgba(233,176,196,0.95); font-weight:700; }

    </style>
</head>

<body class="page-main min-h-screen flex flex-col">
<%@ include file="/WEB-INF/views/fragments/topnav.jspf" %>

<main class="flex-1">
    <section class="hero-full relative flex items-center justify-center overflow-hidden" id="heroSection">

        <%-- 비디오 배경 --%>
        <video class="absolute inset-0 w-full h-full object-cover z-0"
               src="${ctx}/videos/mv01.mp4"
               autoplay muted loop playsinline style="pointer-events:none;"></video>

        <%-- 오버레이 --%>
        <div class="absolute inset-0 hero-overlay z-0"></div>

        <%-- 스포트라이트 (마우스 추적) --%>
        <div class="spotlight" id="spotlight"></div>

        <%-- 스캔 라인 --%>
        <div class="scan-line"></div>

        <%-- 빛 기둥 --%>
        <div class="light-beam light-beam--left"></div>
        <div class="light-beam light-beam--right"></div>

        <%-- 코너 장식 --%>
        <div class="corner-deco corner-deco--tl"></div>
        <div class="corner-deco corner-deco--tr"></div>
        <div class="corner-deco corner-deco--bl"></div>
        <div class="corner-deco corner-deco--br"></div>

        <%-- 메인 콘텐츠 --%>
        <div class="text-center px-6 z-10 w-full max-w-5xl mx-auto relative">

            <%-- COUNTDOWN 배지 --%>
            <div class="countdown-badge mb-6 mx-auto" style="width:fit-content;">
                <span class="countdown-badge__dot"></span>
                <span>SEASON 1 ·</span>
                <span class="countdown-badge__time" id="liveTimer">LIVE NOW</span>
            </div>

            <%-- SM UNIVERSE PRESENTS --%>
            <p class="hero-kicker mb-5">SM UNIVERSE PRESENTS</p>

            <%-- THE NEXT DEBUT --%>
            <h1 class="hero-title-wrap font-orbitron font-black mb-6 leading-none" aria-label="THE NEXT DEBUT">
                <span class="hero-word">
                    <span class="hero-char" style="--i:0">T</span>
                    <span class="hero-char" style="--i:1">H</span>
                    <span class="hero-char" style="--i:2">E</span>
                </span>
                <span class="hero-word-gap"></span>
                <span class="hero-word">
                    <span class="hero-char" style="--i:3">N</span>
                    <span class="hero-char" style="--i:4">E</span>
                    <span class="hero-char" style="--i:5">X</span>
                    <span class="hero-char" style="--i:6">T</span>
                </span>
                <span class="hero-word-gap"></span>
                <span class="hero-word">
                    <span class="hero-char" style="--i:7">D</span>
                    <span class="hero-char" style="--i:8">E</span>
                    <span class="hero-char" style="--i:9">B</span>
                    <span class="hero-char" style="--i:10">U</span>
                    <span class="hero-char" style="--i:11">T</span>
                </span>
            </h1>

            <div class="mt-10 flex flex-col items-center gap-7">
                <p class="hero-subtitle text-base md:text-xl leading-relaxed">
                    새로운 시대를 열어갈 당신만의 아이돌 그룹을 완성하세요.
                </p>

                <%-- ENTER THE STAGE 버튼 --%>
                <div class="stage-btn-wrap">
                    <a href="${ctx}/game" class="stage-btn" id="btnEnterStage" data-logged-in="${loggedIn}">
                        <span class="stage-btn__ring stage-btn__ring--1"></span>
                        <span class="stage-btn__ring stage-btn__ring--2"></span>
                        <span class="stage-btn__shimmer"></span>
                        <span class="stage-btn__particles">
                            <i></i><i></i><i></i><i></i><i></i><i></i>
                        </span>
                        <span class="stage-btn__inner">
                            <span class="stage-btn__label">ENTER THE STAGE</span>
                            <span class="stage-btn__icon"><i class="fas fa-chevron-right"></i></span>
                        </span>
                    </a>
                </div>
            </div>
        </div>

        <%-- 스크롤 힌트 --%>
        <div class="scroll-hint">
            <div class="scroll-hint__mouse">
                <div class="scroll-hint__wheel"></div>
            </div>
            <span class="scroll-hint__label">SCROLL</span>
        </div>

    </section>
</main>

<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>

<script>
/* ── 로그인 체크 ── */
(function(){
    const btn = document.getElementById('btnEnterStage');
    if (!btn) return;
    if (btn.dataset.loggedIn === 'true') return;
    btn.addEventListener('click', function(e){
        e.preventDefault();
        alert('로그인해야 이용이 가능합니다.');
        window.location.href = '${ctx}/login?redirect=' + encodeURIComponent('/main');
    });
})();

/* ── 스포트라이트: 마우스 위치 추적 ── */
(function(){
    const sp   = document.getElementById('spotlight');
    const hero = document.getElementById('heroSection');
    if (!sp || !hero) return;
    hero.addEventListener('mousemove', function(e){
        const rect = hero.getBoundingClientRect();
        const x = ((e.clientX - rect.left) / rect.width  * 100).toFixed(1) + '%';
        const y = ((e.clientY - rect.top)  / rect.height * 100).toFixed(1) + '%';
        sp.style.background =
            'radial-gradient(circle 400px at ' + x + ' ' + y + ',' +
            'rgba(233,176,196,0.13) 0%,' +
            'rgba(203,186,216,0.06) 45%,' +
            'transparent 70%)';
    });
})();

/* ── 플로팅 파티클 28개 ── */
(function(){
    const section = document.getElementById('heroSection');
    const cols = [
        'rgba(233,176,196,OP)', 'rgba(203,186,216,OP)',
        'rgba(186,198,220,OP)', 'rgba(255,255,255,OP)'
    ];
    for (let i = 0; i < 28; i++) {
        const el  = document.createElement('div');
        el.className = 'hero-particle';
        const sz  = (Math.random() * 3.5 + 1.5).toFixed(1);
        const op  = (Math.random() * 0.30 + 0.08).toFixed(2);
        const col = cols[i % cols.length].replace('OP', op);
        const dx  = ((Math.random() - 0.5) * 130).toFixed(0) + 'px';
        const dur = (Math.random() * 14 + 8).toFixed(1);
        const del = (Math.random() * 14).toFixed(1);
        el.style.cssText = [
            'width:'  + sz + 'px',
            'height:' + sz + 'px',
            'background:' + col,
            'left:' + (Math.random() * 100).toFixed(1) + '%',
            'bottom:' + (Math.random() * 35).toFixed(1) + '%',
            '--op:'  + op,
            '--dx:'  + dx,
            'animation-duration:' + dur + 's',
            'animation-delay:-'   + del + 's',
            'box-shadow:0 0 ' + (parseFloat(sz)*2.5).toFixed(1) + 'px ' + col
        ].join(';');
        section.appendChild(el);
    }
})();

/* ── LIVE 타이머 (경과 시간) ── */
(function(){
    const el = document.getElementById('liveTimer');
    if (!el) return;
    const start = Date.now();
    setInterval(function(){
        const s = Math.floor((Date.now() - start) / 1000);
        const m = Math.floor(s / 60);
        const h = Math.floor(m / 60);
        el.textContent =
            'LIVE ' +
            String(h).padStart(2,'0') + ':' +
            String(m % 60).padStart(2,'0') + ':' +
            String(s % 60).padStart(2,'0');
    }, 1000);
})();
</script>
</body>
</html>

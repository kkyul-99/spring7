<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>NEXT DEBUT - SELECT GROUP</title>
    <%@ include file="/WEB-INF/views/fragments/head-common.jspf" %>
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&family=Noto+Sans+KR:wght@300;400;700;900&display=swap" rel="stylesheet">
    <style>
        :root {
            --mixed-c: #cbbad8;
            --male-c:  #baccd8;
            --female-c:#e9b0c4;
        }
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            background: #07030f;
            color: #fff;
            font-family: "Noto Sans KR", sans-serif;
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* 배경 */
        .bg-layer { position: fixed; inset: 0; z-index: 0; pointer-events: none; }
        .bg-core {
            position: absolute; inset: 0;
            background:
                radial-gradient(ellipse 80% 50% at 50% 0%,   rgba(196,132,252,0.18) 0%, transparent 60%),
                radial-gradient(ellipse 60% 40% at 15% 60%,  rgba(244,114,182,0.10) 0%, transparent 55%),
                radial-gradient(ellipse 60% 40% at 85% 60%,  rgba(96,165,250,0.10)  0%, transparent 55%),
                #07030f;
        }
        .bg-spin {
            position: absolute;
            width: 200vw; height: 200vw;
            top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            background: conic-gradient(from 0deg,
                transparent 0deg, rgba(196,132,252,0.04) 30deg, transparent 60deg,
                rgba(244,114,182,0.04) 120deg, transparent 150deg,
                rgba(96,165,250,0.04) 210deg, transparent 240deg,
                rgba(196,132,252,0.04) 300deg, transparent 360deg);
            animation: bgSpin 40s linear infinite;
        }
        @keyframes bgSpin { to { transform: translate(-50%,-50%) rotate(360deg); } }
        #star-canvas { position: absolute; inset: 0; width: 100%; height: 100%; }

        /* 레이아웃 */
        .page-wrap {
            position: relative; z-index: 1;
            min-height: 100vh;
            display: flex; flex-direction: column;
            padding-top: var(--nav-h, 60px);
        }
        main {
            flex: 1;
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            padding: 48px 24px 80px;
        }

        /* 히어로 */
        .hero-block {
            text-align: center; margin-bottom: 60px;
            opacity: 0;
            animation: heroIn 800ms cubic-bezier(.23,1.2,.46,.98) 200ms forwards;
        }
        @keyframes heroIn {
            from { opacity: 0; transform: translateY(28px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .hero-eyebrow {
            font-family: "Orbitron", sans-serif;
            font-size: 10px; letter-spacing: 0.60em;
            color: rgba(255,255,255,0.28);
            margin-bottom: 20px;
            display: flex; align-items: center; justify-content: center; gap: 14px;
        }
        .hero-eyebrow::before, .hero-eyebrow::after {
            content: ""; width: 48px; height: 1px;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.20));
        }
        .hero-eyebrow::after { transform: rotate(180deg); }

        .hero-title {
            font-family: "Orbitron", sans-serif;
            font-size: clamp(3rem, 9vw, 7rem);
            font-weight: 900; line-height: 1;
            letter-spacing: -0.02em; margin-bottom: 28px;
            position: relative; display: inline-block;
        }
        .t-base {
            display: block; color: rgba(255,255,255,0.08);
            position: absolute; inset: 0; user-select: none;
        }
        .t-grad {
            display: block;
            background: linear-gradient(110deg,
                #fff 0%, #f0e6ff 20%, #f472b6 38%,
                #c084fc 52%, #60a5fa 68%, #f0e6ff 85%, #fff 100%);
            background-size: 300%;
            -webkit-background-clip: text; background-clip: text;
            -webkit-text-fill-color: transparent;
            animation: titleShimmer 4s ease-in-out infinite alternate;
        }
        @keyframes titleShimmer { from{background-position:0%;} to{background-position:100%;} }

        .hero-deco {
            display: flex; align-items: center; justify-content: center; gap: 12px;
            margin-bottom: 20px;
        }
        .deco-line { height: 1px; flex: 1; max-width: 120px; background: linear-gradient(90deg, transparent, rgba(196,132,252,0.6), transparent); }
        .deco-diamond {
            width: 8px; height: 8px;
            background: linear-gradient(135deg, #f472b6, #c084fc);
            transform: rotate(45deg);
            box-shadow: 0 0 14px rgba(196,132,252,0.9);
            animation: dPulse 2s ease-in-out infinite alternate;
        }
        @keyframes dPulse {
            from { box-shadow: 0 0 8px rgba(196,132,252,0.6); }
            to   { box-shadow: 0 0 20px rgba(196,132,252,1), 0 0 40px rgba(244,114,182,0.4); }
        }
        .hero-sub { font-size: 14px; color: rgba(255,255,255,0.45); line-height: 1.9; }
        .hero-sub strong { color: rgba(255,255,255,0.80); font-weight: 700; }

        /* 카드 그리드 */
        .cards-grid {
            display: grid; grid-template-columns: repeat(3, 1fr);
            gap: 20px; width: 100%; max-width: 900px; margin-bottom: 52px;
        }
        @media (max-width: 700px) { .cards-grid { grid-template-columns: 1fr; max-width: 380px; } }

        /* 카드 */
        .group-card {
            position: relative; border-radius: 28px;
            padding: 44px 28px 36px; text-align: center;
            cursor: pointer; overflow: hidden;
            border: 1px solid rgba(255,255,255,0.08);
            background: rgba(255,255,255,0.04);
            transition: transform 300ms cubic-bezier(.23,1.2,.46,.98), box-shadow 300ms ease, border-color 300ms ease;
            opacity: 0;
        }
        .group-card:nth-child(1) { animation: cardIn 600ms cubic-bezier(.23,1.2,.46,.98) 400ms forwards; }
        .group-card:nth-child(2) { animation: cardIn 600ms cubic-bezier(.23,1.2,.46,.98) 550ms forwards; }
        .group-card:nth-child(3) { animation: cardIn 600ms cubic-bezier(.23,1.2,.46,.98) 700ms forwards; }
        @keyframes cardIn {
            from { opacity: 0; transform: translateY(32px) scale(0.96); }
            to   { opacity: 1; transform: translateY(0)    scale(1); }
        }

        .card-glow {
            position: absolute; inset: -40%; border-radius: 50%;
            opacity: 0; transition: opacity 400ms ease; filter: blur(40px); pointer-events: none;
        }
        .group-card--mixed  .card-glow { background: radial-gradient(circle, rgba(203,186,216,0.35), transparent 70%); }
        .group-card--male   .card-glow { background: radial-gradient(circle, rgba(186,204,216,0.35), transparent 70%); }
        .group-card--female .card-glow { background: radial-gradient(circle, rgba(233,176,196,0.35), transparent 70%); }

        .card-beam {
            position: absolute; top: 0; left: 15%; right: 15%; height: 2px;
            border-radius: 999px; opacity: 0;
            transition: opacity 300ms ease, left 300ms ease, right 300ms ease;
        }
        .group-card--mixed  .card-beam { background: linear-gradient(90deg,transparent,#cbbad8,transparent); box-shadow: 0 0 16px #cbbad8, 0 0 32px rgba(203,186,216,0.6); }
        .group-card--male   .card-beam { background: linear-gradient(90deg,transparent,#baccd8,transparent); box-shadow: 0 0 16px #baccd8, 0 0 32px rgba(186,204,216,0.6); }
        .group-card--female .card-beam { background: linear-gradient(90deg,transparent,#e9b0c4,transparent); box-shadow: 0 0 16px #e9b0c4, 0 0 32px rgba(233,176,196,0.6); }

        .group-card:hover .card-beam,
        .group-card.selected .card-beam { opacity: 1; left: 0; right: 0; }
        .group-card:hover .card-glow,
        .group-card.selected .card-glow { opacity: 1; }

        .group-card:hover {
            transform: translateY(-12px) scale(1.02);
            border-color: rgba(255,255,255,0.16);
            box-shadow: 0 32px 64px rgba(0,0,0,0.35);
        }
        .group-card--mixed.selected  { border-color:rgba(203,186,216,0.55); box-shadow:0 32px 64px rgba(0,0,0,0.35),0 0 50px rgba(203,186,216,0.20); transform:translateY(-12px) scale(1.02); }
        .group-card--male.selected   { border-color:rgba(186,204,216,0.55); box-shadow:0 32px 64px rgba(0,0,0,0.35),0 0 50px rgba(186,204,216,0.20); transform:translateY(-12px) scale(1.02); }
        .group-card--female.selected { border-color:rgba(233,176,196,0.55); box-shadow:0 32px 64px rgba(0,0,0,0.35),0 0 50px rgba(233,176,196,0.20); transform:translateY(-12px) scale(1.02); }

        .card-check {
            position: absolute; top: 16px; right: 16px;
            width: 28px; height: 28px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 11px; color: #fff;
            opacity: 0; transform: scale(0.4) rotate(-30deg);
            transition: opacity 250ms ease, transform 300ms cubic-bezier(.23,1.8,.46,.98);
        }
        .group-card--mixed  .card-check { background:rgba(203,186,216,0.90); box-shadow:0 0 14px rgba(203,186,216,0.7); }
        .group-card--male   .card-check { background:rgba(186,204,216,0.90); box-shadow:0 0 14px rgba(186,204,216,0.7); }
        .group-card--female .card-check { background:rgba(233,176,196,0.90); box-shadow:0 0 14px rgba(233,176,196,0.7); }
        .group-card.selected .card-check { opacity:1; transform:scale(1) rotate(0deg); }

        .card-icon-wrap {
            width: 88px; height: 88px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 24px; position: relative;
            transition: transform 300ms cubic-bezier(.23,1.2,.46,.98);
        }
        .group-card--mixed  .card-icon-wrap { background:radial-gradient(circle,rgba(203,186,216,0.22),rgba(203,186,216,0.05)); border:1.5px solid rgba(203,186,216,0.30); }
        .group-card--male   .card-icon-wrap { background:radial-gradient(circle,rgba(186,204,216,0.22),rgba(186,204,216,0.05)); border:1.5px solid rgba(186,204,216,0.30); }
        .group-card--female .card-icon-wrap { background:radial-gradient(circle,rgba(233,176,196,0.22),rgba(233,176,196,0.05)); border:1.5px solid rgba(233,176,196,0.30); }
        .group-card:hover    .card-icon-wrap,
        .group-card.selected .card-icon-wrap { transform: scale(1.10) rotate(6deg); }

        .card-icon { font-size: 38px; transition: filter 300ms ease; }
        .group-card--mixed  .card-icon { color:#cbbad8; filter:drop-shadow(0 0 8px rgba(203,186,216,0.5)); }
        .group-card--male   .card-icon { color:#baccd8; filter:drop-shadow(0 0 8px rgba(186,204,216,0.5)); }
        .group-card--female .card-icon { color:#e9b0c4; filter:drop-shadow(0 0 8px rgba(233,176,196,0.5)); }
        .group-card:hover    .card-icon,
        .group-card.selected .card-icon { filter: drop-shadow(0 0 16px currentColor) brightness(1.2); }

        .card-title { font-family:"Orbitron",sans-serif; font-size:18px; font-weight:900; letter-spacing:0.08em; color:rgba(255,255,255,0.92); margin-bottom:12px; }
        .card-desc  { font-size:13px; color:rgba(255,255,255,0.45); line-height:1.80; margin-bottom:20px; }
        .card-badge {
            display:inline-flex; align-items:center; gap:6px;
            padding:5px 16px; border-radius:999px;
            font-family:"Orbitron",sans-serif; font-size:9px; font-weight:700; letter-spacing:0.22em;
        }
        .group-card--mixed  .card-badge { background:rgba(203,186,216,0.14); border:1px solid rgba(203,186,216,0.28); color:rgba(203,186,216,0.90); }
        .group-card--male   .card-badge { background:rgba(186,204,216,0.14); border:1px solid rgba(186,204,216,0.28); color:rgba(186,204,216,0.90); }
        .group-card--female .card-badge { background:rgba(233,176,196,0.14); border:1px solid rgba(233,176,196,0.28); color:rgba(233,176,196,0.90); }

        /* START 버튼 */
        .start-section {
            display:flex; flex-direction:column; align-items:center; gap:14px;
            opacity:0; pointer-events:none; transform:translateY(20px);
            transition:opacity 400ms ease, transform 400ms cubic-bezier(.23,1.2,.46,.98);
        }
        .start-section.show { opacity:1; pointer-events:auto; transform:translateY(0); }

        .btn-start {
            position:relative; overflow:hidden;
            display:inline-flex; align-items:center; gap:14px;
            padding:18px 64px; border-radius:999px;
            font-family:"Orbitron",sans-serif; font-size:14px; font-weight:900; letter-spacing:0.20em;
            color:rgba(15,8,28,0.95); border:none; cursor:pointer;
            background:linear-gradient(135deg,#e9b0c4 0%,#cbbad8 45%,#baccd8 100%);
            background-size:200%;
            box-shadow:0 14px 48px rgba(203,186,216,0.50),0 0 0 1.5px rgba(255,255,255,0.30) inset;
            transition:transform 220ms ease, box-shadow 220ms ease, background-position 500ms ease;
            animation:startPulse 2.6s ease-in-out infinite;
        }
        @keyframes startPulse {
            0%,100% { box-shadow:0 14px 48px rgba(203,186,216,0.50),0 0 0 1.5px rgba(255,255,255,0.30) inset; }
            50%      { box-shadow:0 20px 64px rgba(203,186,216,0.75),0 0 0 1.5px rgba(255,255,255,0.45) inset; }
        }
        .btn-start:hover { transform:translateY(-4px) scale(1.04); background-position:right center; box-shadow:0 24px 72px rgba(203,186,216,0.75),0 0 0 2px rgba(255,255,255,0.40) inset; }
        .btn-start:active { transform:scale(0.98); }
        .btn-start::after {
            content:""; position:absolute; top:0; left:-80%; width:50%; height:100%;
            background:linear-gradient(90deg,transparent,rgba(255,255,255,0.45),transparent);
            transform:skewX(-18deg);
            animation:btnSweep 2.6s ease-in-out infinite;
        }
        @keyframes btnSweep { 0%,35%{left:-80%;} 100%{left:150%;} }
        .btn-start-sub { font-size:11px; letter-spacing:0.14em; color:rgba(255,255,255,0.28); }

        /* 하단 링크 */
        .bottom-links {
            display:flex; justify-content:center; gap:28px; margin-top:48px;
            opacity:0; animation:fadeUp 500ms ease 900ms forwards;
        }
        @keyframes fadeUp { from{opacity:0;transform:translateY(10px);} to{opacity:1;transform:translateY(0);} }
        .bottom-link {
            font-size:12px; letter-spacing:0.08em; color:rgba(255,255,255,0.28);
            text-decoration:none; display:inline-flex; align-items:center; gap:6px;
            padding:6px 14px; border-radius:999px; border:1px solid rgba(255,255,255,0.08);
            transition:all 200ms ease;
        }
        .bottom-link:hover { color:rgba(255,255,255,0.70); border-color:rgba(255,255,255,0.18); background:rgba(255,255,255,0.05); }

        /* 파티클 */
        .burst { position:fixed; pointer-events:none; z-index:999; }
        .burst-p { position:absolute; width:5px; height:5px; border-radius:50%; animation:burstAnim 650ms ease forwards; }
        @keyframes burstAnim { 0%{transform:translate(0,0) scale(1.2);opacity:1;} 100%{transform:translate(var(--tx),var(--ty)) scale(0);opacity:0;} }
    </style>
</head>

<body>
    <div class="bg-layer">
        <div class="bg-core"></div>
        <div class="bg-spin"></div>
        <canvas id="star-canvas"></canvas>
    </div>

    <div class="page-wrap">
        <%@ include file="/WEB-INF/views/fragments/topnav.jspf" %>

        <main>
            <div style="width:100%; max-width:900px;">

                <div class="hero-block">
                    <div class="hero-eyebrow">THE NEXT DEBUT</div>
                    <h1 class="hero-title" style="display:block; text-align:center;">
                        <span class="t-base" aria-hidden="true">그룹 선택</span>
                        <span class="t-grad">그룹 선택</span>
                    </h1>
                    <div class="hero-deco">
                        <div class="deco-line"></div>
                        <div class="deco-diamond"></div>
                        <div class="deco-line" style="transform:rotate(180deg)"></div>
                    </div>
                    <p class="hero-sub">
                        데뷔할 그룹 유형을 선택하세요.<br/>
                        연습생 <strong>총 20명</strong> (남자 10명 · 여자 10명) 중 <strong>4명</strong>이 랜덤으로 선발됩니다.
                    </p>
                </div>

                <form id="game-form" action="${ctx}/game/run" method="post">
                    <input type="hidden" id="selected-group" name="groupType" value="" />

                    <div class="cards-grid">
                        <div class="group-card group-card--mixed" data-value="MIXED" onclick="selectGroup(this,event)">
                            <div class="card-glow"></div>
                            <div class="card-beam"></div>
                            <span class="card-check"><i class="fas fa-check"></i></span>
                            <div class="card-icon-wrap"><i class="fas fa-venus-mars card-icon"></i></div>
                            <div class="card-title">혼성</div>
                            <div class="card-desc">남자 2명 + 여자 2명<br/>다채로운 매력의 혼성 그룹</div>
                            <span class="card-badge">✦ 4 MEMBERS</span>
                        </div>
                        <div class="group-card group-card--male" data-value="MALE" onclick="selectGroup(this,event)">
                            <div class="card-glow"></div>
                            <div class="card-beam"></div>
                            <span class="card-check"><i class="fas fa-check"></i></span>
                            <div class="card-icon-wrap"><i class="fas fa-mars card-icon"></i></div>
                            <div class="card-title">남자</div>
                            <div class="card-desc">남자 4명<br/>남자 연습생 중 랜덤 선발</div>
                            <span class="card-badge">✦ 4 MEMBERS</span>
                        </div>
                        <div class="group-card group-card--female" data-value="FEMALE" onclick="selectGroup(this,event)">
                            <div class="card-glow"></div>
                            <div class="card-beam"></div>
                            <span class="card-check"><i class="fas fa-check"></i></span>
                            <div class="card-icon-wrap"><i class="fas fa-venus card-icon"></i></div>
                            <div class="card-title">여자</div>
                            <div class="card-desc">여자 4명<br/>여자 연습생 중 랜덤 선발</div>
                            <span class="card-badge">✦ 4 MEMBERS</span>
                        </div>
                    </div>

                    <div class="start-section" id="start-section">
                        <button type="submit" class="btn-start">
                            <i class="fas fa-play"></i> START
                        </button>
                        <span class="btn-start-sub">선택한 그룹으로 랜덤 선발을 시작합니다</span>
                    </div>
                </form>

                <div class="bottom-links">
                    <a href="${ctx}/main" class="bottom-link"><i class="fas fa-arrow-left"></i> 메인으로</a>
                    <a href="${ctx}/guide" class="bottom-link"><i class="fas fa-circle-info"></i> 게임 설명</a>
                </div>
            </div>
        </main>
    </div>

    <script>
    /* 별 캔버스 */
    (function(){
        const canvas = document.getElementById('star-canvas');
        const ctx = canvas.getContext('2d');
        let W, H, stars = [];
        function resize(){ W = canvas.width = window.innerWidth; H = canvas.height = window.innerHeight; }
        resize(); window.addEventListener('resize', resize);
        for(let i = 0; i < 140; i++){
            stars.push({ x:Math.random(), y:Math.random(), r:Math.random()*1.2+0.2, a:Math.random(),
                da:(Math.random()*0.4+0.2)*(Math.random()<0.5?1:-1)*0.008, speed:Math.random()*0.00008+0.00002 });
        }
        function draw(){
            ctx.clearRect(0,0,W,H);
            stars.forEach(s => {
                s.a = Math.max(0.05, Math.min(0.85, s.a + s.da));
                if(s.a<=0.05||s.a>=0.85) s.da*=-1;
                s.y -= s.speed; if(s.y<0){s.y=1;s.x=Math.random();}
                ctx.beginPath(); ctx.arc(s.x*W, s.y*H, s.r, 0, Math.PI*2);
                ctx.fillStyle = `rgba(255,255,255,${s.a})`; ctx.fill();
            });
            requestAnimationFrame(draw);
        }
        draw();
    })();

    /* 카드 선택 */
    function selectGroup(el, e){
        document.querySelectorAll('.group-card').forEach(c => c.classList.remove('selected'));
        el.classList.add('selected');
        document.getElementById('selected-group').value = el.getAttribute('data-value');
        document.getElementById('start-section').classList.add('show');
        spawnBurst(e);
    }

    /* 파티클 버스트 */
    function spawnBurst(e){
        const colorMap = {
            'group-card--mixed':  ['#cbbad8','#d8c8e8','#e8d8f0','#f0e8f8'],
            'group-card--male':   ['#baccd8','#c8dce8','#a8c4d8','#90b8d0'],
            'group-card--female': ['#e9b0c4','#f0c4d4','#f8d0e0','#fca8c0']
        };
        const card   = e.currentTarget;
        const key    = Object.keys(colorMap).find(k => card.classList.contains(k)) || 'group-card--mixed';
        const colors = colorMap[key];
        const cx = e.clientX, cy = e.clientY;
        const wrap = document.createElement('div');
        wrap.className = 'burst';
        wrap.style.cssText = `left:${cx}px;top:${cy}px`;
        for(let i = 0; i < 22; i++){
            const p = document.createElement('div');
            p.className = 'burst-p';
            const angle = (i/22)*Math.PI*2;
            const dist  = 50 + Math.random()*55;
            p.style.setProperty('--tx', Math.cos(angle)*dist+'px');
            p.style.setProperty('--ty', Math.sin(angle)*dist+'px');
            p.style.background    = colors[i%colors.length];
            p.style.boxShadow     = `0 0 6px ${colors[i%colors.length]}`;
            p.style.animationDelay = Math.random()*60+'ms';
            wrap.appendChild(p);
        }
        document.body.appendChild(wrap);
        setTimeout(()=>wrap.remove(), 800);
    }
    </script>
</body>
</html>

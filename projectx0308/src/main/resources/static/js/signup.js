(function () {
  function qs(sel) { return document.querySelector(sel); }
  function qsa(sel) { return Array.from(document.querySelectorAll(sel)); }

  const MID_RE = /^[A-Za-z0-9]{6,20}$/;
  const NICK_RE = /^[A-Za-z0-9가-힣]{3,12}$/;

  const state = {
    midRule: false,
    midAvailable: false,
    nickRule: false,
    nickAvailable: false,
    pwStrong: false,
    pwMatch: false,
    requiredFilled: false,
    emailOk: false,
    nameOk: false,
    addressOk: false,
  };

  function setMsg(el, msg, ok) {
    if (!el) return;
    el.textContent = msg || '';
    el.dataset.ok = ok === true ? "1" : ok === false ? "0" : "";
  }

  function paintByOk(input, ok, bad) {
    if (!input) return;
    input.classList.toggle('input-ok', !!ok);
    input.classList.toggle('input-bad', !!bad);
  }

  function debounce(fn, wait) {
    let t = null;
    return function (...args) {
      if (t) clearTimeout(t);
      t = setTimeout(() => fn.apply(this, args), wait);
    };
  }

  async function getJson(url) {
    const res = await fetch(url, { headers: { 'Accept': 'application/json' } });
    if (!res.ok) throw new Error('request_failed');
    return res.json();
  }

  function hasStrongPw(pw) {
    if (!pw) return false;
    const lenOk = pw.length >= 8;
    const hasAlpha = /[A-Za-z]/.test(pw);
    const hasNum = /\d/.test(pw);
    const hasSpecial = /[^A-Za-z\d]/.test(pw);
    return lenOk && hasAlpha && hasNum && hasSpecial;
  }

  function recomputeRequired() {
    const username = qs('#username');
    const realName = qs('#real_name');
    const nickname = qs('#nickname');
    const email = qs('#email');
    const address = qs('#address_main');
    const pw1 = qs('#password1');
    const pw2 = qs('#password2');

    state.nameOk = !!realName && realName.value.trim().length > 0;
    state.emailOk = !!email && email.value.trim().length > 0 && /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value.trim());
    state.addressOk = !!address && address.value.trim().length > 0;

    state.requiredFilled = [username, realName, nickname, email, address, pw1, pw2]
      .filter(Boolean)
      .every(el => el.value.trim().length > 0);
  }

  function updateSubmit() {
    recomputeRequired();
    const submitBtn = qs('#btnSignupSubmit');
    if (!submitBtn) return;

    const can =
      state.requiredFilled &&
      state.midRule && state.midAvailable &&
      state.nickRule && state.nickAvailable &&
      state.pwStrong && state.pwMatch &&
      state.emailOk && state.nameOk && state.addressOk;

    submitBtn.disabled = !can;
  }

  function bindPasswordRules() {
    const pw1 = qs('#password1');
    const pw2 = qs('#password2');
    const strengthMsg = qs('#pw_strength_msg');
    const matchMsg = qs('#pw_match_msg');

    function update() {
      const p1 = pw1 ? pw1.value : '';
      const p2 = pw2 ? pw2.value : '';

      state.pwStrong = hasStrongPw(p1);
      setMsg(strengthMsg, state.pwStrong ? '비밀번호 조건 OK' : '8자 이상 + 영문/숫자/특수문자 포함', p1.length === 0 ? null : state.pwStrong);
      paintByOk(pw1, state.pwStrong, p1.length > 0 && !state.pwStrong);

      state.pwMatch = (p1.length > 0 && p1 === p2);
      setMsg(matchMsg, (p2.length === 0) ? '' : (state.pwMatch ? '비밀번호 일치' : '비밀번호가 다릅니다'), p2.length === 0 ? null : state.pwMatch);
      paintByOk(pw2, state.pwMatch, p2.length > 0 && !state.pwMatch);

      updateSubmit();
    }

    [pw1, pw2].filter(Boolean).forEach(el => el.addEventListener('input', update));
    update();
  }

  function bindToggles() {
    qsa('.toggle-eye').forEach(btn => {
      btn.addEventListener('click', () => {
        const targetId = btn.getAttribute('data-toggle-target');
        const input = targetId ? document.getElementById(targetId) : null;
        if (!input) return;
        input.type = (input.type === 'password') ? 'text' : 'password';
      });
    });
  }

  function bindMidAutoCheck() {
    const input = qs('#username');
    const msgEl = qs('#id_check_msg');
    if (!input) return;

    const run = debounce(async () => {
      const v = input.value.trim();
      state.midAvailable = false;

      if (v.length === 0) {
        state.midRule = false;
        setMsg(msgEl, '', null);
        paintByOk(input, false, false);
        updateSubmit();
        return;
      }

      state.midRule = MID_RE.test(v);
      if (!state.midRule) {
        setMsg(msgEl, '아이디 규칙: 영문+숫자만, 6~20자', false);
        paintByOk(input, false, true);
        updateSubmit();
        return;
      }

      setMsg(msgEl, '중복 확인 중...', null);
      paintByOk(input, false, false);

      try {
        const data = await getJson(`/api/auth/check-mid?mid=${encodeURIComponent(v)}`);
        state.midAvailable = !!data.available;

        if (state.midAvailable) {
          setMsg(msgEl, '아이디 조건 OK · 사용 가능', true);
          paintByOk(input, true, false);
        } else {
          setMsg(msgEl, '이미 사용 중인 아이디입니다.', false);
          paintByOk(input, false, true);
        }
      } catch (_) {
        setMsg(msgEl, '중복 확인에 실패했습니다. 잠시 후 다시 시도해 주세요.', false);
        paintByOk(input, false, true);
      }

      updateSubmit();
    }, 1000);

    input.addEventListener('input', () => {
      // 입력이 바뀌면 상태 초기화
      state.midAvailable = false;
      run();
      updateSubmit();
    });
  }

  function bindNickAutoCheck() {
    const input = qs('#nickname');
    const msgEl = qs('#nickname_check_msg');
    if (!input) return;

    const run = debounce(async () => {
      const v = input.value.trim();
      state.nickAvailable = false;

      if (v.length === 0) {
        state.nickRule = false;
        setMsg(msgEl, '', null);
        paintByOk(input, false, false);
        updateSubmit();
        return;
      }

      state.nickRule = NICK_RE.test(v);
      if (!state.nickRule) {
        setMsg(msgEl, '닉네임 규칙: 한글/영문/숫자, 3~12자', false);
        paintByOk(input, false, true);
        updateSubmit();
        return;
      }

      setMsg(msgEl, '중복 확인 중...', null);
      paintByOk(input, false, false);

      try {
        const data = await getJson(`/api/auth/check-nickname?nickname=${encodeURIComponent(v)}`);
        state.nickAvailable = !!data.available;

        if (state.nickAvailable) {
          setMsg(msgEl, '닉네임 조건 OK · 사용 가능', true);
          paintByOk(input, true, false);
        } else {
          setMsg(msgEl, '이미 사용 중인 닉네임입니다.', false);
          paintByOk(input, false, true);
        }
      } catch (_) {
        setMsg(msgEl, '중복 확인에 실패했습니다. 잠시 후 다시 시도해 주세요.', false);
        paintByOk(input, false, true);
      }

      updateSubmit();
    }, 1000);

    input.addEventListener('input', () => {
      state.nickAvailable = false;
      run();
      updateSubmit();
    });
  }

  function bindAddressStub() {
    const btn = qs('#btnAddressSearch');
    if (!btn) return;
    btn.addEventListener('click', () => {
      alert('주소 검색 API는 추후 연결 예정입니다. 지금은 직접 입력해 주세요.');
    });
  }

  function bindGenericRequiredWatch() {
    const ids = ['#real_name', '#email', '#address_main'];
    ids.forEach(sel => {
      const el = qs(sel);
      if (!el) return;
      el.addEventListener('input', () => updateSubmit());
    });
  }

  document.addEventListener('DOMContentLoaded', () => {
    bindToggles();
    bindPasswordRules();
    bindMidAutoCheck();
    bindNickAutoCheck();
    bindAddressStub();
    bindGenericRequiredWatch();
    updateSubmit();
  });
})();
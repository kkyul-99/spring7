package com.java.service;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.java.entity.Member;
import com.java.repository.MemberRepository;

@Service
public class AuthService {

	private static final String MID_REGEX = "^[A-Za-z0-9]{6,20}$";
	private static final String NICK_REGEX = "^[A-Za-z0-9가-힣]{3,12}$";

	private final MemberRepository memberRepository;
	private final BCryptPasswordEncoder passwordEncoder;

	public AuthService(MemberRepository memberRepository) {
		this.memberRepository = memberRepository;
		this.passwordEncoder = new BCryptPasswordEncoder();
	}

	@Transactional
	public Member signup(SignupRequest req) {
		String mid = safeTrim(req.mid());
		String email = safeTrim(req.email());
		String mname = safeTrim(req.mname());
		String nickname = safeTrim(req.nickname());
		String address = safeTrim(req.address());

		if (mid.isBlank() || req.rawPassword() == null || req.rawPassword().isBlank() || email.isBlank()
				|| mname.isBlank() || nickname.isBlank() || address.isBlank()) {
			throw new IllegalArgumentException("필수값이 누락되었습니다.");
		}
		if (!mid.matches(MID_REGEX)) {
			throw new IllegalArgumentException("아이디 규칙(영문+숫자, 6~20자)에 맞지 않습니다.");
		}
		if (!nickname.matches(NICK_REGEX)) {
			throw new IllegalArgumentException("닉네임 규칙(한글/영문/숫자, 3~12자)에 맞지 않습니다.");
		}
		if (memberRepository.existsByMid(mid)) {
			throw new IllegalArgumentException("이미 사용 중인 아이디입니다.");
		}
		if (memberRepository.existsByNickname(nickname)) {
			throw new IllegalArgumentException("이미 사용 중인 닉네임입니다.");
		}
		if (memberRepository.existsByEmail(email)) {
			throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
		}

		Member m = new Member();
		m.setMid(mid);
		m.setMpw(passwordEncoder.encode(req.rawPassword()));
		m.setMname(mname);
		m.setNickname(nickname);
		m.setEmail(email);
		m.setPhone(safeTrim(req.phone()));
		m.setAddress(address);
		m.setAddressDetail(safeTrim(req.addressDetail()));
		m.setJumin(safeTrim(req.jumin()));
		return memberRepository.save(m);
	}

	@Transactional(readOnly = true)
	public Member login(String mid, String rawPassword) {
		String id = safeTrim(mid);
		if (id.isBlank() || rawPassword == null) {
			return null;
		}
		return memberRepository.findByMid(id).filter(m -> passwordEncoder.matches(rawPassword, m.getMpw()))
				.orElse(null);
	}

	@Transactional(readOnly = true)
	public boolean isMidAvailable(String mid) {
		String v = safeTrim(mid);
		if (!v.matches(MID_REGEX)) {
			return false;
		}
		return !memberRepository.existsByMid(v);
	}

	@Transactional(readOnly = true)
	public boolean isNicknameAvailable(String nickname) {
		String v = safeTrim(nickname);
		if (!v.matches(NICK_REGEX)) {
			return false;
		}
		return !memberRepository.existsByNickname(v);
	}

	@Transactional(readOnly = true)
	public Member getMember(Long mno) {
		return memberRepository.findById(mno).orElse(null);
	}

	/** 닉네임 수정 */
	@Transactional
	public void updateNickname(Long mno, String nickname) {
		String v = safeTrim(nickname);
		if (!v.matches(NICK_REGEX)) {
			throw new IllegalArgumentException("닉네임 규칙(한글/영문/숫자, 3~12자)에 맞지 않습니다.");
		}
		if (memberRepository.existsByNickname(v)) {
			throw new IllegalArgumentException("이미 사용 중인 닉네임입니다.");
		}
		memberRepository.findById(mno).ifPresent(m -> m.setNickname(v));
	}

	/** 이메일 변경 (현재 비밀번호 확인 후) */
	@Transactional
	public void updateEmail(Long mno, String currentPw, String newEmail) {
		String email = safeTrim(newEmail);
		if (email.isBlank() || !email.contains("@")) {
			throw new IllegalArgumentException("올바른 이메일 형식을 입력해주세요.");
		}
		Member m = memberRepository.findById(mno).orElseThrow(() -> new IllegalArgumentException("회원을 찾을 수 없습니다."));
		if (!passwordEncoder.matches(currentPw, m.getMpw())) {
			throw new IllegalArgumentException("비밀번호가 올바르지 않습니다.");
		}
		if (memberRepository.existsByEmail(email)) {
			throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
		}
		m.setEmail(email);
	}

	/** 비밀번호 변경 */
	@Transactional
	public void updatePassword(Long mno, String currentPw, String newPw) {
		Member m = memberRepository.findById(mno).orElseThrow(() -> new IllegalArgumentException("회원을 찾을 수 없습니다."));
		if (!passwordEncoder.matches(currentPw, m.getMpw())) {
			throw new IllegalArgumentException("현재 비밀번호가 올바르지 않습니다.");
		}
		if (newPw == null || newPw.length() < 6) {
			throw new IllegalArgumentException("새 비밀번호는 6자 이상이어야 합니다.");
		}
		m.setMpw(passwordEncoder.encode(newPw));
	}

	/** 회원탈퇴 */
	@Transactional
	public void deleteMember(Long mno, String password) {
		Member m = memberRepository.findById(mno).orElseThrow(() -> new IllegalArgumentException("회원을 찾을 수 없습니다."));
		if (!passwordEncoder.matches(password, m.getMpw())) {
			throw new IllegalArgumentException("비밀번호가 올바르지 않습니다.");
		}
		memberRepository.delete(m);
	}

	/** 프로필 이미지 저장 */
	@Transactional
	public void updateProfileImage(Long mno, String storedFilename) {
		memberRepository.findById(mno).ifPresent(m -> m.setProfileImage(storedFilename));
	}

	/** 아이디 찾기 */
	@Transactional(readOnly = true)
	public String findMid(String mname, String email) {
		return memberRepository.findByMnameAndEmail(safeTrim(mname), safeTrim(email)).map(Member::getMid).orElse(null);
	}

	/** 비밀번호 재설정 */
	@Transactional
	public boolean resetPassword(String mid, String mname, String email, String newPassword) {
		return memberRepository.findByMidAndMnameAndEmail(safeTrim(mid), safeTrim(mname), safeTrim(email)).map(m -> {
			m.setMpw(passwordEncoder.encode(newPassword));
			return true;
		}).orElse(false);
	}

	private static String safeTrim(String v) {
		return v == null ? "" : v.trim();
	}

	public record SignupRequest(String mid, String rawPassword, String mname, String nickname, String email,
			String phone, String address, String addressDetail, String jumin) {
	}
}

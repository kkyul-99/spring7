package com.java.controller.auth;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Map;
import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.java.config.SessionConst;
import com.java.dto.LoginMember;
import com.java.entity.Member;
import com.java.game.service.GameService;
import com.java.service.AuthService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class AuthController {

	private final AuthService authService;
	private final GameService gameService;

	public AuthController(AuthService authService, GameService gameService) {
		this.authService = authService;
		this.gameService = gameService;
	}

	@ResponseBody
	@GetMapping("/api/auth/check-mid")
	public ResponseEntity<Map<String, Object>> checkMid(@RequestParam("mid") String mid) {
		boolean available = authService.isMidAvailable(mid);
		return ResponseEntity.ok(Map.of("available", available));
	}

	@ResponseBody
	@GetMapping("/api/auth/check-nickname")
	public ResponseEntity<Map<String, Object>> checkNickname(@RequestParam("nickname") String nickname) {
		boolean available = authService.isNicknameAvailable(nickname);
		return ResponseEntity.ok(Map.of("available", available));
	}

	@PostMapping("/signup")
	public String signup(@RequestParam("username") String username, @RequestParam("password1") String password1,
			@RequestParam("password2") String password2, @RequestParam("real_name") String realName,
			@RequestParam("nickname") String nickname, @RequestParam("email") String email,
			@RequestParam(value = "phone", required = false) String phone, @RequestParam("address") String address,
			@RequestParam(value = "address_detail", required = false) String addressDetail,

			RedirectAttributes ra) {
		try {
			if (password1 == null || !password1.equals(password2)) {
				throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
			}
			authService.signup(new AuthService.SignupRequest(username, password1, realName, nickname, email, phone,
					address, addressDetail, null // jumin 제거됨
			));
			ra.addFlashAttribute("toast", "회원가입이 완료되었습니다. 로그인 해주세요.");
			return "redirect:/login";
		} catch (IllegalArgumentException e) {
			ra.addFlashAttribute("error", e.getMessage());
			ra.addFlashAttribute("prev_username", username);
			ra.addFlashAttribute("prev_real_name", realName);
			ra.addFlashAttribute("prev_nickname", nickname);
			ra.addFlashAttribute("prev_email", email);
			ra.addFlashAttribute("prev_phone", phone);
			ra.addFlashAttribute("prev_address", address);
			ra.addFlashAttribute("prev_address_detail", addressDetail);
			return "redirect:/signup";
		}
	}

	@PostMapping("/login")
	public String login(@RequestParam("username") String username, @RequestParam("password") String password,
			@RequestParam(value = "redirect", required = false) String redirect, HttpServletRequest request,
			RedirectAttributes ra) {
		Member member = authService.login(username, password);
		if (member == null) {
			ra.addFlashAttribute("error", "아이디 또는 비밀번호가 올바르지 않습니다.");
			ra.addFlashAttribute("prev_username", username);
			return "redirect:/login";
		}

		HttpSession session = request.getSession(true);
		session.setAttribute(SessionConst.LOGIN_MEMBER,
				new LoginMember(member.getMno(), member.getMid(), member.getMname(), member.getNickname()));

		if (redirect != null && redirect.startsWith("/")) {
			return "redirect:" + redirect;
		}
		return "redirect:/main";
	}

	@PostMapping("/logout")
	public String logout(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session != null) {
			session.invalidate();
		}
		return "redirect:/main";
	}

	/* ── 마이페이지 ── */
	@GetMapping("/mypage")
	public String mypage(HttpSession session, Model model) {
		com.java.dto.LoginMember lm = (com.java.dto.LoginMember) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (lm == null) {
			return "redirect:/login?redirect=/mypage";
		}
		Member member = authService.getMember(lm.mno());
		model.addAttribute("member", member);
		model.addAttribute("gameHistory", gameService.getPlayerHistory(lm.mno()));
		return "auth/mypage";
	}

	@PostMapping("/mypage/profile-image")
	public String uploadProfileImage(@org.springframework.web.bind.annotation.RequestParam("file") MultipartFile file,
			HttpSession session, RedirectAttributes ra) throws IOException {
		com.java.dto.LoginMember lm = (com.java.dto.LoginMember) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (lm == null) {
			return "redirect:/login";
		}
		if (file == null || file.isEmpty()) {
			ra.addFlashAttribute("error", "파일을 선택해주세요.");
			return "redirect:/mypage";
		}
		String ext = org.springframework.util.StringUtils.getFilenameExtension(file.getOriginalFilename());
		String saved = UUID.randomUUID().toString().replace("-", "") + (ext == null ? "" : "." + ext);
		Path dir = Paths.get(System.getProperty("user.dir"), "uploads", "profiles");
		Files.createDirectories(dir);
		Files.copy(file.getInputStream(), dir.resolve(saved));
		authService.updateProfileImage(lm.mno(), saved);
		ra.addFlashAttribute("toast", "프로필 이미지가 변경되었습니다.");
		return "redirect:/mypage";
	}

	@PostMapping("/mypage/nickname")
	public String updateNickname(@org.springframework.web.bind.annotation.RequestParam("nickname") String nickname,
			HttpSession session, RedirectAttributes ra) {
		com.java.dto.LoginMember lm = (com.java.dto.LoginMember) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (lm == null) {
			return "redirect:/login";
		}
		try {
			authService.updateNickname(lm.mno(), nickname);
			// 세션 닉네임 갱신
			session.setAttribute(SessionConst.LOGIN_MEMBER,
					new com.java.dto.LoginMember(lm.mno(), lm.mid(), lm.mname(), nickname.trim()));
			ra.addFlashAttribute("toast", "닉네임이 변경되었습니다.");
		} catch (IllegalArgumentException e) {
			ra.addFlashAttribute("error", e.getMessage());
		}
		return "redirect:/mypage";
	}

	@PostMapping("/mypage/email")
	public String updateEmail(@RequestParam("currentPw") String currentPw, @RequestParam("newEmail") String newEmail,
			HttpSession session, RedirectAttributes ra) {
		LoginMember lm = (LoginMember) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (lm == null) {
			return "redirect:/login";
		}
		try {
			authService.updateEmail(lm.mno(), currentPw, newEmail);
			ra.addFlashAttribute("toast", "이메일이 변경되었습니다.");
		} catch (IllegalArgumentException e) {
			ra.addFlashAttribute("error", e.getMessage());
		}
		return "redirect:/mypage";
	}

	@PostMapping("/mypage/password")
	public String updatePassword(@org.springframework.web.bind.annotation.RequestParam("currentPw") String currentPw,
			@org.springframework.web.bind.annotation.RequestParam("newPw1") String newPw1,
			@org.springframework.web.bind.annotation.RequestParam("newPw2") String newPw2, HttpSession session,
			RedirectAttributes ra) {
		com.java.dto.LoginMember lm = (com.java.dto.LoginMember) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (lm == null) {
			return "redirect:/login";
		}
		if (!newPw1.equals(newPw2)) {
			ra.addFlashAttribute("error", "새 비밀번호가 일치하지 않습니다.");
			return "redirect:/mypage";
		}
		try {
			authService.updatePassword(lm.mno(), currentPw, newPw1);
			ra.addFlashAttribute("toast", "비밀번호가 변경되었습니다.");
		} catch (IllegalArgumentException e) {
			ra.addFlashAttribute("error", e.getMessage());
		}
		return "redirect:/mypage";
	}

	@PostMapping("/mypage/delete")
	public String deleteMember(@org.springframework.web.bind.annotation.RequestParam("password") String password,
			HttpSession session, RedirectAttributes ra, HttpServletRequest request) {
		com.java.dto.LoginMember lm = (com.java.dto.LoginMember) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (lm == null) {
			return "redirect:/login";
		}
		try {
			authService.deleteMember(lm.mno(), password);
			session.invalidate();
			ra.addFlashAttribute("toast", "회원탈퇴가 완료되었습니다.");
			return "redirect:/main";
		} catch (IllegalArgumentException e) {
			ra.addFlashAttribute("error", e.getMessage());
			return "redirect:/mypage";
		}
	}

	/* ── 프로필 이미지 서빙 ── */
	@GetMapping("/profile-image/{filename}")
	@org.springframework.web.bind.annotation.ResponseBody
	public org.springframework.http.ResponseEntity<org.springframework.core.io.Resource> profileImage(
			@org.springframework.web.bind.annotation.PathVariable("filename") String filename) {
		if (!filename.matches("^[a-zA-Z0-9._-]+$")) {
			return org.springframework.http.ResponseEntity.badRequest().build();
		}
		Path path = Paths.get(System.getProperty("user.dir"), "uploads", "profiles", filename);
		org.springframework.core.io.FileSystemResource res = new org.springframework.core.io.FileSystemResource(
				path.toFile());
		if (!res.exists()) {
			return org.springframework.http.ResponseEntity.notFound().build();
		}
		return org.springframework.http.ResponseEntity.ok()
				.header(org.springframework.http.HttpHeaders.CONTENT_DISPOSITION, "inline")
				.contentType(org.springframework.http.MediaType.IMAGE_JPEG).body(res);
	}

	/* ── 프로필 이미지 AJAX 업로드 (모달에서 페이지 리로드 없이 사용) ── */
	@PostMapping("/mypage/profile-image/ajax")
	@org.springframework.web.bind.annotation.ResponseBody
	public org.springframework.http.ResponseEntity<java.util.Map<String, Object>> uploadProfileImageAjax(
			@org.springframework.web.bind.annotation.RequestParam("file") MultipartFile file, HttpSession session)
			throws IOException {
		com.java.dto.LoginMember lm = (com.java.dto.LoginMember) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (lm == null) {
			return org.springframework.http.ResponseEntity.status(401).build();
		}
		if (file == null || file.isEmpty()) {
			return org.springframework.http.ResponseEntity.badRequest().build();
		}

		// 파일 저장
		String ext = org.springframework.util.StringUtils.getFilenameExtension(file.getOriginalFilename());
		String saved = UUID.randomUUID().toString().replace("-", "") + (ext == null ? "" : "." + ext);
		Path dir = Paths.get(System.getProperty("user.dir"), "uploads", "profiles");
		Files.createDirectories(dir);
		Files.copy(file.getInputStream(), dir.resolve(saved));

		// DB 저장
		authService.updateProfileImage(lm.mno(), saved);

		// 저장된 파일명 반환 → 프론트에서 즉시 img src 교체
		java.util.Map<String, Object> result = new java.util.LinkedHashMap<>();
		result.put("storedFilename", saved);
		return org.springframework.http.ResponseEntity.ok(result);
	}

	/* ── 마이페이지 정보 JSON API (모달용) ── */
	@GetMapping("/mypage/info")
	@org.springframework.web.bind.annotation.ResponseBody
	public org.springframework.http.ResponseEntity<java.util.Map<String, Object>> mypageInfo(HttpSession session) {
		com.java.dto.LoginMember lm = (com.java.dto.LoginMember) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (lm == null) {
			return org.springframework.http.ResponseEntity.status(401).build();
		}
		Member member = authService.getMember(lm.mno());
		java.util.Map<String, Object> map = new java.util.LinkedHashMap<>();
		// 게임 통계
		java.util.List<com.java.game.service.GameRunResult> history = gameService.getPlayerHistory(lm.mno());
		long totalPlays = history.size();
		long finishedPlays = history.stream().filter(r -> "FINISHED".equals(r.phase())).count();
		// 최근 게임 2개 요약
		java.util.List<java.util.Map<String, Object>> recentGames = history.stream().limit(2).map(r -> {
			java.util.Map<String, Object> g = new java.util.LinkedHashMap<>();
			g.put("groupType", r.groupType() != null ? r.groupType() : "UNKNOWN");
			g.put("phase", r.phase());
			g.put("runId", r.runId());
			return g;
		}).collect(java.util.stream.Collectors.toList());

		map.put("nickname", member != null ? member.getNickname() : lm.nickname());
		map.put("mid", lm.mid());
		map.put("email", member != null ? member.getEmail() : null);
		map.put("profileImage", member != null ? member.getProfileImage() : null);
		map.put("totalPlays", totalPlays);
		map.put("finishedPlays", finishedPlays);
		map.put("createdAt", member != null && member.getCreatedAt() != null ? member.getCreatedAtDay() : "-");
		map.put("recentGames", recentGames);
		return org.springframework.http.ResponseEntity.ok(map);
	}

	/* ── 아이디 찾기 페이지 ── */
	@GetMapping("/find-id")
	public String findIdPage() {
		return "auth/find-id";
	}

	@PostMapping("/find-id")
	public String findId(@RequestParam("mname") String mname, @RequestParam("email") String email,
			RedirectAttributes ra) {
		String mid = authService.findMid(mname, email);
		if (mid == null) {
			ra.addFlashAttribute("error", "일치하는 회원 정보가 없습니다.");
			ra.addFlashAttribute("prev_mname", mname);
			ra.addFlashAttribute("prev_email", email);
		} else {
			// 아이디 일부 마스킹: abcdef → abc***
			String masked = mid.length() > 3 ? mid.substring(0, 3) + "*".repeat(mid.length() - 3) : mid;
			ra.addFlashAttribute("foundId", masked);
		}
		return "redirect:/find-id";
	}

	/* ── 비밀번호 찾기 페이지 ── */
	@GetMapping("/find-pw")
	public String findPwPage() {
		return "auth/find-pw";
	}

	@PostMapping("/find-pw")
	public String findPw(@RequestParam("mid") String mid, @RequestParam("mname") String mname,
			@RequestParam("email") String email, @RequestParam("newPassword1") String newPassword1,
			@RequestParam("newPassword2") String newPassword2, RedirectAttributes ra) {

		if (newPassword1 == null || newPassword1.length() < 6) {
			ra.addFlashAttribute("error", "비밀번호는 6자 이상이어야 합니다.");
			ra.addFlashAttribute("prev_mid", mid);
			ra.addFlashAttribute("prev_mname", mname);
			ra.addFlashAttribute("prev_email", email);
			return "redirect:/find-pw";
		}
		if (!newPassword1.equals(newPassword2)) {
			ra.addFlashAttribute("error", "새 비밀번호가 일치하지 않습니다.");
			ra.addFlashAttribute("prev_mid", mid);
			ra.addFlashAttribute("prev_mname", mname);
			ra.addFlashAttribute("prev_email", email);
			return "redirect:/find-pw";
		}

		boolean ok = authService.resetPassword(mid, mname, email, newPassword1);
		if (!ok) {
			ra.addFlashAttribute("error", "아이디, 이름, 이메일이 일치하는 회원이 없습니다.");
			ra.addFlashAttribute("prev_mid", mid);
			ra.addFlashAttribute("prev_mname", mname);
			ra.addFlashAttribute("prev_email", email);
			return "redirect:/find-pw";
		}

		ra.addFlashAttribute("toast", "비밀번호가 변경되었습니다. 새 비밀번호로 로그인해주세요.");
		return "redirect:/login";
	}
}

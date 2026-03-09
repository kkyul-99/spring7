package com.java.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.java.entity.Board;
import com.java.entity.Member;
import com.java.game.entity.GameRun;
import com.java.game.entity.Grade;
import com.java.game.entity.Trainee;
import com.java.game.repository.GameRunRepository;
import com.java.game.repository.TraineeRepository;
import com.java.repository.BoardRepository;
import com.java.repository.MemberRepository;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

	private final MemberRepository memberRepository;
	private final GameRunRepository gameRunRepository;
	private final TraineeRepository traineeRepository;
	private final BoardRepository boardRepository;

	/* ─────────────── 대시보드 ─────────────── */
	@GetMapping
	public String adminDashboard(HttpSession session, Model model) {

		// 로그인 체크
		Object loginMember = session.getAttribute("LOGIN_MEMBER");
		if (loginMember == null) {
			return "redirect:/login?redirect=/admin";
		}

		/* ── 회원 통계 ── */
		List<Member> members = memberRepository.findAll(Sort.by("createdAt").ascending());
		long totalMembers = members.size();

		// 최근 7일 가입자 날짜별
		DateTimeFormatter dayFmt = DateTimeFormatter.ofPattern("MM/dd");
		Map<String, Long> joinByDay = new LinkedHashMap<>();
		for (int i = 6; i >= 0; i--) {
			joinByDay.put(LocalDateTime.now().minusDays(i).format(dayFmt), 0L);
		}
		for (Member m : members) {
			if (m.getCreatedAt() != null && m.getCreatedAt().isAfter(LocalDateTime.now().minusDays(7))) {
				joinByDay.merge(m.getCreatedAt().format(dayFmt), 1L, Long::sum);
			}
		}

		/* ── 게임 통계 ── */
		List<GameRun> gameRuns = gameRunRepository.findAll();
		long totalGames = gameRuns.size();
		long finishedGames = gameRuns.stream().filter(g -> "FINISHED".equals(g.getPhase())).count();
		long activeGames = totalGames - finishedGames;
		long finishRate = totalGames > 0 ? finishedGames * 100 / totalGames : 0;

		// 그룹 타입별 플레이 수
		Map<String, Long> groupTypeCnt = gameRuns.stream().collect(Collectors
				.groupingBy(g -> g.getGroupType() == null ? "UNKNOWN" : g.getGroupType(), Collectors.counting()));
		// 가장 많이 선택된 그룹
		String topGroup = groupTypeCnt.entrySet().stream().max(Map.Entry.comparingByValue()).map(Map.Entry::getKey)
				.orElse("-");

		/* ── 연습생 통계 ── */
		List<Trainee> trainees = traineeRepository.findAll();
		long totalTrainees = trainees.size();
		long cntS = trainees.stream().filter(t -> t.getGrade() != null && "S".equals(t.getGrade().name())).count();
		long cntA = trainees.stream().filter(t -> t.getGrade() != null && "A".equals(t.getGrade().name())).count();
		long cntB = trainees.stream().filter(t -> t.getGrade() != null && "B".equals(t.getGrade().name())).count();
		long cntC = trainees.stream().filter(t -> t.getGrade() != null && "C".equals(t.getGrade().name())).count();

		/* ── 게시판 통계 ── */
		List<Board> allPosts = boardRepository.findAll();
		long totalPosts = allPosts.size();
		long noticePosts = allPosts.stream().filter(b -> "notice".equals(b.getBoardType())).count();
		long freePosts = allPosts.stream().filter(b -> "free".equals(b.getBoardType())).count();
		long reportPosts = allPosts.stream().filter(b -> "report".equals(b.getBoardType())).count();

		// 최근 게시글 5개
		List<Board> recentPosts = allPosts.stream()
				.sorted(Comparator.comparing(Board::getCreatedAt, Comparator.nullsLast(Comparator.reverseOrder())))
				.limit(5).collect(Collectors.toList());

		/* ── 최근 가입 회원 5명 ── */
		List<Member> recentMembers = members.stream()
				.sorted(Comparator.comparing(Member::getCreatedAt, Comparator.nullsLast(Comparator.reverseOrder())))
				.limit(5).collect(Collectors.toList());

		/* ── Model 전달 ── */
		model.addAttribute("totalMembers", totalMembers);
		model.addAttribute("totalGames", totalGames);
		model.addAttribute("finishedGames", finishedGames);
		model.addAttribute("activeGames", activeGames);
		model.addAttribute("finishRate", finishRate);
		model.addAttribute("topGroup", topGroup);
		model.addAttribute("totalTrainees", totalTrainees);
		model.addAttribute("joinByDayKeys", new ArrayList<>(joinByDay.keySet()));
		model.addAttribute("joinByDayVals", new ArrayList<>(joinByDay.values()));
		model.addAttribute("groupTypeCnt", groupTypeCnt);
		model.addAttribute("cntS", cntS);
		model.addAttribute("cntA", cntA);
		model.addAttribute("cntB", cntB);
		model.addAttribute("cntC", cntC);
		model.addAttribute("recentMembers", recentMembers);
		model.addAttribute("allMembers", members);
		model.addAttribute("totalPosts", totalPosts);
		model.addAttribute("noticePosts", noticePosts);
		model.addAttribute("freePosts", freePosts);
		model.addAttribute("reportPosts", reportPosts);
		model.addAttribute("recentPosts", recentPosts);
		model.addAttribute("allTrainees", trainees);

		return "admin/dashboard";
	}

	/* ─────────────── 회원 강제탈퇴 ─────────────── */
	@PostMapping("/members/{mno}/delete")
	@Transactional
	public String deleteMember(@PathVariable("mno") Long mno, HttpSession session, RedirectAttributes ra) {
		if (session.getAttribute("LOGIN_MEMBER") == null) {
			return "redirect:/login";
		}
		memberRepository.findById(mno).ifPresent(memberRepository::delete);
		ra.addFlashAttribute("success", "회원이 강제 탈퇴 처리되었습니다.");
		return "redirect:/admin";
	}

	/* ─────────────── 연습생 수정 ─────────────── */
	@PostMapping("/trainees/{id}/edit")
	@Transactional
	public String editTrainee(@PathVariable("id") Long id, @RequestParam("name") String name,
			@RequestParam("grade") String grade, @RequestParam("vocal") int vocal, @RequestParam("dance") int dance,
			@RequestParam("star") int star, @RequestParam("mental") int mental, @RequestParam("teamwork") int teamwork,
			HttpSession session, RedirectAttributes ra) {
		if (session.getAttribute("LOGIN_MEMBER") == null) {
			return "redirect:/login";
		}
		traineeRepository.findById(id).ifPresent(t -> {
			t.setName(name);
			t.setGrade(Grade.valueOf(grade));
			t.setVocal(Math.max(0, Math.min(100, vocal)));
			t.setDance(Math.max(0, Math.min(100, dance)));
			t.setStar(Math.max(0, Math.min(100, star)));
			t.setMental(Math.max(0, Math.min(100, mental)));
			t.setTeamwork(Math.max(0, Math.min(100, teamwork)));
		});
		ra.addFlashAttribute("success", "연습생 정보가 수정되었습니다.");
		return "redirect:/admin#trainees";
	}

	/* ─────────────── 연습생 삭제 ─────────────── */
	@PostMapping("/trainees/{id}/delete")
	@Transactional
	public String deleteTrainee(@PathVariable("id") Long id, HttpSession session, RedirectAttributes ra) {
		if (session.getAttribute("LOGIN_MEMBER") == null) {
			return "redirect:/login";
		}
		traineeRepository.deleteById(id);
		ra.addFlashAttribute("success", "연습생이 삭제되었습니다.");
		return "redirect:/admin#trainees";
	}
}

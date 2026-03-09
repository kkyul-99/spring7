package com.java.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.java.config.SessionConst;
import com.java.dto.LoginMember;
import com.java.game.entity.GroupType;
import com.java.game.repository.GameRunRepository;
import com.java.game.service.GameRunResult;
import com.java.game.service.GameService;
import com.java.game.service.SceneResult;
import com.java.game.service.StatChangeResult;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/game")
public class GameController {

	private final GameService gameService;
	private final GameRunRepository gameRunRepository;

	// 게임 홈 (그룹 선택 화면)
	@GetMapping
	public String gameHome() {
		return "game/game";
	}

	// 그룹 선택 후 랜덤 선발 실행
	@PostMapping("/run")
	public String createRun(@RequestParam(name = "groupType") GroupType groupType, HttpSession session) {
		// 로그인 회원이면 playerMno 저장
		LoginMember lm = (LoginMember) session.getAttribute(SessionConst.LOGIN_MEMBER);
		Long runId = gameService.createRunAndPickRoster(groupType);
		if (lm != null) {
			gameService.setPlayerMno(runId, lm.mno());
		}
		return "redirect:/game/run/" + runId + "/roster";
	}

	// 선발 결과 화면
	@GetMapping("/run/{runId}/roster")
	public String roster(@PathVariable(name = "runId") Long runId, Model model) {
		GameRunResult result = gameService.getRunResult(runId);
		model.addAttribute("result", result);
		return "game/roster";
	}

	// 선발 확정 처리
	@PostMapping("/run/{runId}/confirm")
	public String confirmRun(@PathVariable(name = "runId") Long runId) {
		gameService.confirmRun(runId);
		return "redirect:/game/run/" + runId + "/roster";
	}

	// 게임 시작 화면 (현재 phase의 씬+선택지도 DB에서 로드)
	@GetMapping("/run/{runId}/start")
	public String gameStart(@PathVariable(name = "runId") Long runId, Model model) {
		GameRunResult result = gameService.getRunResult(runId);
		model.addAttribute("result", result);

		// FINISHED가 아닌 경우에만 씬 데이터 로드
		if (!"FINISHED".equals(result.phase())) {
			SceneResult scene = gameService.getSceneForRun(runId);
			model.addAttribute("scene", scene);
		}
		return "game/gamestart";
	}
	
	// 랜덤이벤트 처리 API 추가
	@ResponseBody
	@PostMapping("/run/{runId}/random-event")
	public ResponseEntity<StatChangeResult> applyRandomEvent(@PathVariable(name = "runId") Long runId) {
	    StatChangeResult result = gameService.applyRandomEvent(runId);
	    return ResponseEntity.ok(result);
	}

	/**
	 * 선택지 적용 API (AJAX) POST /game/run/{runId}/choice?key=A → StatChangeResult JSON
	 * 반환
	 */
	@ResponseBody
	@PostMapping("/run/{runId}/choice")
	public ResponseEntity<StatChangeResult> applyChoice(@PathVariable(name = "runId") Long runId,
			@RequestParam(name = "key") String key) {
		StatChangeResult result = gameService.applyChoice(runId, key);
		return ResponseEntity.ok(result);
	}
}
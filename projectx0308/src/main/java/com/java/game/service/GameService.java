package com.java.game.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.java.game.entity.GameRun;
import com.java.game.entity.GameRunMember;
import com.java.game.entity.GameScene;
import com.java.game.entity.GameChoice;
import com.java.game.entity.GameRandomEvent;
import com.java.game.entity.Gender;
import com.java.game.entity.GroupType;
import com.java.game.entity.Trainee;
import com.java.game.repository.GameRunMemberRepository;
import com.java.game.repository.GameRunRepository;
import com.java.game.repository.TraineeRepository;
import com.java.game.repository.GameSceneRepository;
import com.java.game.repository.GameChoiceRepository;
import com.java.game.repository.GameRandomEventRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class GameService {

	private final TraineeRepository traineeRepository;
	private final GameRunRepository gameRunRepository;
	private final GameRunMemberRepository gameRunMemberRepository;
	private final GameSceneRepository sceneRepository;
	private final GameChoiceRepository choiceRepository;
	
	private final Random random = new Random();

	@Transactional
	public Long createRunAndPickRoster(GroupType groupType) {
		// 게임 실행 기록 저장
		GameRun run = gameRunRepository.save(new GameRun(groupType.name()));
		// groupType에 따라 4명 선발
		List<Trainee> picked = pickRoster(groupType);
		// 선발 순서 저장
		int order = 1;
		for (Trainee t : picked) {
			gameRunMemberRepository.save(new GameRunMember(run, t, order++));
		}
		return run.getRunId();
	}

	@Transactional(readOnly = true)
	public GameRunResult getRunResult(Long runId) {
		List<GameRunMember> members = gameRunMemberRepository.findRoster(runId);
		if (members.isEmpty()) {
			throw new IllegalArgumentException("존재하지 않는 RUN이거나 roster가 없습니다. runId=" + runId);
		}
		GameRun run = members.get(0).getRun();
		String groupType = run.getGroupType();
		boolean confirmed = run.isConfirmed();
		String phase = run.getPhase();

		List<RosterItem> roster = members.stream().map(m -> toRosterItem(m)).collect(Collectors.toList());

		return new GameRunResult(runId, groupType, roster, confirmed, phase);
	}

	// 선발 결과 확정
	@Transactional
	public void confirmRun(Long runId) {
		GameRun run = gameRunRepository.findById(runId)
				.orElseThrow(() -> new IllegalArgumentException("존재하지 않는 runId: " + runId));
		run.confirm();
	}

	/**
	 * 선택지(A/B/C/D) 적용: - 선발된 멤버 중 랜덤 1명 선택 - 선택지에 연관된 스탯을 ±1~3 범위로 조정 - GameRun
	 * phase 다음 단계로 전진 - 결과 반환
	 */
	@Transactional
	public StatChangeResult applyChoice(Long runId, String choiceKey) {
		// 1. GameRun 조회 및 phase 전진
		GameRun run = gameRunRepository.findById(runId)
				.orElseThrow(() -> new IllegalArgumentException("존재하지 않는 runId: " + runId));
		
		String currentPhase = run.getPhase();

		// 2. 선발 멤버 목록
		List<GameRunMember> members = gameRunMemberRepository.findRoster(runId);
		if (members.isEmpty())
			throw new IllegalStateException("roster가 없습니다.");

		// 3. 랜덤으로 멤버 1명 선택
		GameRunMember target = members.get(random.nextInt(members.size()));
		Trainee trainee = target.getTrainee();

		// 4. 선택지에 따른 주 스탯 결정
		String statName = resolveStatName(choiceKey);

		// 5. 변화량: +1~3 또는 -1~2 (상승 확률이 약간 더 높음)
		int delta = calcDelta(choiceKey);

		// 6. 변경 전 값 저장
		int beforeVal = getStatValue(trainee, statName);

		// 7. 스탯 적용 (엔티티 dirty-check로 자동 UPDATE)
		applyStatToTrainee(trainee, statName, delta);
		
		int afterVal = getStatValue(trainee, statName);
		
		// 8. 랜덤이벤트 발생 여부 체크
	    boolean randomTriggered = false;

	    if (shouldTriggerRandomEvent()) {
	        List<GameRandomEvent> events = randomEventRepository.findByPhase(currentPhase);

	        if (!events.isEmpty()) {
	            GameRandomEvent picked = events.get(random.nextInt(events.size()));
	            run.setPendingRandomEventId(picked.getId());
	            randomTriggered = true;
	        }
	    }
	    
	    // 9. phase 처리
	    String nextPhase;

	    if (randomTriggered) {
	        // 랜덤이벤트가 뜨면 아직 같은 phase 유지
	        nextPhase = currentPhase;
	    } else {
	        // 랜덤이벤트가 없으면 다음 phase로 진행
	        nextPhase = calcNextPhase(currentPhase);
	        run.nextPhase();
	    }
	    gameRunRepository.save(run);

		// 10. 업데이트된 roster 반환
		List<RosterItem> updatedRoster = members.stream().map(this::toRosterItem).collect(Collectors.toList());

		return new StatChangeResult(trainee.getId(), trainee.getName(), statName, afterVal - beforeVal, // clamp 후 실제
																										// delta
				beforeVal, afterVal, nextPhase, updatedRoster);
	}

	/** playerMno 연동 */
	@Transactional
	public void setPlayerMno(Long runId, Long mno) {
		GameRun run = gameRunRepository.findById(runId).orElse(null);
		if (run != null) {
			run.setPlayerMno(mno);
		}
	}

	/** 회원 게임 기록 조회 (최신 10개) */
	@Transactional(readOnly = true)
	public java.util.List<GameRunResult> getPlayerHistory(Long mno) {
		return gameRunRepository.findByPlayerMnoOrderByCreatedAtDesc(mno).stream().limit(10).map(run -> {
			java.util.List<com.java.game.entity.GameRunMember> members = gameRunMemberRepository
					.findRoster(run.getRunId());
			java.util.List<RosterItem> roster = members.stream().map(m -> toRosterItem(m))
					.collect(java.util.stream.Collectors.toList());
			return new GameRunResult(run.getRunId(), run.getGroupType(), roster, run.isConfirmed(), run.getPhase());
		}).collect(java.util.stream.Collectors.toList());
	}

	/* ── 현재 phase의 씬 + 선택지 조회 ── */
	@Transactional(readOnly = true)
	public SceneResult getScene(String phase) {
		GameScene scene = sceneRepository.findByPhase(phase)
				.orElseThrow(() -> new IllegalArgumentException("씬 데이터 없음: " + phase));

		java.util.List<SceneResult.ChoiceItem> choices = choiceRepository.findByPhaseOrderBySortOrder(phase).stream()
				.map(c -> new SceneResult.ChoiceItem(c.getChoiceKey(), c.getChoiceText(), c.getStatTarget()))
				.collect(java.util.stream.Collectors.toList());

		return new SceneResult(phase, scene.getEventType(), scene.getTitle(), scene.getDescription(), choices, false);
	}

	/* ── DB의 statTarget(영문)을 한글로 변환 ── */
	private String resolveStatName(String choiceKey) {
		return switch (choiceKey.toUpperCase()) {
		case "A" -> "보컬";
		case "B" -> "댄스";
		case "C" -> "팀웍";
		case "D" -> "멘탈";
		default -> "스타";
		};
	}

	/* ── 변화량 계산: 대부분 +1~3, 가끔 -1~-2 ── */
	private int calcDelta(String choiceKey) {
		// 70% 확률 상승, 30% 하락
		boolean up = random.nextInt(10) < 7;
		if (up) {
			return random.nextInt(3) + 1; // +1, +2, +3
		} else {
			return -(random.nextInt(2) + 1); // -1, -2
		}
	}

	/* ── 스탯명으로 현재 값 조회 ── */
	private int getStatValue(Trainee t, String statName) {
		return switch (statName) {
		case "보컬" -> t.getVocal();
		case "댄스" -> t.getDance();
		case "스타" -> t.getStar();
		case "멘탈" -> t.getMental();
		case "팀웍" -> t.getTeamwork();
		default -> 0;
		};
	}

	/* ── 스탯 적용 ── */
	private void applyStatToTrainee(Trainee t, String statName, int delta) {
		switch (statName) {
		case "보컬" -> t.applyVocal(delta);
		case "댄스" -> t.applyDance(delta);
		case "스타" -> t.applyStar(delta);
		case "멘탈" -> t.applyMental(delta);
		case "팀웍" -> t.applyTeamwork(delta);
		}
	}

	/* ── 다음 phase 문자열만 미리 계산 (run.nextPhase() 호출 전) ── */
	private String calcNextPhase(String current) {
		return switch (current) {
		case "DAY1_MORNING" -> "DAY1_EVENING";
		case "DAY1_EVENING" -> "DAY2_MORNING";
		case "DAY2_MORNING" -> "DAY2_EVENING";
		case "DAY2_EVENING" -> "DAY3_MORNING";
		case "DAY3_MORNING" -> "DAY3_EVENING";
		default -> "FINISHED";
		};
	}

	/* ── GameRunMember → RosterItem 변환 ── */
	private RosterItem toRosterItem(GameRunMember m) {
		Trainee t = m.getTrainee();
		return new RosterItem(t.getId(), t.getName(), t.getGender(), t.getGrade() != null ? t.getGrade().name() : "",
				t.getVocal(), t.getDance(), t.getStar(), t.getMental(), t.getTeamwork(), t.getImagePath(),
				m.getPickOrder());
	}

	private List<Trainee> pickRoster(GroupType groupType) {
		List<Trainee> all = traineeRepository.findAll();
		List<Trainee> males = all.stream().filter(t -> t.getGender() == Gender.MALE).collect(Collectors.toList());
		List<Trainee> females = all.stream().filter(t -> t.getGender() == Gender.FEMALE).collect(Collectors.toList());

		Collections.shuffle(males);
		Collections.shuffle(females);

		List<Trainee> result = new ArrayList<>(4);
		switch (groupType) {
		case MIXED -> {
			if (males.size() < 2 || females.size() < 2)
				throw new IllegalStateException("혼성 구성에 필요한 연습생이 부족합니다.");
			result.add(males.get(0));
			result.add(males.get(1));
			result.add(females.get(0));
			result.add(females.get(1));
		}
		case MALE -> {
			if (males.size() < 4)
				throw new IllegalStateException("남자 연습생이 4명 미만입니다.");
			result.addAll(males.subList(0, 4));
		}
		case FEMALE -> {
			if (females.size() < 4)
				throw new IllegalStateException("여자 연습생이 4명 미만입니다.");
			result.addAll(females.subList(0, 4));
		}
		default -> throw new IllegalArgumentException("지원하지 않는 groupType: " + groupType);
		}
		return result;
	}
	
	// 랜덤 이벤트
	private final GameRandomEventRepository randomEventRepository;
	
	// 씬 조회 시, 해당 phase에 대기 중인 랜덤이벤트가 있으면 그것부터 보여주도록 수정
	@Transactional
	public SceneResult getSceneForRun(Long runId) {
	    GameRun run = gameRunRepository.findById(runId)
	            .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 runId: " + runId));

	    String phase = run.getPhase();

	    // 랜덤이벤트가 대기 중이면 그것부터 보여줌
	    if (run.getPendingRandomEventId() != null) {
	        GameRandomEvent event = randomEventRepository.findById(run.getPendingRandomEventId())
	                .orElseThrow(() -> new IllegalStateException("랜덤이벤트를 찾을 수 없습니다."));

	        return new SceneResult(
	                phase,
	                "🎲 RANDOM EVENT",
	                event.getTitle(),
	                event.getDescription(),
	                java.util.Collections.emptyList(),
	                true
	        );
	    }

	    // 아니면 무조건 일반 씬 보여줌
	    GameScene scene = sceneRepository.findByPhase(phase)
	            .orElseThrow(() -> new IllegalArgumentException("씬 데이터 없음: " + phase));

	    List<SceneResult.ChoiceItem> choices =
	            choiceRepository.findByPhaseAndChoiceKeyInOrderBySortOrder(
	                            phase,
	                            java.util.List.of("A", "B", "C", "D")
	                    ).stream()
	                    .map(c -> new SceneResult.ChoiceItem(
	                            c.getChoiceKey(),
	                            c.getChoiceText(),
	                            c.getStatTarget()
	                    ))
	                    .toList();

	    return new SceneResult(
	            phase,
	            scene.getEventType(),
	            scene.getTitle(),
	            scene.getDescription(),
	            choices,
	            false
	    );
	}
	
	// 35% 확률
	private boolean shouldTriggerRandomEvent() {
		return true;
//	    return random.nextInt(100) < 35;
	}
	
	// 랜덤이벤트 처리 메서드
	@Transactional
	public StatChangeResult applyRandomEvent(Long runId) {
	    GameRun run = gameRunRepository.findById(runId)
	            .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 runId: " + runId));

	    Long eventId = run.getPendingRandomEventId();
	    if (eventId == null) {
	        throw new IllegalStateException("진행 중인 랜덤이벤트가 없습니다.");
	    }

	    GameRandomEvent event = randomEventRepository.findById(eventId)
	            .orElseThrow(() -> new IllegalStateException("랜덤이벤트를 찾을 수 없습니다."));

	    String nextPhase = calcNextPhase(run.getPhase());
	    run.nextPhase();
	    run.setPendingRandomEventId(null);

	    List<GameRunMember> members = gameRunMemberRepository.findRoster(runId);
	    if (members.isEmpty()) {
	        throw new IllegalStateException("roster가 없습니다.");
	    }

	    GameRunMember target = members.get(random.nextInt(members.size()));
	    Trainee trainee = target.getTrainee();

	    String statName = convertStatTarget(event.getStatTarget());

	    int delta = event.getDeltaMin();
	    if (event.getDeltaMax() > event.getDeltaMin()) {
	        delta += random.nextInt(event.getDeltaMax() - event.getDeltaMin() + 1);
	    }

	    int beforeVal = getStatValue(trainee, statName);
	    applyStatToTrainee(trainee, statName, delta);
	    int afterVal = getStatValue(trainee, statName);

	    List<RosterItem> updatedRoster = members.stream()
	            .map(this::toRosterItem)
	            .collect(java.util.stream.Collectors.toList());

	    return new StatChangeResult(
	            trainee.getId(),
	            trainee.getName(),
	            statName,
	            afterVal - beforeVal,
	            beforeVal,
	            afterVal,
	            nextPhase,
	            updatedRoster
	    );
	}
	
	private String convertStatTarget(String statTarget) {
	    return switch (statTarget.toUpperCase()) {
	        case "VOCAL" -> "보컬";
	        case "DANCE" -> "댄스";
	        case "STAR" -> "스타";
	        case "MENTAL" -> "멘탈";
	        case "TEAMWORK" -> "팀웍";
	        default -> throw new IllegalArgumentException("알 수 없는 statTarget: " + statTarget);
	    };
	}
	
}

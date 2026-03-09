package com.java.game.config;

import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.java.game.entity.GameChoice;
import com.java.game.entity.GameScene;
import com.java.game.repository.GameChoiceRepository;
import com.java.game.repository.GameSceneRepository;

import lombok.RequiredArgsConstructor;

/**
 * 서버 시작 시 게임 씬(6개) + 선택지(36개)를 DB에 자동 삽입 ApplicationRunner 대신
 * ContextRefreshedEvent 사용 → JPA 완전 초기화 후 실행 보장
 */
@Component
@RequiredArgsConstructor
public class SceneSeedRunner {

	private final GameSceneRepository sceneRepo;
	private final GameChoiceRepository choiceRepo;

	private boolean seeded = false; // 중복 실행 방지

	@EventListener(ContextRefreshedEvent.class)
	@Transactional
	public void onApplicationReady() {
		if (seeded) {
			return;
		}
		seeded = true;
		seedScenes();
		seedChoices();
		System.out.println("[SceneSeedRunner] 씬 " + sceneRepo.count() + "개 / 선택지 " + choiceRepo.count() + "개 준비 완료");
	}

	private void seedScenes() {
		saveScene("DAY1_MORNING", "⚡ TRAINING EVENT", "오늘의 첫 번째 훈련이 시작됩니다",
				"매니저가 연습실 문을 두드린다. 멤버들이 하나둘 모여들기 시작한다. " + "아직 잠기운이 가시지 않은 눈빛이지만, 데뷔를 향한 열망만큼은 누구보다 뜨겁다. "
						+ "오늘 첫 번째 훈련, 무엇에 집중할 것인지 결정할 시간이다. " + "당신의 선택이 멤버들의 첫 성장을 결정짓는다.");

		saveScene("DAY1_EVENING", "🌙 EVENING SESSION", "하루의 마지막 시간, 마무리가 중요합니다",
				"저녁 노을이 연습실 창문을 붉게 물들인다. 멤버들의 체력은 슬슬 바닥을 보이고 있지만 " + "눈빛만큼은 여전히 살아있다. 지금 이 시간을 어떻게 활용하느냐에 따라 내일의 "
						+ "컨디션이 달라진다. 첫날의 마무리, 현명한 선택을 해라.");

		saveScene("DAY2_MORNING", "⚡ TRAINING EVENT", "이틀째 아침, 긴장감이 높아지고 있습니다",
				"어제의 피로가 채 가시기도 전에 아침이 밝았다. 그러나 멤버들의 눈빛은 어제보다 더 선명하다. " + "어젯밤 각자가 반성하고 다짐한 것들이 이 아침을 더욱 무겁게 만든다. "
						+ "데뷔까지 남은 시간이 줄어들수록 지금 이 순간의 선택이 더욱 중요해진다.");

		saveScene("DAY2_EVENING", "🌙 EVENING SESSION", "반환점을 돌았습니다, 지금이 고비입니다",
				"훈련의 절반이 지났다. 일부 멤버들에게서 피로와 긴장의 기색이 역력하다. " + "누군가는 작은 실수에 흔들리고 있고, 누군가는 조용히 이를 악물고 있다. "
						+ "이 저녁을 어떻게 보내느냐가 마지막 날의 퍼포먼스를 결정할 것이다. 팀 전체를 살펴라.");

		saveScene("DAY3_MORNING", "🔥 FINAL DAY", "마지막 날 아침입니다, 모든 걸 쏟아내세요", "드디어 마지막 날이다. 멤버들의 얼굴에는 긴장과 설렘이 뒤섞여 있다. "
				+ "어제 저녁 아무도 잠을 제대로 자지 못했을 것이다. 하지만 눈 아래 그늘조차 " + "지금 이 순간만큼은 빛나고 있다. 데뷔 무대까지 단 하루, 오늘의 훈련이 운명을 가른다.");

		saveScene("DAY3_EVENING", "✨ LAST CHANCE", "마지막 기회입니다, 이 순간을 놓치지 마세요",
				"모든 훈련의 마지막 시간. 멤버들은 지쳐있지만 눈빛만은 누구보다 빛나고 있다. " + "내일이면 무대에 선다. 수백 번의 연습이 하나의 무대로 수렴되는 이 순간, "
						+ "지금 이 저녁이 당신과 멤버들이 함께하는 마지막 훈련 시간이다. 최선을 다해라.");
	}

	private void seedChoices() {
		// DAY1 MORNING
		saveChoice("DAY1_MORNING", "A", "보컬 트레이닝에 집중한다 — 발성과 음정을 끌어올린다", "VOCAL", 1);
		saveChoice("DAY1_MORNING", "B", "안무 연습을 강도 높게 진행한다 — 칼군무를 완성한다", "DANCE", 2);
		saveChoice("DAY1_MORNING", "C", "팀 빌딩 활동을 진행한다 — 멤버 간 유대감을 쌓는다", "TEAMWORK", 3);
		saveChoice("DAY1_MORNING", "D", "멘탈 코칭 세션을 연다 — 무대 공포를 극복시킨다", "MENTAL", 4);
		saveChoice("DAY1_MORNING", "SPECIAL", "카메라 앞에 서는 연습을 한다 — 카리스마를 키운다", "STAR", 5);

		// DAY1 EVENING
		saveChoice("DAY1_EVENING", "A", "보컬 녹음 리뷰를 함께 듣는다 — 스스로 문제점을 찾게 한다", "VOCAL", 1);
		saveChoice("DAY1_EVENING", "B", "스트레칭과 기초 체력 훈련을 병행한다 — 내일을 위해 몸을 관리한다", "DANCE", 2);
		saveChoice("DAY1_EVENING", "C", "저녁 식사를 함께하며 대화한다 — 서로의 고민을 나눈다", "TEAMWORK", 3);
		saveChoice("DAY1_EVENING", "D", "오늘 하루를 일기로 정리하게 한다 — 감정을 글로 풀어낸다", "MENTAL", 4);
		saveChoice("DAY1_EVENING", "SPECIAL", "SNS용 셀프 영상을 촬영한다 — 팬들과의 연결을 연습한다", "STAR", 5);

		// DAY2 MORNING
		saveChoice("DAY2_MORNING", "A", "고음 집중 특훈을 진행한다 — 한계를 넘어서게 한다", "VOCAL", 1);
		saveChoice("DAY2_MORNING", "B", "거울 앞 퍼포먼스 연습을 한다 — 시선과 표정까지 완성한다", "DANCE", 2);
		saveChoice("DAY2_MORNING", "C", "역할 분담 회의를 연다 — 각자의 강점을 포지션에 맞춘다", "TEAMWORK", 3);
		saveChoice("DAY2_MORNING", "D", "명상과 호흡 훈련을 한다 — 집중력을 극대화한다", "MENTAL", 4);
		saveChoice("DAY2_MORNING", "SPECIAL", "언론 인터뷰 대비 질답 훈련을 한다 — 말하는 능력을 키운다", "STAR", 5);

		// DAY2 EVENING
		saveChoice("DAY2_EVENING", "A", "하모니 맞추기 연습을 집중적으로 한다 — 목소리를 하나로 모은다", "VOCAL", 1);
		saveChoice("DAY2_EVENING", "B", "안무 후반부를 반복 숙달한다 — 완성도를 90%에서 100%로", "DANCE", 2);
		saveChoice("DAY2_EVENING", "C", "갈등이 있는 멤버를 중재한다 — 팀워크 회복이 먼저다", "TEAMWORK", 3);
		saveChoice("DAY2_EVENING", "D", "슬럼프에 빠진 멤버를 개별 면담한다 — 동기를 다시 불태운다", "MENTAL", 4);
		saveChoice("DAY2_EVENING", "SPECIAL", "미니 팬미팅 시뮬레이션을 진행한다 — 팬 앞에 서는 연습을 한다", "STAR", 5);

		// DAY3 MORNING
		saveChoice("DAY3_MORNING", "A", "마지막 보컬 체크를 진행한다 — 컨디션을 최상으로 끌어올린다", "VOCAL", 1);
		saveChoice("DAY3_MORNING", "B", "드레스 리허설을 진행한다 — 무대 위 동선을 완벽히 익힌다", "DANCE", 2);
		saveChoice("DAY3_MORNING", "C", "팀 미팅으로 최종 의지를 다진다 — 서로에게 응원의 말을 전한다", "TEAMWORK", 3);
		saveChoice("DAY3_MORNING", "D", "자유 시간을 준다 — 스스로 마음을 정리하게 한다", "MENTAL", 4);
		saveChoice("DAY3_MORNING", "SPECIAL", "무대 위 애드리브 훈련을 한다 — 돌발상황 대처 능력을 키운다", "STAR", 5);

		// DAY3 EVENING
		saveChoice("DAY3_EVENING", "A", "마지막 무대 직전 발성 워밍업을 한다 — 목소리의 떨림을 잡는다", "VOCAL", 1);
		saveChoice("DAY3_EVENING", "B", "무대 입장 퍼포먼스를 최종 점검한다 — 첫 3초가 전부다", "DANCE", 2);
		saveChoice("DAY3_EVENING", "C", "멤버 전원이 손을 맞잡고 파이팅을 외친다 — 하나임을 확인한다", "TEAMWORK", 3);
		saveChoice("DAY3_EVENING", "D", "무대 직전 짧은 명상으로 정신을 가다듬는다 — 두려움을 설렘으로 바꾼다", "MENTAL", 4);
		saveChoice("DAY3_EVENING", "SPECIAL", "데뷔 소감을 미리 써본다 — 성공을 마음속으로 먼저 경험한다", "STAR", 5);
	}

	private void saveScene(String phase, String eventType, String title, String desc) {
		if (!sceneRepo.existsByPhase(phase)) {
			sceneRepo.save(new GameScene(phase, eventType, title, desc));
		}
	}

	private void saveChoice(String phase, String key, String text, String stat, int order) {
		if (!choiceRepo.existsByPhaseAndChoiceKey(phase, key)) {
			choiceRepo.save(new GameChoice(phase, key, text, stat, order));
		}
	}
}

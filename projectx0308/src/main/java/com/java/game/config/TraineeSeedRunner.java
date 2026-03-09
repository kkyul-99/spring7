package com.java.game.config;

import java.util.List;
import java.util.Random;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.java.game.entity.Gender;
import com.java.game.entity.Grade;
import com.java.game.entity.Trainee;
import com.java.game.repository.TraineeRepository;

@Component
public class TraineeSeedRunner implements CommandLineRunner {

	private final TraineeRepository traineeRepository;

	public TraineeSeedRunner(TraineeRepository traineeRepository) {
		this.traineeRepository = traineeRepository;
	}

	/* 랜덤 데이터 풀 */
	private static final String[] HOBBIES = { "노래 듣기", "춤 연습", "독서", "요리", "드라이브", "게임", "수영", "그림 그리기", "영화 감상", "쇼핑",
			"유튜브 보기", "산책", "헬스", "카페 탐방", "사진 찍기" };

	private static final String[] MOTTOS = { "하루하루 최선을 다하자", "포기하지 않으면 반드시 이긴다", "꿈꾸는 자만이 이룰 수 있다", "나를 믿자",
			"오늘의 나는 어제보다 성장했다", "웃으면 복이 온다", "열정이 재능을 이긴다", "지금 이 순간을 즐겨라", "작은 것에도 감사하자", "두려움 없이 도전하자", "진심은 반드시 통한다",
			"빛나는 순간을 위해" };

	private static final String[] MALE_INSTA = { "jun_star_", "minho.official", "siwoo_shine", "hyun_debut", "taejun.x",
			"kangmin_idol", "yujin_trainee", "seokwoo_mv", "dahun_stage", "ryunix_" };

	private static final String[] FEMALE_INSTA = { "soyeon.g", "minji_bloom", "yura_sparkle", "haeun_official",
			"jiyeon_star", "naeun.shine", "eunji_debut", "chaerin_x", "somi_trainee", "yeeun_idol" };

	@Override
	@Transactional
	public void run(String... args) throws Exception {
		Random rnd = new Random();

		/* ── 기존 데이터에 프로필 없으면 채워주기 ── */
		List<Trainee> all = traineeRepository.findAll();
		boolean needsProfile = all.stream().anyMatch(t -> t.getAge() == null);

		if (!needsProfile && !all.isEmpty()) {
			return; // 이미 프로필까지 있으면 스킵
		}

		if (all.isEmpty()) {
			/* 최초 생성 */
			seedInitial(rnd);
		} else {
			/* 기존 데이터에 프로필만 추가 */
			int mIdx = 0, fIdx = 0;
			for (Trainee t : all) {
				fillProfile(t, rnd, t.getGender() == Gender.MALE ? MALE_INSTA[mIdx++ % 10] : FEMALE_INSTA[fIdx++ % 10]);
				traineeRepository.save(t);
			}
			System.out.println("✅ 기존 연습생 프로필 업데이트 완료");
		}
	}

	private void fillProfile(Trainee t, Random rnd, String insta) {
		t.setAge(19 + rnd.nextInt(5)); // 19~23세
		// 성별에 맞는 키/체중 범위
		if (t.getGender() == Gender.MALE) {
			t.setHeight(173 + rnd.nextInt(13)); // 남자: 173~185cm
			t.setWeight(60 + rnd.nextInt(21)); // 남자: 60~80kg
		} else {
			t.setHeight(158 + rnd.nextInt(12)); // 여자: 158~169cm
			t.setWeight(45 + rnd.nextInt(16)); // 여자: 45~60kg
		}
		t.setHobby(HOBBIES[rnd.nextInt(HOBBIES.length)]);
		t.setMotto(MOTTOS[rnd.nextInt(MOTTOS.length)]);
		t.setInstagram(insta);
	}

	private void seedInitial(Random rnd) {
		int[][] maleStats = { { 85, 70, 90, 75, 80 }, { 72, 88, 78, 82, 70 }, { 90, 65, 85, 68, 75 },
				{ 68, 92, 72, 90, 85 }, { 78, 78, 88, 72, 92 }, { 95, 60, 80, 85, 65 }, { 62, 85, 95, 78, 88 },
				{ 80, 80, 70, 95, 72 }, { 75, 95, 65, 70, 90 }, { 88, 72, 82, 88, 78 }, };
		Grade[] maleGrades = { Grade.S, Grade.A, Grade.S, Grade.A, Grade.B, Grade.S, Grade.B, Grade.A, Grade.A,
				Grade.B };

		for (int i = 0; i < 10; i++) {
			String img = "/images/trainee/m" + String.format("%02d", i + 1) + ".jpg";
			int[] s = maleStats[i];
			Trainee t = new Trainee("남연습생" + (i + 1), Gender.MALE, maleGrades[i], s[0], s[1], s[2], s[3], s[4], img);
			fillProfile(t, rnd, MALE_INSTA[i]);
			traineeRepository.save(t);
		}

		int[][] femaleStats = { { 92, 75, 88, 80, 70 }, { 78, 90, 82, 70, 85 }, { 65, 85, 95, 88, 78 },
				{ 88, 68, 75, 92, 90 }, { 72, 95, 70, 78, 88 }, { 85, 82, 92, 65, 75 }, { 70, 78, 85, 90, 92 },
				{ 95, 70, 78, 85, 68 }, { 80, 88, 68, 72, 95 }, { 68, 92, 90, 95, 82 }, };
		Grade[] femaleGrades = { Grade.S, Grade.A, Grade.A, Grade.S, Grade.B, Grade.A, Grade.B, Grade.S, Grade.A,
				Grade.B };

		for (int i = 0; i < 10; i++) {
			String img = "/images/trainee/f" + String.format("%02d", i + 1) + ".jpg";
			int[] s = femaleStats[i];
			Trainee t = new Trainee("여연습생" + (i + 1), Gender.FEMALE, femaleGrades[i], s[0], s[1], s[2], s[3], s[4],
					img);
			fillProfile(t, rnd, FEMALE_INSTA[i]);
			traineeRepository.save(t);
		}

		System.out.println("✅ 연습생 시드 데이터 + 프로필 생성 완료: 남자 10명, 여자 10명");
	}
}
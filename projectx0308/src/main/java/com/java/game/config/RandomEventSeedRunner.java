package com.java.game.config;

import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.java.game.entity.GameRandomEvent;
import com.java.game.repository.GameRandomEventRepository;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class RandomEventSeedRunner {

    private final GameRandomEventRepository repo;
    private boolean seeded = false;

    @EventListener(ContextRefreshedEvent.class)
    @Transactional
    public void seed() {
        if (seeded) return;
        seeded = true;

        save("DAY1_MORNING", "갑작스러운 칭찬", "트레이너가 한 멤버의 가능성을 크게 칭찬했다. 자신감이 오른다.", "STAR", 1, 3);
        save("DAY1_MORNING", "목 상태 난조", "한 멤버가 아침부터 목 상태가 좋지 않다.", "VOCAL", -2, -1);

        save("DAY1_EVENING", "안무 영상 바이럴", "짧게 찍은 연습 영상이 반응을 얻었다.", "STAR", 1, 2);
        save("DAY1_EVENING", "가벼운 삐끗함", "연습 중 발목을 살짝 접질렀다.", "DANCE", -2, -1);

        save("DAY2_MORNING", "예상 밖의 호흡", "둘의 합이 갑자기 좋아지며 팀 분위기가 오른다.", "TEAMWORK", 1, 3);
        save("DAY2_MORNING", "멘탈 흔들림", "악플 비슷한 피드백을 보고 한 멤버가 흔들린다.", "MENTAL", -2, -1);

        save("DAY2_EVENING", "집중력 폭발", "늦은 시간인데도 오히려 몰입이 올라간다.", "MENTAL", 1, 2);
        save("DAY2_EVENING", "화음 대박", "하모니가 딱 맞아떨어지는 순간이 나왔다.", "VOCAL", 1, 3);

        save("DAY3_MORNING", "카메라 적응 완료", "카메라 리허설에서 존재감이 확 살아난다.", "STAR", 2, 3);
        save("DAY3_MORNING", "팀 구호 효과", "팀 구호 한 번에 분위기가 하나로 뭉친다.", "TEAMWORK", 1, 2);

        save("DAY3_EVENING", "긴장 최고조", "무대 직전 긴장감이 급격히 올라간다.", "MENTAL", -2, -1);
        save("DAY3_EVENING", "마지막 각성", "막판 집중력이 폭발한다.", "DANCE", 1, 3);
    }

    private void save(String phase, String title, String description, String statTarget, int deltaMin, int deltaMax) {
        repo.save(new GameRandomEvent(phase, title, description, statTarget, deltaMin, deltaMax));
    }
}

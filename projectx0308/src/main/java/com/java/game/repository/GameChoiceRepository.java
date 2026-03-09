package com.java.game.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.java.game.entity.GameChoice;

public interface GameChoiceRepository extends JpaRepository<GameChoice, Long> {
	/** phase에 해당하는 선택지 목록 (정렬 순서대로) */
	List<GameChoice> findByPhaseOrderBySortOrder(String phase);
	List<GameChoice> findByPhaseAndChoiceKeyInOrderBySortOrder(String phase, List<String> choiceKeys);

	/** 중복 삽입 방지 체크 */
	boolean existsByPhaseAndChoiceKey(String phase, String choiceKey);
}

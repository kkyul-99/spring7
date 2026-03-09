package com.java.game.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.java.game.entity.GameScene;

public interface GameSceneRepository extends JpaRepository<GameScene, Long> {
	/** phase 이름으로 씬 1개 조회 */
	Optional<GameScene> findByPhase(String phase);

	/** 해당 phase의 씬이 이미 존재하는지 확인 (중복 삽입 방지) */
	boolean existsByPhase(String phase);
}

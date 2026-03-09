package com.java.game.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.java.game.entity.GameRun;

public interface GameRunRepository extends JpaRepository<GameRun, Long> {
	/** 회원별 게임 기록 (최신순) */
	java.util.List<GameRun> findByPlayerMnoOrderByCreatedAtDesc(Long playerMno);
}
package com.java.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.java.entity.Board;

public interface BoardRepository extends JpaRepository<Board, Long> {

	/** 게시판 타입별 목록 — 최신순 */
	List<Board> findByBoardTypeOrderByCreatedAtDesc(String boardType);
}

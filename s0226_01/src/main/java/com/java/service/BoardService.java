package com.java.service;

import java.util.List;

import org.springframework.data.domain.Sort;

import com.java.dto.BoardDto;

public interface BoardService {

	//전체게시글리스트
	List<BoardDto> findAll(Sort sort);
	//글쓰기저장
	void save(BoardDto bdto);

}

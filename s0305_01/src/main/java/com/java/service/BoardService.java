package com.java.service;

import java.util.List;
import java.util.Map;

import org.springframework.data.domain.Sort;

import com.java.dto.BoardDto;

public interface BoardService {

	//전체게시글리스트 - 하단넘버링(현재페이지,페이지당 개수)
	Map<String, Object> findAll(int page, int size, String category, String search);
	
	//글쓰기저장
	void save(BoardDto bdto);
	//게시글수정 저장
	void update(BoardDto bdto);
	//답변달기 저장
	void reply(BoardDto bdto);
	
	//게시글 1개 가져오기
	Map<String, Object> findById(Integer bno);
	//게시글 삭제
	void deleteById(Integer bno);
	

}

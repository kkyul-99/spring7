package com.java.service;

import java.util.List;
import java.util.Map;

import org.springframework.data.domain.Sort;

import com.java.dto.BoardDto;

public interface BoardService {

	//전체 게시글 리스트
	List<BoardDto> findAll(Sort sort);
	
	//글쓰기 저장
	void save(BoardDto bdto);
    //게시글 수정 저장	
	void update(BoardDto bdto);
	//게시글 답변달기 저장
	void reply(BoardDto bdto);
	
	//게시글 1개 가져오기
    Map<String, Object> findById(Integer bno);
	
    //게시글 삭제
	void deleteById(Integer bno);

}

package com.java.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.java.dto.BoardDto;
import com.java.dto.SearchDto;

@Mapper
public interface BoardMapper {

	//게시글 전체가져오기
	int selectAllCount();
	List<BoardDto> selectAll(
			@Param("startrow") int startrow,
            @Param("endrow") int endrow);
	//검색
	List<BoardDto> selectSearch(SearchDto searchDto);
	
	//게시글 상세보기
	BoardDto selectOne(BoardDto boardDto);
	//이전글
	BoardDto selectOnePrev(BoardDto boardDto);
	//다음글
	BoardDto selectOneNext(BoardDto boardDto);
	//조회수 1 증가
	void updateBhit(BoardDto boardDto);
	//게시글 수정
	void updateBoard(BoardDto boardDto);

	//게시글 쓰기
	void insertBoard(BoardDto boardDto);
	//답변달기 같은 bgroup 모두 bstep 1 증가
	void updateReply(BoardDto boardDto);
	//답변달기 저장
	void insertReply(BoardDto boardDto);
	
	//게시글 삭제
	void deleteBoard(BoardDto boardDto);
	

}

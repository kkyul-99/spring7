package com.java.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.java.dto.BoardDto;

// component,Controller,Service,Repository,Configuration,Bean

@Mapper // MyBatis에서 지원하는 annotation
// IOC컨테이너에 Dao로 등록
public interface BoardDao {
	
	// 게시글 전체 조회
	List<BoardDto> selectAll();

}

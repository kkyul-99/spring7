package com.java.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.java.dto.BoardDto;

public interface CustomerRepository extends JpaRepository<BoardDto, Integer> {
	
	//제목에서 검색어가 포함되어 있는 단어를 검색함.
	// select * from boarddto where btitle like '%a%' of bcontent like '%a%'
	Page<BoardDto> findByBtitleContainingOrBcontentContaining(String btitle, String bcontent, Pageable pageable);
	Page<BoardDto> findByBtitleContaining(String search, Pageable pageable);
	Page<BoardDto> findByBcontentContaining(String search, Pageable pageable);
	
}

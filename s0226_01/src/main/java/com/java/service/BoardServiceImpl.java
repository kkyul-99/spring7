package com.java.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.java.dto.BoardDto;
import com.java.repository.BoardRepository;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired BoardRepository boardRepository;
	
	//전체게시글리스트
	@Override 
	public List<BoardDto> findAll(Sort sort) {
		List<BoardDto> list = boardRepository.findAll(sort);
		return list;
	}

	//글쓰기저장
	@Transactional // 메소드완료시 기존의 연속성context가 수정되면 db에 자동반영
	@Override
	public void save(BoardDto bdto) {
		//Repository에 저장시 객체를 리턴해줌.
		BoardDto boardDto = boardRepository.save(bdto);
		//bgroup에 bno번호를 다시 넣어줌.
		boardDto.setBgroup(boardDto.getBno());
		//boardRepository.save(boardDto); // @Transactional 있으면 생략가능
	}

}

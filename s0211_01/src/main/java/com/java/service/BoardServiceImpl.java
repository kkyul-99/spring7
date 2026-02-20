package com.java.service;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.java.dao.BoardDao;
import com.java.dto.BoardDto;

@Service
// 객체선언 없이 사용 가능
// IOC컨테이너에 등록 => DI(Dependency Injection) 가능
public class BoardServiceImpl implements BoardService {
	
	@ Autowired BoardDao boardDao;

	@Override
	public List<BoardDto> selectAll() {
		// MyBatis에서 board를 select하는 코드 작성
		List<BoardDto> list = boardDao.selectAll();
		
//		List<BoardDto> list = new ArrayList<>();
//		list.add(new BoardDto(1,"제목1","내용1","aaa",1,0,0,0,null,new Timestamp(System.currentTimeMillis())));
//		list.add(new BoardDto(1,"제목2","내용2","aaa",2,0,0,0,null,new Timestamp(System.currentTimeMillis())));
		return list;
	}

}

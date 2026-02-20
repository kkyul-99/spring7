package com.java.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.java.dto.BoardDto;

@Service
public class BoradServiceImpl implements BoardService {

	@Override
	public List<BoardDto> selectAll() {
		List<BoardDto> list = null;
		return list;
	}

}

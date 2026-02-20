package com.java.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.java.dto.BoardDto;
import com.java.service.BoardService;

@Controller
public class BoardController {
	
	@Autowired BoardService boardService;
	
	@GetMapping("/board/boardList")
	public String boardList(Model model) {
		// service에서 메서드 호출함
		// 게시글 전체 가져오기
		List<BoardDto> list = boardService.selectAll();
		return "boardList";
	}

}

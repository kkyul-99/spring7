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
	
	// jsp에서 하는 방식 - 객체선언
//	BoardService boardService = new BoardServiceImpl();
	
	@Autowired // IOC컨테이너에 등록된 객체를 주입(DI) - 객체선언 불필요
	BoardService boardService;
	
	@GetMapping("/board/blist")
	public String blist(Model model) {
		List<BoardDto> list = boardService.selectAll();
		model.addAttribute("list",list);
		System.out.println("list 개수: "+list.size());
		return "blist";
	}

}

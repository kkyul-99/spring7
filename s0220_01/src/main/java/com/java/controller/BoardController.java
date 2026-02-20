package com.java.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.java.dto.BoardDto;
import com.java.dto.SearchDto;
import com.java.service.BoardService;

import jakarta.servlet.http.HttpSession;

@Controller
public class BoardController {

	@Autowired BoardService boardService;
	@Autowired HttpSession session;
	
	
	
	
	//[답변달기]------------------------------------
	@GetMapping("/board/breply") //답변달기페이지 열기
	public String breply(BoardDto boardDto,Model model)  {
		BoardDto bdto = boardService.selectOne(boardDto);
		model.addAttribute("board",bdto);
		return "board/breply";
	}//
	@PostMapping("/board/breply") //답변달기 저장
	public String doBreply(BoardDto boardDto)  {
		String id = (String) session.getAttribute("session_id");
		boardDto.setId(id);
		boardService.InsertReply(boardDto);
		return "redirect:/board/blist";
	}//------------------------------------
	
	
	
	@PostMapping("/board/bupdate") //수정저장
	public String doBbupdate(BoardDto boardDto,Model model)  {
		// 수정후 1개 가져오기
		BoardDto bdto = boardService.updateBoard(boardDto);
		model.addAttribute("board",bdto);
		String flag = "3";
		String url = String.format(
				"redirect:/board/bview?bno=%s&flag=%s", 
				bdto.getBno(),flag);
		return url;
	}//
	
	//@RequestParam(name="bno",defaultValue = "1") int bno,
	@GetMapping("/board/bupdate") //수정페이지 열기
	public String bupdate(BoardDto boardDto,Model model)  {
		BoardDto bdto = boardService.selectOne(boardDto);
		model.addAttribute("board",bdto);
		return "board/bupdate";
	}//
	
	
//	@PutMapping("/board/bdelete") // 게시글삭제 Method전송방식
	@GetMapping("/board/bdelete")
	public String bdelete(BoardDto boardDto) {
		String id = (String)session.getAttribute("session_id");
		BoardDto bdto = boardService.selectOne(boardDto);
		System.out.println("bdelete id,bdto getId : "+id+","+bdto.getId());
		if(!id.equals(bdto.getId())) return "redirect:/member/login";
		boardService.deleteBoard(boardDto);
		return "redirect:/board/blist?flag=2";
	}
	
	
	@GetMapping("/board/bview") //게시글 상세보기
	public String bview(BoardDto boardDto,
			@RequestParam(name="flag",required = false) String flag,
			Model model) {
		System.out.println("bview bno : "+boardDto.getBno());
		//1개 가져오기
		BoardDto bdto = boardService.selectOne(boardDto);
		model.addAttribute("board",bdto);
		model.addAttribute("flag",flag);
		return "board/bview";
	}
	
	// 검색 ----
	@GetMapping("/board/bsearch")
	public String bsearch(SearchDto searchDto, Model model) {
		System.out.println("검색어: "+searchDto.getCategory()+","+searchDto.getSearch());
		List<BoardDto> list = boardService.selectSearch(searchDto);
		model.addAttribute("list",list);
		model.addAttribute("searchDto",searchDto);
		return "board/blist";
	}
	
	
	@GetMapping("/board/blist") //게시글 전체가져오기
	public String blist(
			@RequestParam(name="flag",required = false) String flag,
			@RequestParam(name="page",defaultValue="1") int page,
			Model model) {
		Map<String, Object> map = boardService.selectAll(page);
		model.addAttribute("flag",flag);
		model.addAttribute("map",map);
		return "board/blist";
	}//
	
	@GetMapping("/board/bwrite") //글쓰기페이지 열기
	public String bwrite() {
		return "board/bwrite";
	}
	
	@PostMapping("/board/bwrite") //글쓰기 저장
	public String bwrite(BoardDto boardDto, Model model) {
		String id = (String) session.getAttribute("session_id");
		boardDto.setId(id);
		System.out.println("제목 : "+boardDto.getBtitle());
		boardService.insertBoard(boardDto);
		
		return "redirect:/board/blist?flag=1";
	}
	
}

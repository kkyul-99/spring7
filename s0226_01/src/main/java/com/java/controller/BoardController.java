package com.java.controller;

import java.io.File;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.multipart.MultipartFile;

import com.java.dto.BoardDto;
import com.java.dto.MemberDto;
import com.java.service.BoardService;
import com.java.service.MemberService;

import jakarta.servlet.http.HttpSession;

@Controller
public class BoardController {
	
	@Autowired BoardService boardService;
	@Autowired MemberService memberService;
	@Autowired HttpSession session;
	
	//글쓰기페이지
	@GetMapping("/board/bwrite")
	public String bwrite(Model model) {
		return "bwrite";
	}
	
	//글쓰기 저장
	@PostMapping("/board/bwrite")
	public String bwrite(BoardDto bdto,
			@RequestPart("file") MultipartFile files,
			Model model) {
		System.out.println("controller bdto : "+bdto.getBtitle());
		// 파일이름 저장
		if(!files.isEmpty()) {
			String fName = files.getOriginalFilename();
			long time = System.currentTimeMillis();
			String refName = String.format("%s_%s",time,fName);
			System.out.println("파일이름: "+fName);
			System.out.println("파일변경이름: "+refName);
			String fileUploadUrl = "C:/upload/";
			File f = new File(fileUploadUrl+refName);
			try {
				files.transferTo(f);
				bdto.setBfile(refName); //변경된 파일이름을 저장
			}catch (Exception e) {e.printStackTrace();}
		}
		
		String id = (String) session.getAttribute("session_id");
		
		// MemberDto객체를 검색해서 저장
		MemberDto mdto = memberService.findById(id);
		bdto.setMemberDto(mdto);
		//글쓰기 저장
		boardService.save(bdto);
		return "redirect:/board/blist";
	}
	
	//전체게시글리스트
	@GetMapping("/board/blist")
	public String blist(Model model) {
		//정렬 - bgroup:역순정렬,bstep:순차정렬
		Sort sort = Sort.by(
				Sort.Order.desc("bgroup"),Sort.Order.asc("bstep"));
		List<BoardDto> list = boardService.findAll(sort);
		System.out.println("controller list : "+list.size());
		model.addAttribute("list",list);
		return "blist";
	}

}

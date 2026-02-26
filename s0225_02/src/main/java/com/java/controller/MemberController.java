package com.java.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.java.dto.MemberDto;
import com.java.service.MemberService;

@Controller
public class MemberController {
	
	@Autowired MemberService memberService;
	
	//로그인 페이지
	@GetMapping("/member/login")
	public String login() {
		return "login";
	}
	
	//로그인 확인
	@PostMapping("/member/login")
	public String login(MemberDto mdto) {
		System.out.println("controller mdto : "+mdto.getId()+","+mdto.getPw());
		
		MemberDto memberDto = memberService.findByIdAndPw(mdto);
		return "redirect:/";
	}
	
	//전체회원리스트 페이지
	@GetMapping("/member/mlist")
	public String mlist() {
		return "mlist";
	}

}

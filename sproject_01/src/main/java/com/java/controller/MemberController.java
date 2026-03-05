package com.java.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.java.dto.MemberDto;
import com.java.service.MemberService;

import jakarta.servlet.http.HttpSession;

@Controller
public class MemberController {
	
	@Autowired MemberService memberService;
	@Autowired HttpSession session;
	
	//01. 로그인페이지 연결
	@GetMapping("/member/login")
	public String login() {
		return "member/login";
	}
	
	//02. 로그인 확인
	@PostMapping("/member/login")
	public String login(MemberDto mdto, Model model) {
		MemberDto memberDto = memberService.findByIdAndPw(mdto);
		if (memberDto != null) {
			session.setAttribute("session_id", memberDto.getId());
			session.setAttribute("session_name", memberDto.getName());
			model.addAttribute("flag",1);
		}else {
			model.addAttribute("flag",-1);
		}
		return "member/login";
	}

	//03. 로그아웃
	@GetMapping("/member/logout")
	public String logout(Model model) {
		session.invalidate();
		model.addAttribute("flag",0);
		return "member/login";
	}
}

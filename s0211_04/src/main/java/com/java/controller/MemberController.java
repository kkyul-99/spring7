package com.java.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.java.dto.Member;
import com.java.service.MemberService;

import jakarta.servlet.http.HttpSession;

@Controller
public class MemberController {
	
    @Autowired HttpSession session;
	// MemberService memberService = new MemberServiceImpl();
	@Autowired MemberService memberService;
	
	@GetMapping("/member/logout")
	public String logout(String flag,Model model) {
		session.invalidate(); // 세션 초기화
		return "redirect:/?flag=0";
	}
	
	@GetMapping("/member/login")
	public String login(String flag,Model model) {
		model.addAttribute("flag",flag);
		return "login";
	}
	
	// 1.HttpServletRequest 2.@RequestParam 3.객체
	// 객체로 받을 때는 DTO의 변수명과 form의 name이 같아야 함
	@PostMapping("/member/login") // form
	// html의 name과 변수명이 같으면 @RequestParam 생략 가능
//	public String login(@RequestParam("id") String userid {
//	public String login(@RequestParam String id) {
	public String login(Member member,Model model) {
		// db연결 - id,pw 일치여부 확인 -> 맞으면 1개 가져오기
		System.out.println("id,pw: "+member.getId()+","+member.getPw());
		Member m = memberService.selectIdAndPw(member);
		if(m != null) {
			System.out.println("m: "+m.getId());
			session.setAttribute("session_id", m.getId());
			session.setAttribute("session_name", m.getName());
			return "redirect:/?flag=1";
		}else {
			System.out.println("아이디 또는 패스워드가 일치하지 않습니다.");
		}
		return "login";
	}

}

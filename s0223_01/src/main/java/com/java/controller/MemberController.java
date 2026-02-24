package com.java.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.support.NullValue;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;

import com.java.dto.MemberDto;
import com.java.service.MemberService;

import lombok.RequiredArgsConstructor;

//@RequiredArgsConstructor
//private final MemberService memberService;

@Controller
public class MemberController {

	@Autowired MemberService memberService;
	
	@GetMapping("/member/memberShip")
	public String memberShip() {
		return "memberShip";
	}
	
	@PostMapping("/member/memberShip")
	public String memberShip(MemberDto mdto,
			@RequestParam(name="phone1",required = false) String phone1,
			@RequestParam(name="phone2",required = false) String phone2,
			@RequestParam(name="phone3",required = false) String phone3
			) {
		String phone = String.format("%s-%s-%s", phone1,phone2,phone3);
		mdto.setPhone(phone);
		
		System.out.println("phone : "+ phone);
		System.out.printf("id,pw,name : %s,%s ",mdto.getId(),mdto.getName());
		
		// 회원가입 db저장
		memberService.save(mdto);
		return "redirect:/";
	}
	
	
	@GetMapping("/member/login") //로그인페이지 호출
	public String login() {
		return "login";
	}
	
	@PostMapping("/member/login") //로그인확인
	public String login(MemberDto mdto) {
		System.out.println("id,pw : "+mdto.getId()+","+mdto.getPw());
		//MemberDto memberDto = memberService.findByIdAndPw(mdto);
		MemberDto memberDto = memberService.selectLogin(mdto);
		System.out.println("login 검색 : "+memberDto.getName());
		return "login";
	}
	
}

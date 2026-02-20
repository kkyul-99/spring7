package com.java.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.java.dto.MemberDto;
import com.java.service.MemberService;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class MemberController {

	@Autowired MemberService memberService;
	@Autowired HttpSession session;
	
	
	//로그아웃
	@GetMapping("/member/logout")
	public String logout() {
		session.invalidate();
		return "redirect:/";
	}//
	
	//로그인페이지
	@GetMapping("/member/login")
	public String login( 
			@RequestParam(name="flag",required = false) String flag,
			Model model) {
		System.out.println("login flag : "+flag);
		model.addAttribute("flag",flag);
		return "member/login";
	}//
	
	//로그인확인 - required : 필수사항 아님. defaultValue : 없을경우 해당값 대체
	@PostMapping("/member/login")
	public String login(MemberDto mdto,
			@RequestParam(name="saveId",required = false) String saveId,
			HttpServletResponse response, Model model ) {
		System.out.println("controller id,pw : "+mdto.getId());
		//saveId 쿠키저장 - id:aaa
		Cookie cookie = new Cookie("cookie_id",mdto.getId());
		if(saveId != null) cookie.setMaxAge(60*60*24*30); //60초*60분*24시간*30일
		else cookie.setMaxAge(0);
		response.addCookie(cookie);
		//로그인확인
		MemberDto memberDto = memberService.selectLogin(mdto);
		if(memberDto != null) {
			System.out.println("memberDto name : "+memberDto.getName());
			session.setAttribute("session_id", memberDto.getId());
			session.setAttribute("session_name", memberDto.getName());
			return "redirect:/?flag=1";
			
		}else {
			System.out.println("id,pw존재하지 않음.");
			return "redirect:/member/login?flag=2";
		}
		
	}//login
	
	
}//class

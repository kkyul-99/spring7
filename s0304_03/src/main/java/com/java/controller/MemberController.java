package com.java.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.java.dto.MemberDto;

import jakarta.servlet.http.HttpSession;

@Controller
public class MemberController {
	@Autowired HttpSession session;
	
	//회원가입페이지
	@GetMapping("/member/memberShip") 
	public String memberShip() {
		return "memberShip";    
	}
	
	//회원가입저장
	@ResponseBody
	@PostMapping("/member/memberShip") 
	public MemberDto memberShip(MemberDto mdto,
			@RequestParam(name="bno", required = false) Integer bno,
			@RequestParam(name="phone1", required = false) String phone1,
			@RequestParam(name="phone2", required = false) String phone2,
			@RequestParam(name="phone3", required = false) String phone3,
			Model model) {
		
		System.out.println("bno : "+bno);
		System.out.println("phone1 : "+phone1);
		System.out.println("id : "+mdto.getId());
		System.out.println("pw : "+mdto.getPw());
		System.out.println("email : "+mdto.getEmail());
//		return "redirect:/member/mlist";    
		return mdto;    
	}
	
	
	
	

}

package com.java.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.java.dto.MemberDto;
import com.java.service.MemberService;

@Controller
public class MemberController {
	
	@Autowired
	MemberService memberService;
	
	@GetMapping("/member/mlist") // http://localhost:8181/member/mlist
	public String mlist(Model model) { // 데이터를 view로 전달하기 위해 Model 사용
		List<MemberDto> list = memberService.selectAll();
		model.addAttribute("list",list);
		System.out.println("list 개수: "+list.size());
		return "mlist"; // view resolver가 mlist.jsp로 포워딩
	}

}

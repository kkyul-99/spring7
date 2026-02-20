package com.java.controller;

import java.util.Arrays;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.java.dto.MemberDto;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class MemberController {

    private final FController FController;

    MemberController(FController FController) {
        this.FController = FController;
    }
	
	// @RequestMapping("/login")
	// request는 get/post방식 둘다 가능
	// 하지만 보안상 보통 get/post방식을 나누어서 사용
	@GetMapping("/login")
	public String login(Integer flag,Model model) {
		System.out.println("flag: "+flag);
		model.addAttribute("flag",flag);
		return "login";
	}// login
	
	@PostMapping("/login")
	public String login(HttpServletRequest request,Model model) {
		String id = request.getParameter("id");
		String pw = request.getParameter("pw");
		System.out.println("id: "+id);
		System.out.println("pw: "+pw);
		// jsp -> request.setAttribute()
		// spring -> model.addAttribute()
		if(id.equals("aaa") && pw.equals("1111")) {
			return "redirect:/?flag=1";
		}else {
			return "redirect:/login?flag=2";
			// 아이디 또는 패스워드가 일치하지 않습니다. 다시 로그인해주세요.
		}
		// model.addAttribute("id",id);
		// model.addAttribute("pw",pw);
		//return "doLogin";
	}// login
	
	@GetMapping("/join")
	public String join() {
		return "join";
	}// join
	
	@GetMapping("/mUpdate")
	public String mUpdate(Model model) {
		MemberDto mdto = new MemberDto("aaa","1111","홍길동",
                "010-1111-1111","aaa@naver.com","남자","게임,골프,독서");
		model.addAttribute("member",mdto);
		return "mUpdate";
	}// mUpdate
	
	@PostMapping("/join")
	public String join(HttpServletRequest request,Model model) {
		String id = request.getParameter("id");
		String pw = request.getParameter("pw");
		String name = request.getParameter("name");
		String phone = request.getParameter("phone");
		String email = request.getParameter("email");
		String gender = request.getParameter("gender");
		String[] hobbys = request.getParameterValues("hobby");
		String hobby = Arrays.toString(hobbys);
		System.out.println(String.format("%s,%s,%s,%s,%s,%s,%s",
				id,pw,name,phone,email,gender,hobby));
		model.addAttribute("id",id);
		model.addAttribute("pw",pw);
		model.addAttribute("name",name);
		model.addAttribute("phone",phone);
		model.addAttribute("email",email);
		model.addAttribute("gender",gender);
		model.addAttribute("hobby",hobby);
		return "doJoin";
	}// join

}

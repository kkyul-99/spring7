package com.java.handler;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestController;

//@ControllerAdvice //컨트롤러에서 제일먼저 검색 진행함.
@Controller
//@RestController //문자열로 리턴
public class GlobalExceptionHandler {

	// 최상위 예외처리 진행
	@ExceptionHandler(Exception.class) //각각의 예외처리를 진행
	public String exceptionMethod(IllegalArgumentException e,
			Model model) {
//		return e.getMessage(); //데이터로 리턴
		model.addAttribute("message",e.getMessage());
		return "error";        //jsp 페이지로 리턴
	}
	
//	//IllegalArgumentException만 예외처리를 할 수 있음
//	@ExceptionHandler(IllegalArgumentException.class)
//	public String illegalArgument(IllegalArgumentException e) {
//		return e.getMessage(); //데이터로 리턴
////		return "error";        //jsp 페이지로 리턴
//	}
//	
//	//NullPointerException만 예외처리를 할 수 있음
//	@ExceptionHandler(NullPointerException.class)
//	public String illegalArgument(NullPointerException e) {
//		return "숫자를 0으로 나눌 수 없습니다."; //데이터로 리턴
////		return "error";        //jsp 페이지로 리턴
//	}

}

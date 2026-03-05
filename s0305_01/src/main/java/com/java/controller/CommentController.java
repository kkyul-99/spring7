package com.java.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.java.dto.CommentDto;
import com.java.service.CommentService;

import jakarta.servlet.http.HttpSession;

@Controller
public class CommentController {

	@Autowired CommentService commentService;
	@Autowired HttpSession session;
	
	// 01. 하단 댓글 저장
	@ResponseBody
	@PostMapping("/comment/save")
	public CommentDto save(CommentDto cdto,
			@RequestParam(name="bno",defaultValue = "1") int bno
			) {
		System.out.println("controller ccontent : "+cdto.getCcontent());
		//service 전달
		CommentDto commentDto = commentService.save(cdto,bno);
		return commentDto;
	}//save
	
	// 02. 하단 댓글 삭제
	@ResponseBody
	@DeleteMapping("/comment/delete")
	public String delete(CommentDto cdto) {
		int cno = cdto.getCno();
		System.out.println("댓글번호: "+cno);
		// service 전달
		commentService.deleteById(cno);
		return "삭제성공";
	}//delete
	
	// 05. 하단 댓글 수정 저장
	@ResponseBody
	@PutMapping("/comment/update")
	public CommentDto update(CommentDto cdto) {
		System.out.println("댓글번호: "+cdto.getCno());
		System.out.println("댓글내용: "+cdto.getCcontent());
		// service 전달
		CommentDto commentDto = commentService.save(cdto);
		return commentDto;
	}//update
	
}

package com.java.service;

import java.lang.classfile.constantpool.MemberRefEntry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.java.dto.BoardDto;
import com.java.dto.CommentDto;
import com.java.dto.MemberDto;
import com.java.repository.BoardRepository;
import com.java.repository.CommentRepository;
import com.java.repository.MemberRepository;

import jakarta.servlet.http.HttpSession;

@Service
public class CommentServiceImpl implements CommentService {

	@Autowired CommentRepository commentRepository;
	@Autowired MemberRepository memberRepository;
	@Autowired BoardRepository boardRepository;
	@Autowired HttpSession session;
	
	//하단댓글저장
	@Override
	public CommentDto save(CommentDto cdto, int bno) {
		String id = (String) session.getAttribute("session_id");
		MemberDto mdto = memberRepository.findById(id).get();
		cdto.setMemberDto(mdto);
		BoardDto bdto = boardRepository.findById(bno).get();
		cdto.setBoardDto(bdto);
		//db에 저장
		//cno(자동),ccontent(입력),boardDto(검색),memberDto(검색),cdate(자동)
		CommentDto commentDto = commentRepository.save(cdto);
		return commentDto;
	}

}

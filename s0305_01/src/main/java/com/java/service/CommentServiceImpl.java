package com.java.service;

import java.lang.classfile.constantpool.MemberRefEntry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
	
	// 01. 하단 댓글 저장
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
	
	// 02. 하단 댓글 삭제
	@Override
	public void deleteById(int cno) {
        commentRepository.deleteById(cno);
	}
	
	// 05. 하단 댓글 수정 저장
	@Transactional
	@Override
	public CommentDto save(CommentDto cdto) {
		// cdto -> cno, ccontent (memberDto, boardDto, cdate는 null)
		// save() - cno가 있으면 update, 없으면 insert
		// 01. select
		CommentDto commentDto = commentRepository.findById(cdto.getCno()).get();
		commentDto.setCcontent(cdto.getCcontent());
		// Transactional 어노테이션이 있으면 save() 메서드 호출 안해도 update 됨
//		commentDto = commentRepository.save(cdto);
		return commentDto;
	}

}

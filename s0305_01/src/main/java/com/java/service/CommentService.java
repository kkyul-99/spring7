package com.java.service;

import com.java.dto.CommentDto;

public interface CommentService {
	
	// 01. 하단 댓글 저장
	CommentDto save(CommentDto cdto, int bno);

	// 02. 하단 댓글 삭제
	void deleteById(int cno);

	// 05. 하단 댓글 수정 저장
	CommentDto save(CommentDto cdto);

}

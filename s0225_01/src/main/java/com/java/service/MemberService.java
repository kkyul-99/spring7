package com.java.service;

import java.util.List;

import com.java.dto.MemberDto;

public interface MemberService {

	//로그인확인
	MemberDto findByIdAndPw(MemberDto mdto);
	//전체회원리스트
	List<MemberDto> findAll();
	//회원삭제
	void deleteById(MemberDto mdto);
	//회원가입 저장
	void save(MemberDto mdto);
	//회원정보 상세보기
	MemberDto findById(MemberDto mdto);
	//회원정보 수정저장
	void update(MemberDto mdto);

}

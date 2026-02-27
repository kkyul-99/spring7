package com.java.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.java.dto.MemberDto;
import com.java.repository.MemberRepository;

@Service
public class MemberServiceImpl implements MemberService {

	@Autowired MemberRepository memberRepository;
	
	@Override //로그인확인
	public MemberDto findByIdAndPw(MemberDto mdto) {
		System.out.println("service mdto : "+mdto.getId());
		
		// findByIdAndPw
		// select * from memberDto where id=? and pw=?
		// findByNameOrPhone
		// select * from memberDto where name=? or phone=?
		// findByBnoBetween(1,10)
		// select * from board where between 1 and 10
		//select 1개일때 -> null에 대한 처리를 해줘야 함.
		// 1 .get() : 에러처리를 하지 않음
		// 2 .orElse() : null처리, 빈객체처리
		// 3 .orElseThrow() : 예외처리를 해서 넘겨줄수 있음
		MemberDto memberDto = memberRepository.
				              findByIdAndPw(mdto.getId(),mdto.getPw())
//				              .get();
				              .orElse(null);
//                        	  .orElse(new MemberDto());
//				              .orElseThrow(
//				                ()->{return new IllegalArgumentException();}
//				              );
        
		//지정하는 이름방식을 따르지 않을 경우
//		MemberDto memberDto = memberRepository.
//				              selectLogin(mdto.getId(),mdto.getPw())
//				              .orElse(null);
		return memberDto;
	}//로그인확인

	//전체회원리스트
	// select : 여러개 데이터를 가져오는 경우, null 처리를 할 필요가 없음.
	// List타입 : null값 받아도 됨.
	@Override 
	public List<MemberDto> findAll() {
		// findAll : MemberRepository 메소드선언 할 필요가 없음.
		List<MemberDto> list = memberRepository.findAll();
		return list;
	}

	//회원삭제
	@Override
	public void deleteById(MemberDto mdto) {
		memberRepository.deleteById(mdto.getId());
	}

	//회원가입저장,수정
	@Transactional
	@Override
	public void save(MemberDto mdto) {
		memberRepository.save(mdto);
	}//

	//회원정보 상세보기
	@Override
	public MemberDto findById(String id) {
		MemberDto memberDto = memberRepository.findById(id)
				              .orElse(null);
		return memberDto;
	}

	//회원정보 수정저장
	@Transactional
	@Override
	public void update(MemberDto mdto) {
		// 수정1. 검색후 검색된 데이터에 값변경
		// 아이디,패스워드,이름,폰,이메일,성별,취미
		// 폰,이메일,성별,취미만 수정가능
//		MemberDto memberDto = memberRepository.findById(mdto.getId())
//				              .orElse(null);
//		memberDto.setPhone(mdto.getPhone());
//		memberDto.setEmail(mdto.getEmail());
//		memberDto.setGender(mdto.getGender());
//		memberDto.setHobby(mdto.getHobby());
		
		//수정2. save() : 아이디가 없으면 insert, 아이디가 있으면 update진행
		memberRepository.save(mdto);
	}

}

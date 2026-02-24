package com.java.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.java.dto.MemberDto;
import com.java.repository.MemberRepository;

@Service
public class MemberServiceImpl implements MemberService {

	@Autowired MemberRepository memberRepository;
	
	@Override //로그인
	public MemberDto findByIdAndPw(MemberDto mdto) {
		
		// 검색해서 데이터가 있을 경우 : memberDto 객체를 가져옴.
		// 검색해서 데이터가 없을 경우 : memberDto 빈객체를 생성해서 리턴
		MemberDto memberDto = 
				memberRepository.findByIdAndPw(mdto.getId(),mdto.getPw())
				.get();  // 없을경우 에러처리
				//없을경우 빈객체생성해서 리턴
//				.orElseGet(	()->{ return new MemberDto(); }	); 
		        // 없을경우 예외처리를 해서 리턴
				//.orElseThrow(()-> { return new IllegalArgumentException(); });
		return memberDto;
	}

	@Override
	public MemberDto selectLogin(MemberDto mdto) {
		MemberDto memberDto = memberRepository.selectLogin(
				mdto.getId(),mdto.getPw())
				.get()
				;
		return memberDto;
	}

	@Override //회원가입저장
	public void save(MemberDto mdto) {
		memberRepository.save(mdto);
	}

}

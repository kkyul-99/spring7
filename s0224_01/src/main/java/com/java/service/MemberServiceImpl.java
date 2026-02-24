package com.java.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.java.dto.MemberDto;
import com.java.repository.MemberRepository;

@Service
public class MemberServiceImpl implements MemberService {
	
	@Autowired MemberRepository memberRepository;
	
	@Override //로그인 확인
	public MemberDto findByIdAndPw(MemberDto mdto) {
		System.out.println("service mdto: "+mdto.getId()+", "+mdto.getPw());
		
		// find = select, By = where, id=? and pw=?
		// findByIdAndPwOrName => select * from memberDto where id=? and pw=? or name=?
		MemberDto memberDto =
				memberRepository.findByIdAndPw(mdto.getId(),mdto.getPw())
				// 객체 1개 넘길 때 에러처리 방법 3가지
//				.get(); // 1. 에러 처리를 하지 않음.
				.orElse(null); // 2. null 또는 빈객체 넘겨줄 수 있음.
//				.orElseThrow( // 3. 예외처리 해서 리턴
//						() -> {return new IllegalArgumentException("검색데이터가 없음.");} );
		return memberDto;
	}
	
	@Override //전체회원리스트
	public List<MemberDto> findAll() {
		// 1. 정렬
//		Sort sort = Sort.by(
//				Sort.Order.desc("name"),
//				Sort.Order.asc("id") );
//		List<MemberDto> list = memberRepository.findAll();
		
		// 2. 정렬
		List<MemberDto> list = memberRepository.findAll(
				Sort.by(Sort.Order.desc("name"),
						Sort.Order.asc("id")) );
		return list;
	}
	
	@Override // 회원가입 저장
	public void save(MemberDto mdto) {
		memberRepository.save(mdto);
	}
	
	@Transactional // 하나의 작업 단위로 묶어서 처리하는 것.
	// 연계된 작업이 모두 성공해야 최종적으로 DB에 반영됨(commit). 하나라도 실패하면 전체 작업이 rollback.
	@Override // 회원삭제
	public void deleteById(MemberDto mdto) {
		memberRepository.deleteById(mdto.getId());
	}
	
}

package com.java.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.java.dto.MemberDto;

//@Repository
//JpaRepository<사용객체,primary key타입>
public interface MemberRepository extends JpaRepository<MemberDto, String> {

	//jpa는 select에서 리턴타입이 Optional타입
	Optional<MemberDto> findByIdAndPw(String id, String pw);

	// jpa에서 자동으로 query문을 생성할수 없음.
	@Query(value = "select * from memberDto where id=? and pw=?",
			nativeQuery = true)
	Optional<MemberDto> selectLogin(String id, String pw);

	// save()를 만들지 않아도 찾아서 실행시켜줌.
	

}

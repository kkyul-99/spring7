package com.java.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.java.dto.MemberDto;

// JpaRepository 상속받아야 함.
// <dto객체,dto객체 primary key타입>
// findAll(),findById(),save(),delete(),deleteById(),count()
public interface MemberRepository extends JpaRepository<MemberDto, String> {

	//로그인확인 - 1개 데이터전달 : Optional타입이어야 함.
	Optional<MemberDto> findByIdAndPw(String id, String pw);

	//로그인확인
//	@Query(value = "select * from memberdto where id=? and pw=?",
//			nativeQuery = true)
	// MemberDto 이름을 클래스명과 동일하게 해야함
	@Query("select m from MemberDto m where m.id=:id and m.pw=:pw")
	Optional<MemberDto> selectLogin(@Param("id") String id, 
			@Param("pw") String pw);

}

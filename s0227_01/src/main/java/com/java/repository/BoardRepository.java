package com.java.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import com.java.dto.BoardDto;

public interface BoardRepository extends JpaRepository<BoardDto, Integer> {
	
//	@Query(value="update boardDto set bstep=bstep+1 where bgroup=? and bstep>?",
//			nativeQuery = true)
//	void replyBstepUp(int bgroup, int bstep);
	
	//Query: select가 아닌 update, delete 실행할 때 @Modifying, @Transactional 필요
	@Modifying
	@Transactional
	@Query(value="update boardDto set bstep=bstep+1 where bgroup=:bgroup and bstep>:bstep",
			nativeQuery = true)
	void replyBstepUp(@Param("bgroup") int bgroup, @Param("bstep") int bstep);
	
	//게시글 이전글 가져오기
	@Query(value="select * from boarddto where bno =\n"
			+ "(select pre_bno from (select bno,lag(bno,1,-1) over(order by bgroup desc, bstep asc)\n"
			+ "pre_bno from boarddto) where bno=?)",
			nativeQuery = true)
	Optional<BoardDto> findByPre(Integer bno);
	
	//게시글 다음글 가져오기
	@Query(value="select * from boarddto where bno =\n"
			+ "(select next_bno from (select bno,lead(bno,1,-1) over(order by bgroup desc, bstep asc)\n"
			+ "next_bno from boarddto) where bno=?)",
			nativeQuery = true)
	Optional<BoardDto> findByNext(Integer bno);

}

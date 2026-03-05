package com.java.repository;

import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import com.java.dto.BoardDto;

public interface BoardRepository extends JpaRepository<BoardDto, Integer> {
    //Query : select가 아닌 update,delete 실행할때 @Modifying,@Transactional
	@Modifying
	@Transactional
	@Query(
	value = "update boardDto set bstep=bstep+1 where bgroup=? and bstep>?"
			,nativeQuery = true)
	void replyBstepUp(int bgroup,int bstep );

	//이전글가져오기
	@Query(value="select * from boarddto where bno=( select pre_bno from\r\n"
			+ "(select bno,lag(bno,1,-1) over(order by bgroup desc,bstep asc) \r\n"
			+ "pre_bno from boarddto) where bno=?)"
			,nativeQuery = true)
	Optional<BoardDto> findByPre(Integer bno);
	//다음글가져오기
	@Query(value="select * from boarddto where bno=( select next_bno from\r\n"
			+ "(select bno,lead(bno,1,-1) over(order by bgroup desc,bstep asc) \r\n"
			+ "next_bno from boarddto) where bno=?)"
			,nativeQuery = true)
	Optional<BoardDto> findByNext(Integer bno);

	// 검색 - 제목으로 검색
	Page<BoardDto> findByBtitleContaining(String btitle, Pageable pageable);
	// 검색 - 내용으로 검색
	Page<BoardDto> findByBcontentContaining(String bcontent, Pageable pageable);
	// 검색 - 제목,내용으로 검색
	Page<BoardDto> findByBtitleContainingOrBcontentContaining(String btitle, String bcontent, Pageable pageable);
	
//	@Modifying
//	@Transactional
//	@Query(value = "update boardDto set bstep=bstep+1 where bgroup=:bgroup and bstep>:bstep"
//			,nativeQuery = true)
//	void replyBstepUp(@Param("bgroup") int bgroup,@Param("bstep") int bstep );

}

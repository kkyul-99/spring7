package com.java.service;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.java.dto.BoardDto;
import com.java.repository.BoardRepository;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired BoardRepository boardRepository;
	
	//전체 게시글 리스트
	@Override 
	public List<BoardDto> findAll(Sort sort) {
		List<BoardDto> list = boardRepository.findAll(sort);
		return list;
	}

	//글쓰기 저장
	@Transactional // 메소드완료시 기존의 연속성context가 수정되면 db에 자동반영
	@Override
	public void save(BoardDto bdto) {
		//Repository에 저장시 객체를 리턴해줌.
		BoardDto boardDto = boardRepository.save(bdto);
		//bgroup에 bno번호를 다시 넣어줌.
		boardDto.setBgroup(boardDto.getBno());
		//boardRepository.save(boardDto); // @Transactional 있으면 생략가능
	}
	//게시글 수정 저장
	@Transactional
	@Override
	public void update(BoardDto bdto) {
		BoardDto boardDto = boardRepository.findById(bdto.getBno())
				            .get();
		boardDto.setBtitle(bdto.getBtitle());
		boardDto.setBcontent(bdto.getBcontent());
		boardDto.setBfile(bdto.getBfile());
		boardDto.setBdate(new Timestamp(System.currentTimeMillis()));
		//boardRepository.save(boardDto); // @Transactional 있으면 생략가능
	}
	//게시글 답변달기 저장
	@Transactional
	@Override
	public void reply(BoardDto bdto) {
		// 1. 부모 bgroup에서 부모보다 큰 bstep의 1을 증가시켜줘야함.
		boardRepository.replyBstepUp(bdto.getBgroup(),bdto.getBstep());
		
		// 2. 파일저장 - bno,btitle,bcontent,bfile,bdate
		
		BoardDto boardDto = boardRepository.save(bdto);
		//bgroup: 부모의 값 입력 / bstep,bindent: 부모보다 1증가
		boardDto.setBgroup(bdto.getBgroup());
		boardDto.setBstep(bdto.getBstep()+1);
		boardDto.setBindent(bdto.getBindent()+1);
		
		boardRepository.save(bdto);
	}
	
	//게시글 1개 가져오기
	// JpaRepository에서 제공하는 메소드들
	// findAll(), findById(), save(), delete(), deleteById, count()
	@Transactional(readOnly = true) //정합성을 유지하기 위해서 readOnly = true
	@Override
	public Map<String, Object> findById(Integer bno) {
		Map<String, Object> map = new HashMap<>();
		//이전글
		BoardDto preDto = boardRepository.findByPre(bno)
						  .orElse(null);
//		//다음글
		BoardDto nextDto = boardRepository.findByNext(bno)
						  .orElse(null);
		//해당글
		BoardDto board = boardRepository.findById(bno)
				            //예외처리
				            .orElse(null);
		System.out.println("preDto : "+preDto.getBno());
		System.out.println("nextDto : "+nextDto.getBno());
		map.put("preDto",preDto);
		map.put("nextDto",nextDto);
		map.put("board",board);
		//조회수 1증가 - 조회수 무한증가 방지방법: cookies, session, db등록
		board.setBhit(board.getBhit()+1);
		return map;
	}
	
	//게시글 삭제
	@Override
	public void deleteById(Integer bno) {
		boardRepository.deleteById(bno);
	}
	
}

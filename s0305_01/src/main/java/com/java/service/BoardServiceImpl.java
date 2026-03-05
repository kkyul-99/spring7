package com.java.service;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.java.dto.BoardDto;
import com.java.repository.BoardRepository;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired BoardRepository boardRepository;
	
	//전체게시글리스트
	@Override 
	public Map<String, Object> findAll(int page, int size, String category, String search) {
		//정렬 - bgroup:역순정렬,bstep:순차정렬
		Sort sort = Sort.by(
				Sort.Order.desc("bgroup"),Sort.Order.asc("bstep"));
		//Pageable 0부터 시작, 1페이지가 0페이지가 됨.
		Pageable pageable = PageRequest.of(page-1, size, sort);
		//Repository로 전달해서 db가져옴.
		Page<BoardDto> pageList = null;
		// 검색이 아닐경우
		System.out.println("impl category : "+category);
		if(category==null || category == "") 
			pageList = boardRepository.findAll(pageable);
		else if(category.equals("all"))
			pageList = boardRepository.findByBtitleContainingOrBcontentContaining(search,search,pageable);
		else if(category.equals("btitle"))	
			pageList = boardRepository.findByBtitleContaining(search,pageable);
		else
			pageList = boardRepository.findByBcontentContaining(search,pageable);
		
		List<BoardDto> list = pageList.getContent();
		int maxPage = pageList.getTotalPages();
		int startPage = ((page-1)/5)*5+1; //0-10:1, 11-20:11
		int endPage = Math.min(startPage+5-1,maxPage);       //0-10:10 11-20:20
		//if(endPage>maxPage) endPage = maxPage;
		Map<String, Object> map = new HashMap<>();
		map.put("list", list);             //게시글데이터
		map.put("maxPage", maxPage);       //최대페이지
		map.put("startPage", startPage);   //하단넘버링 시작번호
		map.put("endPage", endPage);       //하단넘버링 끝번호
		map.put("page", page);             //현재페이지
		map.put("category", category);     //검색-카테고리
		map.put("search", search);         //검색-검색어
		return map;
	}//

	//글쓰기저장
	@Transactional // 메소드완료시 기존의 연속성context가 수정되면 db에 자동반영
	@Override
	public void save(BoardDto bdto) {
		//Repository에 저장시 객체를 리턴해줌.
		BoardDto boardDto = boardRepository.save(bdto);
		//bgroup에 bno번호를 다시 넣어줌.
		boardDto.setBgroup(boardDto.getBno());
		//boardRepository.save(boardDto); // @Transactional 있으면 생략가능
	}
	//게시글수정 저장
	@Transactional
	@Override
	public void update(BoardDto bdto) {
		BoardDto boardDto = boardRepository.findById(bdto.getBno())
				            .get();
		boardDto.setBtitle(bdto.getBtitle());
		boardDto.setBcontent(bdto.getBcontent());
		boardDto.setBfile(bdto.getBfile()); 
		boardDto.setBdate(new Timestamp(System.currentTimeMillis()));
	}
	
	//답변달기 저장
	@Transactional
	@Override
	public void reply(BoardDto bdto) {
		
		// 1.작업 부모 bgroup에서 부모보다 큰 bstep에 1을 증가시켜줘야 함.
		boardRepository.replyBstepUp(bdto.getBgroup(),bdto.getBstep());
		
		//bgroup:부모 값입력, bstep,bindent:부모 값 +1을 증가해서 입력
		bdto.setBgroup(bdto.getBgroup());
		bdto.setBstep(bdto.getBstep()+1);
		bdto.setBindent(bdto.getBindent()+1);
		
		boardRepository.save(bdto);
	}
	
	
	

	//게시글 1개 가져오기
	//findAll(),findById(),save(),delete(),deleteById(),count()
	@Transactional(readOnly = true) //readOnly = true : 정합성을 유지
	@Override
	public Map<String, Object> findById(Integer bno) {
		Map<String, Object> map = new HashMap<>();
		//이전글
		BoardDto preDto = boardRepository.findByPre(bno)
				          .orElse(null);
		//다음글
		BoardDto nextDto =boardRepository.findByNext(bno)
				          .orElse(null);
		//해당글
		BoardDto boardDto = boardRepository.findById(bno)
				            .orElse(null);
		map.put("preDto", preDto);
		map.put("nextDto", nextDto);
		map.put("boardDto", boardDto);
		//조회수1증가 - 조회수 방지방법 cookies-쿠키삭제,session,db등록
		boardDto.setBhit(boardDto.getBhit()+1);
		return map;
	}

	//게시글 삭제
	@Override
	public void deleteById(Integer bno) {
		boardRepository.deleteById(bno);
	}//

	

	

}

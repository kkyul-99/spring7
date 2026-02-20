package com.java.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.java.dao.BoardMapper;
import com.java.dto.BoardDto;
import com.java.dto.SearchDto;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired BoardMapper boardMapper;
	
	@Override //게시글 전체가져오기
	public Map<String, Object> selectAll(int page) {
		//1. 하단 넘버링에 필요한 변수
		//총게시글수, 현재페이지, 최대페이지, 첫페이지, 마지막페이지
		//page: 현재페이지
		int count = boardMapper.selectAllCount();
		double rowPerPage = 10; //한페이지당 게시글 수
		int maxPage = (int)Math.ceil(count/rowPerPage); //최대페이지
		int startPage = ((page-1)/10)*10+1; //첫페이지
		int endPage = startPage+10-1; //마지막페이지
		if(endPage>maxPage) endPage = maxPage;
		
		//2. 해당 page의 게시글 가져오기
		int startrow = (page-1)*10+1;
		int endrow = startrow + (int)rowPerPage - 1;
		
		//3. 현재페이지에 해당되는 게시글 전체 가져오기
		List<BoardDto> list = boardMapper.selectAll(startrow,endrow);
		
		//리턴해야할 값: list, 총게시글수, 현재페이지, 최대페이지, 첫페이지, 마지막페이지
		Map<String, Object> map = new HashMap<>();
		map.put("count", count);
		map.put("page", page);
		map.put("maxPage", maxPage);
		map.put("startPage", startPage);
		map.put("endPage", endPage);
		map.put("list", list);
		return map;
	}
	
	@Override //검색
	public List<BoardDto> selectSearch(SearchDto searchDto) {
		List<BoardDto> list = boardMapper.selectSearch(searchDto);
		return list;
	}
	
	@Override //게시글 1개 가져오기
	public BoardDto selectOne(BoardDto boardDto) {
		//현재글
		BoardDto bdto = boardMapper.selectOne(boardDto);
		//이전글
		BoardDto prevdto = boardMapper.selectOnePrev(boardDto);
		//다음글
		BoardDto nextdto = boardMapper.selectOneNext(boardDto);
		
		//조회수 1 증가
		boardMapper.updateBhit(boardDto);
		return bdto;
	}
	@Override //게시글수정 및 1개가져오기
	public BoardDto updateBoard(BoardDto boardDto) {
		//게시글수정
		boardMapper.updateBoard(boardDto);
		//게시글 1개가져오기
		BoardDto bdto = boardMapper.selectOne(boardDto);
		return bdto;
	}

	@Override //게시글쓰기
	public void insertBoard(BoardDto boardDto) {
		boardMapper.insertBoard(boardDto);
	}
	@Override //답변달기 저장
	public void InsertReply(BoardDto boardDto) {
		// 같은 bgroup에 있는 현재 게시글보다 더 높은 bstep을 1씩증가
		boardMapper.updateReply(boardDto);
		// 답변달기 저장
		boardMapper.insertReply(boardDto);
		
	}
	
	@Override //게시글삭제
	public void deleteBoard(BoardDto boardDto) {
		boardMapper.deleteBoard(boardDto);
	}

}

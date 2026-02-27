package com.java.controller;

import java.io.File;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.java.dto.BoardDto;
import com.java.dto.MemberDto;
import com.java.service.BoardService;
import com.java.service.MemberService;

import jakarta.servlet.http.HttpSession;

@Controller
//@RestController //데이터전달(class 내의 모든 메서드에 @ResponseBody가 적용됨)
public class BoardController {
	
	@Autowired BoardService boardService;
	@Autowired MemberService memberService;
	@Autowired HttpSession session;
	
	//게시글 답변달기 저장
	@PostMapping("/board/breply")
	public String breply(BoardDto bdto,
			@RequestPart("file") MultipartFile files,
			Model model) {
		System.out.println("controller bfile : "+bdto.getBfile());
		// 파일이름 저장 - 새로운 파일이 있으면 새로운 파일로, 없으면 기존 파일로
		if(!files.isEmpty()) {
			String fName = files.getOriginalFilename();
			long time = System.currentTimeMillis();
			String refName = String.format("%s_%s",time,fName);
			System.out.println("파일이름: "+fName);
			System.out.println("파일변경이름: "+refName);
			String fileUploadUrl = "C:/upload/";
			File f = new File(fileUploadUrl+refName);
			try {
				files.transferTo(f);
				bdto.setBfile(refName); //변경된 파일이름을 저장
			}catch (Exception e) {e.printStackTrace();}
		}
		
		String id = (String) session.getAttribute("session_id");
		
		// MemberDto객체를 검색해서 저장
		MemberDto mdto = memberService.findById(id);
		bdto.setMemberDto(mdto);
		//답변달기 저장
		boardService.reply(bdto);
		
		return "redirect:/board/blist";
	}
	
	//게시글 답변달기 페이지
	@GetMapping("/board/breply")
	public String breply(
			@RequestParam(name="bno", required = false) Integer bno,
			Model model) {
		System.out.println("controller bno : "+bno);
		//db에서 게시글 1개 가져오기
		Map<String, Object> map = boardService.findById(bno);
		model.addAttribute("board", map.get("boardDto"));
		return "breply";
	}
	
	//게시글 수정 저장
	@PostMapping("/board/bupdate")
	public String bupdate(BoardDto bdto,
			@RequestPart("file") MultipartFile files,
			Model model) {
		System.out.println("controller bno : "+bdto.getBno());
		System.out.println("controller bfile : "+bdto.getBfile());
		// 파일이름 저장 - 새로운 파일이 있으면 새로운 파일로, 없으면 기존 파일로
		if(!files.isEmpty()) {
			String fName = files.getOriginalFilename();
			long time = System.currentTimeMillis();
			String refName = String.format("%s_%s",time,fName);
			System.out.println("파일이름: "+fName);
			System.out.println("파일변경이름: "+refName);
			String fileUploadUrl = "C:/upload/";
			File f = new File(fileUploadUrl+refName);
			try {
				files.transferTo(f);
				bdto.setBfile(refName); //변경된 파일이름을 저장
			}catch (Exception e) {e.printStackTrace();}
		}
		
		String id = (String) session.getAttribute("session_id");
		
		// MemberDto객체를 검색해서 저장
//		MemberDto mdto = memberService.findById(id);
//		bdto.setMemberDto(mdto);
		//수정 저장
		boardService.update(bdto);
		
		return "redirect:/board/blist";
	}
	
	//게시글 수정 페이지
	@GetMapping("/board/bupdate")
	public String bupdate(
			@RequestParam(name="bno", required = false) Integer bno,
			Model model) {
		System.out.println("controller bno : "+bno);
		//db에서 게시글 1개 가져오기
		Map<String, Object> map = boardService.findById(bno);
		model.addAttribute("board", map.get("boardDto"));
		return "bupdate";
	}
	
	//게시글 삭제
	@ResponseBody //데이터전달(해당 메서드에만 적옹)
	@DeleteMapping("/board/bdelete")
	public String bdelete(
			@RequestParam(name="bno", required = false) Integer bno,
			Model model) {
		System.out.println("controller bno : "+bno);
		boardService.deleteById(bno);
		return "성공"; //bview.jsp
	}
	
	//상세보기 페이지
	@GetMapping("/board/bview/{bno}")
	public String bview(
			@PathVariable(name="bno", required = false) Integer bno,
			Model model) {
		System.out.println("controller bno : "+bno);
		Map<String, Object> map = boardService.findById(bno);
		model.addAttribute("board", map.get("board"));
		model.addAttribute("preDto", map.get("preDto"));
		model.addAttribute("nextDto", map.get("nextDto"));
		return "bview";
	}
	
	//글쓰기 페이지
	@GetMapping("/board/bwrite")
	public String bwrite(Model model) {
		return "bwrite";
	}
	
	//글쓰기 저장
	@PostMapping("/board/bwrite")
	public String bwrite(BoardDto bdto,
			@RequestPart("file") MultipartFile files,
			Model model) {
		System.out.println("controller bdto : "+bdto.getBtitle());
		// 파일이름 저장
		if(!files.isEmpty()) {
			String fName = files.getOriginalFilename();
			long time = System.currentTimeMillis();
			String refName = String.format("%s_%s",time,fName);
			System.out.println("파일이름: "+fName);
			System.out.println("파일변경이름: "+refName);
			String fileUploadUrl = "C:/upload/";
			File f = new File(fileUploadUrl+refName);
			try {
				files.transferTo(f);
				bdto.setBfile(refName); //변경된 파일이름을 저장
			}catch (Exception e) {e.printStackTrace();}
		}
		
		String id = (String) session.getAttribute("session_id");
		
		// MemberDto객체를 검색해서 저장
		MemberDto mdto = memberService.findById(id);
		bdto.setMemberDto(mdto);
		//글쓰기 저장
		boardService.save(bdto);
		
		return "redirect:/board/blist";
	}
	
	//전체 게시글 리스트
	@GetMapping("/board/blist")
	public String blist(Model model) {
		//정렬 - bgroup:역순정렬,bstep:순차정렬
		Sort sort = Sort.by(
				Sort.Order.desc("bgroup"),Sort.Order.asc("bstep"));
		List<BoardDto> list = boardService.findAll(sort);
		System.out.println("controller list : "+list.size());
		model.addAttribute("list",list);
		return "blist";
	}

}

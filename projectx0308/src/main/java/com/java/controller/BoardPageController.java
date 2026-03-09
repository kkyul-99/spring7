package com.java.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.java.config.SessionConst;
import com.java.dto.LoginMember;
import com.java.entity.Board;
import com.java.entity.BoardComment;
import com.java.entity.BoardLike;
import com.java.repository.BoardCommentRepository;
import com.java.repository.BoardLikeRepository;
import com.java.repository.BoardRepository;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/boards")
@RequiredArgsConstructor
public class BoardPageController {

	private final BoardRepository boardRepository;
	private final BoardCommentRepository commentRepository;
	private final BoardLikeRepository likeRepository;

	private static final Set<String> IMAGE_EXTS = Set.of("jpg", "jpeg", "png", "gif", "webp", "bmp");

	private static final Map<String, String> BOARD_TITLES = Map.of("notice", "공지사항/이벤트", "free", "자유게시판", "report",
			"버그/리포트");

	/* 목록 */
	@GetMapping("/{type}")
	public String list(@PathVariable("type") String type, Model model) {
		List<Board> posts = boardRepository.findByBoardTypeOrderByCreatedAtDesc(type);
		model.addAttribute("boardType", type);
		model.addAttribute("boardTitle", resolveTitle(type));
		model.addAttribute("posts", posts);
		return "boards/list";
	}

	/* 글쓰기 폼 */
	@GetMapping("/{type}/write")
	public String writeForm(@PathVariable("type") String type, HttpSession session, Model model) {
		if (session.getAttribute(SessionConst.LOGIN_MEMBER) == null)
			return "redirect:/login?redirect=/boards/" + type + "/write";
		model.addAttribute("boardType", type);
		model.addAttribute("boardTitle", resolveTitle(type));
		return "boards/write";
	}

	/* 글쓰기 제출 */
	@PostMapping("/{type}/write")
	public String writeSubmit(@PathVariable("type") String type, @RequestParam("title") String title,
			@RequestParam("content") String content, @RequestParam(value = "file", required = false) MultipartFile file,
			HttpSession session, RedirectAttributes ra) throws IOException {
		LoginMember lm = (LoginMember) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (lm == null)
			return "redirect:/login?redirect=/boards/" + type + "/write";
		String st = StringUtils.trimWhitespace(title), sc = StringUtils.trimWhitespace(content);
		if (!StringUtils.hasText(st)) {
			ra.addFlashAttribute("error", "제목을 입력해주세요.");
			return "redirect:/boards/" + type + "/write";
		}
		if (!StringUtils.hasText(sc)) {
			ra.addFlashAttribute("error", "내용을 입력해주세요.");
			return "redirect:/boards/" + type + "/write";
		}
		String orig = null, stored = null;
		boolean img = false;
		if (file != null && !file.isEmpty()) {
			orig = sanitizeFilename(file.getOriginalFilename());
			stored = storeUpload(file, orig);
			String ext = StringUtils.getFilenameExtension(orig);
			img = ext != null && IMAGE_EXTS.contains(ext.toLowerCase());
		}
		boardRepository.save(new Board(type, st, sc, orig, stored, img, lm.nickname()));
		ra.addFlashAttribute("success", "글이 등록되었습니다.");
		return "redirect:/boards/" + type;
	}

	/* 상세보기 (조회수 증가) */
	@GetMapping("/{type}/{id}")
	@Transactional
	public String view(@PathVariable("type") String type, @PathVariable("id") Long id, HttpSession session,
			Model model) {
		Board post = boardRepository.findById(id).orElse(null);
		if (post == null || !post.getBoardType().equals(type)) {
			model.addAttribute("error", "게시글을 찾을 수 없습니다.");
			model.addAttribute("boardType", type);
			model.addAttribute("boardTitle", resolveTitle(type));
			return "boards/list";
		}
		post.incrementViewCount();
		boardRepository.save(post);
		List<BoardComment> comments = commentRepository.findByBoardIdOrderByCreatedAtAsc(id);
		LoginMember lm = (LoginMember) session.getAttribute(SessionConst.LOGIN_MEMBER);
		boolean liked = lm != null && likeRepository.existsByBoardIdAndMno(id, lm.mno());
		model.addAttribute("boardType", type);
		model.addAttribute("boardTitle", resolveTitle(type));
		model.addAttribute("post", post);
		model.addAttribute("comments", comments);
		model.addAttribute("liked", liked);
		model.addAttribute("loginMember", lm);
		return "boards/view";
	}

	/* 글 수정 폼 */
	@GetMapping("/{type}/{id}/edit")
	public String editForm(@PathVariable("type") String type, @PathVariable("id") Long id, HttpSession session,
			Model model, RedirectAttributes ra) {
		LoginMember lm = (LoginMember) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (lm == null)
			return "redirect:/login";
		Board post = boardRepository.findById(id).orElse(null);
		if (post == null || !post.getBoardType().equals(type)) {
			ra.addFlashAttribute("error", "게시글을 찾을 수 없습니다.");
			return "redirect:/boards/" + type;
		}
		if (!post.getAuthorNick().equals(lm.nickname())) {
			ra.addFlashAttribute("error", "본인 글만 수정할 수 있습니다.");
			return "redirect:/boards/" + type + "/" + id;
		}
		model.addAttribute("boardType", type);
		model.addAttribute("boardTitle", resolveTitle(type));
		model.addAttribute("post", post);
		return "boards/edit";
	}

	/* 글 수정 제출 */
	@PostMapping("/{type}/{id}/edit")
	@Transactional
	public String editSubmit(@PathVariable("type") String type, @PathVariable("id") Long id,
			@RequestParam("title") String title, @RequestParam("content") String content, HttpSession session,
			RedirectAttributes ra) {
		LoginMember lm = (LoginMember) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (lm == null)
			return "redirect:/login";
		Board post = boardRepository.findById(id).orElse(null);
		if (post == null) {
			ra.addFlashAttribute("error", "게시글을 찾을 수 없습니다.");
			return "redirect:/boards/" + type;
		}
		if (!post.getAuthorNick().equals(lm.nickname())) {
			ra.addFlashAttribute("error", "본인 글만 수정할 수 있습니다.");
			return "redirect:/boards/" + type + "/" + id;
		}
		post.setTitle(StringUtils.trimWhitespace(title));
		post.setContent(StringUtils.trimWhitespace(content));
		boardRepository.save(post);
		ra.addFlashAttribute("success", "글이 수정되었습니다.");
		return "redirect:/boards/" + type + "/" + id;
	}

	/* 글 삭제 */
	@PostMapping("/{type}/{id}/delete")
	@Transactional
	public String delete(@PathVariable("type") String type, @PathVariable("id") Long id, HttpSession session,
			RedirectAttributes ra) {
		LoginMember lm = (LoginMember) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (lm == null)
			return "redirect:/login";
		Board post = boardRepository.findById(id).orElse(null);
		if (post == null) {
			ra.addFlashAttribute("error", "게시글을 찾을 수 없습니다.");
			return "redirect:/boards/" + type;
		}
		if (!post.getAuthorNick().equals(lm.nickname())) {
			ra.addFlashAttribute("error", "본인 글만 삭제할 수 있습니다.");
			return "redirect:/boards/" + type + "/" + id;
		}
		commentRepository.deleteByBoardId(id);
		likeRepository.deleteByBoardId(id);
		boardRepository.delete(post);
		ra.addFlashAttribute("success", "글이 삭제되었습니다.");
		return "redirect:/boards/" + type;
	}

	/* 댓글 작성 */
	@PostMapping("/{type}/{id}/comments")
	@Transactional
	public String addComment(@PathVariable("type") String type, @PathVariable("id") Long id,
			@RequestParam("content") String content, HttpSession session, RedirectAttributes ra) {
		LoginMember lm = (LoginMember) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (lm == null)
			return "redirect:/login";
		Board post = boardRepository.findById(id).orElse(null);
		if (post == null) {
			ra.addFlashAttribute("error", "게시글을 찾을 수 없습니다.");
			return "redirect:/boards/" + type;
		}
		String safe = StringUtils.trimWhitespace(content);
		if (!StringUtils.hasText(safe) || safe.length() > 500) {
			ra.addFlashAttribute("error", "댓글은 1~500자로 입력해주세요.");
			return "redirect:/boards/" + type + "/" + id;
		}
		commentRepository.save(new BoardComment(post, safe, lm.nickname(), lm.mno()));
		return "redirect:/boards/" + type + "/" + id + "#comments";
	}

	/* 댓글 삭제 */
	@PostMapping("/{type}/{id}/comments/{cid}/delete")
	@Transactional
	public String deleteComment(@PathVariable("type") String type, @PathVariable("id") Long id,
			@PathVariable("cid") Long cid, HttpSession session, RedirectAttributes ra) {
		LoginMember lm = (LoginMember) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (lm == null)
			return "redirect:/login";
		BoardComment c = commentRepository.findById(cid).orElse(null);
		if (c == null) {
			ra.addFlashAttribute("error", "댓글을 찾을 수 없습니다.");
			return "redirect:/boards/" + type + "/" + id;
		}
		if (!lm.mno().equals(c.getAuthorMno())) {
			ra.addFlashAttribute("error", "본인 댓글만 삭제할 수 있습니다.");
			return "redirect:/boards/" + type + "/" + id;
		}
		commentRepository.delete(c);
		return "redirect:/boards/" + type + "/" + id + "#comments";
	}

	/* 좋아요 토글 (AJAX) */
	@PostMapping("/{type}/{id}/like")
	@ResponseBody
	@Transactional
	public ResponseEntity<Map<String, Object>> toggleLike(@PathVariable("type") String type,
			@PathVariable("id") Long id, HttpSession session) {
		LoginMember lm = (LoginMember) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (lm == null)
			return ResponseEntity.status(401).body(Map.of("error", "로그인이 필요합니다."));
		Board post = boardRepository.findById(id).orElse(null);
		if (post == null)
			return ResponseEntity.status(404).body(Map.of("error", "게시글을 찾을 수 없습니다."));
		Optional<BoardLike> ex = likeRepository.findByBoardIdAndMno(id, lm.mno());
		boolean liked;
		if (ex.isPresent()) {
			likeRepository.delete(ex.get());
			post.decrementLikeCount();
			liked = false;
		} else {
			likeRepository.save(new BoardLike(id, lm.mno()));
			post.incrementLikeCount();
			liked = true;
		}
		boardRepository.save(post);
		return ResponseEntity.ok(Map.of("liked", liked, "likeCount", post.getLikeCount()));
	}

	/* 파일 서빙 */
	@GetMapping("/files/{storedName}")
	public ResponseEntity<Resource> serveFile(@PathVariable("storedName") String storedName,
			@RequestParam(value = "inline", defaultValue = "false") boolean inline) {
		if (!StringUtils.hasText(storedName) || !storedName.matches("^[a-zA-Z0-9._-]+$"))
			return ResponseEntity.badRequest().build();
		Path path = Paths.get(System.getProperty("user.dir"), "uploads", storedName).normalize();
		FileSystemResource resource = new FileSystemResource(path.toFile());
		if (!resource.exists())
			return ResponseEntity.notFound().build();
		MediaType mt = detectMediaType(storedName);
		String disp = inline ? "inline" : "attachment; filename=\"" + storedName + "\"";
		return ResponseEntity.ok().header(HttpHeaders.CONTENT_DISPOSITION, disp).contentType(mt).body(resource);
	}

	private static String resolveTitle(String type) {
		return Optional.ofNullable(BOARD_TITLES.get(type)).orElse("게시판");
	}

	private static String sanitizeFilename(String fn) {
		if (!StringUtils.hasText(fn))
			return "file";
		String b = fn.replaceAll("[\\\\/\\r\\n]", "_");
		return b.length() > 120 ? b.substring(b.length() - 120) : b;
	}

	private static String storeUpload(MultipartFile file, String orig) throws IOException {
		String ext = StringUtils.getFilenameExtension(orig);
		String saved = UUID.randomUUID().toString().replace("-", "") + (ext == null ? "" : "." + ext);
		Path dir = Paths.get(System.getProperty("user.dir"), "uploads");
		Files.createDirectories(dir);
		Files.copy(file.getInputStream(), dir.resolve(saved).normalize());
		return saved;
	}

	private static MediaType detectMediaType(String fn) {
		String ext = StringUtils.getFilenameExtension(fn);
		if (ext == null)
			return MediaType.APPLICATION_OCTET_STREAM;
		return switch (ext.toLowerCase()) {
		case "jpg", "jpeg" -> MediaType.IMAGE_JPEG;
		case "png" -> MediaType.IMAGE_PNG;
		case "gif" -> MediaType.IMAGE_GIF;
		case "webp" -> MediaType.parseMediaType("image/webp");
		default -> MediaType.APPLICATION_OCTET_STREAM;
		};
	}
}
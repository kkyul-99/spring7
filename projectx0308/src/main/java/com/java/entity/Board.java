package com.java.entity;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;

/**
 * 게시판 글 엔티티
 */
@Entity
@Table(name = "BOARD")
@SequenceGenerator(
		name = "board_seq_generator",
		sequenceName = "BOARD_SEQ",
		allocationSize = 1
)
public class Board {

	private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "board_seq_generator")
	private Long id;

	@Column(name = "BOARD_TYPE", nullable = false, length = 20)
	private String boardType;

	@Column(nullable = false, length = 200)
	private String title;

	@Column(nullable = false, columnDefinition = "CLOB")
	private String content;

	@Column(name = "ORIGINAL_FILENAME", length = 255)
	private String originalFilename;

	@Column(name = "STORED_FILENAME", length = 255)
	private String storedFilename;

	@Column(name = "IS_IMAGE", nullable = false)
	private boolean image = false;

	@Column(name = "AUTHOR_NICK", length = 60)
	private String authorNick;

	@Column(name = "VIEW_COUNT", nullable = false)
	private long viewCount = 0;

	@Column(name = "LIKE_COUNT", nullable = false)
	private long likeCount = 0;

	@Column(name = "CREATED_AT", nullable = false)
	private LocalDateTime createdAt;

	@PrePersist
	void onCreate() {
		if (createdAt == null) createdAt = LocalDateTime.now();
	}

	protected Board() {
	}

	public Board(String boardType, String title, String content, String originalFilename, String storedFilename,
			boolean image, String authorNick) {
		this.boardType = boardType;
		this.title = title;
		this.content = content;
		this.originalFilename = originalFilename;
		this.storedFilename = storedFilename;
		this.image = image;
		this.authorNick = authorNick;
	}

	public Long getId() { return id; }
	public String getBoardType() { return boardType; }
	public String getTitle() { return title; }
	public String getContent() { return content; }
	public String getOriginalFilename() { return originalFilename; }
	public String getStoredFilename() { return storedFilename; }
	public boolean isImage() { return image; }
	public String getAuthorNick() { return authorNick; }
	public long getViewCount() { return viewCount; }
	public long getLikeCount() { return likeCount; }

	public void incrementViewCount() { this.viewCount++; }
	public void incrementLikeCount() { this.likeCount++; }
	public void decrementLikeCount() {
		if (this.likeCount > 0) this.likeCount--;
	}

	public LocalDateTime getCreatedAt() { return createdAt; }

	public void setTitle(String t) { this.title = t; }
	public void setContent(String c) { this.content = c; }

	public String getCreatedAtStr() {
		return createdAt != null ? createdAt.format(FMT) : "";
	}
}

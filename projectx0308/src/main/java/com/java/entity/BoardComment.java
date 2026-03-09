package com.java.entity;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;

@Entity
@Table(name = "BOARD_COMMENT")
@SequenceGenerator(
		name = "board_comment_seq_generator",
		sequenceName = "BOARD_COMMENT_SEQ",
		allocationSize = 1
)
public class BoardComment {

	private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "board_comment_seq_generator")
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY, optional = false)
	@JoinColumn(name = "BOARD_ID", nullable = false)
	private Board board;

	@Column(nullable = false, columnDefinition = "CLOB")
	private String content;

	@Column(name = "AUTHOR_NICK", length = 60, nullable = false)
	private String authorNick;

	@Column(name = "AUTHOR_MNO")
	private Long authorMno;

	@Column(name = "CREATED_AT", nullable = false)
	private LocalDateTime createdAt;

	@PrePersist
	void onCreate() {
		if (createdAt == null) createdAt = LocalDateTime.now();
	}

	protected BoardComment() {
	}

	public BoardComment(Board board, String content, String authorNick, Long authorMno) {
		this.board = board;
		this.content = content;
		this.authorNick = authorNick;
		this.authorMno = authorMno;
	}

	public Long getId() { return id; }
	public Board getBoard() { return board; }
	public String getContent() { return content; }
	public String getAuthorNick() { return authorNick; }
	public Long getAuthorMno() { return authorMno; }
	public LocalDateTime getCreatedAt() { return createdAt; }

	public String getCreatedAtStr() {
		return createdAt != null ? createdAt.format(FMT) : "";
	}

	public void setContent(String c) {
		this.content = c;
	}
}

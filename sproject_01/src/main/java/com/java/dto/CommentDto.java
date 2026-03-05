package com.java.dto;

import java.sql.Timestamp;

import org.hibernate.annotations.UpdateTimestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
public class CommentDto {
	
	@Id @GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer cno;
	@Column(length = 2000,nullable = false)
	private String ccontent;
	@ManyToOne
	@JoinColumn(name="bno")
	private BoardDto boardDto;
	@ManyToOne
	private MemberDto memberDto;
	@UpdateTimestamp
	private Timestamp cdate;

}

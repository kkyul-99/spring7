package com.java.game.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;

@Entity
@Table(name = "GAME_RUN")
@SequenceGenerator(
		name = "game_run_seq_generator",
		sequenceName = "GAME_RUN_SEQ",
		allocationSize = 1
)
public class GameRun {

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "game_run_seq_generator")
	@Column(name = "ID")
	private Long runId;

	@Column(name = "GROUP_TYPE", nullable = false, length = 20)
	private String groupType;

	/** 플레이한 회원 mno (비로그인이면 null) */
	@Column(name = "PLAYER_MNO")
	private Long playerMno;

	@Column(name = "CREATED_AT", nullable = false)
	private LocalDateTime createdAt;

	// 선발 확정 여부
	@Column(name = "CONFIRMED", nullable = false)
	private boolean confirmed = false;

	// 현재 진행 단계: MORNING → EVENING → ... (DAY1_MORNING 형태)
	@Column(name = "PHASE", nullable = false, length = 30)
	private String phase = "DAY1_MORNING";

	protected GameRun() {
	}

	public GameRun(String groupType) {
		this.groupType = groupType;
		this.createdAt = LocalDateTime.now();
		this.confirmed = false;
		this.phase = "DAY1_MORNING";
	}

	public Long getRunId() {
		return runId;
	}

	public String getGroupType() {
		return groupType;
	}

	public Long getPlayerMno() {
		return playerMno;
	}

	public void setPlayerMno(Long mno) {
		this.playerMno = mno;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public boolean isConfirmed() {
		return confirmed;
	}

	public String getPhase() {
		return phase;
	}

	public void confirm() {
		this.confirmed = true;
	}

	/** 다음 단계로 진행 */
	public void nextPhase() {
		this.phase = switch (this.phase) {
		case "DAY1_MORNING" -> "DAY1_EVENING";
		case "DAY1_EVENING" -> "DAY2_MORNING";
		case "DAY2_MORNING" -> "DAY2_EVENING";
		case "DAY2_EVENING" -> "DAY3_MORNING";
		case "DAY3_MORNING" -> "DAY3_EVENING";
		case "DAY3_EVENING" -> "FINISHED";
		default -> "FINISHED";
		};
	}
	
	// 현재 단계에서 발생한 랜덤 이벤트 ID (없으면 null)
	@Column(name = "PENDING_RANDOM_EVENT_ID")
	private Long pendingRandomEventId;
	
	public Long getPendingRandomEventId() {
	    return pendingRandomEventId;
	}

	public void setPendingRandomEventId(Long pendingRandomEventId) {
	    this.pendingRandomEventId = pendingRandomEventId;
	}
}

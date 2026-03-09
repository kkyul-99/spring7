package com.java.game.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "GAME_SCENE")
@Getter
@Setter
@NoArgsConstructor
@SequenceGenerator(
		name = "game_scene_seq_generator",
		sequenceName = "GAME_SCENE_SEQ",
		allocationSize = 1
)
public class GameScene {

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "game_scene_seq_generator")
	private Long id;

	@Column(nullable = false, unique = true, length = 50)
	private String phase;

	@Column(nullable = false, length = 50)
	private String eventType;

	@Column(nullable = false, length = 100)
	private String title;

	@Column(nullable = false, columnDefinition = "CLOB")
	private String description;

	public GameScene(String phase, String eventType, String title, String description) {
		this.phase = phase;
		this.eventType = eventType;
		this.title = title;
		this.description = description;
	}
}

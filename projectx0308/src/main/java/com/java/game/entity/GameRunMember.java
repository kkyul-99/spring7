package com.java.game.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "GAME_RUN_MEMBER")
@SequenceGenerator(
		name = "game_run_member_seq_generator",
		sequenceName = "GAME_RUN_MEMBER_SEQ",
		allocationSize = 1
)
public class GameRunMember {

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "game_run_member_seq_generator")
	@Column(name = "ID")
	private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "RUN_ID", nullable = false)
    private GameRun run;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "TRAINEE_ID", nullable = false)
    private Trainee trainee;

    @Column(name = "PICK_ORDER", nullable = false)
    private int pickOrder;

    @Column(name = "CREATED_AT", nullable = false)
    private LocalDateTime createdAt;

    protected GameRunMember() {}

    public GameRunMember(GameRun run, Trainee trainee, int pickOrder) {
        this.run = run;
        this.trainee = trainee;
        this.pickOrder = pickOrder;
        this.createdAt = LocalDateTime.now();
    }

    public Long getId()              { return id; }
    public GameRun getRun()          { return run; }
    public Trainee getTrainee()      { return trainee; }
    public int getPickOrder()        { return pickOrder; }
    public LocalDateTime getCreatedAt() { return createdAt; }
}

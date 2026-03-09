package com.java.game.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;

@Entity
@Table(name = "GAME_RANDOM_EVENT")
@SequenceGenerator(
        name = "game_random_event_seq_generator",
        sequenceName = "GAME_RANDOM_EVENT_SEQ",
        allocationSize = 1
)
public class GameRandomEvent {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "game_random_event_seq_generator")
    private Long id;

    @Column(name = "PHASE", nullable = false, length = 30)
    private String phase;

    @Column(name = "TITLE", nullable = false, length = 100)
    private String title;

    @Column(name = "DESCRIPTION", nullable = false, columnDefinition = "CLOB")
    private String description;

    @Column(name = "STAT_TARGET", nullable = false, length = 20)
    private String statTarget;   // VOCAL / DANCE / STAR / MENTAL / TEAMWORK

    @Column(name = "DELTA_MIN", nullable = false)
    private int deltaMin;

    @Column(name = "DELTA_MAX", nullable = false)
    private int deltaMax;

    protected GameRandomEvent() {}

    public GameRandomEvent(String phase, String title, String description, String statTarget, int deltaMin, int deltaMax) {
        this.phase = phase;
        this.title = title;
        this.description = description;
        this.statTarget = statTarget;
        this.deltaMin = deltaMin;
        this.deltaMax = deltaMax;
    }

    public Long getId() { return id; }
    public String getPhase() { return phase; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public String getStatTarget() { return statTarget; }
    public int getDeltaMin() { return deltaMin; }
    public int getDeltaMax() { return deltaMax; }
}

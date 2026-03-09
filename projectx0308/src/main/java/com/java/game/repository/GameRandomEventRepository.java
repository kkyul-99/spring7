package com.java.game.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.java.game.entity.GameRandomEvent;

public interface GameRandomEventRepository extends JpaRepository<GameRandomEvent, Long> {

    List<GameRandomEvent> findByPhase(String phase);
}

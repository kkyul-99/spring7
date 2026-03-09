package com.java.game.service;

import com.java.game.entity.Gender;

public record RosterItem(
        Long traineeId,
        String name,
        Gender gender,
        String grade,
        int vocal,
        int dance,
        int star,
        int mental,
        int teamwork,
        String imagePath,
        int pickOrder
) {}

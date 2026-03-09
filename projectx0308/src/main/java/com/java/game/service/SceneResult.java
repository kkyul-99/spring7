package com.java.game.service;

import java.util.List;

public record SceneResult(
		String phase,
		String eventType,
		String title,
		String description,
		List<ChoiceItem> choices,
		boolean randomEvent
) {
	public record ChoiceItem(
			String choiceKey,
			String choiceText,
			String statTarget
	) {}
}

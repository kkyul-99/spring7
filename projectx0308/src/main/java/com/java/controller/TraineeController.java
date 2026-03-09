package com.java.controller;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.java.game.entity.Gender;
import com.java.game.entity.Trainee;
import com.java.game.repository.TraineeRepository;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/trainees")
public class TraineeController {

	private final TraineeRepository traineeRepository;

	/**
	 * 아이돌 목록 페이지 GET /trainees?gender=ALL|MALE|FEMALE
	 */
	@GetMapping
	public String list(@RequestParam(name = "gender", defaultValue = "ALL") String gender, Model model) {

		List<Trainee> trainees;

		if ("MALE".equalsIgnoreCase(gender)) {
			trainees = traineeRepository.findByGender(Gender.MALE);
		} else if ("FEMALE".equalsIgnoreCase(gender)) {
			trainees = traineeRepository.findByGender(Gender.FEMALE);
		} else {
			// 전체: 남자 먼저, 여자 나중 정렬
			List<Trainee> all = traineeRepository.findAll();
			trainees = all.stream().sorted((a, b) -> {
				// 등급 순 (S > A > B > C)
				int ga = gradeOrder(a.getGrade() != null ? a.getGrade().name() : "C");
				int gb = gradeOrder(b.getGrade() != null ? b.getGrade().name() : "C");
				if (ga != gb)
					return Integer.compare(ga, gb);
				return a.getName().compareTo(b.getName());
			}).collect(Collectors.toList());
		}

		// 등급 순 정렬
		trainees = trainees.stream().sorted((a, b) -> {
			int ga = gradeOrder(a.getGrade() != null ? a.getGrade().name() : "C");
			int gb = gradeOrder(b.getGrade() != null ? b.getGrade().name() : "C");
			if (ga != gb)
				return Integer.compare(ga, gb);
			return a.getName().compareTo(b.getName());
		}).collect(Collectors.toList());

		// 등급별 카운트
		long cntS = trainees.stream().filter(t -> t.getGrade() != null && "S".equals(t.getGrade().name())).count();
		long cntA = trainees.stream().filter(t -> t.getGrade() != null && "A".equals(t.getGrade().name())).count();
		long cntB = trainees.stream().filter(t -> t.getGrade() != null && "B".equals(t.getGrade().name())).count();
		long cntC = trainees.stream().filter(t -> t.getGrade() == null || "C".equals(t.getGrade().name())).count();

		model.addAttribute("trainees", trainees);
		model.addAttribute("selectedGender", gender.toUpperCase());
		model.addAttribute("totalCount", trainees.size());
		model.addAttribute("cntS", cntS);
		model.addAttribute("cntA", cntA);
		model.addAttribute("cntB", cntB);
		model.addAttribute("cntC", cntC);

		return "trainees/list";
	}

	/** S=0, A=1, B=2, C=3 (오름차순 정렬용) */
	private int gradeOrder(String g) {
		return switch (g) {
		case "S" -> 0;
		case "A" -> 1;
		case "B" -> 2;
		default -> 3;
		};
	}
}

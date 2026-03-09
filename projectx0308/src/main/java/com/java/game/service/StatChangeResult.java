package com.java.game.service;

/**
 * 선택지 적용 후 스탯 변경 결과 DTO - traineeId : 영향받은 연습생 ID - traineeName : 연습생 이름 -
 * statName : 변경된 스탯명 (한글: "보컬", "댄스" 등) - delta : 변경량 (양수=상승, 음수=하락) -
 * beforeVal : 변경 전 값 - afterVal : 변경 후 값 - nextPhase : 다음 진행 단계 (예:
 * DAY1_EVENING) - updatedRoster : 업데이트된 전체 멤버 스탯
 */
public record StatChangeResult(Long traineeId, String traineeName, String statName, int delta, int beforeVal,
		int afterVal, String nextPhase, java.util.List<RosterItem> updatedRoster) {
}

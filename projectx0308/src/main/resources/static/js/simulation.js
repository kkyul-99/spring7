function selectTrainee(name) {
    // 카드를 클릭했을 때 해당 엘리먼트를 찾음 (예시: name을 ID로 쓸 경우)
    const card = document.getElementById(`card-${name}`);

    if (selectedTrainees.includes(name)) {
        selectedTrainees = selectedTrainees.filter(t => t !== name);
        card.classList.remove('selected'); // CSS에서 .selected { border: 2px solid cyan; } 정의
    } else {
        if (selectedTrainees.length < 3) {
            selectedTrainees.push(name);
            card.classList.add('selected');
        } else {
            alert("최대 3명까지만 선택 가능합니다!");
        }
    }
    document.getElementById('selected-count').innerText = selectedTrainees.length;
}

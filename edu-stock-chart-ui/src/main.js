import Chart from 'chart.js/auto';

// 실습 뼈대: 더미 데이터로 차트가 뜨는 것까지만 확인한다.
// 실제 시세 조회는 /api 호출로 교체한다. (vite.config.js 에 프록시 설정됨)
const sample = {
  labels: ['D-4', 'D-3', 'D-2', 'D-1', 'D'],
  values: [70500, 71200, 70800, 72300, 73100],
};

new Chart(document.getElementById('chart'), {
  type: 'line',
  data: {
    labels: sample.labels,
    datasets: [
      {
        label: '종가 (샘플)',
        data: sample.values,
        borderColor: '#141311',
        borderWidth: 1.5,
        pointRadius: 3,
        tension: 0.25,
      },
    ],
  },
  options: {
    responsive: true,
    maintainAspectRatio: false,
    plugins: { legend: { display: true } },
    scales: { y: { beginAtZero: false } },
  },
});

document.getElementById('status').textContent = '샘플 데이터 표시 중 · API 미연결';

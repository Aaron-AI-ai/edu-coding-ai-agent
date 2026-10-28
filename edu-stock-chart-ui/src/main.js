// 코스콤증권 대시보드 · 데이터는 /api/dashboard/* (vite.config.js 프록시 → Spring Boot 8080)
// 버튼은 눌린 상태만 바뀐다. 루프 실습 과제 두 곳은 서버가 구현해야 결과가 바뀐다.
//  - 순위 필터(data-market · data-sort): /api/dashboard/rankings?market=&sort=
//  - 종목 검색(상단 검색창): /api/stocks/search?q=

const $ = (id) => document.getElementById(id);

const fmt = (n) => Number(n).toLocaleString('ko-KR', { maximumFractionDigits: 2 });
const tone = (n) => (n > 0 ? 'up' : n < 0 ? 'down' : '');
const signed = (n) => (n > 0 ? '+' : '') + fmt(n);
const pct = (n) => (n > 0 ? '+' : '') + Number(n).toFixed(2) + '%';
// 억원 → '24.9조원' · '2,417억원'
const won = (eok) => (eok >= 10000 ? `${(eok / 10000).toLocaleString('ko-KR', { minimumFractionDigits: 1, maximumFractionDigits: 1 })}조원` : `${fmt(eok)}억원`);

// 순위 조회 조건 · data-sort 가 없는 버튼(거래량 등)은 조건을 바꾸지 않는다
const rankingQuery = { market: 'ALL', sort: 'TRADE_AMOUNT' };

async function get(path) {
  const res = await fetch(`/api/dashboard/${path}`);
  if (!res.ok) throw new Error(`${path} ${res.status}`);
  return res.json();
}

// 쉼표 구분 값 → SVG 선. 점선은 첫 값(전일 종가 자리)
// span: 선이 차지하는 가로 비율 (장중이라 일부만 그린 효과)
function sparkline(csv, cls, { w = 80, h = 50, fill = false, span = 1 } = {}) {
  if (!csv) return `<svg class="spark" viewBox="0 0 ${w} ${h}"><line class="base" x1="0" x2="${w}" y1="${h / 2}" y2="${h / 2}" /></svg>`;
  const v = csv.split(',').map(Number);
  const min = Math.min(...v), max = Math.max(...v), pad = 4;
  const y = (n) => pad + (h - pad * 2) * (max === min ? 0.5 : 1 - (n - min) / (max - min));
  const x = (i) => (w - pad) * span * (i / (v.length - 1));
  const pts = v.map((n, i) => `${x(i).toFixed(1)},${y(n).toFixed(1)}`).join(' ');
  const [lx, ly] = [x(v.length - 1), y(v.at(-1))];
  return `<svg class="spark ${cls}" viewBox="0 0 ${w} ${h}">
    <line class="base" x1="0" x2="${w}" y1="${y(v[0])}" y2="${y(v[0])}" />
    ${fill ? `<polygon class="area" points="0,${h} ${pts} ${lx},${h}" />` : ''}
    <polyline points="${pts}" />
    <circle cx="${lx}" cy="${ly}" r="3" />
  </svg>`;
}

function tags(idx) {
  if (!idx.tag) return '';
  return idx.tag.split(',').map((t, i) => `<span class="tag ${idx.tagHot && i === 0 ? 'hot' : ''}">${t}</span>`).join('');
}

function priceLine(idx) {
  if (idx.price == null) return `<div class="price link">실시간 시세 보기 <span class="chev">›</span></div>`;
  return `<div class="price">${fmt(idx.price)} <span class="${tone(idx.changeRate)}">${signed(idx.changeAmount)} (${fmt(Math.abs(idx.changeRate))}%)</span></div>`;
}

function renderIndices(list) {
  const board = list.filter((i) => i.onBoard);
  const [main, ...rest] = board;
  $('main-index').innerHTML = `
    <div class="name">${main.name} ${tags(main)}</div>
    ${priceLine(main)}
    ${sparkline(main.sparkline, tone(main.changeRate), { w: 330, h: 90, fill: true, span: 0.14 })}
    <dl class="range"><dt>52주 최고</dt><dt>52주 최저</dt><dd>${fmt(main.high52w)}</dd><dd>${fmt(main.low52w)}</dd></dl>`;
  $('index-grid').innerHTML = rest.map((i) => `
    <div class="index-card ${i.tagHot ? 'hot' : ''}">
      ${sparkline(i.sparkline, tone(i.changeRate))}
      <div><div class="name">${i.name} ${tags(i)}</div>${priceLine(i)}</div>
    </div>`).join('');
  $('ticker-items').innerHTML = list.filter((i) => i.onTicker).map((i) => `
    <span>${i.name} <b>${fmt(i.price)}</b> <em class="${tone(i.changeRate)}">${signed(i.changeAmount)} (${fmt(Math.abs(i.changeRate))}%)</em></span>`).join('');
}

function loadRankings() {
  return get(`rankings?${new URLSearchParams(rankingQuery)}`).then(renderRankings);
}

function renderSchedules(list) {
  $('schedule-list').innerHTML = list.map((s) => `
    <li><span class="dim">${Number(s.scheduleDate.slice(8))}일</span>${s.title}</li>`).join('');
}

// 순위 칸은 rankNo 가 아니라 받은 목록의 순서(1부터)를 보여준다
function renderRankings(list) {
  $('ranking-body').innerHTML = list.map((r, i) => `
    <tr>
      <td class="heart"><button data-toggle>♥</button></td>
      <td class="rank">${i + 1}</td>
      <td class="stock-cell"><span class="stock">
        <span class="logo-sq ${r.overseas ? 'us' : ''}" style="background:${r.logoColor};color:${r.logoColor === '#ffffff' ? '#e5383b' : '#fff'}">${r.logoText}</span>${r.name}
      </span></td>
      <td class="num">${fmt(r.price)}원</td>
      <td class="num ${tone(r.changeRate)}">${pct(r.changeRate)}</td>
      <td class="num">${fmt(r.tradeAmount)}억원</td>
      <td class="num">${won(r.marketCap)}</td>
      <td><div class="ratio">
        <div class="bar"><i class="buy" style="width:${r.buyRatio}%"></i><i class="sell" style="width:${100 - r.buyRatio}%"></i></div>
        <span class="down">${r.buyRatio}</span><span class="up">${100 - r.buyRatio}</span>
      </div></td>
      <td>${r.industry ? `<span class="pill">${r.industry}</span>` : ''}</td>
      <td>${r.aiSummary ?? ''}</td>
    </tr>`).join('');
}

// 같은 묶음(data-group) 안에서 하나만 눌림 · data-toggle 은 켜고 끄기
document.addEventListener('click', (e) => {
  const btn = e.target.closest('button');
  if (!btn) return;
  if (btn.hasAttribute('data-toggle')) btn.classList.toggle('on');
  const group = btn.closest('[data-group]');
  if (group) group.querySelectorAll('button').forEach((b) => b.classList.toggle('active', b === btn));

  const { market, sort } = btn.dataset;
  if (market) rankingQuery.market = market;
  if (sort) rankingQuery.sort = sort;
  if (market || sort) loadRankings().catch(showError);
});

function showError(err) {
  console.error(err);
  $('ranking-body').innerHTML = `<tr><td colspan="10" class="error">API 연결 실패 · edu-stock-chart(8080)를 먼저 실행하세요</td></tr>`;
}

// 종목 검색 · 결과를 눌러도 화면 전환은 하지 않는다
const searchInput = $('search-input');
const searchResults = $('search-results');
let searchTimer;

function showSearch(html) {
  searchResults.innerHTML = html;
  searchResults.hidden = !html;
}

async function search(q) {
  const res = await fetch(`/api/stocks/search?q=${encodeURIComponent(q)}`);
  if (searchInput.value.trim() !== q) return; // 늦게 온 이전 응답은 버린다
  if (res.status === 404) return showSearch('<li class="msg">검색 기능 준비 중 · /api/stocks/search 미구현</li>');
  if (!res.ok) return showSearch(`<li class="msg">검색 실패 (${res.status})</li>`);
  const list = await res.json();
  showSearch(list.length
    ? list.map((s) => `<li><button><b>${s.name}</b><span class="dim">${s.symbol} · ${s.market}</span></button></li>`).join('')
    : '<li class="msg">검색 결과가 없습니다</li>');
}

searchInput.addEventListener('input', () => {
  clearTimeout(searchTimer);
  const q = searchInput.value.trim();
  if (!q) return showSearch('');
  searchTimer = setTimeout(() => search(q).catch(() => showSearch('<li class="msg">API 연결 실패</li>')), 200);
});

document.addEventListener('keydown', (e) => {
  if (e.key === '/' && document.activeElement !== searchInput) {
    e.preventDefault();
    searchInput.focus();
  }
  if (e.key === 'Escape') showSearch('');
});

document.addEventListener('click', (e) => {
  if (!e.target.closest('.search-box') || e.target.closest('#search-results button')) showSearch('');
});

$('asof').textContent = new Date().toTimeString().slice(0, 5);

Promise.all([get('indices'), get('schedules'), loadRankings()])
  .then(([indices, schedules]) => {
    renderIndices(indices);
    renderSchedules(schedules);
  })
  .catch(showError);

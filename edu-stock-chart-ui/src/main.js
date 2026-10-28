// 코스콤증권 대시보드 · 데이터는 /api/dashboard/* (vite.config.js 프록시 → Spring Boot 8080)
// 버튼은 눌린 상태만 바뀐다. 루프 실습 과제 두 곳은 서버가 구현해야 결과가 바뀐다.
//  - 순위 필터(data-market · data-sort): /api/dashboard/rankings?market=&sort=
//  - 종목 검색(상단 검색창): /api/stocks/search?q=
// superpowers 시연 과제는 순위 행을 누르면 열리는 종목 상세 화면이다 (아래 '종목 상세' · /api/stocks/{symbol}/detail)

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
  list.forEach((r) => rankingBySymbol.set(r.symbol, r));
  $('ranking-body').innerHTML = list.map((r, i) => `
    <tr data-symbol="${r.symbol}">
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

// ── 종목 상세 ─────────────────────────────────────────────
// 순위 행을 누르면 #/stocks/{symbol} 로 바뀌고 GET /api/stocks/{symbol}/detail 을 부른다.
// 서버에 API 가 없으면(404) 팝업만 띄우고 대시보드에 남는다. 뒤로 가기 · 로고는 대시보드로.
// 응답: { symbol, name, market, price, changeAmount, changeRate, dayLow, dayHigh, low52w, high52w,
//        tradeAmountRank, executionStrength, individualNet, foreignNet, institutionNet,
//        dailyPrices: [{ tradeDate, openPrice, highPrice, lowPrice, closePrice, volume }] (오래된 날짜 순) }
const rankingBySymbol = new Map(); // 로고 모양 · 색은 순위 목록에서 가져온다

document.addEventListener('click', (e) => {
  const row = e.target.closest('#ranking-body tr[data-symbol]');
  if (row && !e.target.closest('button')) location.hash = `#/stocks/${row.dataset.symbol}`;
});

function notice(title, sub) {
  $('notice-msg').replaceChildren(Object.assign(document.createElement('b'), { textContent: title }), sub);
  $('notice').showModal();
}

function showDashboard() {
  $('detail').hidden = true;
  $('dashboard').hidden = false;
}

async function route() {
  const symbol = location.hash.match(/^#\/stocks\/([^/]+)$/)?.[1];
  if (!symbol) return showDashboard();
  let res;
  try {
    res = await fetch(`/api/stocks/${encodeURIComponent(symbol)}/detail`);
  } catch {
    res = { ok: false, status: 0 };
  }
  if (!res.ok) {
    history.replaceState(null, '', location.pathname); // 주소를 대시보드로 되돌린다
    showDashboard();
    return res.status === 404
      ? notice('아직 구현되지 않았습니다', `GET /api/stocks/${decodeURIComponent(symbol)}/detail`)
      : notice(`상세 조회 실패 (${res.status || '연결 안 됨'})`, 'edu-stock-chart(8080)를 확인하세요');
  }
  renderDetail(await res.json());
  $('dashboard').hidden = true;
  $('detail').hidden = false;
  scrollTo(0, 0);
}

window.addEventListener('hashchange', route);

// 일봉 캔들 + 이동평균(5 · 20) + 거래량 · 상승 빨강, 하락 파랑
function candles(days, { w = 560, h = 230, vh = 70 } = {}) {
  const hi = Math.max(...days.map((d) => d.highPrice));
  const lo = Math.min(...days.map((d) => d.lowPrice));
  const maxVol = Math.max(...days.map((d) => d.volume));
  const step = w / days.length;
  const y = (p) => 8 + (h - 16) * (1 - (p - lo) / (hi - lo));
  const cx = (i) => step * i + step / 2;
  const ma = (n) => days.map((_, i) => i + 1 < n ? null
    : days.slice(i + 1 - n, i + 1).reduce((s, d) => s + d.closePrice, 0) / n)
    .map((v, i) => (v == null ? '' : `${cx(i).toFixed(1)},${y(v).toFixed(1)}`)).filter(Boolean).join(' ');
  const bars = days.map((d, i) => {
    const c = d.closePrice >= d.openPrice ? 'up' : 'down';
    const top = y(Math.max(d.openPrice, d.closePrice));
    const bh = Math.max(1, Math.abs(y(d.openPrice) - y(d.closePrice)));
    const vy = h + vh * (1 - d.volume / maxVol);
    return `<g class="${c}">
      <line x1="${cx(i)}" x2="${cx(i)}" y1="${y(d.highPrice)}" y2="${y(d.lowPrice)}" />
      <rect x="${cx(i) - step * 0.35}" y="${top}" width="${step * 0.7}" height="${bh}" />
      <rect class="vol" x="${cx(i) - step * 0.35}" y="${vy}" width="${step * 0.7}" height="${h + vh - vy}" />
    </g>`;
  }).join('');
  const last = days.at(-1).closePrice;
  return `<svg class="candles" viewBox="0 0 ${w + 70} ${h + vh}">
    <polyline class="ma5" points="${ma(5)}" /><polyline class="ma20" points="${ma(20)}" />
    ${bars}
    <line class="now" x1="0" x2="${w}" y1="${y(last)}" y2="${y(last)}" />
    <text class="axis" x="${w + 6}" y="${y(hi) + 10}">${fmt(hi)}</text>
    <text class="axis" x="${w + 6}" y="${y(lo)}">${fmt(lo)}</text>
    <rect class="tag" x="${w + 2}" y="${y(last) - 10}" width="68" height="20" rx="3" />
    <text class="tag-t" x="${w + 6}" y="${y(last) + 5}">${fmt(last)}</text>
  </svg>`;
}

// 범위 막대 위 현재가 위치
function range(label, low, high, price) {
  const at = Math.min(100, Math.max(0, ((price - low) / (high - low)) * 100));
  return `<dt>${label}</dt><dd>${fmt(low)}원</dd><dd><span class="range-bar"><i style="left:${at}%"></i></span></dd><dd>${fmt(high)}원</dd>`;
}

// 주 → '+26만' · '-42만'
const man = (n) => (n > 0 ? '+' : '') + fmt(Math.round(n / 10000)) + '만';

function renderDetail(s) {
  const r = rankingBySymbol.get(s.symbol) ?? { logoText: s.symbol.slice(0, 2), logoColor: '#33333b', overseas: false };
  const days = s.dailyPrices ?? [];
  const flows = [['개인', s.individualNet], ['외국인', s.foreignNet], ['기관', s.institutionNet]];
  const maxFlow = Math.max(...flows.map(([, v]) => Math.abs(v)), 1);
  const recent = days.slice(-10).reverse();

  $('detail').innerHTML = `
    <header class="d-head">
      <div>
        <div class="d-name">
          <span class="logo-sq ${r.overseas ? 'us' : ''}" style="background:${r.logoColor};color:${r.logoColor === '#ffffff' ? '#e5383b' : '#fff'}">${r.logoText}</span>
          <b>${s.name}</b><span class="dim">${s.symbol} · ${s.market}</span>
        </div>
        <div class="d-price"><b>${fmt(s.price)}원</b> <span class="dim">· 어제보다</span>
          <span class="${tone(s.changeRate)}">${signed(s.changeAmount)}원 (${fmt(Math.abs(s.changeRate))}%)</span></div>
      </div>
      <dl class="d-range">${range('1일 범위', s.dayLow, s.dayHigh, s.price)}${range('52주 범위', s.low52w, s.high52w, s.price)}</dl>
      <dl class="d-stat"><dt>거래대금</dt><dd>${s.tradeAmountRank}위</dd><dt>체결강도</dt><dd>${fmt(s.executionStrength)}%</dd></dl>
    </header>

    <nav class="d-tabs" data-group>
      <button class="active">차트 · 호가</button><button>종목정보</button><button>뉴스 · 공시</button><button>거래현황</button><button>커뮤니티</button>
    </nav>

    <div class="d-grid">
      <section class="card d-chart">
        <h4>차트</h4>
        <div class="seg" data-group><button>1분</button><button class="active">일</button><button>주</button><button>월</button><button>년</button></div>
        <div class="legend"><span class="ma5">이동평균 5</span><span class="ma20">20</span></div>
        ${days.length ? candles(days) : '<p class="dim empty">일봉 데이터가 없습니다</p>'}
      </section>

      <section class="card d-book">
        <h4>호가</h4>
        <div class="login-need"><p>호가를 보려면<br />로그인이 필요해요</p><button class="btn-chip">로그인하기</button></div>
      </section>

      <section class="card d-order">
        <h4>일반주문</h4>
        <label>주문 유형<span class="box">일반 주문 <span class="caret">⌄</span></span></label>
        <label>구매 가격<span class="seg" data-group><button class="active">지정가</button><button>시장가</button></span></label>
        <label><span></span><span class="box">${fmt(s.price)} <span class="dim">원</span></span></label>
        <label>수량<span class="box dim">수량 입력</span></label>
        <label><span></span><span class="pcts" data-group><button>10%</button><button>25%</button><button>50%</button><button>최대</button></span></label>
        <label>총 주문 금액<span class="box dim">금액 입력</span></label>
        <p class="dim">주문 가능 금액 0원</p>
        <button class="btn-buy">로그인하고 구매하기</button>
      </section>

      <section class="card d-quotes">
        <h4>시세</h4>
        <div class="seg" data-group><button>실시간</button><button class="active">일별</button></div>
        <table>
          <thead><tr><th>일자</th><th class="num">종가</th><th class="num">등락률</th><th class="num">거래량(주)</th></tr></thead>
          <tbody>${recent.map((d, i) => {
            const prev = recent[i + 1] ?? days.at(-recent.length - 1);
            const rate = prev ? ((d.closePrice - prev.closePrice) / prev.closePrice) * 100 : 0;
            return `<tr><td>${d.tradeDate.slice(5).replace('-', '.')}</td><td class="num">${fmt(d.closePrice)}</td>
              <td class="num ${tone(rate)}">${pct(rate)}</td><td class="num">${fmt(d.volume)}</td></tr>`;
          }).join('')}</tbody>
        </table>
      </section>

      <section class="card d-flow">
        <h4>개인 · 외국인 · 기관</h4>
        ${flows.map(([k, v]) => `
          <div class="flow"><span>${k}</span><b class="${tone(v)}">${man(v)}</b>
            <span class="flow-bar"><i class="${tone(v)}" style="width:${(Math.abs(v) / maxFlow) * 50}%"></i></span></div>`).join('')}
      </section>
    </div>`;
}

$('asof').textContent = new Date().toTimeString().slice(0, 5);

Promise.all([get('indices'), get('schedules'), loadRankings()])
  .then(([indices, schedules]) => {
    renderIndices(indices);
    renderSchedules(schedules);
  })
  .catch(showError)
  .finally(route); // #/stocks/SOXL 로 바로 열어도 상세를 띄운다

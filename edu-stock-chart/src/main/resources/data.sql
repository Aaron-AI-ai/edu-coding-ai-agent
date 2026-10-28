-- 실습용 샘플 시세 (가상의 값)
INSERT INTO stock_price (symbol, trade_date, close_price) VALUES
('005930', '2026-09-01', 70100.00),
('005930', '2026-09-02', 70500.00),
('005930', '2026-09-03', 69800.00),
('005930', '2026-09-04', 71200.00),
('005930', '2026-09-07', 71900.00),
('005930', '2026-09-08', 71500.00),
('005930', '2026-09-09', 72300.00),
('005930', '2026-09-10', 72800.00),
('005930', '2026-09-11', 72100.00),
('005930', '2026-09-14', 73000.00);

-- 실습용 샘플 계좌 (가상의 값)
INSERT INTO account (account_no, owner_name, balance) VALUES
('110-1234-5678', '홍길동', 1500000.00),
('110-2345-6789', '김철수', 0.00),
('220-3456-7890', '이영희', 98765432.10);

-- 대시보드 샘플 (가상의 값) · price 가 NULL 이면 '실시간 시세 보기' 로 표시
INSERT INTO market_index (code, name, tag, tag_hot, price, change_amount, change_rate, high_52w, low_52w, sparkline, on_board, on_ticker, sort_order) VALUES
('NASDAQ',  '나스닥',          '중동 긴장 완화',  FALSE, 26037.33,   81.99,   0.31, 26103.86, 25986.55, '26100,26080,26040,26010,25995,26020,26037', TRUE, TRUE, 1),
('SPX',     'S&P 500',         '실적시즌 호조',   FALSE, 7661.53,    37.85,   0.49, NULL, NULL, '7668,7655,7650,7652,7658,7661',             TRUE, TRUE, 2),
('USDKRW',  '달러 환율',       NULL,              FALSE, 1330.05,    5.75,    0.43, NULL, NULL, '1324,1326,1323,1327,1325,1328,1326,1329,1327,1330', TRUE, TRUE, 3),
('VIX',     'VIX',             NULL,              FALSE, 18.52,      -0.93,  -4.78, NULL, NULL, '19.4,19.6,19.1,19.3,18.9,18.7,18.52',       TRUE, FALSE, 4),
('NQF',     '나스닥 100 선물', NULL,              FALSE, NULL,       NULL,    NULL, NULL, NULL, NULL,                                      TRUE, FALSE, 5),
('DJI',     '다우존스',        NULL,              FALSE, NULL,       NULL,    NULL, NULL, NULL, NULL,                                      TRUE, FALSE, 6),
('KOSPI',   '코스피',          '외국인 매도 부담', FALSE, 5469.47,   -80.83,  -1.45, NULL, NULL, '5550,5520,5535,5490,5505,5480,5500,5469',  TRUE, FALSE, 7),
('SOX',     '필라델피아 반도체', NULL,            FALSE, 10875.66,   96.2,    0.89, NULL, NULL, '10880,10860,10840,10850,10875',             TRUE, TRUE, 8),
('BTC',     '비트코인',        '현물 ETF 순유출', FALSE, 106350000, -930000, -0.86, NULL, NULL, '107100000,106600000,107300000,106500000,107000000,106200000,106350000', TRUE, FALSE, 9),
('NG',      '천연가스',        '급상승,카타르 공급 차질',          TRUE,  NULL,       NULL,    NULL, NULL, NULL, NULL,                                      TRUE, FALSE, 10),
('DXY',     '달러 인덱스',     NULL,              FALSE, 102,        0.19,    0.18, NULL, NULL, NULL,                                      FALSE, TRUE, 0);

INSERT INTO economic_schedule (schedule_date, title) VALUES
('2026-10-27', '3분기 경제성장률(GDP) 발표(속보치)'),
('2026-10-27', 'CB 소비자신뢰지수 발표'),
('2026-10-27', '신규주택 매매건수 발표');

INSERT INTO stock_ranking (rank_no, symbol, name, logo_text, logo_color, overseas, price, change_rate, trade_amount, market_cap, buy_ratio, industry, ai_summary) VALUES
(1,  'SOXL', 'SOXL',              '3x',  '#f5a524', TRUE,  113134,  2.23, 52, 249000,   46, '반도체', '메타 AI 투자 확대'),
(2,  'SOXS', 'SOXS',              '인버스', '#f5a524', TRUE,  68002,  -2.11, 38, 55000,    55, '반도체', NULL),
(3,  'VOO',  'VOO',               'S&P', '#e5383b', TRUE,  929552,  0.47, 19, 13851000, 6,  NULL,     NULL),
(4,  'ASTS', '와이즈샛 스페이스 홀딩스', 'A', '#ffffff', TRUE,  9839,   21.40, 15, 2417,     50, '우주항공', NULL),
(5,  'QLD',  'QLD',               '2x',  '#1f6f8b', TRUE,  114975,  0.77, 14, 181000,   5,  NULL,     '반도체 실적 기대'),
(6,  'SCHD', 'SCHD',              'S',   '#3b82f6', TRUE,  46866,   0.34, 13, 1570000,  13, NULL,     NULL),
(7,  'TSLA', '테슬라',            'T',   '#e5383b', TRUE,  522264,  5.95, 13, 19489000, 80, '전기차', '바클레이스 의견상향'),
(8,  'NVDA', '엔비디아',          'N',   '#76b900', TRUE,  262410,  1.12, 12, 63250000, 62, '반도체', 'AI 서버 수요 지속'),
(9,  '005930', '삼성전자',        'S',   '#1428a0', FALSE, 73000,  -1.35, 11, 4358000,  41, '반도체', '외국인 순매도'),
(10, 'TQQQ', 'TQQQ',              '3x',  '#16a34a', TRUE,  128730,  0.92, 10, 393000,   58, NULL,     NULL);

-- 루프 실습용 추가 순위 (가상의 값) · 국내 · 해외 필터 결과가 의미 있도록 국내 종목을 늘린다
INSERT INTO stock_ranking (rank_no, symbol, name, logo_text, logo_color, overseas, price, change_rate, trade_amount, market_cap, buy_ratio, industry, ai_summary) VALUES
(11, '000660', 'SK하이닉스',       'SK', '#ea002c', FALSE, 198500,  3.12, 9, 1445000, 57, '반도체',   'HBM 공급 확대'),
(12, '012450', '한화에어로스페이스', 'H',  '#f37321', FALSE, 412000, -2.37, 8, 208000,  44, '우주항공', NULL),
(13, '900110', '코스모스바이오',   'C',  '#8b5cf6', FALSE, 4210,   29.94, 7, 1830,    71, '바이오',   NULL),
(14, '035720', '카카오',           'K',  '#fee500', FALSE, 41250,  -0.60, 6, 183000,  49, '인터넷',   NULL),
(15, '247540', '에코프로비엠',     'E',  '#0f766e', FALSE, 168900,  7.81, 6, 165000,  63, '2차전지',  '양극재 수주 공시'),
(16, '900270', '한빛테크',         'H',  '#64748b', FALSE, 1185,  -18.25, 5, 420,     22, NULL,       NULL),
(17, 'GMXX',   '그린마스 홀딩스',  'G',  '#22c55e', TRUE,  3920,   12.48, 5, 980,     68, NULL,       NULL);

-- 종목 마스터 (코스모스바이오 · 한빛테크 · 그린마스 홀딩스는 가상의 종목)
INSERT INTO stock (symbol, name, market) VALUES
('005930', '삼성전자',           'KOSPI'),
('000660', 'SK하이닉스',         'KOSPI'),
('207940', '삼성바이오로직스',   'KOSPI'),
('006400', '삼성SDI',            'KOSPI'),
('028260', '삼성물산',           'KOSPI'),
('005380', '현대차',             'KOSPI'),
('000270', '기아',               'KOSPI'),
('035420', 'NAVER',              'KOSPI'),
('035720', '카카오',             'KOSPI'),
('051910', 'LG화학',             'KOSPI'),
('373220', 'LG에너지솔루션',     'KOSPI'),
('068270', '셀트리온',           'KOSPI'),
('105560', 'KB금융',             'KOSPI'),
('055550', '신한지주',           'KOSPI'),
('005490', 'POSCO홀딩스',        'KOSPI'),
('012450', '한화에어로스페이스', 'KOSPI'),
('247540', '에코프로비엠',       'KOSDAQ'),
('086520', '에코프로',           'KOSDAQ'),
('900110', '코스모스바이오',     'KOSDAQ'),
('900270', '한빛테크',           'KOSDAQ'),
('SOXL',   'SOXL',               'NYSE'),
('SOXS',   'SOXS',               'NYSE'),
('VOO',    'VOO',                'NYSE'),
('ASTS',   '와이즈샛 스페이스 홀딩스', 'NASDAQ'),
('QLD',    'QLD',                'NYSE'),
('SCHD',   'SCHD',               'NYSE'),
('TSLA',   '테슬라',             'NASDAQ'),
('NVDA',   '엔비디아',           'NASDAQ'),
('TQQQ',   'TQQQ',               'NASDAQ'),
('GMXX',   '그린마스 홀딩스',    'NASDAQ'),
('AAPL',   '애플',               'NASDAQ'),
('MSFT',   '마이크로소프트',     'NASDAQ');

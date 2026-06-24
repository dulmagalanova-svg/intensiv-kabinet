-- Сид: Предобучение 1-3 + видео Kinescope.
-- Применять в Supabase → SQL Editor: скопировать ВСЁ → Run.
-- video_url = Kinescope embed (iframe src).

delete from public.lessons where id in (0,1,2,3,4,101);

insert into public.lessons (id, slug, title, day, sort, video_url, body_html) values

(1, 'predob-1', 'Предобучение 1 · Добро пожаловать', 0, 1,
 'https://kinescope.io/embed/hXsW9hjzfyQ4nVkKPyqZdy', $$
<div class="say"><b>Добро пожаловать!</b> Здесь ты соберёшь команду AI-агентов, которая будет работать на тебя каждый день. Я проведу за руку, по шагам, без сложного кода.</div>
<h2>Как устроен рынок AI (за 2 минуты)</h2>
<ul>
  <li><b>Claude</b> (Anthropic) — наш основной инструмент, на нём строим агентов.</li>
  <li><b>ChatGPT</b> (OpenAI) — самый известный, альтернатива.</li>
  <li><b>Perplexity</b> — поиск с источниками.</li>
  <li><b>Дешёвые</b> (DeepSeek, Kimi) — для массовых задач.</li>
</ul>
<div class="big"><b>Что запомнить:</b> берём один сильный мозг — Claude — и работаем на нём. Остальное добавим, когда упрёмся в задачу.</div>
<h2>Как учиться с помощью AI</h2>
<ul>
  <li><b>Не понял термин — спроси AI:</b> «объясни простыми словами, как ребёнку».</li>
  <li><b>Большое — разбей:</b> «разбери по шагам, что делать первым».</li>
  <li><b>Делай сразу</b> — повторяй руками, не только смотри.</li>
  <li><b>Ошибка — норма:</b> скопируй её и спроси AI, как починить.</li>
</ul>
<div class="say"><b>Главное:</b> ты не обязана знать всё наизусть. Твоя суперсила — спрашивать AI. Это твой репетитор 24/7.</div>
$$),

(2, 'predob-2', 'Предобучение 2 · Агент vs чат + модели', 0, 2,
 'https://kinescope.io/embed/rz7a2egkTqYkqpXDG6BPEn', $$
<div class="say"><b>В этом уроке:</b> чем агент отличается от обычного чата и какие бывают модели Claude.</div>
<h2>Агент — это не просто чат</h2>
<ul>
  <li><b>Обычный чат</b> (как ChatGPT в браузере): спросил — ответил, и всё забыл.</li>
  <li><b>Агент</b>: живёт в Telegram, <b>помнит</b> тебя и контекст, <b>действует</b> (правит файлы, делает задачи), имеет <b>характер</b> и роль.</li>
</ul>
<div class="big"><b>Суть интенсива:</b> мы превращаем «умный чат» в твоего личного сотрудника, который доступен 24/7 в Telegram.</div>
<h2>Модели Claude — какая для чего</h2>
<ul>
  <li><b>Opus</b> — самая умная, для сложного (архитектура, разбор). Дороже/медленнее.</li>
  <li><b>Sonnet</b> — баланс ум/скорость. Хороший дефолт для агентов.</li>
  <li><b>Haiku</b> — самая быстрая/дешёвая, для простого и массового.</li>
</ul>
<div class="say"><b>Что запомнить:</b> по умолчанию берём Sonnet — золотая середина. Менять модель научимся позже, одной строкой.</div>
<h2>Подписка или API</h2>
<ul>
  <li><b>Подписка Claude (Pro/Max)</b> — фикс в месяц, удобно для старта. Берём её.</li>
  <li><b>API</b> — оплата за использование, для продвинутого. Позже.</li>
</ul>
$$),

(3, 'predob-3', 'Предобучение 3 · Техническая подготовка', 0, 3,
 'https://kinescope.io/embed/hXsW9hjzfyQ4nVkKPyqZdy', $$
<div class="say"><b>Ставим всё, что понадобится</b> — по шагам, командами. Это один раз, дальше всё работает.</div>
<div class="big"><b>Список:</b> VS Code · Node.js · подписка Claude · Claude Code · bun · GitHub · Telegram · (для РФ) VPN.</div>
<h2>Шаги установки</h2>
<ul>
  <li><b>VS Code</b> — редактор. Скачай с code.visualstudio.com.</li>
  <li><b>Node.js</b> — платформа. Скачай LTS с nodejs.org, проверь: <code>node -v</code>.</li>
  <li><b>Подписка Claude</b> — оформи Pro или Max на claude.ai (для РФ — с VPN).</li>
  <li><b>Claude Code</b> — установи: <code>npm install -g @anthropic-ai/claude-code</code>, проверь <code>claude --version</code>.</li>
  <li><b>bun</b> — движок агента: <code>curl -fsSL https://bun.sh/install | bash</code>, перезапусти терминал, проверь <code>bun --version</code>.</li>
  <li><b>GitHub</b> — заведи бесплатный аккаунт на github.com.</li>
  <li><b>VPN (РФ)</b> — включи и проверь, что claude.ai открывается.</li>
</ul>
<div class="say"><b>Если застряла</b> — вставь в claude: «Помоги поставить всё для интенсива, проведи по шагам, по одному, жди мой ответ». Он проведёт.</div>
$$)

on conflict (id) do update set title=excluded.title, body_html=excluded.body_html, day=excluded.day, sort=excluded.sort, slug=excluded.slug, video_url=excluded.video_url;

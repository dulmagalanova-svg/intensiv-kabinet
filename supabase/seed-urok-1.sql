-- Сид Урока 1 (образец) для проверки рендера на платформе.
-- Применять в Supabase → SQL Editor. body_html через $$ (кавычки не экранируем).
-- Видео добавим позже в поле video_url — пока окно-плейсхолдер.

delete from public.lessons where id between 0 and 99;

insert into public.lessons (id, slug, title, day, sort, video_url, body_html) values
(101, 'urok-1-pervyy-agent', 'Урок 1 · Первый агент в Telegram', 1, 101, null, $$
<div class="goal">
  <div class="g"><div class="lab">Цель</div>Собрать и запустить первого агента из готовой заготовки и связать его со своим Telegram-ботом.</div>
  <div class="g res"><div class="lab">Результат</div>Пишешь боту в Telegram — он отвечает сам, своим «голосом». Твой первый живой AI-агент работает.</div>
</div>

<h2>Что понадобится (с предобучения)</h2>
<ul>
  <li>Установлены VS Code, Node.js, Claude Code.</li>
  <li>Оплачена подписка Claude, вход выполнен.</li>
  <li>Есть аккаунт GitHub, под рукой Telegram.</li>
  <li>Для РФ — включён VPN.</li>
</ul>
<div class="big"><b>Как это устроено (важно понять):</b> ты ничего «большое» не печатаешь руками. Всю основу агента — связь с Telegram, шаблон личности, структуру — ты СКАЧИВАЕШЬ одной командой (Шаг 4). В терминал вводишь только короткие команды.</div>
<div class="tags"><span>Claude Code</span><span>BotFather</span><span>git clone</span><span>заготовка-агента</span><span>Telegram</span></div>

<div class="step">
  <div class="head"><span class="n">1</span><span class="t">Проверь, что Claude Code на месте</span></div>
  <div class="body">
    <p>Открой терминал (советую встроенный в VS Code: <b>Terminal → New Terminal</b>) и проверь версию:</p>
    <pre>claude --version</pre>
    <div class="see"><b>Что увидишь:</b> номер версии. Если «command not found» — поставь: <code>npm install -g @anthropic-ai/claude-code</code>.</div>
    <p>Запусти Claude Code:</p>
    <pre>claude</pre>
    <div class="see"><b>Спросит «доверяешь этой папке?»</b> — нажми <b>1</b> (Yes).</div>
    <span class="ok">✅ Claude Code запускается.</span>
  </div>
</div>

<div class="step">
  <div class="head"><span class="n">2</span><span class="t">Создай бота в Telegram</span></div>
  <div class="body">
    <p>В Telegram найди <b>@BotFather</b>. Напиши:</p>
    <pre>/newbot</pre>
    <p>Он спросит <b>имя</b> (любое) и <b>адрес</b> латиницей на <code>bot</code>.</p>
    <div class="see"><b>Что увидишь:</b> <b>токен</b> — длинную строку. Скопируй.</div>
    <div class="why"><b>Безопасность:</b> токен никому не показывай — это как пароль.</div>
    <span class="ok">✅ Бот создан, токен скопирован.</span>
  </div>
</div>

<div class="step">
  <div class="head"><span class="n">3</span><span class="t">Узнай свой Telegram ID</span></div>
  <div class="body">
    <p>Найди <b>@userinfobot</b>, напиши что угодно.</p>
    <div class="see"><b>Что увидишь:</b> твой <b>Id</b> — число. Скопируй.</div>
    <div class="why"><b>Зачем:</b> чтобы агент слушался ТОЛЬКО тебя.</div>
    <span class="ok">✅ Свой ID скопирован.</span>
  </div>
</div>

<div class="step">
  <div class="head"><span class="n">4</span><span class="t">Скачай готовую заготовку</span></div>
  <div class="body">
    <p>В терминале выполни:</p>
    <pre>git clone https://github.com/dulmagalanova-svg/intensiv-starter</pre>
    <div class="big"><b>Ключевой момент.</b> Внутри папки УЖЕ лежит всё: плагин связи с Telegram, шаблон CLAUDE.md, структура. Скачиваешь готовое одной командой.</div>
    <p>Зайди в папку:</p>
    <pre>cd intensiv-starter</pre>
    <span class="ok">✅ Заготовка скачана.</span>
  </div>
</div>

<div class="step">
  <div class="head"><span class="n">5</span><span class="t">Вставь токен и ID в настройки</span></div>
  <div class="body">
    <p>В VS Code открой <code>secrets/channel.env</code>. Впиши:</p>
    <pre>TELEGRAM_BOT_TOKEN=сюда_токен
TELEGRAM_ALLOWED_USER_IDS=сюда_свой_ID</pre>
    <div class="see"><b>Важно:</b> без пробелов. Сохрани — Cmd+S / Ctrl+S.</div>
    <span class="ok">✅ Токен и ID вписаны.</span>
  </div>
</div>

<div class="step">
  <div class="head"><span class="n">6</span><span class="t">Запусти агента</span></div>
  <div class="body">
    <p>В терминале (в папке intensiv-starter):</p>
    <pre>./start.sh</pre>
    <div class="see"><b>Окно держи открытым</b> — пока оно открыто, агент работает.</div>
    <span class="ok">✅ Агент запущен.</span>
  </div>
</div>

<div class="step">
  <div class="head"><span class="n">7</span><span class="t">Проверь — вау-момент</span></div>
  <div class="body">
    <p>Открой своего бота в Telegram и напиши:</p>
    <pre>Привет, ты кто?</pre>
    <div class="see"><b>Что увидишь:</b> через пару секунд бот ответит сам.</div>
    <span class="ok">✅ Твой первый живой агент отвечает!</span>
  </div>
</div>

<h2>Готовый промпт — если застряла</h2>
<p>Скопируй и вставь в окно <code>claude</code>:</p>
<div class="prompt">
  <div class="h">Промпт «помоги запустить первого агента»</div>
  <pre>Я ставлю первого агента по интенсиву «AI-команда». Проведи по шагам, по одному, жди мой ответ:
1. Проверь claude --version и node --version.
2. Помоги склонировать: git clone https://github.com/dulmagalanova-svg/intensiv-starter, потом cd intensiv-starter.
3. Объясни, куда в secrets/channel.env вставить токен и мой ID.
4. Помоги запустить ./start.sh.
После каждого шага жди моё подтверждение.</pre>
</div>

<h2>Если не работает</h2>
<div class="trouble">
  <div class="row"><div class="q">«claude: command not found»</div><div class="a">Не установлен: <code>npm install -g @anthropic-ai/claude-code</code>.</div></div>
  <div class="row"><div class="q">Ошибка ./start.sh или «node: command not found»</div><div class="a">Нет Node.js. Поставь с nodejs.org (LTS), проверь node -v.</div></div>
  <div class="row"><div class="q">Бот не отвечает</div><div class="a">Токен без пробелов, ID верный, окно ./start.sh открыто, включён VPN.</div></div>
  <div class="row"><div class="q">Совсем застряла</div><div class="a">Разберём на эфире, или вставь промпт выше.</div></div>
</div>

<div class="big"><b>Итог Урока 1:</b> у тебя работает личный AI-агент в Telegram. На Уроке 2 сделаем его «тобой»: характер, голос и память.</div>
$$)
on conflict (id) do update set title=excluded.title, body_html=excluded.body_html, day=excluded.day, sort=excluded.sort, slug=excluded.slug, video_url=excluded.video_url;

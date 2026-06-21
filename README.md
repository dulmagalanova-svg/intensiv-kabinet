# Кабинет интенсива «AI-команда»

Закрытый личный кабинет: вход по email+пароль, уроки только после оплаты, прогресс, домашки, оплата Продамус → автодоступ.

## Стек
- **Supabase** — Auth + Postgres + Storage + RLS (проект `intensiv-kabinet`).
- **Netlify** — статический хостинг `public/` + serverless `netlify/functions/`.
- Ванильный HTML/CSS/JS + supabase-js (без фреймворка).

## Структура
```
public/            страницы (index=вход, lessons, lesson, admin)
public/js/         supabase-client, auth, lessons, homework, admin
netlify/functions/ prodamus-webhook (приём оплаты, фаза 4)
supabase/schema.sql схема БД + RLS
```

## Развёртывание
1. Применить `supabase/schema.sql` в Supabase → SQL Editor.
2. Подключить репозиторий к Netlify (continuous deploy), publish dir `public`.
3. Netlify env vars (фаза 4): `SUPABASE_SERVICE_KEY`, `PRODAMUS_WEBHOOK_SECRET` — секреты, НЕ в репозиторий.
4. Поддомен `kabinet.dulmabuyantueva.pro` → Netlify custom domain.

## Безопасность
- Клиент использует только **publishable** ключ. **Секретный** ключ — только в Netlify Function (env var).
- Доступ к урокам гейтит **RLS** на сервере, не клиент.

Собрала germiona, 2026-06-21.

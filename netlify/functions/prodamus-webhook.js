// Приём уведомления об оплате от Продамус → открыть доступ по email покупателя.
//
// Защита: секретный токен в URL (?key=...), известный только Продамусу и нам.
// Без него запрос отклоняется — чтобы доступ нельзя было открыть подделкой.
// (HMAC-подпись Продамуса добавим как доп. защиту после теста на реальном платеже —
//  для этого логируем payload+signature ниже.)
//
// Env vars (Netlify → Site settings → Environment):
//   SUPABASE_URL          — https://<ref>.supabase.co
//   SUPABASE_SECRET_KEY   — sb_secret_... (service-role, обходит RLS; ТОЛЬКО на сервере)
//   WEBHOOK_SECRET        — длинная случайная строка, она же в URL уведомления Продамуса

// нормализуем: убираем хвостовые слэши и случайный суффикс /rest/v1, чтобы
// SUPABASE_URL был чистым origin (иначе при склейке выходит двойной /rest/v1)
const SUPABASE_URL = (process.env.SUPABASE_URL || '').replace(/\/+$/, '').replace(/\/rest\/v1$/, '')
const SERVICE_KEY = process.env.SUPABASE_SECRET_KEY
const WEBHOOK_SECRET = process.env.WEBHOOK_SECRET

export async function handler(event){
  if(event.httpMethod !== 'POST') return { statusCode: 405, body: 'method not allowed' }

  // секрет-гейт
  const key = (event.queryStringParameters || {}).key
  if(!WEBHOOK_SECRET || key !== WEBHOOK_SECRET){
    return { statusCode: 403, body: 'forbidden' }
  }

  // тело приходит form-urlencoded
  const data = Object.fromEntries(new URLSearchParams(event.body || ''))
  // лог для отладки на этапе теста (поможет добавить HMAC-проверку под реальный payload)
  console.log('prodamus webhook keys:', Object.keys(data).join(','), '| signature:', data.signature || '—')

  // статус оплаты — реагируем только на успешную
  const status = (data.payment_status || '').toLowerCase()
  if(status && status !== 'success'){
    return { statusCode: 200, body: 'ignored status: ' + status }
  }

  // email покупателя (Продамус кладёт в один из этих полей)
  const email = (data.customer_email || data.email || data._param_email || '').toLowerCase().trim()
  if(!email){
    console.log('prodamus webhook: no email in payload')
    return { statusCode: 200, body: 'no email' } // 200, чтобы Продамус не ретраил
  }

  const headers = {
    apikey: SERVICE_KEY,
    Authorization: 'Bearer ' + SERVICE_KEY,
    'Content-Type': 'application/json'
  }

  // 1) открыть доступ, если профиль уже есть
  const patch = await fetch(
    `${SUPABASE_URL}/rest/v1/profiles?email=eq.${encodeURIComponent(email)}`,
    { method: 'PATCH', headers: { ...headers, Prefer: 'return=representation' },
      body: JSON.stringify({ paid: true, paid_at: new Date().toISOString() }) }
  )
  const updated = await patch.json().catch(() => [])

  // 2) профиля ещё нет (оплатил до регистрации) — запомнить email,
  //    триггер откроет доступ при регистрации этим email
  if(!Array.isArray(updated) || updated.length === 0){
    await fetch(`${SUPABASE_URL}/rest/v1/paid_emails`,
      { method: 'POST', headers: { ...headers, Prefer: 'resolution=merge-duplicates' },
        body: JSON.stringify({ email, paid_at: new Date().toISOString() }) })
    console.log('prodamus webhook: prepaid email stored', email)
  } else {
    console.log('prodamus webhook: access opened for', email)
  }

  return { statusCode: 200, body: 'ok' }
}

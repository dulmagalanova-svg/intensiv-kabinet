// Приём уведомления об оплате от Продамус → открыть доступ по email покупателя.
//
// Защита: секретный токен в URL (?key=...), известный только Продамусу и нам.
// (HMAC-подпись Продамуса добавим после теста на реальном платеже — логируем payload ниже.)
//
// Env vars (Netlify → Site settings → Environment):
//   SUPABASE_URL, SUPABASE_SECRET_KEY (sb_secret_, ТОЛЬКО на сервере), WEBHOOK_SECRET

const SUPABASE_URL = process.env.SUPABASE_URL
const SERVICE_KEY = process.env.SUPABASE_SECRET_KEY
const WEBHOOK_SECRET = process.env.WEBHOOK_SECRET

export async function handler(event){
  if(event.httpMethod !== 'POST') return { statusCode: 405, body: 'method not allowed' }

  const key = (event.queryStringParameters || {}).key
  if(!WEBHOOK_SECRET || key !== WEBHOOK_SECRET){
    return { statusCode: 403, body: 'forbidden' }
  }

  const data = Object.fromEntries(new URLSearchParams(event.body || ''))
  console.log('prodamus webhook keys:', Object.keys(data).join(','), '| signature:', data.signature || '—')

  const status = (data.payment_status || '').toLowerCase()
  if(status && status !== 'success'){
    return { statusCode: 200, body: 'ignored status: ' + status }
  }

  const email = (data.customer_email || data.email || data._param_email || '').toLowerCase().trim()
  if(!email){
    console.log('prodamus webhook: no email in payload')
    return { statusCode: 200, body: 'no email' }
  }

  const headers = {
    apikey: SERVICE_KEY,
    Authorization: 'Bearer ' + SERVICE_KEY,
    'Content-Type': 'application/json'
  }

  const patch = await fetch(
    `${SUPABASE_URL}/rest/v1/profiles?email=eq.${encodeURIComponent(email)}`,
    { method: 'PATCH', headers: { ...headers, Prefer: 'return=representation' },
      body: JSON.stringify({ paid: true, paid_at: new Date().toISOString() }) }
  )
  const updated = await patch.json().catch(() => [])

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

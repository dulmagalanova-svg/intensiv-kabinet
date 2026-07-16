// Авторизация: регистрация / вход / выход + guard для закрытых страниц.
import { supabase } from './supabase-client.js'

export async function signUp(email, password){
  return supabase.auth.signUp({ email, password })
}

export async function signIn(email, password){
  return supabase.auth.signInWithPassword({ email, password })
}

export async function signOut(){
  await supabase.auth.signOut()
  location.href = '/index.html'
}

// Отправить письмо со ссылкой для сброса пароля. Ссылка ведёт на /reset.html.
export async function resetPassword(email){
  return supabase.auth.resetPasswordForEmail(email, {
    redirectTo: location.origin + '/reset.html'
  })
}

// Установить новый пароль. Работает на /reset.html после перехода по ссылке из
// письма (Supabase поднимает временную recovery-сессию из токена в URL).
export async function updatePassword(password){
  return supabase.auth.updateUser({ password })
}

// Вызывать в начале закрытых страниц. Нет сессии → на лендинг.
export async function requireAuth(){
  const { data } = await supabase.auth.getSession()
  if(!data.session){ location.href = '/index.html'; return null }
  return data.session
}

// Текущий пользователь (или null).
export async function currentUser(){
  const { data } = await supabase.auth.getUser()
  return data.user || null
}

// Опрос-ворота: пока обязательный опрос не заполнен — уводим на /survey.html.
// Возвращает true, если можно показывать уроки; false — если увели на опрос.
// FAIL-OPEN: любая ошибка проверки (нет таблицы / сбой сети) → пропускаем,
// чтобы техническая проблема НИКОГДА не заперла оплаченные уроки. Запираем
// только явный случай «таблица есть, ответа нет».
export async function requireSurvey(){
  try {
    const { data: u } = await supabase.auth.getUser()
    if(!u.user) return true
    // админ (Mrs) опрос не проходит — предпросмотр
    const { data: prof } = await supabase.from('profiles').select('is_admin').eq('id', u.user.id).maybeSingle()
    if(prof && prof.is_admin) return true
    const { data, error } = await supabase
      .from('survey_responses').select('id').eq('user_id', u.user.id).limit(1)
    if(error) return true                 // fail-open
    if(data && data.length) return true    // уже ответил
    location.href = '/survey.html'         // не ответил → на опрос
    return false
  } catch(e){ return true }
}

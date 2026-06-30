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

// Общая верхняя навигация кабинета: Главная · Материалы · Лента · Профиль.
// Вставляется в <div id="nav"></div>. active — ключ текущей страницы.
import { signOut } from './auth.js'

export function renderNav(active){
  const el = document.getElementById('nav')
  if(!el) return
  const item = (href, key, label) =>
    `<a href="${href}" class="${active === key ? 'on' : ''}">${label}</a>`
  el.innerHTML = `
    <div class="topbar"><div class="row">
      <span class="brand">Интенсив · AI-команда</span>
      <nav class="mainnav">
        ${item('/glavnaya.html', 'glavnaya', 'Главная')}
        ${item('/lessons.html', 'materialy', 'Материалы')}
        ${item('/slovar.html', 'slovar', 'Словарь')}
        ${item('/ssylki.html', 'ssylki', 'Ссылки')}
        ${item('/lenta.html', 'lenta', 'Лента')}
        ${item('/profil.html', 'profil', 'Профиль')}
      </nav>
      <button id="navLogout">Выйти</button>
    </div></div>`
  document.getElementById('navLogout').onclick = () => signOut()
}

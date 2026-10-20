/* ============================================================
   VerdeVivo - Core app: storage, state, navbar, toasts, modals
   ============================================================ */

const App = (() => {
  const KEYS = {
    plants: 'vv_plants',
    tasks: 'vv_tasks',
    routine: 'vv_routine',
    posts: 'vv_posts',
    notifications: 'vv_notifications',
    profile: 'vv_profile',
    garden: 'vv_garden',
    savedRecovery: 'vv_savedRecovery',
  };

  let user = null;

  const defaultProfile = {
    name: '',
    bio: '',
    avatar: null,
    plants: 0,
    discovered: [],
  };

  /* ---------- Storage helpers ---------- */
  function read(key, fallback) {
    try {
      const raw = localStorage.getItem(KEYS[key]);
      return raw ? JSON.parse(raw) : fallback;
    } catch (e) {
      return fallback;
    }
  }
  function write(key, value) {
    localStorage.setItem(KEYS[key], JSON.stringify(value));
  }

  /* ---------- Plant helpers ---------- */
  function defaultPlants() {
    return [
      {
        id: 'p1', name: 'Ficus Lyrata', species: 'Figueira-lira', scientific: 'Ficus lyrata',
        image: plantImg('ficus'), ageYears: 1.4, heightCm: 68, health: 'Ótima',
        humidity: 42, temperature: 22, light: 85, lastWatered: daysAgo(0), lastFert: daysAgo(12),
        lastBloom: null, favorite: false, attention: false, space: 'Sala',
        history: [
          { type: 'Brotamento', date: daysAgoStr(180), desc: 'Novas brotações surgiram na base.' },
          { type: 'Folhas novas', date: daysAgoStr(90), desc: 'Crescimento vigoroso de folhas.' },
          { type: 'Maturidade', date: daysAgoStr(30), desc: 'Folhas grandes e saudáveis.' },
        ],
        measurements: [ { date: daysAgoStr(180), height: 52 }, { date: daysAgoStr(120), height: 57 }, { date: daysAgoStr(60), height: 62 }, { date: daysAgoStr(30), height: 65 }, { date: daysAgoStr(0), height: 68 } ],
        nextCare: 'Regar quando substrato estiver seco',
      },
      {
        id: 'p2', name: 'Costela-de-Adão', species: 'Monstera deliciosa', scientific: 'Monstera deliciosa',
        image: plantImg('monstera'), ageYears: 2.1, heightCm: 95, health: 'Precisa de água',
        humidity: 28, temperature: 24, light: 60, lastWatered: daysAgo(9), lastFert: daysAgo(20),
        lastBloom: null, favorite: true, attention: true, space: 'Sala',
        history: [
          { type: 'Brotamento', date: daysAgoStr(120), desc: 'Novo broto lateral apareceu.' },
          { type: 'Folhas novas', date: daysAgoStr(45), desc: 'Duas folhas novas com fenestras.' },
        ],
        measurements: [ { date: daysAgoStr(180), height: 70 }, { date: daysAgoStr(90), height: 82 }, { date: daysAgoStr(30), height: 90 }, { date: daysAgoStr(0), height: 95 } ],
        nextCare: 'Rega urgente',
      },
      {
        id: 'p3', name: 'Calathea Orbifolia', species: 'Calathea orbifolia', scientific: 'Calathea orbifolia',
        image: plantImg('calathea'), ageYears: 0.8, heightCm: 40, health: 'Ótima',
        humidity: 65, temperature: 22, light: 50, lastWatered: daysAgo(2), lastFert: daysAgo(15),
        lastBloom: null, favorite: false, attention: false, space: 'Quarto',
        history: [
          { type: 'Brotamento', date: daysAgoStr(60), desc: 'Folhas novas desenrolando.' },
        ],
        measurements: [ { date: daysAgoStr(150), height: 28 }, { date: daysAgoStr(80), height: 34 }, { date: daysAgoStr(0), height: 40 } ],
        nextCare: 'Pulverizar folhas',
      },
      {
        id: 'p4', name: 'Cacto Echinopsis', species: 'Echinopsis', scientific: 'Echinopsis sp.',
        image: plantImg('cactus'), ageYears: 3, heightCm: 25, health: 'Ótima',
        humidity: 20, temperature: 26, light: 90, lastWatered: daysAgo(14), lastFert: daysAgo(30),
        lastBloom: daysAgo(200), favorite: false, attention: false, space: 'Varanda',
        history: [
          { type: 'Floração', date: daysAgoStr(200), desc: 'Floresceu pela primeira vez!' },
        ],
        measurements: [ { date: daysAgoStr(180), height: 20 }, { date: daysAgoStr(90), height: 23 }, { date: daysAgoStr(0), height: 25 } ],
        nextCare: 'Rega em 7 dias',
      },
      {
        id: 'p5', name: 'Jiboia', species: 'Epipremnum aureum', scientific: 'Epipremnum aureum',
        image: plantImg('jiboia'), ageYears: 1.1, heightCm: 55, health: 'Boa',
        humidity: 55, temperature: 23, light: 70, lastWatered: daysAgo(4), lastFert: daysAgo(10),
        lastBloom: null, favorite: false, attention: false, space: 'Escritório',
        history: [
          { type: 'Crescimento', date: daysAgoStr(40), desc: 'Videira cresceu 10cm.' },
        ],
        measurements: [ { date: daysAgoStr(150), height: 38 }, { date: daysAgoStr(60), height: 47 }, { date: daysAgoStr(0), height: 55 } ],
        nextCare: 'Podar ponta',
      },
      {
        id: 'p6', name: 'Espada-de-São-Jorge', species: 'Sansevieria', scientific: 'Dracaena trifasciata',
        image: plantImg('sansevieria'), ageYears: 2.5, heightCm: 80, health: 'Ótima',
        humidity: 30, temperature: 24, light: 65, lastWatered: daysAgo(10), lastFert: daysAgo(25),
        lastBloom: null, favorite: false, attention: false, space: 'Sala',
        history: [
          { type: 'Folhas novas', date: daysAgoStr(70), desc: 'Três novas folhas eretas.' },
        ],
        measurements: [ { date: daysAgoStr(180), height: 62 }, { date: daysAgoStr(60), height: 74 }, { date: daysAgoStr(0), height: 80 } ],
        nextCare: 'Rega leve',
      },
      {
        id: 'p7', name: 'Samambaia', species: 'Nephrolepis', scientific: 'Nephrolepis exaltata',
        image: plantImg('samambaia'), ageYears: 1.6, heightCm: 45, health: 'Pouca luz',
        humidity: 70, temperature: 21, light: 25, lastWatered: daysAgo(1), lastFert: daysAgo(8),
        lastBloom: null, favorite: false, attention: true, space: 'Banheiro',
        history: [],
        measurements: [ { date: daysAgoStr(120), height: 35 }, { date: daysAgoStr(40), height: 42 }, { date: daysAgoStr(0), height: 45 } ],
        nextCare: 'Mover para local mais iluminado',
      },
      {
        id: 'p8', name: 'Zamioculca', species: 'Zamioculcas zamiifolia', scientific: 'Zamioculcas zamiifolia',
        image: plantImg('zamioculca'), ageYears: 2, heightCm: 60, health: 'Ótima',
        humidity: 40, temperature: 23, light: 55, lastWatered: daysAgo(12), lastFert: daysAgo(30),
        lastBloom: null, favorite: true, attention: false, space: 'Escritório',
        history: [
          { type: 'Brotamento', date: daysAgoStr(50), desc: 'Nova haste brotando do solo.' },
        ],
        measurements: [ { date: daysAgoStr(160), height: 45 }, { date: daysAgoStr(70), height: 53 }, { date: daysAgoStr(0), height: 60 } ],
        nextCare: 'Rega em 10 dias',
      },
    ];
  }

  function plantImg(kind) {
    const map = {
      ficus: 'assets/images/ficus.jpg', monstera: 'assets/images/monstera.jpg',
      calathea: 'assets/images/calathea.jpg', cactus: 'assets/images/cactus.jpg',
      jiboia: 'assets/images/jiboia.jpg', sansevieria: 'assets/images/sansevieria.jpg',
      samambaia: 'assets/images/samambaia.jpg', zamioculca: 'assets/images/zamioculca.jpg',
    };
    return map[kind] || map.ficus;
  }

  function daysAgo(n) { const d = new Date(); d.setDate(d.getDate() - n); return d.toISOString(); }
  function daysAgoStr(n) { return formatDate(new Date(Date.now() - n * 86400000)); }
  function formatDate(d) { return d.toISOString().slice(0, 10); }

  /* ---------- Tasks ---------- */
  function defaultTasks() {
    const today = new Date().toISOString().slice(0, 10);
    return [
      { id: 't1', type: 'Rega', plant: 'Ficus Lyrata', plantId: 'p1', time: '08:30', desc: 'Usar 150ml de água mineral em temperatura ambiente.', due: today, done: false, removed: false },
      { id: 't2', type: 'Pulverizar', plant: 'Calathea Orbifolia', plantId: 'p3', time: '09:00', desc: 'Pulverizar as folhas para aumentar a umidade.', due: today, done: false, removed: false },
      { id: 't3', type: 'Girar vaso', plant: 'Samambaia', plantId: 'p7', time: '10:15', desc: 'Girar o vaso 180° para um crescimento uniforme.', due: today, done: false, removed: false },
      { id: 't4', type: 'Verificar luz', plant: 'Costela-de-Adão', plantId: 'p2', time: '14:00', desc: 'Observar a posição de luz e reajustar se necessário.', due: today, done: false, removed: false },
      { id: 't5', type: 'Limpar folhas', plant: 'Zamioculca', plantId: 'p8', time: '16:30', desc: 'Remover o pó das folhas com pano úmido.', due: today, done: false, removed: false },
      { id: 't6', type: 'Adubar', plant: 'Jiboia', plantId: 'p5', time: '18:00', desc: 'Aplicar adubo líquido diluído na rega.', due: today, done: false, removed: false },
    ];
  }

  function defaultRoutine() {
    const out = {};
    for (let i = 1; i <= 3; i++) {
      const d = new Date();
      d.setDate(d.getDate() - i);
      out[formatDate(d)] = { doneCount: 6, total: 6 };
    }
    return out;
  }

  function defaultPosts() {
    return [
      {
        id: 'post1', author: 'Fernanda Lima', avatar: null, date: daysAgoStr(1), title: 'Minha monstera floresceu!',
        desc: 'Depois de 2 anos de cuidado, minha Costela-de-Adão finalmente teve novas fenestras incríveis. Compartilho a felicidade!',
        image: plantImg('monstera'), likes: 0, liked: false, comments: [
          { author: 'Rafael', text: 'Que maravilha! Parabéns!' },
        ], userId: null, reported: false,
      },
      {
        id: 'post2', author: 'Carlos M.', avatar: null, date: daysAgoStr(3), title: 'Dica: umidade para calathea',
        desc: 'Para quem tem dificuldade com calatheas, a dica é manter um umidificador ou bandeja com pedrinhas e água próximo.',
        image: plantImg('calathea'), likes: 0, liked: false, comments: [], userId: null, reported: false,
      },
      {
        id: 'post3', author: 'Ana Souza', avatar: null, date: daysAgoStr(5), title: 'Antes e depois da minha sala',
        desc: 'Transformei meu espaço com plantas de interior e agora sinto o ar muito mais leve e agradável.',
        image: plantImg('garden'), likes: 0, liked: false, comments: [
          { author: 'Beatriz', text: 'Ficou lindo!' }, { author: 'João', text: 'Inspiração demais' },
        ], userId: null, reported: false,
      },
    ];
  }

  function defaultNotifications() {
    return [
      { id: 'n1', title: 'Está na hora de regar sua Ficus Lyrata', time: 'Agora', read: false, icon: 'droplet', iconBg: 'blue' },
      { id: 'n2', title: 'Sua Calathea precisa de mais umidade', time: 'há 10 min', read: false, icon: 'cloud', iconBg: 'warn' },
      { id: 'n3', title: 'Você completou sua rotina de ontem!', time: 'há 5 h', read: true, icon: 'check', iconBg: 'green' },
    ];
  }

  function defaultGarden() {
    return { Sala: ['p1', 'p6'], Quarto: ['p3'], Varanda: ['p4'], Jardim: [], Escritório: ['p5', 'p8'], 'Área externa': [], Banheiro: ['p7'] };
  }

  /* ---------- Getters ---------- */
  function getPlants() { return read('plants', defaultPlants()); }
  function savePlants(p) { write('plants', p); }
  function getTasks() { return read('tasks', defaultTasks()); }
  function saveTasks(t) { write('tasks', t); }
  function getRoutine() { return read('routine', defaultRoutine()); }
  function saveRoutine(r) { write('routine', r); }
  function getPosts() { return read('posts', defaultPosts()); }
  function savePosts(p) { write('posts', p); }
  function getNotifications() { return read('notifications', defaultNotifications()); }
  function saveNotifications(n) { write('notifications', n); }
  function getProfile() { return { ...defaultProfile, ...read('profile', defaultProfile) }; }
  function saveProfile(p) { write('profile', p); }
  function getGarden() { return read('garden', defaultGarden()); }
  function saveGarden(g) { write('garden', g); }
  function getSavedRecovery() { return read('savedRecovery', null); }
  function saveRecovery(r) { write('savedRecovery', r); }

  /* ---------- Session / auth (local, organized) ---------- */
  const SYM = 'vv_session';
  function isLoggedIn() { return localStorage.getItem(SYM) === 'true'; }
  function setLoggedIn(v) { localStorage.setItem(SYM, v ? 'true' : 'false'); }

  /* ---------- Toast ---------- */
  function toast(title, msg, type) {
    type = type || 'success';
    let wrap = document.getElementById('toast-wrap');
    if (!wrap) {
      wrap = document.createElement('div');
      wrap.id = 'toast-wrap';
      document.body.appendChild(wrap);
    }
    const icons = { success: 'check-circle', error: 'alert-circle', warn: 'alert-triangle' };
    const colors = { success: 'green', error: 'coral', warn: 'warn' };
    const el = document.createElement('div');
    el.className = 'toast ' + type;
    el.innerHTML = `
      <div class="t-icon ${colors[type]}"><svg data-lucide="${icons[type]}" width="20" height="20"></svg></div>
      <div>
        <div class="t-title">${title}</div>
        ${msg ? `<div class="t-msg">${msg}</div>` : ''}
      </div>`;
    wrap.appendChild(el);
    if (window.lucide) window.lucide.createIcons();
    setTimeout(() => { el.style.transition = 'opacity .4s, transform .4s'; el.style.opacity = '0'; el.style.transform = 'translateX(40px)'; setTimeout(() => el.remove(), 400); }, 3200);
  }

  /* ---------- Modal ---------- */
  function openModal(idOrEl) {
    const el = typeof idOrEl === 'string' ? document.getElementById(idOrEl) : idOrEl;
    if (el) el.classList.add('open');
  }
  function closeModal(idOrEl) {
    const el = typeof idOrEl === 'string' ? document.getElementById(idOrEl) : idOrEl;
    if (el) el.classList.remove('open');
  }
  function initModals() {
    document.addEventListener('click', (e) => {
      if (e.target.classList && e.target.classList.contains('modal-overlay') && e.target !== e.target.querySelector('.modal')) {
        e.target.classList.remove('open');
      }
      const closer = e.target.closest('[data-close-modal]');
      if (closer) {
        const m = closer.closest('.modal-overlay');
        if (m) m.classList.remove('open');
      }
      const opener = e.target.closest('[data-open-modal]');
      if (opener) {
        const target = opener.getAttribute('data-open-modal');
        if (target === 'plant-modal') { if (window.UI) window.UI.openPlantModal(null); return; }
        const el = document.getElementById(target);
        if (el) el.classList.add('open');
      }
    });
  }

  /* ---------- Notifications ---------- */
  function renderNotifications() {
    const wrap = document.getElementById('notif-list');
    if (!wrap) return;
    const list = getNotifications();
    const unread = list.filter(n => !n.read).length;
    const countEl = document.getElementById('notif-count');
    if (countEl) {
      countEl.textContent = unread;
      countEl.classList.toggle('hide', unread === 0);
    }
    if (!list.length) {
      wrap.innerHTML = `<div class="empty-state" style="padding:30px"><p>Nenhuma notificação.</p></div>`;
      return;
    }
    wrap.innerHTML = list.map(n => `
      <div class="notif-item ${n.read ? '' : 'unread'}">
        <div class="nf-icon ${n.iconBg}"><svg data-lucide="${n.icon}" width="19" height="19"></svg></div>
        <div>
          <div class="nf-title">${n.title}</div>
          <div class="nf-time">${n.time}</div>
        </div>
        <button class="nf-dismiss" data-dismiss="${n.id}"><svg data-lucide="x" width="16" height="16"></svg></button>
      </div>`).join('');
    if (window.lucide) window.lucide.createIcons();
  }

  function addNotification(title, icon, iconBg) {
    const list = getNotifications();
    list.unshift({ id: 'n' + Date.now(), title, time: 'Agora', read: false, icon: icon || 'bell', iconBg: iconBg || 'green' });
    saveNotifications(list.slice(0, 60));
    renderNotifications();
    const toggle = document.querySelector('.nav-notif > .icon-btn');
    if (toggle) { toggle.classList.add('bump'); setTimeout(() => toggle.classList.remove('bump'), 500); }
  }

  /* ---------- Navbar build ---------- */
  function buildNavbar(active) {
    const navWrap = document.getElementById('navbar');
    if (!navWrap) return;
    const links = [
      { href: 'index.html', icon: 'home', label: 'Início', key: 'index' },
      { href: 'plants.html', icon: 'leaf', label: 'Minhas Plantas', key: 'plants' },
      { href: 'routine.html', icon: 'calendar-check', label: 'Rotina', key: 'routine' },
      { href: 'diagnosis.html', icon: 'scan-search', label: 'Diagnóstico IA', key: 'diagnosis' },
      { href: 'community.html', icon: 'users', label: 'Comunidade', key: 'community' },
      { href: 'garden.html', icon: 'trees', label: 'Jardim', key: 'garden' },
      { href: 'profile.html', icon: 'user', label: 'Sobre', key: 'profile' },
    ];
    const me = getProfile();
    const linkHtml = links.map(l => `<li><a class="nav-link ${active === l.key ? 'active' : ''}" href="${l.href}"><svg data-lucide="${l.icon}" width="17" height="17"></svg>${l.label}</a></li>`).join('');
    const unread = getNotifications().filter(n => !n.read).length;
    navWrap.innerHTML = `
      <div class="nav-inner">
        <a class="brand" href="index.html">
          <span class="brand-logo">
            <svg class="leaf" data-lucide="leaf" width="22" height="22"></svg>
            <span class="dot"></span>
          </span>
          <span class="brand-text">
            <span class="brand-name">VerdeVivo</span>
            <span class="brand-tag">cuide do seu jardim</span>
          </span>
        </a>
        <ul class="nav-links">${linkHtml}</ul>
        <div class="nav-actions">
          <div class="nav-notif">
            <button class="icon-btn" data-notif-toggle aria-label="Notificações">
              <svg data-lucide="bell" width="21" height="21"></svg>
              <span class="dot-count ${unread === 0 ? 'hide' : ''}" id="notif-count">${unread}</span>
            </button>
            <div class="notif-dropdown" id="notif-dropdown">
              <div class="notif-head"><h4>Notificações</h4><button class="muted-link" id="notif-clear" style="background:none;border:none;font-size:12.5px">Marcar lidas</button></div>
              <div id="notif-list"></div>
            </div>
          </div>
          ${isLoggedIn()
            ? `<a class="nav-user" href="profile.html"><img class="avatar" src="${me.avatar || defaultAvatar()}" alt="avatar"><span>${me.name.split(' ')[0]}</span></a>
               <button class="btn btn-green btn-sm" data-open-modal="plant-modal">+ Adicionar planta</button>`
            : `<a class="btn-login" href="#" data-open-modal="login-modal"><svg data-lucide="log-in" width="16" height="16"></svg>Criar conta</a>`}
          <button class="nav-burger" data-burger aria-label="Menu"><svg data-lucide="menu" width="24" height="24"></svg></button>
        </div>
      </div>
      <nav class="mobile-nav" id="mobile-nav">
        <a class="nav-link ${active === 'index' ? 'active' : ''}" href="index.html"><svg data-lucide="home" width="22" height="22"></svg>Início</a>
        <a class="nav-link ${active === 'plants' ? 'active' : ''}" href="plants.html"><svg data-lucide="leaf" width="22" height="22"></svg>Minhas Plantas</a>
        <a class="nav-link ${active === 'routine' ? 'active' : ''}" href="routine.html"><svg data-lucide="calendar-check" width="22" height="22"></svg>Rotina</a>
        <a class="nav-link ${active === 'diagnosis' ? 'active' : ''}" href="diagnosis.html"><svg data-lucide="scan-search" width="22" height="22"></svg>Diagnóstico IA</a>
        <a class="nav-link ${active === 'community' ? 'active' : ''}" href="community.html"><svg data-lucide="users" width="22" height="22"></svg>Comunidade</a>
        <a class="nav-link ${active === 'garden' ? 'active' : ''}" href="garden.html"><svg data-lucide="trees" width="22" height="22"></svg>Jardim</a>
        <a class="nav-link ${active === 'profile' ? 'active' : ''}" href="profile.html"><svg data-lucide="user" width="22" height="22"></svg>Sobre</a>
        <div class="mobile-actions">
          ${isLoggedIn() ? `<button class="btn btn-green btn-block" data-open-modal="plant-modal" data-close-mobile>+ Adicionar planta</button>`
            : `<button class="btn btn-coral btn-block" data-open-modal="login-modal" data-close-mobile>Criar conta</button>`}
        </div>
      </nav>`;
    if (window.lucide) window.lucide.createIcons();
    navWrap.classList.add('nav', 'loaded');

    // Login modal
    let loginModal = document.getElementById('login-modal');
    if (!loginModal) {
      loginModal = document.createElement('div');
      loginModal.className = 'modal-overlay';
      loginModal.id = 'login-modal';
      loginModal.innerHTML = `
        <div class="modal" style="max-width:420px">
          <div class="modal-head">
            <h3>Bem-vindo(a) ao VerdeVivo 🌿</h3>
            <button class="modal-close" data-close-modal><svg data-lucide="x" width="20" height="20"></svg></button>
          </div>
          <p class="text-muted" style="margin-bottom:20px;font-size:14px">Crie seu perfil para salvar suas plantas, rotinas e publicações. Nenhuma conta é necessária para navegar.</p>
          <form id="login-form">
            <div class="field"><label>Seu nome</label><input id="login-name" required placeholder="Ex: Maria"></div>
            <button class="btn btn-primary btn-block" type="submit">Criar conta</button>
          </form>
          <p class="text-muted" style="font-size:12.5px;margin-top:14px">Os dados são salvos localmente no seu navegador.</p>
        </div>`;
      document.body.appendChild(loginModal);
      const form = loginModal.querySelector('#login-form');
      form.addEventListener('submit', (e) => {
        e.preventDefault();
        const name = loginModal.querySelector('#login-name').value.trim();
        const profile = getProfile();
        profile.name = name || 'Jardineiro(a)';
        saveProfile(profile);
        setLoggedIn(true);
        loginModal.classList.remove('open');
        buildNavbar((window.__activePage) || 'index');
        toast('Conta criada!', 'Bem-vindo(a), ' + profile.name + '!');
        if (window.__authCb) window.__authCb();
      });
    }
  }

  function defaultAvatar(seed) {
    const svg = encodeURIComponent(`<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100"><rect width="100" height="100" fill="#4c7c5f"/><text x="50" y="62" font-size="42" text-anchor="middle" fill="#fff" font-family="sans-serif">${seed || '🌱'}</text></svg>`);
    return 'data:image/svg+xml,' + svg;
  }

  function avatarFor(seed) {
    return defaultAvatar(seed);
  }

  function initNavbar(active) {
    buildNavbar(active);
    const burger = document.querySelector('[data-burger]');
    const mob = document.getElementById('mobile-nav');
    if (burger) burger.addEventListener('click', () => mob.classList.toggle('open'));
    const notifToggle = document.querySelector('[data-notif-toggle]');
    if (notifToggle) notifToggle.addEventListener('click', (e) => {
      e.stopPropagation();
      const dd = document.getElementById('notif-dropdown');
      dd.classList.toggle('open');
    });
    document.addEventListener('click', (e) => {
      const dd = document.getElementById('notif-dropdown');
      if (dd && dd.classList.contains('open') && !e.target.closest('.nav-notif')) dd.classList.remove('open');
      if (mob && mob.classList.contains('open') && !e.target.closest('.brand') && !e.target.closest('[data-burger]') && !e.target.closest('.mobile-nav') && !e.target.closest('#navbar')) mob.classList.remove('open');
    });
    const clearBtn = document.getElementById('notif-clear');
    if (clearBtn) clearBtn.addEventListener('click', () => {
      saveNotifications(getNotifications().map(n => ({ ...n, read: true })));
      renderNotifications();
      if (window.__notifRefresh) window.__notifRefresh();
    });
    document.getElementById('notif-list') && addEventListener('click', (e) => {
      const d = e.target.closest('[data-dismiss]');
      if (d) {
        const id = d.getAttribute('data-dismiss');
        saveNotifications(getNotifications().filter(n => n.id !== id));
        renderNotifications();
      }
    });
    renderNotifications();
  }

  function closeAllMenus() {
    const mob = document.getElementById('mobile-nav');
    if (mob) mob.classList.remove('open');
  }

  /* ---------- Init ---------- */
  function init(activePage) {
    window.__activePage = activePage;
    initNavbar(activePage);
    initModals();
  }

  return {
    read, write, KEYS,
    getPlants, savePlants, getTasks, saveTasks, getRoutine, saveRoutine,
    getPosts, savePosts, getNotifications, saveNotifications,
    getProfile, saveProfile, getGarden, saveGarden,
    getSavedRecovery, saveRecovery,
    toast, openModal, closeModal, initModals,
    init, buildNavbar, renderNotifications, addNotification,
    isLoggedIn, setLoggedIn, closeAllMenus,
    plantImg, formatDate, daysAgoStr, defaultAvatar, avatarFor, _avatarFallback: avatarFor,
  };
})();

window.App = App;

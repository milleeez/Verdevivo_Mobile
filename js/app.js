/* ============================================================
   VerdeVivo - Core app: storage, state, navbar, toasts, modals
   ============================================================ */

const App = (() => {
  const SYM = 'vv_session';

  const KEYS = {
    plants: 'vv_plants',
    tasks: 'vv_tasks',
    routine: 'vv_routine',
    posts: 'vv_posts',
    notifications: 'vv_notifications',
    profile: 'vv_profile',
    garden: 'vv_garden',
    savedRecovery: 'vv_savedRecovery',
    account: 'vv_account',
    accounts: 'vv_accounts',
  };

  const defaultProfile = {
    name: '',
    bio: '',
    avatar: null,
    plants: 0,
    discovered: [],
  };

  /* ---------- Storage helpers ---------- */
  /* Keys that belong to a specific account (namespaced per e-mail). */
  const SCOPED = ['plants', 'tasks', 'routine', 'notifications', 'profile', 'garden', 'savedRecovery', 'posts'];
  /* Shared keys (account/session are global). */
  const SHARED = ['account', 'accounts'];

  function scopeId() {
    const session = localStorage.getItem(SYM);
    return session && session !== 'false' ? session : null;
  }

  function storageKey(key) {
    if (SHARED.indexOf(key) !== -1) return KEYS[key];
    const id = scopeId();
    return id ? KEYS[key] + '::' + id : KEYS[key];
  }

  function read(key, fallback) {
    try {
      const raw = localStorage.getItem(storageKey(key));
      return raw ? JSON.parse(raw) : fallback;
    } catch (e) {
      return fallback;
    }
  }
  function write(key, value) {
    localStorage.setItem(storageKey(key), JSON.stringify(value));
  }

  /* ---------- Plant helpers ---------- */
  function defaultPlants() {
    return [];
  }

  /* Sample garden seeded only after the user creates an account. */
  function starterPlants() {
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
        image: plantImg('calathea'), ageYears: 3, heightCm: 25, health: 'Ótima',
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
    ];
  }

  function plantImg(kind) {
    const map = {
      ficus: 'assets/images/ficus.jpg', monstera: 'assets/images/monstera.jpg',
      calathea: 'assets/images/calathea.jpg', cactus: 'assets/images/cactus.jpg',
      jiboia: 'assets/images/jiboia.jpg', sansevieria: 'assets/images/sansevieria.jpg',
      samambaia: 'assets/images/samambaia.jpg',
    };
    return map[kind] || map.ficus;
  }

  function daysAgo(n) { const d = new Date(); d.setDate(d.getDate() - n); return d.toISOString(); }
  function daysAgoStr(n) { return formatDate(new Date(Date.now() - n * 86400000)); }
  function formatDate(d) { return d.toISOString().slice(0, 10); }

  /* ---------- Tasks ---------- */
  function defaultTasks() {
    return [];
  }

  /* Sample routine tasks seeded only after the user creates an account. */
  function starterTasks() {
    const today = new Date().toISOString().slice(0, 10);
    return [
      { id: 't1', type: 'Rega', plant: 'Ficus Lyrata', plantId: 'p1', time: '08:30', desc: 'Usar 150ml de água mineral em temperatura ambiente.', due: today, done: false, removed: false },
      { id: 't2', type: 'Pulverizar', plant: 'Calathea Orbifolia', plantId: 'p3', time: '09:00', desc: 'Pulverizar as folhas para aumentar a umidade.', due: today, done: false, removed: false },
      { id: 't3', type: 'Girar vaso', plant: 'Samambaia', plantId: 'p7', time: '10:15', desc: 'Girar o vaso 180° para um crescimento uniforme.', due: today, done: false, removed: false },
      { id: 't4', type: 'Verificar luz', plant: 'Costela-de-Adão', plantId: 'p2', time: '14:00', desc: 'Observar a posição de luz e reajustar se necessário.', due: today, done: false, removed: false },
      { id: 't6', type: 'Adubar', plant: 'Jiboia', plantId: 'p5', time: '18:00', desc: 'Aplicar adubo líquido diluído na rega.', due: today, done: false, removed: false },
    ];
  }

  function defaultRoutine() {
    return {};
  }

  /* Sample neighbors' posts seeded only after the user creates an account. */
  function starterPosts() {
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

  function defaultPosts() {
    return [];
  }

  function defaultNotifications() {
    return [];
  }

  function defaultGarden() {
    return {};
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

  /* ---------- Session / auth ---------- */
  function getAccount() { return read('account', null); }
  function saveAccount(a) { write('account', a); }
  function getAccounts() { return read('accounts', []); }
  function saveAccounts(list) { write('accounts', list); }

  function isLoggedIn() { return localStorage.getItem(SYM) !== null && localStorage.getItem(SYM) !== 'false' && !!getAccount(); }
  function currentUser() { return getAccount(); }

  function normalizeEmail(email) { return String(email || '').trim().toLowerCase(); }

  /* Create account with name + email + password (any email/password accepted). */
  function signUp(name, email, password) {
    name = String(name || '').trim();
    email = normalizeEmail(email);
    password = String(password || '');
    if (!name) return { ok: false, error: 'Informe seu nome.' };
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) return { ok: false, error: 'Informe um e-mail válido.' };
    if (password.length < 4) return { ok: false, error: 'A senha precisa ter ao menos 4 caracteres.' };

    const accounts = getAccounts();
    if (accounts.some(a => a.email === email)) return { ok: false, error: 'Já existe uma conta com este e-mail. Faça login.' };

    const account = { name, email, password: btoa(password), createdAt: new Date().toISOString() };
    accounts.push(account);
    saveAccounts(accounts);

    startSession(account);

    const profile = getProfile();
    profile.name = name;
    saveProfile(profile);

    seedStarterData();
    return { ok: true, account };
  }

  /* Log in with email + password (accepts any credentials once registered). */
  function signIn(email, password) {
    email = normalizeEmail(email);
    password = String(password || '');
    const account = getAccounts().find(a => a.email === email);
    if (!account) return { ok: false, error: 'Nenhuma conta encontrada com este e-mail.' };
    if (account.password !== btoa(password)) return { ok: false, error: 'Senha incorreta.' };
    startSession(account);
    const profile = getProfile();
    if (!profile.name) { profile.name = account.name; saveProfile(profile); }
    return { ok: true, account };
  }

  function startSession(account) {
    localStorage.setItem(SYM, account.email);
    saveAccount(account);
  }

  /* Populate a fresh account with a starter garden/routine/community. */
  function seedStarterData() {
    if (!localStorage.getItem(storageKey('plants'))) savePlants(starterPlants());
    if (!localStorage.getItem(storageKey('tasks'))) saveTasks(starterTasks());
    if (!localStorage.getItem(storageKey('posts'))) savePosts(starterPosts());
    if (!localStorage.getItem(storageKey('garden'))) {
      saveGarden({ Sala: ['p1', 'p6'], Quarto: ['p3'], Varanda: ['p4'], Jardim: [], 'Escritório': ['p5'], 'Área externa': [], Banheiro: ['p7'] });
    }
    if (!localStorage.getItem(storageKey('notifications'))) {
      saveNotifications([
        { id: 'n1', title: 'Bem-vindo(a) ao VerdeVivo! Comece adicionando uma planta.', time: 'Agora', read: false, icon: 'leaf', iconBg: 'green' },
      ]);
    }
  }

  function setLoggedIn(v) { if (!v) logout(); }

  /* Reset the current account's data back to the starter sample. */
  function resetData() {
    const id = scopeId();
    if (!id) return false;
    SCOPED.forEach(key => localStorage.removeItem(KEYS[key] + '::' + id));
    seedStarterData();
    return true;
  }

  function logout() {
    localStorage.setItem(SYM, 'false');
    write('account', null);
  }

  function requireLogin(message) {
    if (isLoggedIn()) return true;
    if (window.App && App.openModal) App.openModal('login-modal');
    toast('Crie uma conta', message || 'Você precisa de uma conta para continuar.', 'warn');
    return false;
  }

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
    if (!el) return;
    if (el.id === 'login-modal' && el._applyMode) el._applyMode('signup');
    el.classList.add('open');
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
        if (el) {
          if (el.id === 'login-modal' && el._applyMode) el._applyMode('signup');
          el.classList.add('open');
        }
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
            : `<a class="btn-login" href="#" data-open-modal="login-modal"><svg data-lucide="log-in" width="16" height="16"></svg>Entrar</a>`}
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
            : `<button class="btn btn-coral btn-block" data-open-modal="login-modal" data-close-mobile>Entrar / Criar conta</button>`}
        </div>
      </nav>`;
    if (window.lucide) window.lucide.createIcons();
    navWrap.classList.add('nav', 'loaded');

    // Auth modal (sign up / sign in)
    let loginModal = document.getElementById('login-modal');
    if (!loginModal) {
      loginModal = document.createElement('div');
      loginModal.className = 'modal-overlay';
      loginModal.id = 'login-modal';
      loginModal.innerHTML = `
        <div class="modal" style="max-width:440px">
          <div class="modal-head">
            <h3 id="auth-title">Criar conta 🌿</h3>
            <button class="modal-close" data-close-modal><svg data-lucide="x" width="20" height="20"></svg></button>
          </div>
          <p class="text-muted" style="margin-bottom:20px;font-size:14px" id="auth-sub">Crie sua conta para ter acesso a plantas, rotina, diagnóstico e comunidade.</p>
          <form id="auth-form">
            <div class="field" id="auth-name-field"><label>Nome</label><input id="auth-name" placeholder="Ex: Maria"></div>
            <div class="field"><label>E-mail</label><input type="email" id="auth-email" required placeholder="voce@email.com"></div>
            <div class="field"><label>Senha</label><input type="password" id="auth-password" required placeholder="Mínimo de 4 caracteres"></div>
            <button class="btn btn-primary btn-block" type="submit" id="auth-submit">Criar conta</button>
          </form>
          <p class="text-muted" style="font-size:13px;margin-top:16px;text-align:center">
            <span id="auth-switch-text">Já tem conta?</span>
            <button type="button" id="auth-switch" style="background:none;border:none;color:var(--green-dark);font-weight:800;cursor:pointer;font-size:13px">Entrar</button>
          </p>
          <p class="text-muted" style="font-size:12px;margin-top:8px;text-align:center">Os dados ficam salvos localmente no seu navegador.</p>
        </div>`;
      document.body.appendChild(loginModal);

      const mode = { value: 'signup' };
      const nameField = loginModal.querySelector('#auth-name-field');
      const nameInput = loginModal.querySelector('#auth-name');
      const titleEl = loginModal.querySelector('#auth-title');
      const subEl = loginModal.querySelector('#auth-sub');
      const submitBtn = loginModal.querySelector('#auth-submit');
      const switchBtn = loginModal.querySelector('#auth-switch');
      const switchText = loginModal.querySelector('#auth-switch-text');

      function applyMode(next) {
        mode.value = next;
        const signup = next === 'signup';
        nameField.style.display = signup ? '' : 'none';
        nameInput.required = signup;
        titleEl.textContent = signup ? 'Criar conta 🌿' : 'Entrar na sua conta';
        subEl.textContent = signup
          ? 'Crie sua conta para ter acesso a plantas, rotina, diagnóstico e comunidade.'
          : 'Entre com o e-mail e a senha da sua conta.';
        submitBtn.textContent = signup ? 'Criar conta' : 'Entrar';
        switchText.textContent = signup ? 'Já tem conta?' : 'Ainda não tem conta?';
        switchBtn.textContent = signup ? 'Entrar' : 'Criar conta';
      }
      loginModal._applyMode = applyMode;

      switchBtn.addEventListener('click', () => {
        applyMode(mode.value === 'signup' ? 'signin' : 'signup');
      });

      loginModal.querySelector('#auth-form').addEventListener('submit', (e) => {
        e.preventDefault();
        const email = loginModal.querySelector('#auth-email').value;
        const password = loginModal.querySelector('#auth-password').value;
        const name = nameInput.value;
        const res = mode.value === 'signup' ? signUp(name, email, password) : signIn(email, password);
        if (!res.ok) { toast('Não foi possível continuar', res.error, 'error'); return; }
        loginModal.classList.remove('open');
        loginModal.querySelector('#auth-form').reset();
        buildNavbar((window.__activePage) || 'index');
        toast(mode.value === 'signup' ? 'Conta criada! 🎉' : 'Bem-vindo(a) de volta!', 'Olá, ' + res.account.name + '!');
        if (window.__authCb) window.__authCb();
        if (window.__refreshAll) window.__refreshAll();
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

  /* Block a whole page behind an account. Returns true if access is allowed. */
  function guardPage(opts) {
    opts = opts || {};
    const rootId = opts.root || 'app-root';
    const root = document.getElementById(rootId) || document.querySelector('main');
    if (!root) return true;

    if (!root.dataset.originalHtml) root.dataset.originalHtml = root.innerHTML;

    function showAuth() {
      root.innerHTML = `
        <div class="container page-section">
          <div class="card empty-state" style="max-width:520px;margin:40px auto">
            <div class="e-icon"><svg data-lucide="lock" width="44" height="44"></svg></div>
            <h3>${opts.title || 'Você precisa de uma conta'}</h3>
            <p>${opts.message || 'Crie uma conta gratuita para acessar este recurso do seu jardim.'}</p>
            <div class="flex gap-8 mt-16" style="justify-content:center">
              <button class="btn btn-primary" data-open-modal="login-modal"><svg data-lucide="log-in" width="16" height="16"></svg>Criar conta / Entrar</button>
              <a class="btn btn-ghost" href="index.html">Voltar ao início</a>
            </div>
          </div>
        </div>`;
      if (window.lucide) window.lucide.createIcons();
    }

    function restore() {
      root.innerHTML = root.dataset.originalHtml;
      if (window.lucide) window.lucide.createIcons();
      if (typeof opts.onReady === 'function') opts.onReady();
    }

    window.__authCb = () => {
      if (isLoggedIn()) restore();
      else showAuth();
    };

    if (isLoggedIn()) { if (typeof opts.onReady === 'function') opts.onReady(); return true; }
    showAuth();
    return false;
  }

  return {
    read, write, KEYS,
    getPlants, savePlants, getTasks, saveTasks, getRoutine, saveRoutine,
    getPosts, savePosts, getNotifications, saveNotifications,
    getProfile, saveProfile, getGarden, saveGarden,
    getSavedRecovery, saveRecovery,
    toast, openModal, closeModal, initModals,
    init, buildNavbar, renderNotifications, addNotification,
    isLoggedIn, setLoggedIn, closeAllMenus, guardPage,
    getAccount, currentUser, signUp, signIn, logout, requireLogin, resetData,
    plantImg, formatDate, daysAgoStr, defaultAvatar, avatarFor, _avatarFallback: avatarFor,
  };
})();

window.App = App;

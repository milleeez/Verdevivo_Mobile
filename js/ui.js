/* ============================================================
   VerdeVivo - Shared UI: plant cards, modal, garden, helpers
   ============================================================ */

window.UI = (() => {

  /* ---------- Status dot ---------- */
  function statusDot(p) {
    const s = window.Plants.healthStatus(p);
    return `<span class="dot-status ${s.cls}">${s.label}</span>`;
  }

  /* ---------- Plant card (detail list page) ---------- */
  function plantCard(p) {
    const s = window.Plants.healthStatus(p);
    return `
      <article class="card plant-card card-hover">
        <a href="plant-detail.html?id=${p.id}">
          <img src="${p.image}" alt="${p.name}" class="pc-img" loading="lazy">
        </a>
        <div class="pc-body">
          <div class="flex items-center justify-between">
            <h3 class="pc-name">${p.name}</h3>
            <button class="icon-btn fav ${p.favorite ? 'active' : ''}" data-fav="${p.id}" aria-label="Favoritar"
              style="background:${p.favorite ? 'var(--coral-light)' : 'var(--green-lighter)'};color:${p.favorite ? 'var(--coral-dark)' : 'var(--green-medium)'};width:38px;height:38px">
              <svg data-lucide="heart" width="19" height="19" fill="${p.favorite ? 'currentColor' : 'none'}"></svg>
            </button>
          </div>
          <div class="pc-species">${p.species}</div>
          <div class="flex items-center gap-8">${statusDot(p)}</div>
          <div class="pc-stats">
            <div class="pc-stat"><div class="v">${p.humidity}%</div><div class="l">Umidade</div></div>
            <div class="pc-stat"><div class="v">${p.temperature}°C</div><div class="l">Temp</div></div>
            <div class="pc-stat"><div class="v">${p.light}%</div><div class="l">Luz</div></div>
          </div>
          <div class="pc-meta text-muted" style="font-size:12.5px;margin-bottom:14px">
            Última rega: ${timeAgo(p.lastWatered)} · Próximo: <strong style="color:var(--green-dark)">${p.nextCare || '—'}</strong>
          </div>
          <div class="pc-actions">
            <a class="btn btn-ghost btn-sm" href="plant-detail.html?id=${p.id}">Ver detalhes</a>
            <button class="btn btn-primary btn-sm" data-care="${p.id}">Registrar cuidado</button>
          </div>
        </div>
      </article>`;
  }

  /* ---------- Mini card (attention list) ---------- */
  function miniCard(p) {
    const s = window.Plants.healthStatus(p);
    return `
      <a class="mini-card" href="plant-detail.html?id=${p.id}">
        <img src="${p.image}" alt="${p.name}" loading="lazy">
        <div class="mc-info">
          <div class="mc-name">${p.name}</div>
          <div class="mc-sub">${p.species}</div>
          <div class="mc-meta">Umidade: ${p.humidity}% · Luz: ${p.light}% · ${p.temperature}°C</div>
        </div>
        <span class="badge ${s.cls === 'danger' ? 'badge-danger' : s.cls === 'warn' ? 'badge-warning' : s.cls === 'ok' ? 'badge-green' : 'badge-muted'}">${s.label}</span>
      </a>`;
  }

  /* ---------- Monitor card ---------- */
  function monitorCard(p) {
    return `
      <a class="monitor-card" href="plant-detail.html?id=${p.id}">
        <img src="${p.image}" alt="${p.name}" loading="lazy">
        <div class="m-body">
          <div class="m-name">${p.name}</div>
          <div class="m-species">${p.species}</div>
          <div class="flex items-center mt-8">${statusDot(p)}</div>
          <div class="text-muted" style="font-size:12px;margin-top:8px">Atualizado ${timeAgo(p.lastWatered)}</div>
        </div>
      </a>`;
  }

  /* ---------- Register care modal ---------- */
  function openCareModal(plantId) {
    const p = window.Plants.getById(plantId);
    if (!p) { App.toast('Erro', 'Planta não encontrada', 'error'); return; }
    const existing = document.getElementById('care-modal');
    if (existing) existing.remove();
    const types = ['Regar', 'Adubar', 'Podar', 'Pulverizar', 'Girar vaso', 'Limpar folhas'];
    const overlay = document.createElement('div');
    overlay.className = 'modal-overlay open';
    overlay.id = 'care-modal';
    overlay.innerHTML = `
      <div class="modal">
        <div class="modal-head">
          <h3>Registrar cuidado · ${p.name}</h3>
          <button class="modal-close" data-close-modal><svg data-lucide="x" width="20" height="20"></svg></button>
        </div>
        <form id="care-form">
          <input type="hidden" id="care-plant" value="${p.id}">
          <div class="field">
            <label>Tipo de cuidado</label>
            <select id="care-type">
              ${types.map(t => `<option value="${t}" ${t === 'Regar' ? 'selected' : ''}>${t}</option>`).join('')}
            </select>
          </div>
          <div class="field">
            <label>Data</label>
            <input type="date" id="care-date" value="${new Date().toISOString().slice(0,10)}">
          </div>
          <div class="field">
            <label>Observações (opcional)</label>
            <textarea id="care-note" placeholder="Ex: usei 200ml de água"></textarea>
          </div>
          <button class="btn btn-primary btn-block" type="submit">Salvar cuidado</button>
        </form>
      </div>`;
    document.body.appendChild(overlay);
    if (window.lucide) window.lucide.createIcons();
    overlay.querySelector('[data-close-modal]').addEventListener('click', () => overlay.remove());
    overlay.addEventListener('click', (e) => { if (e.target === overlay) overlay.remove(); });
    overlay.querySelector('#care-form').addEventListener('submit', (e) => {
      e.preventDefault();
      const type = overlay.querySelector('#care-type').value;
      const note = overlay.querySelector('#care-note').value;
      let patch = { lastWatered: new Date().toISOString() };
      if (type === 'Adubar') patch.lastFert = new Date().toISOString();
      if (type === 'Podar') patch.lastPrune = new Date().toISOString();
      window.Plants.updatePlant(p.id, patch);
      if (note) App.addNotification(`Cuidado registrado: ${note} em ${p.name}`, 'check', 'green');
      else App.addNotification(`${type} registrado em ${p.name}`, 'check', 'green');
      overlay.remove();
      App.toast('Cuidado registrado!', `${type} em ${p.name}`);
      if (window.__refreshPlants) window.__refreshPlants();
    });
  }

  /* ---------- Plant add/edit modal ---------- */
  function openPlantModal(existing) {
    const p = existing || null;
    const oldOverlay = document.getElementById('plant-modal');
    if (oldOverlay && oldOverlay.classList.contains('open')) oldOverlay.remove();
    const overlay = document.createElement('div');
    overlay.className = 'modal-overlay open';
    overlay.id = 'plant-modal';
    overlay.innerHTML = `
      <div class="modal modal-wide">
        <div class="modal-head">
          <h3>${p ? 'Editar planta' : 'Adicionar nova planta'}</h3>
          <button class="modal-close" data-close-modal><svg data-lucide="x" width="20" height="20"></svg></button>
        </div>
        <form id="plant-form">
          <input type="hidden" id="pf-id" value="${p ? p.id : ''}">
          <div class="grid grid-2" style="gap:16px">
            <div class="field"><label>Nome</label><input id="pf-name" required value="${p ? p.name : ''}" placeholder="Ex: Ficus Lyrata"></div>
            <div class="field"><label>Espécie</label><input id="pf-species" required value="${p ? p.species : ''}" placeholder="Ex: Figueira-lira"></div>
            <div class="field"><label>Nome científico</label><input id="pf-scientific" value="${p ? p.scientific : ''}" placeholder="Ex: Ficus lyrata"></div>
            <div class="field"><label>Idade (anos)</label><input id="pf-age" type="number" step="0.1" min="0" value="${p ? p.ageYears : 1}"></div>
            <div class="field"><label>Altura (cm)</label><input id="pf-height" type="number" min="0" value="${p ? p.heightCm : 30}"></div>
            <div class="field"><label>Espaço do jardim</label>
              <select id="pf-space">${['Sala','Quarto','Varanda','Jardim','Escritório','Área externa','Banheiro'].map(s => `<option ${p && p.space === s ? 'selected' : ''}>${s}</option>`).join('')}</select>
            </div>
          </div>
          <div class="field"><label>Link da foto (URL) — ou escolha abaixo</label>
            <input id="pf-image" value="${p ? p.image : ''}" placeholder="https://... ou deixe para escolher">
          </div>
          <div style="display:flex;gap:8px;flex-wrap:wrap;margin-bottom:16px" class="preset-imgs">
            ${presetButtons()}
          </div>
          <div class="flex items-center gap-12" style="margin-bottom:16px">
            <label class="flex items-center gap-8" style="font-weight:600;font-size:14px"><input type="checkbox" id="pf-fav" ${p && p.favorite ? 'checked' : ''}> Favorita</label>
            <label class="flex items-center gap-8" style="font-weight:600;font-size:14px"><input type="checkbox" id="pf-attention" ${p && p.attention ? 'checked' : ''}> Precisa de atenção</label>
          </div>
          <button class="btn btn-primary btn-block" type="submit">${p ? 'Salvar alterações' : 'Adicionar planta'}</button>
        </form>
      </div>`;
    document.body.appendChild(overlay);
    if (window.lucide) window.lucide.createIcons();
    overlay.querySelectorAll('.preset-imgs button').forEach(b => b.addEventListener('click', () => {
      overlay.querySelector('#pf-image').value = b.getAttribute('data-src');
    }));
    overlay.querySelector('[data-close-modal]').addEventListener('click', () => overlay.remove());
    overlay.addEventListener('click', (e) => { if (e.target === overlay) overlay.remove(); });
    overlay.querySelector('#plant-form').addEventListener('submit', (e) => {
      e.preventDefault();
      const data = {
        id: overlay.querySelector('#pf-id').value || 'p' + Date.now(),
        name: overlay.querySelector('#pf-name').value.trim(),
        species: overlay.querySelector('#pf-species').value.trim(),
        scientific: overlay.querySelector('#pf-scientific').value.trim() || overlay.querySelector('#pf-species').value.trim(),
        ageYears: parseFloat(overlay.querySelector('#pf-age').value) || 1,
        heightCm: parseFloat(overlay.querySelector('#pf-height').value) || 30,
        space: overlay.querySelector('#pf-space').value,
        image: overlay.querySelector('#pf-image').value.trim() || App.plantImg('ficus'),
        favorite: overlay.querySelector('#pf-fav').checked,
        attention: overlay.querySelector('#pf-attention').checked,
      };
      const plants = App.getPlants();
      const idx = plants.findIndex(x => x.id === data.id);
      const defaults = { humidity: 45, temperature: 23, light: 60, health: 'Ótima', lastWatered: new Date().toISOString(), lastFert: new Date().toISOString(), lastBloom: null, history: [], measurements: [{ date: App.formatDate(new Date()), height: data.heightCm }], nextCare: 'Regar quando necessário' };
      if (idx >= 0) {
        plants[idx] = { ...plants[idx], ...data };
        App.savePlants(plants);
        App.toast('Planta atualizada!', data.name);
      } else {
        App.savePlants([...plants, { ...defaults, ...data }]);
        App.toast('Planta adicionada!', data.name);
        // add to garden space
        const garden = App.getGarden();
        if (!garden[data.space]) garden[data.space] = [];
        garden[data.space].push(data.id);
        App.saveGarden(garden);
        App.addNotification(`Você adicionou ${data.name} ao seu jardim`, 'leaf', 'coral');
      }
      overlay.remove();
      if (window.__refreshPlants) window.__refreshPlants();
      if (window.__refreshAll) window.__refreshAll();
    });
  }

  function presetButtons() {
    const imgs = {
      'Ficus': 'ficus', 'Monstera': 'monstera', 'Calathea': 'calathea', 'Cacto': 'cactus',
      'Jiboia': 'jiboia', 'Sansevieria': 'sansevieria', 'Samambaia': 'samambaia', 'Zamioculca': 'zamioculca',
    };
    return Object.entries(imgs).map(([name, kind]) =>
      `<button type="button" class="btn btn-ghost btn-sm" data-src="${App.plantImg(kind)}">${name}</button>`).join('');
  }

  /* ---------- Time helpers ---------- */
  function timeAgo(iso) {
    if (!iso) return '—';
    const then = new Date(iso).getTime();
    const now = Date.now();
    const diff = Math.max(0, now - then);
    const mins = Math.floor(diff / 60000);
    if (mins < 60) return 'agora mesmo';
    const hours = Math.floor(mins / 60);
    if (hours < 24) return `há ${hours}h`;
    const days = Math.floor(hours / 24);
    if (days === 1) return 'ontem';
    if (days < 30) return `há ${days} dias`;
    const months = Math.floor(days / 30);
    return `há ${months} mês(es)`;
  }

  /* ---------- Global delegation for dynamic buttons ---------- */
  function bindGlobalEvents() {
    document.addEventListener('click', (e) => {
      const care = e.target.closest('[data-care]');
      if (care) { openCareModal(care.getAttribute('data-care')); return; }
      const fav = e.target.closest('[data-fav]');
      if (fav) {
        const id = fav.getAttribute('data-fav');
        const p = window.Plants.getById(id);
        if (!p) return;
        const val = !p.favorite;
        window.Plants.updatePlant(id, { favorite: val });
        if (window.__refreshPlants) window.__refreshPlants();
        App.toast(val ? 'Adicionada às favoritas' : 'Removida das favoritas', p.name);
        return;
      }
      const addPlant = e.target.closest('[data-open-plant]');
      if (addPlant) { openPlantModal(null); return; }
    });
  }

  return {
    plantCard, miniCard, monitorCard, openCareModal, openPlantModal,
    timeAgo, statusDot, bindGlobalEvents,
  };
})();

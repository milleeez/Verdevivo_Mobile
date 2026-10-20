/* ============================================================
   VerdeVivo - Plants: CRUD, measurements, filters, modals
   ============================================================ */

window.Plants = (() => {

  /* ---------- Health / status ---------- */
  function healthStatus(p) {
    if (!p) return { label: 'Desconhecido', cls: 'muted' };
    if (p.attention) return { label: 'Precisa de atenção', cls: 'danger' };
    const h = (p.humidity || 0);
    if (h < 30) return { label: 'Precisa de água', cls: 'danger' };
    if ((p.light || 0) < 35 && p.species !== 'Cacto') return { label: 'Pouca luz', cls: 'warn' };
    if (p.health === 'Boa') return { label: 'Boa', cls: 'ok' };
    return { label: p.health || 'Ótima', cls: 'ok' };
  }

  function healthClass(p) {
    return healthStatus(p).cls;
  }

  function getById(id) {
    return App.getPlants().find(p => p.id === id);
  }

  function updatePlant(id, patch) {
    const plants = App.getPlants();
    const idx = plants.findIndex(p => p.id === id);
    if (idx === -1) return;
    plants[idx] = { ...plants[idx], ...patch };
    App.savePlants(plants);
    return plants[idx];
  }

  function deletePlant(id) {
    const plants = App.getPlants().filter(p => p.id !== id);
    App.savePlants(plants);
    // remove from garden
    const garden = App.getGarden();
    for (const k in garden) garden[k] = garden[k].filter(pid => pid !== id);
    App.saveGarden(garden);
    // remove tasks for this plant
    App.saveTasks(App.getTasks().filter(t => t.plantId !== id));
  }

  return { healthStatus, healthClass, getById, updatePlant, deletePlant };
})();

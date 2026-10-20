/* ============================================================
   VerdeVivo - Routine: weekly calendar, daily tasks, streak
   ============================================================ */

window.Routine = (() => {

  const TASK_ICONS = {
    'Rega': 'droplet', 'Adubar': 'flask-conical', 'Podar': 'scissors',
    'Girar vaso': 'refresh-cw', 'Verificar luz': 'sun', 'Pulverizar': 'cloud-rain',
    'Limpar folhas': 'sparkles',
  };
  const TASK_COLORS = {
    'Rega': 'blue', 'Adubar': 'green', 'Podar': 'coral', 'Girar vaso': 'warn',
    'Verificar luz': 'warn', 'Pulverizar': 'blue', 'Limpar folhas': 'green',
  };

  const WEEK_NAMES = ['dom', 'seg', 'ter', 'qua', 'qui', 'sex', 'sáb'];

  let selectedKey = null;

  function todayKey() { return App.formatDate(new Date()); }

  function keyFor(date) { return App.formatDate(date); }

  function shiftKey(key, days) {
    const d = parseKey(key);
    d.setDate(d.getDate() + days);
    return App.formatDate(d);
  }

  function parseKey(key) {
    const [y, m, d] = key.split('-').map(Number);
    return new Date(y, m - 1, d);
  }

  /* ---------- Seeding ---------- */

  function seedTasks(key) {
    const base = [
      { type: 'Rega', plant: 'Ficus Lyrata', plantId: 'p1', time: '08:30', desc: 'Usar 150ml de água mineral em temperatura ambiente.' },
      { type: 'Pulverizar', plant: 'Calathea Orbifolia', plantId: 'p3', time: '09:00', desc: 'Pulverizar as folhas para aumentar a umidade.' },
      { type: 'Girar vaso', plant: 'Samambaia', plantId: 'p7', time: '10:15', desc: 'Girar o vaso 180° para um crescimento uniforme.' },
      { type: 'Verificar luz', plant: 'Costela-de-Adão', plantId: 'p2', time: '14:00', desc: 'Observar a posição de luz e reajustar se necessário.' },
      { type: 'Limpar folhas', plant: 'Zamioculca', plantId: 'p8', time: '16:30', desc: 'Remover o pó das folhas com pano úmido.' },
      { type: 'Adubar', plant: 'Jiboia', plantId: 'p5', time: '18:00', desc: 'Aplicar adubo líquido diluído na rega.' },
    ].map((t, i) => ({ id: 't' + key.replace(/-/g, '') + i, ...t, due: key, done: false, removed: false }));
    return base;
  }

  function ensureSeeded() {
    const key = todayKey();
    const tasks = App.getTasks();
    if (!tasks.some(t => t.due === key && !t.removed)) {
      App.saveTasks([...tasks, ...seedTasks(key)]);
    }
  }

  /* ---------- Reads ---------- */

  function allTasks() { return App.getTasks().filter(t => !t.removed); }

  function tasksByKey(key) {
    return allTasks().filter(t => t.due === key);
  }

  function getTasksToday() { return tasksByKey(todayKey()); }

  function getSelectedKey() { return selectedKey || todayKey(); }

  function setSelectedKey(key) { selectedKey = key; }

  /* Day view: tasks for the selected day + overdue (pending) from earlier days. */
  function tasksForView(key) {
    const day = (key === todayKey()) ? todayKey() : key;
    const own = tasksByKey(day).map(t => ({ ...t, overdue: false }));
    if (day === todayKey()) {
      const overdue = allTasks().filter(t => t.due < day && !t.done).map(t => ({ ...t, overdue: true }));
      return [...overdue, ...own];
    }
    return own;
  }

  function saveTask(id, patch) {
    const tasks = App.getTasks();
    const idx = tasks.findIndex(t => t.id === id);
    if (idx === -1) return;
    tasks[idx] = { ...tasks[idx], ...patch };
    App.saveTasks(tasks);
    syncRoutine(tasks, tasks[idx].due);
  }

  function removeTask(id) {
    const tasks = App.getTasks().map(t => t.id === id ? { ...t, removed: true } : t);
    App.saveTasks(tasks);
    const removed = tasks.find(t => t.id === id);
    syncRoutine(tasks, removed && removed.due);
  }

  function addTask(data) {
    const tasks = App.getTasks();
    const due = data.due || todayKey();
    tasks.push({ id: 't' + Date.now() + Math.floor(Math.random() * 1000), ...data, due, done: false, removed: false });
    App.saveTasks(tasks);
    syncRoutine(tasks, due);
  }

  /* ---------- Routine record (progress history) ---------- */

  function syncRoutine(tasks, onKey) {
    const routine = App.getRoutine();

    /* Always keep today's record up to date. */
    const today = todayKey();
    const todays = tasks.filter(t => t.due === today && !t.removed);
    routine[today] = { doneCount: todays.filter(t => t.done).length, total: todays.length };

    /* And the record for the specific affected day, if different. */
    if (onKey && onKey !== today) {
      const dayTasks = tasks.filter(t => t.due === onKey && !t.removed);
      routine[onKey] = { doneCount: dayTasks.filter(t => t.done).length, total: dayTasks.length };
    }

    if (todays.length && todays.every(t => t.done) && routine.__notifiedToday !== today) {
      App.addNotification('Você completou sua rotina de hoje! 🎉', 'check', 'green');
      routine.__notifiedToday = today;
    }
    App.saveRoutine(routine);
  }

  function streak() {
    const routine = App.getRoutine();
    let streak = 0;
    const d = new Date();
    for (let i = 0; i < 700; i++) {
      const rec = routine[App.formatDate(d)];
      if (rec && rec.doneCount > 0) { streak++; d.setDate(d.getDate() - 1); }
      else break;
    }
    if (streak === 0) {
      const d2 = new Date();
      d2.setDate(d2.getDate() - 1);
      for (let i = 0; i < 700; i++) {
        const rec = routine[App.formatDate(d2)];
        if (rec && rec.doneCount > 0) { streak++; d2.setDate(d2.getDate() - 1); }
        else break;
      }
    }
    return streak;
  }

  /* ---------- Rendering ---------- */

  function calendarHtml(today = new Date()) {
    const routine = App.getRoutine();
    const view = getSelectedKey();
    const dow = (today.getDay() + 6) % 7; // Monday first
    const monday = new Date(today);
    monday.setDate(today.getDate() - dow);
    const days = [];
    for (let i = 0; i < 7; i++) {
      const d = new Date(monday);
      d.setDate(monday.getDate() + i);
      const key = App.formatDate(d);
      const rec = routine[key];
      const isToday = key === todayKey();
      const isSel = key === view;
      let cls = 'future';
      if (isToday) cls = 'today';
      else if (rec && rec.total && rec.doneCount >= rec.total) cls = 'completed';
      else if (rec && rec.doneCount > 0) cls = 'partial';
      if (isSel) cls += ' selected';
      days.push({ key, num: d.getDate(), name: ['seg', 'ter', 'qua', 'qui', 'sex', 'sáb', 'dom'][i], cls });
    }
    return days.map(d => `
      <button type="button" class="cal-day ${d.cls}" data-cal-day="${d.key}">
        <div class="cd-name">${d.name}</div>
        <div class="cd-num">${d.num}</div>
        <div class="cd-dot"></div>
      </button>`).join('');
  }

  function taskCard(t) {
    const icon = TASK_ICONS[t.type] || 'leaf';
    const color = TASK_COLORS[t.type] || 'green';
    const isFuture = t.due > todayKey();
    return `
      <div class="task-card ${t.done ? 'done' : ''}" data-task="${t.id}">
        <button class="check-btn" data-toggle-task="${t.id}" aria-label="Concluir"><svg data-lucide="check" width="18" height="18"></svg></button>
        <span class="tc-time">${t.time}</span>
        <span class="tc-icon m-icon-${color}"><svg data-lucide="${icon}" width="22" height="22"></svg></span>
        <div class="tc-body">
          <div class="tc-title">${t.type}</div>
          <div class="tc-plant">${t.plant}</div>
          <div class="tc-desc">${t.desc}</div>
          <div class="tc-meta">
            ${t.done
              ? '<span class="badge badge-green">Concluída</span>'
              : t.overdue
                ? `<span class="badge badge-danger">Atrasada · ${formatShort(t.due)}</span>`
                : isFuture
                  ? `<span class="badge badge-muted">Agendada · ${formatShort(t.due)}</span>`
                  : '<span class="badge badge-coral">Pendente</span>'}
            <button class="btn btn-ghost btn-sm" data-remove-task="${t.id}">Remover</button>
          </div>
        </div>
      </div>`;
  }

  function formatShort(key) {
    const d = parseKey(key);
    return `${String(d.getDate()).padStart(2, '0')}/${String(d.getMonth() + 1).padStart(2, '0')}`;
  }

  return {
    TASK_ICONS, TASK_COLORS,
    todayKey, shiftKey, parseKey, keyFor, allTasks,
    tasksByKey, getTasksToday, getTasksOrDefault: getTasksToday,
    tasksForView, getSelectedKey, setSelectedKey,
    ensureSeeded, saveTask, removeTask, addTask, syncRoutine, streak,
    calendarHtml, taskCard,
  };
})();

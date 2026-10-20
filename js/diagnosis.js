/* ============================================================
   VerdeVivo - AI Diagnosis: fake-but-realistic visual analysis
   ============================================================ */

window.Diagnosis = (() => {

  const SPECIES = [
    { name: 'Calathea Orbifolia', photo: 'calathea', conf: 98, days: 7, problems: ['Queimadura por exposição solar', 'Baixa umidade', 'Estresse hídrico'] },
    { name: 'Ficus Lyrata', photo: 'monstera', conf: 96, days: 5, problems: ['Solo muito seco', 'Acúmulo de sais'] },
    { name: 'Costela-de-Adão', photo: 'monstera', conf: 97, days: 4, problems: ['Falta de água', 'Ar seco demais'] },
    { name: 'Cacto Echinopsis', photo: 'calathea', conf: 95, days: 3, problems: ['Excesso de rega'] },
    { name: 'Jiboia', photo: 'jiboia', conf: 97, days: 4, problems: ['Folhas envelhecidas', 'Luz insuficiente'] },
    { name: 'Espada-de-São-Jorge', photo: 'sansevieria', conf: 96, days: 3, problems: ['Excesso de umidade no solo'] },
    { name: 'Samambaia', photo: 'samambaia', conf: 94, days: 6, problems: ['Baixa umidade do ar', 'Falhas na rega'] },
  ];

  const MARKERS = [
    { l: 30, t: 36, title: 'Área analisada', type: 'info' },
    { l: 62, t: 30, title: 'Possível queimadura', type: 'bad' },
    { l: 78, t: 66, title: 'Folha saudável', type: 'good' },
    { l: 42, t: 74, title: 'Baixa umidade', type: 'bad' },
  ];

  const RECOVERY_PLAN = [
    { num: 1, title: 'Reposicionar para sombra parcial', desc: 'Afaste o vaso cerca de 1,5m da janela voltada para o oeste.' },
    { num: 2, title: 'Aumentar umidade do ar', desc: 'Mantenha o ambiente com umidade próxima de 60%.' },
    { num: 3, title: 'Reduzir exposição solar', desc: 'Evite luz solar direta durante os horários mais intensos.' },
    { num: 4, title: 'Monitorar folhas', desc: 'Verifique novas manchas diariamente.' },
  ];

  const STATUS = ['Analisando sua planta...', 'Detectando folhas...', 'Comparando com banco de espécies...', 'Medindo saúde do substrato...', 'Gerando plano de recuperação...'];

  function pickResult() {
    const r = SPECIES[Math.floor(Math.random() * SPECIES.length)];
    return r;
  }

  function steps() {
    const r = pickResult();
    const statusBy = (h) => h < 30 ? 'Crítico' : h < 55 ? 'Atenção' : 'Bom';
    const light = ['Alta', 'Média', 'Baixa'][Math.floor(Math.random() * 3)];
    return {
      ...r,
      markerPoints: MARKERS,
      humidity: 45 + Math.floor(Math.random() * 40),
      lightLabel: light,
      recoveryDays: r.days + Math.floor(Math.random() * 3),
      health: Math.random() > 0.3 ? 'Boa' : 'Regular',
    };
  }

  return { SPECIES, MARKERS, RECOVERY_PLAN, STATUS, pickResult, steps };
})();
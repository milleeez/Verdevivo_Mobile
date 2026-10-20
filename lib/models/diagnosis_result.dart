class DiagnosisMarker {
  final double leftPercent;
  final double topPercent;
  final String title;
  final String type; // good, bad, info

  DiagnosisMarker({
    required this.leftPercent,
    required this.topPercent,
    required this.title,
    required this.type,
  });
}

class RecoveryStep {
  final int num;
  final String title;
  final String desc;
  bool done;

  RecoveryStep({
    required this.num,
    required this.title,
    required this.desc,
    this.done = false,
  });
}

class DiagnosisResult {
  final String name;
  final String photo;
  final int confidence;
  final int recoveryDays;
  final String health;
  final int humidity;
  final String lightLabel;
  final List<String> problems;
  final List<DiagnosisMarker> markers;
  final List<RecoveryStep> recoveryPlan;

  DiagnosisResult({
    required this.name,
    required this.photo,
    required this.confidence,
    required this.recoveryDays,
    required this.health,
    required this.humidity,
    required this.lightLabel,
    required this.problems,
    required this.markers,
    required this.recoveryPlan,
  });

  static DiagnosisResult sampleCalathea() {
    return DiagnosisResult(
      name: 'Calathea Orbifolia',
      photo: 'assets/images/calathea.jpg',
      confidence: 98,
      recoveryDays: 7,
      health: 'Atenção',
      humidity: 48,
      lightLabel: 'Média',
      problems: [
        'Queimadura por exposição solar',
        'Baixa umidade do ar',
        'Estresse hídrico leve',
      ],
      markers: [
        DiagnosisMarker(leftPercent: 30, topPercent: 36, title: 'Área analisada', type: 'info'),
        DiagnosisMarker(leftPercent: 62, topPercent: 30, title: 'Possível queimadura', type: 'bad'),
        DiagnosisMarker(leftPercent: 78, topPercent: 66, title: 'Folha saudável', type: 'good'),
        DiagnosisMarker(leftPercent: 42, topPercent: 74, title: 'Baixa umidade', type: 'bad'),
      ],
      recoveryPlan: [
        RecoveryStep(num: 1, title: 'Reposicionar para sombra parcial', desc: 'Afaste o vaso cerca de 1,5m da janela com sol direto.'),
        RecoveryStep(num: 2, title: 'Aumentar umidade do ar', desc: 'Mantenha o ambiente com umidade próxima de 60%.'),
        RecoveryStep(num: 3, title: 'Reduzir exposição solar', desc: 'Evite raios solares intensos nas horas mais quentes.'),
        RecoveryStep(num: 4, title: 'Monitorar folhas novas', desc: 'Verifique novas brotações diariamente.'),
      ],
    );
  }
}

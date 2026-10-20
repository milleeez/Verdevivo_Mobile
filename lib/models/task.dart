class PlantTask {
  final String id;
  final String type;
  final String plant;
  final String plantId;
  final String time;
  final String desc;
  final String due;
  bool done;

  PlantTask({
    required this.id,
    required this.type,
    required this.plant,
    required this.plantId,
    required this.time,
    required this.desc,
    required this.due,
    this.done = false,
  });

  static List<PlantTask> getDefaultTasks() {
    return [
      PlantTask(id: 't1', type: 'Rega', plant: 'Ficus Lyrata', plantId: 'p1', time: '08:30', desc: 'Usar 150ml de água mineral em temperatura ambiente.', due: 'Hoje', done: false),
      PlantTask(id: 't2', type: 'Pulverizar', plant: 'Calathea Orbifolia', plantId: 'p3', time: '09:00', desc: 'Pulverizar as folhas para aumentar a umidade.', due: 'Hoje', done: false),
      PlantTask(id: 't3', type: 'Girar vaso', plant: 'Samambaia', plantId: 'p7', time: '10:15', desc: 'Girar o vaso 180° para um crescimento uniforme.', due: 'Hoje', done: false),
      PlantTask(id: 't4', type: 'Verificar luz', plant: 'Costela-de-Adão', plantId: 'p2', time: '14:00', desc: 'Observar a posição de luz e reajustar se necessário.', due: 'Hoje', done: false),
      PlantTask(id: 't5', type: 'Limpar folhas', plant: 'Zamioculca', plantId: 'p8', time: '16:30', desc: 'Remover o pó das folhas com pano úmido.', due: 'Hoje', done: false),
      PlantTask(id: 't6', type: 'Adubar', plant: 'Jiboia', plantId: 'p5', time: '18:00', desc: 'Aplicar adubo líquido diluído na rega.', due: 'Hoje', done: false),
    ];
  }
}

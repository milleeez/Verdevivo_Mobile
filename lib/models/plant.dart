class PlantHistory {
  final String type;
  final String date;
  final String desc;

  PlantHistory({
    required this.type,
    required this.date,
    required this.desc,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'date': date,
    'desc': desc,
  };

  factory PlantHistory.fromJson(Map<String, dynamic> json) => PlantHistory(
    type: json['type'] ?? '',
    date: json['date'] ?? '',
    desc: json['desc'] ?? '',
  );
}

class PlantMeasurement {
  final String date;
  final double height;

  PlantMeasurement({
    required this.date,
    required this.height,
  });

  Map<String, dynamic> toJson() => {
    'date': date,
    'height': height,
  };

  factory PlantMeasurement.fromJson(Map<String, dynamic> json) => PlantMeasurement(
    date: json['date'] ?? '',
    height: (json['height'] as num?)?.toDouble() ?? 0.0,
  );
}

class Plant {
  final String id;
  String name;
  String species;
  String scientific;
  String image;
  double ageYears;
  double heightCm;
  String health;
  int humidity;
  int temperature;
  int light;
  String lastWatered;
  String? lastFert;
  String? lastBloom;
  bool favorite;
  bool attention;
  String space;
  List<PlantHistory> history;
  List<PlantMeasurement> measurements;
  String nextCare;

  Plant({
    required this.id,
    required this.name,
    required this.species,
    required this.scientific,
    required this.image,
    required this.ageYears,
    required this.heightCm,
    required this.health,
    required this.humidity,
    required this.temperature,
    required this.light,
    required this.lastWatered,
    this.lastFert,
    this.lastBloom,
    this.favorite = false,
    this.attention = false,
    required this.space,
    required this.history,
    required this.measurements,
    required this.nextCare,
  });

  Plant copyWith({
    String? name,
    String? species,
    String? scientific,
    String? image,
    double? ageYears,
    double? heightCm,
    String? health,
    int? humidity,
    int? temperature,
    int? light,
    String? lastWatered,
    String? lastFert,
    bool? favorite,
    bool? attention,
    String? space,
    List<PlantHistory>? history,
    List<PlantMeasurement>? measurements,
    String? nextCare,
  }) {
    return Plant(
      id: id,
      name: name ?? this.name,
      species: species ?? this.species,
      scientific: scientific ?? this.scientific,
      image: image ?? this.image,
      ageYears: ageYears ?? this.ageYears,
      heightCm: heightCm ?? this.heightCm,
      health: health ?? this.health,
      humidity: humidity ?? this.humidity,
      temperature: temperature ?? this.temperature,
      light: light ?? this.light,
      lastWatered: lastWatered ?? this.lastWatered,
      lastFert: lastFert ?? this.lastFert,
      lastBloom: lastBloom,
      favorite: favorite ?? this.favorite,
      attention: attention ?? this.attention,
      space: space ?? this.space,
      history: history ?? this.history,
      measurements: measurements ?? this.measurements,
      nextCare: nextCare ?? this.nextCare,
    );
  }

  static List<Plant> getDefaultPlants() {
    return [
      Plant(
        id: 'p1',
        name: 'Ficus Lyrata',
        species: 'Figueira-lira',
        scientific: 'Ficus lyrata',
        image: 'assets/images/ficus.jpg',
        ageYears: 1.4,
        heightCm: 68,
        health: 'Ótima',
        humidity: 42,
        temperature: 22,
        light: 85,
        lastWatered: 'Hoje',
        lastFert: '12 dias atrás',
        favorite: false,
        attention: false,
        space: 'Sala',
        history: [
          PlantHistory(type: 'Brotamento', date: '6 meses atrás', desc: 'Novas brotações surgiram na base.'),
          PlantHistory(type: 'Folhas novas', date: '3 meses atrás', desc: 'Crescimento vigoroso de folhas.'),
          PlantHistory(type: 'Maturidade', date: '1 mês atrás', desc: 'Folhas grandes e saudáveis.'),
        ],
        measurements: [
          PlantMeasurement(date: '6m', height: 52),
          PlantMeasurement(date: '4m', height: 57),
          PlantMeasurement(date: '2m', height: 62),
          PlantMeasurement(date: '1m', height: 65),
          PlantMeasurement(date: 'Hoje', height: 68),
        ],
        nextCare: 'Regar quando substrato estiver seco',
      ),
      Plant(
        id: 'p2',
        name: 'Costela-de-Adão',
        species: 'Monstera deliciosa',
        scientific: 'Monstera deliciosa',
        image: 'assets/images/monstera.jpg',
        ageYears: 2.1,
        heightCm: 95,
        health: 'Precisa de água',
        humidity: 28,
        temperature: 24,
        light: 60,
        lastWatered: '9 dias atrás',
        lastFert: '20 dias atrás',
        favorite: true,
        attention: true,
        space: 'Sala',
        history: [
          PlantHistory(type: 'Brotamento', date: '4 meses atrás', desc: 'Novo broto lateral apareceu.'),
          PlantHistory(type: 'Folhas novas', date: '45 dias atrás', desc: 'Duas folhas novas com fenestras.'),
        ],
        measurements: [
          PlantMeasurement(date: '6m', height: 70),
          PlantMeasurement(date: '3m', height: 82),
          PlantMeasurement(date: '1m', height: 90),
          PlantMeasurement(date: 'Hoje', height: 95),
        ],
        nextCare: 'Rega urgente',
      ),
      Plant(
        id: 'p3',
        name: 'Calathea Orbifolia',
        species: 'Calathea orbifolia',
        scientific: 'Calathea orbifolia',
        image: 'assets/images/calathea.jpg',
        ageYears: 0.8,
        heightCm: 40,
        health: 'Ótima',
        humidity: 65,
        temperature: 22,
        light: 50,
        lastWatered: '2 dias atrás',
        lastFert: '15 dias atrás',
        favorite: false,
        attention: false,
        space: 'Quarto',
        history: [
          PlantHistory(type: 'Brotamento', date: '2 meses atrás', desc: 'Folhas novas desenrolando.'),
        ],
        measurements: [
          PlantMeasurement(date: '5m', height: 28),
          PlantMeasurement(date: '2m', height: 34),
          PlantMeasurement(date: 'Hoje', height: 40),
        ],
        nextCare: 'Pulverizar folhas',
      ),
      Plant(
        id: 'p4',
        name: 'Cacto Echinopsis',
        species: 'Echinopsis',
        scientific: 'Echinopsis sp.',
        image: 'assets/images/cactus.jpg',
        ageYears: 3.0,
        heightCm: 25,
        health: 'Ótima',
        humidity: 20,
        temperature: 26,
        light: 90,
        lastWatered: '14 dias atrás',
        lastFert: '30 dias atrás',
        favorite: false,
        attention: false,
        space: 'Varanda',
        history: [
          PlantHistory(type: 'Floração', date: '6 meses atrás', desc: 'Floresceu pela primeira vez!'),
        ],
        measurements: [
          PlantMeasurement(date: '6m', height: 20),
          PlantMeasurement(date: '3m', height: 23),
          PlantMeasurement(date: 'Hoje', height: 25),
        ],
        nextCare: 'Rega em 7 dias',
      ),
      Plant(
        id: 'p5',
        name: 'Jiboia',
        species: 'Epipremnum aureum',
        scientific: 'Epipremnum aureum',
        image: 'assets/images/jiboia.jpg',
        ageYears: 1.1,
        heightCm: 55,
        health: 'Boa',
        humidity: 55,
        temperature: 23,
        light: 70,
        lastWatered: '4 dias atrás',
        lastFert: '10 dias atrás',
        favorite: false,
        attention: false,
        space: 'Escritório',
        history: [
          PlantHistory(type: 'Crescimento', date: '40 dias atrás', desc: 'Videira cresceu 10cm.'),
        ],
        measurements: [
          PlantMeasurement(date: '5m', height: 38),
          PlantMeasurement(date: '2m', height: 47),
          PlantMeasurement(date: 'Hoje', height: 55),
        ],
        nextCare: 'Podar ponta',
      ),
      Plant(
        id: 'p6',
        name: 'Espada-de-São-Jorge',
        species: 'Sansevieria',
        scientific: 'Dracaena trifasciata',
        image: 'assets/images/sansevieria.jpg',
        ageYears: 2.5,
        heightCm: 80,
        health: 'Ótima',
        humidity: 30,
        temperature: 24,
        light: 65,
        lastWatered: '10 dias atrás',
        lastFert: '25 dias atrás',
        favorite: false,
        attention: false,
        space: 'Sala',
        history: [
          PlantHistory(type: 'Folhas novas', date: '70 dias atrás', desc: 'Três novas folhas eretas.'),
        ],
        measurements: [
          PlantMeasurement(date: '6m', height: 62),
          PlantMeasurement(date: '2m', height: 74),
          PlantMeasurement(date: 'Hoje', height: 80),
        ],
        nextCare: 'Rega leve',
      ),
      Plant(
        id: 'p7',
        name: 'Samambaia',
        species: 'Nephrolepis',
        scientific: 'Nephrolepis exaltata',
        image: 'assets/images/samambaia.jpg',
        ageYears: 1.6,
        heightCm: 45,
        health: 'Pouca luz',
        humidity: 70,
        temperature: 21,
        light: 25,
        lastWatered: '1 dia atrás',
        lastFert: '8 dias atrás',
        favorite: false,
        attention: true,
        space: 'Banheiro',
        history: [],
        measurements: [
          PlantMeasurement(date: '4m', height: 35),
          PlantMeasurement(date: '1m', height: 42),
          PlantMeasurement(date: 'Hoje', height: 45),
        ],
        nextCare: 'Mover para local mais iluminado',
      ),
      Plant(
        id: 'p8',
        name: 'Zamioculca',
        species: 'Zamioculcas zamiifolia',
        scientific: 'Zamioculcas zamiifolia',
        image: 'assets/images/zamioculca.jpg',
        ageYears: 2.0,
        heightCm: 60,
        health: 'Ótima',
        humidity: 40,
        temperature: 23,
        light: 55,
        lastWatered: '12 dias atrás',
        lastFert: '30 dias atrás',
        favorite: true,
        attention: false,
        space: 'Escritório',
        history: [
          PlantHistory(type: 'Brotamento', date: '50 dias atrás', desc: 'Nova haste brotando do solo.'),
        ],
        measurements: [
          PlantMeasurement(date: '5m', height: 45),
          PlantMeasurement(date: '2m', height: 53),
          PlantMeasurement(date: 'Hoje', height: 60),
        ],
        nextCare: 'Rega em 10 dias',
      ),
    ];
  }
}

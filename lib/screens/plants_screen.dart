import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../models/plant.dart';
import 'plant_detail_screen.dart';

class PlantsScreen extends StatefulWidget {
  const PlantsScreen({super.key});

  @override
  State<PlantsScreen> createState() => _PlantsScreenState();
}

class _PlantsScreenState extends State<PlantsScreen> {
  String _selectedFilter = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  void _showAddPlantDialog(BuildContext context) {
    final nameController = TextEditingController();
    final speciesController = TextEditingController();
    final scientificController = TextEditingController();
    final ageController = TextEditingController(text: '1.0');
    final heightController = TextEditingController(text: '30');
    String selectedSpace = 'Sala';
    String selectedImage = 'assets/images/ficus.jpg';

    final spaces = ['Sala', 'Quarto', 'Varanda', 'Jardim', 'Escritório', 'Área externa', 'Banheiro'];
    final imagePresets = [
      {'name': 'Ficus', 'path': 'assets/images/ficus.jpg'},
      {'name': 'Monstera', 'path': 'assets/images/monstera.jpg'},
      {'name': 'Calathea', 'path': 'assets/images/calathea.jpg'},
      {'name': 'Cacto', 'path': 'assets/images/cactus.jpg'},
      {'name': 'Jiboia', 'path': 'assets/images/jiboia.jpg'},
      {'name': 'Sansevieria', 'path': 'assets/images/sansevieria.jpg'},
      {'name': 'Samambaia', 'path': 'assets/images/samambaia.jpg'},
      {'name': 'Zamioculca', 'path': 'assets/images/zamioculca.jpg'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Adicionar Nova Planta', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                        IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nome da planta *',
                        hintText: 'Ex: Minha Monstera',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: speciesController,
                      decoration: InputDecoration(
                        labelText: 'Espécie *',
                        hintText: 'Ex: Costela-de-Adão',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedSpace,
                            decoration: InputDecoration(
                              labelText: 'Espaço',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            items: spaces.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => selectedSpace = val);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: heightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Altura (cm)',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Escolha uma foto:', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 50,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: imagePresets.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, idx) {
                          final item = imagePresets[idx];
                          final isSelected = selectedImage == item['path'];
                          return ChoiceChip(
                            label: Text(item['name']!),
                            selected: isSelected,
                            selectedColor: AppColors.greenDark,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppColors.greenDark,
                              fontWeight: FontWeight.bold,
                            ),
                            onSelected: (_) {
                              setModalState(() => selectedImage = item['path']!);
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.coralDark,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        if (nameController.text.trim().isEmpty) return;
                        final newPlant = Plant(
                          id: 'p_${DateTime.now().millisecondsSinceEpoch}',
                          name: nameController.text.trim(),
                          species: speciesController.text.trim().isEmpty ? 'Planta Ornamental' : speciesController.text.trim(),
                          scientific: scientificController.text.trim().isEmpty ? speciesController.text.trim() : scientificController.text.trim(),
                          image: selectedImage,
                          ageYears: double.tryParse(ageController.text) ?? 1.0,
                          heightCm: double.tryParse(heightController.text) ?? 30.0,
                          health: 'Ótima',
                          humidity: 50,
                          temperature: 23,
                          light: 65,
                          lastWatered: 'Hoje',
                          space: selectedSpace,
                          history: [
                            PlantHistory(type: 'Adição', date: 'Hoje', desc: 'Planta adicionada ao seu jardim.')
                          ],
                          measurements: [
                            PlantMeasurement(date: 'Hoje', height: double.tryParse(heightController.text) ?? 30.0)
                          ],
                          nextCare: 'Regar em 3 dias',
                        );
                        Provider.of<AppState>(context, listen: false).addPlant(newPlant);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.greenDark,
                            content: Text('${newPlant.name} adicionada ao seu jardim!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Text('Adicionar Planta'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    var filtered = state.plants;

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered.where((p) => p.name.toLowerCase().contains(q) || p.species.toLowerCase().contains(q)).toList();
    }

    if (_selectedFilter == 'healthy') {
      filtered = filtered.where((p) => !p.attention && p.health != 'Precisa de água').toList();
    } else if (_selectedFilter == 'water') {
      filtered = filtered.where((p) => p.humidity < 35 || p.health == 'Precisa de água').toList();
    } else if (_selectedFilter == 'light') {
      filtered = filtered.where((p) => p.light < 35).toList();
    } else if (_selectedFilter == 'attention') {
      filtered = filtered.where((p) => p.attention).toList();
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Minhas Plantas',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.greenDark),
                  ),
                  const Text(
                    'Gerencie sua coleção, registre cuidados e acompanhe a saúde de cada uma.',
                    style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 14),
                  // Search field
                  TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Buscar por nome ou espécie...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(999),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(999),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('all', 'Todas'),
                        const SizedBox(width: 8),
                        _buildFilterChip('healthy', 'Saudáveis'),
                        const SizedBox(width: 8),
                        _buildFilterChip('water', 'Precisam de água'),
                        const SizedBox(width: 8),
                        _buildFilterChip('light', 'Pouca luz'),
                        const SizedBox(width: 8),
                        _buildFilterChip('attention', 'Atenção'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          if (filtered.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.search_off, size: 54, color: AppColors.textLight),
                    const SizedBox(height: 12),
                    const Text('Nenhuma planta encontrada', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = 'all';
                          _searchQuery = '';
                          _searchController.clear();
                        });
                      },
                      child: const Text('Limpar filtros', style: TextStyle(color: AppColors.coralDark)),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final plant = filtered[index];
                    return _buildPlantCard(context, plant, state);
                  },
                  childCount: filtered.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.coralDark,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nova Planta', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => _showAddPlantDialog(context),
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _selectedFilter == key;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.greenDark,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.greenDark,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
      shape: const StadiumBorder(side: BorderSide(color: AppColors.border)),
      onSelected: (_) {
        setState(() {
          _selectedFilter = key;
        });
      },
    );
  }

  Widget _buildPlantCard(BuildContext context, Plant plant, AppState state) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlantDetailScreen(plantId: plant.id)),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  child: Image.asset(
                    plant.image,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      color: AppColors.greenLighter,
                      child: const Icon(Icons.eco, size: 48, color: AppColors.greenMedium),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.greenLight,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Em ${plant.space}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.greenDark),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: IconButton(
                      icon: Icon(
                        plant.favorite ? Icons.favorite : Icons.favorite_border,
                        color: plant.favorite ? AppColors.coralDark : AppColors.greenMedium,
                        size: 20,
                      ),
                      onPressed: () => state.toggleFavorite(plant.id),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          plant.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.greenDark),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: plant.attention ? const Color(0xFFFDE8E5) : AppColors.greenLight,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          plant.health,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: plant.attention ? AppColors.dangerInk : AppColors.greenDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(plant.species, style: const TextStyle(fontSize: 13.5, color: AppColors.textMuted)),
                  const SizedBox(height: 12),
                  // Stats row
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.greenLighter,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCol('Umidade', '${plant.humidity}%', Icons.water_drop, AppColors.info),
                        _buildStatCol('Temp', '${plant.temperature}°C', Icons.thermostat, AppColors.greenDark),
                        _buildStatCol('Luz', '${plant.light}%', Icons.wb_sunny, AppColors.warning),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Última rega: ${plant.lastWatered}',
                        style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PlantDetailScreen(plantId: plant.id)),
                          );
                        },
                        child: const Text('Ver detalhes →', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.greenMedium2)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCol(String label, String value, IconData icon, Color iconColor) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.greenDark)),
          ],
        ),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
      ],
    );
  }
}

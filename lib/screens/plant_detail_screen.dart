import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../models/plant.dart';

class PlantDetailScreen extends StatelessWidget {
  final String plantId;

  const PlantDetailScreen({super.key, required this.plantId});

  void _showAddMeasurementDialog(BuildContext context, Plant plant) {
    final heightController = TextEditingController(text: '${plant.heightCm}');
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Registrar Nova Medição', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.greenDark)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Altura atual (cm)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar', style: TextStyle(color: AppColors.textMuted))),
            ElevatedButton(
              onPressed: () {
                final h = double.tryParse(heightController.text) ?? plant.heightCm;
                Provider.of<AppState>(context, listen: false).addMeasurement(plant.id, h);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(backgroundColor: AppColors.greenDark, content: Text('Medição de ${h}cm salva com sucesso!')),
                );
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _showCareDialog(BuildContext context, Plant plant) {
    String selectedType = 'Regar';
    final types = ['Regar', 'Adubar', 'Podar', 'Pulverizar', 'Girar vaso', 'Limpar folhas'];
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              title: Text('Registrar cuidado - ${plant.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: InputDecoration(
                      labelText: 'Tipo de cuidado',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (val) {
                      if (val != null) setDialogState(() => selectedType = val);
                    },
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: noteController,
                    decoration: InputDecoration(
                      labelText: 'Observações (opcional)',
                      hintText: 'Ex: usei 150ml de água',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancelar', style: TextStyle(color: AppColors.textMuted)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<AppState>(context, listen: false).registerCare(plant.id, selectedType, notes: noteController.text);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(backgroundColor: AppColors.greenDark, content: Text('$selectedType registrado em ${plant.name}!')),
                    );
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final plant = state.plants.firstWhere(
      (p) => p.id == plantId,
      orElse: () => state.plants.first,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    plant.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: AppColors.greenMedium),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black54],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.greenLight,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Em ${plant.space}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.greenDark, fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          plant.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          plant.scientific,
                          style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(plant.favorite ? Icons.favorite : Icons.favorite_border, color: plant.favorite ? AppColors.coral : Colors.white),
                onPressed: () => state.toggleFavorite(plant.id),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white),
                onPressed: () {
                  state.deletePlant(plant.id);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Health and next care banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.greenLighter,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.greenLight),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Condição Geral', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                            const SizedBox(height: 4),
                            Text(plant.health, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                          ],
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.water_drop, size: 16),
                          label: const Text('Cuidar Agora'),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.coralDark),
                          onPressed: () => _showCareDialog(context, plant),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Environmental stats grid
                  const Text('Parâmetros Atuais', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildMetricTile('Umidade', '${plant.humidity}%', 'Ideal: 40-70%', Icons.water_drop, AppColors.info),
                      const SizedBox(width: 10),
                      _buildMetricTile('Temperatura', '${plant.temperature}°C', 'Ideal: 18-26°C', Icons.thermostat, AppColors.greenDark),
                      const SizedBox(width: 10),
                      _buildMetricTile('Luz Solar', '${plant.light}%', 'Ideal: 50-80%', Icons.wb_sunny, AppColors.warning),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Growth timeline / measurements
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Evolução de Crescimento', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                      TextButton.icon(
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Nova medição'),
                        onPressed: () => _showAddMeasurementDialog(context, plant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Altura atual: ${plant.heightCm} cm', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.greenDark)),
                              Text('Idade: ${plant.ageYears} anos', style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
                            ],
                          ),
                          const Divider(height: 24),
                          ...plant.measurements.reversed.map((m) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(m.date, style: const TextStyle(color: AppColors.textMuted)),
                                Text('${m.height} cm', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),

                  // Development history
                  const SizedBox(height: 24),
                  const Text('Histórico de Desenvolvimento', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                  const SizedBox(height: 12),
                  if (plant.history.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('Nenhum evento registrado ainda.', style: TextStyle(color: AppColors.textMuted)),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: plant.history.length,
                      itemBuilder: (context, idx) {
                        final h = plant.history[idx];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                margin: const EdgeInsets.only(top: 4, right: 12),
                                decoration: const BoxDecoration(
                                  color: AppColors.greenMedium,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(h.type, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                                        Text(h.date, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                      ],
                                    ),
                                    Text(h.desc, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String title, String value, String sub, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
            Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
            const SizedBox(height: 4),
            Text(sub, style: TextStyle(fontSize: 9.5, color: AppColors.textLight.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }
}

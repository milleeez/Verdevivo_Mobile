import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../models/plant.dart';
import 'plant_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                  const Text('Tipo de cuidado', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textMuted)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                    ),
                    items: types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (val) {
                      if (val != null) setDialogState(() => selectedType = val);
                    },
                  ),
                  const SizedBox(height: 14),
                  const Text('Observações (opcional)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textMuted)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: noteController,
                    decoration: InputDecoration(
                      hintText: 'Ex: Usei 200ml de água',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
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
                      SnackBar(
                        backgroundColor: AppColors.greenDark,
                        content: Text('$selectedType registrado em ${plant.name}!'),
                        behavior: SnackBarBehavior.floating,
                      ),
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
    final plants = state.plants;
    final attention = state.attentionPlants;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Banner (similar to original hero.jpg and float pills)
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.greenDark, AppColors.greenMedium2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.greenDark.withOpacity(0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.coralLight,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🌱 Seu assistente de jardinagem', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.coralInk)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Seu jardim mais saudável começa aqui.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Monitore suas plantas, receba cuidados personalizados e descubra exatamente o que seu jardim precisa.',
                  style: TextStyle(fontSize: 13.5, color: Color(0xFFDCEBE1), height: 1.4),
                ),
                const SizedBox(height: 18),
                // Floating climate metrics
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildHeroFloat(Icons.thermostat, '24°C', 'Ideal', AppColors.greenLight, AppColors.greenInk),
                      const SizedBox(width: 10),
                      _buildHeroFloat(Icons.water_drop, '65%', 'Úmido', const Color(0xFFE3F0FB), AppColors.infoInk),
                      const SizedBox(width: 10),
                      _buildHeroFloat(Icons.wb_sunny, '6h', 'Boa luz', const Color(0xFFFDF0DC), AppColors.warningInk),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Resumo do Jardim (Metrics)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Resumo do seu jardim',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.greenDark),
                ),
                Text(
                  '${plants.length} espécies',
                  style: const TextStyle(fontSize: 13, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: [
                _buildSummaryCard('Plantas no jardim', '${plants.length}', Icons.eco_outlined, AppColors.greenLight, AppColors.greenInk),
                _buildSummaryCard('Precisam de atenção', '${attention.length}', Icons.warning_amber_rounded, const Color(0xFFFDE8E5), AppColors.dangerInk),
                _buildSummaryCard('Tarefas hoje', '${state.tasks.where((t) => !t.done).length} pendentes', Icons.checklist_rounded, const Color(0xFFFDF0DC), AppColors.warningInk),
                _buildSummaryCard('Sequência ativa', '${state.streakDays} dias', Icons.local_fire_department, AppColors.coralLight, AppColors.coralInk),
              ],
            ),
          ),

          // Plantas que precisam de atenção
          if (attention.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Icon(Icons.crisis_alert, color: AppColors.dangerInk, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Plantas que precisam de atenção',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.greenDark),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: attention.length,
              itemBuilder: (context, index) {
                final plant = attention[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlantDetailScreen(plantId: plant.id)),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              plant.image,
                              width: 68,
                              height: 68,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 68,
                                height: 68,
                                color: AppColors.greenLighter,
                                child: const Icon(Icons.eco, color: AppColors.greenMedium),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plant.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.greenDark),
                                ),
                                Text(
                                  plant.species,
                                  style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFDE8E5),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    plant.health,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.dangerInk),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.greenDark,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            ),
                            onPressed: () => _showCareDialog(context, plant),
                            child: const Text('Cuidar', style: TextStyle(fontSize: 13)),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],

          // Outras plantas em monitoramento
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              'Em monitoramento contínuo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.greenDark),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: plants.length,
              itemBuilder: (context, index) {
                final plant = plants[index];
                return Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 12),
                  child: Card(
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
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                            child: Image.asset(
                              plant.image,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 100,
                                color: AppColors.greenLighter,
                                child: const Icon(Icons.eco, color: AppColors.greenMedium),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plant.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: AppColors.greenDark),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.water_drop, size: 13, color: AppColors.info),
                                    const SizedBox(width: 3),
                                    Text('${plant.humidity}%', style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
                                    const Spacer(),
                                    const Icon(Icons.wb_sunny, size: 13, color: AppColors.warning),
                                    const SizedBox(width: 3),
                                    Text('${plant.light}%', style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroFloat(IconData icon, String value, String label, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: textCol),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textCol)),
              Text(label, style: TextStyle(fontSize: 10.5, color: textCol.withOpacity(0.85))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value, IconData icon, Color iconBg, Color iconColor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: iconBg,
              child: Icon(icon, size: 18, color: iconColor),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                Text(label, style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

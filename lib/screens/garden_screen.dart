import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../widgets/page_guard.dart';
import 'plant_detail_screen.dart';

class GardenScreen extends StatelessWidget {
  const GardenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final spaces = state.gardenSpaces;
    final plants = state.plants;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Jardim'),
      ),
      body: PageGuard(
        title: 'Seu jardim fica na sua conta',
        message: 'Crie uma conta para organizar suas plantas por espaço e ver seus próximos cuidados.',
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Espaços do Jardim',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.greenDark),
              ),
              const Text(
                'Organize suas plantas por ambiente e acompanhe as condições de cada espaço.',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),
              ...spaces.entries.map((entry) {
                final spaceName = entry.key;
                final plantIds = entry.value;
                final spacePlants = plants.where((p) => plantIds.contains(p.id)).toList();

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.room_preferences, color: AppColors.greenMedium, size: 22),
                                const SizedBox(width: 8),
                                Text(spaceName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.greenLighter, borderRadius: BorderRadius.circular(999)),
                              child: Text('${spacePlants.length} plantas', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.greenInk)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (spacePlants.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text('Nenhuma planta alocada neste espaço ainda.', style: TextStyle(fontSize: 13, color: AppColors.textLight, fontStyle: FontStyle.italic)),
                          )
                        else
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: spacePlants.map((plant) {
                              return InkWell(
                                borderRadius: BorderRadius.circular(999),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => PlantDetailScreen(plantId: plant.id)),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: AppColors.border),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(999),
                                        child: Image.asset(
                                          plant.image,
                                          width: 22,
                                          height: 22,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => const Icon(Icons.eco, size: 16),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(plant.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.greenDark)),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import 'plant_detail_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditProfileDialog(BuildContext context) {
    final state = Provider.of<AppState>(context, listen: false);
    final nameController = TextEditingController(text: state.userName);
    final bioController = TextEditingController(text: state.userBio);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Editar Perfil', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.greenDark)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Seu nome',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: bioController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar', style: TextStyle(color: AppColors.textMuted))),
            ElevatedButton(
              onPressed: () {
                state.updateProfile(nameController.text.trim(), bioController.text.trim());
                Navigator.pop(ctx);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final achievements = state.getAchievements();
    final favs = state.favoritePlants;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Hero Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.greenDark, AppColors.greenMedium2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: AppColors.greenLight,
                        child: const Text('🌿', style: TextStyle(fontSize: 32)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.userName,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.userBio,
                              style: const TextStyle(fontSize: 12.5, color: Color(0xFFDCEBE1)),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_note, color: Colors.white),
                        onPressed: () => _showEditProfileDialog(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildProfileStat('${state.plants.length}', 'Plantas'),
                      _buildProfileStat('${state.posts.where((p) => p.userId == 'me').length}', 'Posts'),
                      _buildProfileStat('${favs.length}', 'Favoritas'),
                      _buildProfileStat('${state.streakDays}d', 'Sequência'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Plantas Favoritas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Plantas Favoritas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                Text('${favs.length} salvas', style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 10),
            if (favs.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('Toque no ícone de coração em qualquer planta para marcá-la como favorita.', style: TextStyle(color: AppColors.textMuted)),
              )
            else
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: favs.length,
                  itemBuilder: (context, idx) {
                    final plant = favs[idx];
                    return Container(
                      width: 120,
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
                                child: Image.asset(plant.image, height: 75, width: double.infinity, fit: BoxFit.cover),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(plant.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: AppColors.greenDark)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 24),

            // Conquistas / Achievements
            const Text('Minhas Conquistas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
            const SizedBox(height: 12),
            ...achievements.map((ach) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                color: ach.unlocked ? Colors.white : AppColors.offWhite,
                child: ListTile(
                  leading: Text(ach.icon, style: const TextStyle(fontSize: 26)),
                  title: Text(ach.title, style: TextStyle(fontWeight: FontWeight.bold, color: ach.unlocked ? AppColors.greenDark : AppColors.textLight)),
                  subtitle: Text(ach.desc, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: ach.unlocked ? AppColors.greenLight : const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      ach.unlocked ? 'Desbloqueada' : 'Bloqueada',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: ach.unlocked ? AppColors.successInk : AppColors.textLight,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: const TextStyle(fontSize: 11.5, color: Color(0xFFA9C4B0))),
      ],
    );
  }
}

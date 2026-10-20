import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../models/task.dart';

class RoutineScreen extends StatelessWidget {
  const RoutineScreen({super.key});

  void _showAddTaskDialog(BuildContext context) {
    String selectedType = 'Rega';
    final typeList = ['Rega', 'Pulverizar', 'Girar vaso', 'Verificar luz', 'Limpar folhas', 'Adubar', 'Podar'];
    final timeController = TextEditingController(text: '09:00');
    final descController = TextEditingController();
    String? selectedPlantId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        final plants = Provider.of<AppState>(context, listen: false).plants;
        if (selectedPlantId == null && plants.isNotEmpty) {
          selectedPlantId = plants.first.id;
        }

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Nova Tarefa de Rotina', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                      IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: InputDecoration(
                      labelText: 'Tipo de cuidado',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: typeList.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedType = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedPlantId,
                    decoration: InputDecoration(
                      labelText: 'Planta associada',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: plants.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedPlantId = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: timeController,
                    decoration: InputDecoration(
                      labelText: 'Horário previsto',
                      hintText: 'Ex: 10:30',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descController,
                    decoration: InputDecoration(
                      labelText: 'Instruções da tarefa',
                      hintText: 'Ex: verificar solo e umidade antes de regar',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.coralDark,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      final plant = plants.firstWhere((p) => p.id == selectedPlantId, orElse: () => plants.first);
                      final newTask = PlantTask(
                        id: 't_${DateTime.now().millisecondsSinceEpoch}',
                        type: selectedType,
                        plant: plant.name,
                        plantId: plant.id,
                        time: timeController.text.trim().isEmpty ? '09:00' : timeController.text.trim(),
                        desc: descController.text.trim().isEmpty ? 'Cuidado diário recomendado.' : descController.text.trim(),
                        due: 'Hoje',
                        done: false,
                      );
                      Provider.of<AppState>(context, listen: false).addTask(newTask);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(backgroundColor: AppColors.greenDark, content: Text('Tarefa adicionada à sua rotina!')),
                      );
                    },
                    child: const Text('Criar Tarefa'),
                  ),
                ],
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
    final tasks = state.tasks;
    final completed = state.completedTasksCount;
    final progress = tasks.isEmpty ? 0.0 : (completed / tasks.length);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rotina & Cuidados', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                    Text('Seu plano de cuidados para manter o verde vivo.', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.coralLight, borderRadius: BorderRadius.circular(999)),
                  child: Row(
                    children: [
                      const Icon(Icons.local_fire_department, size: 16, color: AppColors.coralDark),
                      const SizedBox(width: 4),
                      Text('${state.streakDays} dias', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.coralInk, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Weekly mini calendar
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDayPill('SEG', '19', true),
                  _buildDayPill('TER', '20', true, isToday: true),
                  _buildDayPill('QUA', '21', false),
                  _buildDayPill('QUI', '22', false),
                  _buildDayPill('SEX', '23', false),
                  _buildDayPill('SÁB', '24', false),
                  _buildDayPill('DOM', '25', false),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Progress card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$completed de ${tasks.length} concluídas hoje', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.greenDark, fontSize: 15)),
                        Text('${(progress * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.greenMedium, fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: AppColors.greenLighter,
                        color: AppColors.greenMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tasks header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tarefas de Hoje', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('+ Nova tarefa'),
                  onPressed: () => _showAddTaskDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Task list
            if (tasks.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text('Nenhuma tarefa pendente para hoje! 🎉', style: TextStyle(color: AppColors.textMuted)),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (context, idx) {
                  final task = tasks[idx];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: task.done ? AppColors.greenLighter : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(
                              task.done ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: task.done ? AppColors.successInk : AppColors.textLight,
                              size: 26,
                            ),
                            onPressed: () => state.toggleTask(task.id),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      task.type,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.greenDark,
                                        decoration: task.done ? TextDecoration.lineThrough : null,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: task.done ? AppColors.greenLight : AppColors.coralLight,
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        task.time,
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.bold,
                                          color: task.done ? AppColors.greenDark : AppColors.coralInk,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  task.plant,
                                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.greenMedium),
                                ),
                                const SizedBox(height: 4),
                                Text(task.desc, style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.textLight),
                            onPressed: () => state.removeTask(task.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.greenDark,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_task),
        onPressed: () => _showAddTaskDialog(context),
      ),
    );
  }

  Widget _buildDayPill(String day, String num, bool done, {bool isToday = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isToday ? AppColors.greenDark : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isToday ? null : Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(day, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isToday ? Colors.white70 : AppColors.textMuted)),
          const SizedBox(height: 4),
          Text(num, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isToday ? Colors.white : AppColors.greenDark)),
          const SizedBox(height: 4),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: done ? AppColors.success : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

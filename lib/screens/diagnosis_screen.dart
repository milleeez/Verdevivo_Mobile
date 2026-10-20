import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../models/diagnosis_result.dart';
import '../widgets/page_guard.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> with SingleTickerProviderStateMixin {
  bool _isAnalyzing = false;
  DiagnosisResult? _result;
  late AnimationController _laserController;

  @override
  void initState() {
    super.initState();
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _laserController.dispose();
    super.dispose();
  }

  void _runAnalysis() {
    setState(() {
      _isAnalyzing = true;
    });

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _result = DiagnosisResult.sampleCalathea();
        });
        Provider.of<AppState>(context, listen: false).addNotification('Diagnóstico botânico pronto!', 'sparkles', 'green');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageGuard(
        title: 'O diagnóstico fica na sua conta',
        message: 'Crie uma conta para analisar fotos das suas plantas e salvar planos de recuperação.',
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Diagnóstico por IA',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.greenDark),
              ),
              const Text(
                'Fotografe as folhas para identificar doenças, pragas ou carências nutricionais.',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
              const SizedBox(height: 18),

              // Camera / Viewfinder Box
              if (_result == null && !_isAnalyzing)
                Container(
                  height: 320,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C1710),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 14, offset: const Offset(0, 6)),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          'assets/images/calathea.jpg',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      // Viewfinder corners
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _cornerBorder(top: true, left: true),
                                  _cornerBorder(top: true, left: false),
                                ],
                              ),
                              // Laser scan animation
                              AnimatedBuilder(
                                animation: _laserController,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, (_laserController.value - 0.5) * 160),
                                    child: Container(
                                      height: 2.5,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(colors: [Colors.transparent, AppColors.success, Colors.transparent]),
                                        boxShadow: [
                                          BoxShadow(color: AppColors.success.withOpacity(0.8), blurRadius: 8),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _cornerBorder(top: false, left: true),
                                  _cornerBorder(top: false, left: false),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.center_focus_strong, size: 54, color: Colors.white70),
                          const SizedBox(height: 12),
                          const Text('Enquadre a folha na mira', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 18),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Analisar Folha Agora'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.coralDark,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            ),
                            onPressed: _runAnalysis,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              else if (_isAnalyzing)
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: AppColors.greenMedium),
                      SizedBox(height: 20),
                      Text('Analisando morfologia da planta...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.greenDark)),
                      SizedBox(height: 6),
                      Text('Cruzando com banco botânico e histórico climático', style: TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
                    ],
                  ),
                )
              else ...[
                // Results Display
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                            child: Image.asset(
                              _result!.photo,
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Visual markers
                          Positioned(
                            top: 40,
                            left: 70,
                            child: _markerPin('Possível queimadura', isBad: true),
                          ),
                          Positioned(
                            bottom: 40,
                            right: 80,
                            child: _markerPin('Folha saudável', isBad: false),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(color: Colors.black74, borderRadius: BorderRadius.circular(999)),
                              child: Row(
                                children: [
                                  const Icon(Icons.verified, size: 14, color: AppColors.success),
                                  const SizedBox(width: 4),
                                  Text('${_result!.confidence}% de precisão', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_result!.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(color: const Color(0xFFFDF0DC), borderRadius: BorderRadius.circular(999)),
                                  child: Text('Recuperação: ${_result!.recoveryDays}d', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.warningInk)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            const Text('Problemas Identificados:', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                            const SizedBox(height: 8),
                            ..._result!.problems.map((prob) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                children: [
                                  const Icon(Icons.warning_amber_rounded, size: 18, color: AppColors.dangerInk),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(prob, style: const TextStyle(fontSize: 13, color: AppColors.text))),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Recovery Plan
                const Text('Plano de Recuperação Passo a Passo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                const SizedBox(height: 12),
                ..._result!.recoveryPlan.map((step) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: AppColors.greenLight,
                            child: Text('${step.num}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(step.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.greenDark, fontSize: 14.5)),
                                const SizedBox(height: 3),
                                Text(step.desc, style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                          Checkbox(
                            value: step.done,
                            activeColor: AppColors.greenMedium,
                            onChanged: (val) {
                              setState(() {
                                step.done = val ?? false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Realizar Novo Diagnóstico'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenDark,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    setState(() {
                      _result = null;
                    });
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _cornerBorder({required bool top, required bool left}) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border(
          top: top ? const BorderSide(color: AppColors.success, width: 3.5) : BorderSide.none,
          bottom: !top ? const BorderSide(color: AppColors.success, width: 3.5) : BorderSide.none,
          left: left ? const BorderSide(color: AppColors.success, width: 3.5) : BorderSide.none,
          right: !left ? const BorderSide(color: AppColors.success, width: 3.5) : BorderSide.none,
        ),
      ),
    );
  }

  Widget _markerPin(String title, {required bool isBad}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isBad ? AppColors.danger : AppColors.success,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isBad ? Icons.close : Icons.check, size: 13, color: Colors.white),
          const SizedBox(width: 4),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

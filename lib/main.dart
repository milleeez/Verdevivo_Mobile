import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/app_state.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: const FloraeeApp(),
    ),
  );
}

class FloraeeApp extends StatelessWidget {
  const FloraeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VerdeVivo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigationScreen(),
    );
  }
}

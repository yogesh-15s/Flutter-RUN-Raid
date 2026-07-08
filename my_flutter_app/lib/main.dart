import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/run_tracker/presentation/run_state_controller.dart';
import 'features/run_tracker/presentation/run_screen.dart';
import 'features/run_tracker/data/background_tracker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the Background execution config
  await BackgroundTracker.initializeService();

  runApp(
    ChangeNotifierProvider(
      create: (_) => RunStateController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Territory Run Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const RunScreen(),
    );
  }
}

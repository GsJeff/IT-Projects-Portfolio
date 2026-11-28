import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'onboarding_pages.dart';
import 'services/accessibility_provider.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load the environment file from the project root for mobile compatibility
  await dotenv.load(fileName: 'assets/config.env');

  runApp(
    ChangeNotifierProvider(
      create: (context) => AccessibilityProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AccessibilityProvider>(
      builder: (context, accessibility, child) {
        return MaterialApp(
          title: 'DocuSense',
          theme: accessibility.theme,
          darkTheme: accessibility.theme,
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home: const OnboardingFlow(),
        );
      },
    );
  }
}
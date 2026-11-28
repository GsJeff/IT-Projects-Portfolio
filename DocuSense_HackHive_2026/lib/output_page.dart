import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/accessibility_provider.dart';
import 'settings_page.dart';

class Output extends StatelessWidget {
  final String simplifiedText;
  final String category;

  const Output({
    super.key,
    required this.simplifiedText,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    // Access the accessibility settings
    final accel = context.watch<AccessibilityProvider>();

    return Scaffold(
      // Background color adapts to Dark Mode
      backgroundColor: accel.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          '$category Result',
          style: TextStyle(
            fontSize: 20 * accel.fontSizeMultiplier,
            letterSpacing: accel.letterSpacing,
            fontFamily: accel.isDyslexicFont ? accel.dyslexicFontType : null,
            fontWeight: accel.isHighContrast ? FontWeight.bold : null,
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          Row(
            children: [
              const Text('Accessibility Settings'),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      
      body: SafeArea(
        child: SingleChildScrollView(
          // SingleChildScrollView ensures no overflow when font size is huge
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                simplifiedText,
                style: TextStyle(
                  // Accessibility settings applied here
                  fontSize: 18 * accel.fontSizeMultiplier,
                  letterSpacing: accel.letterSpacing,
                  fontFamily: accel.isDyslexicFont ? accel.dyslexicFontType : null,
                  color: accel.isDarkMode ? Colors.white : Colors.black87,
                  height: 1.6,
                  fontWeight: accel.isHighContrast ? FontWeight.bold : null,
                ),
              ),
              const SizedBox(height: 40),
              // Return Home Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  child: Text(
                    "Back to Home",
                    style: TextStyle(
                      fontSize: 16 * accel.fontSizeMultiplier,
                      letterSpacing: accel.letterSpacing,
                      fontFamily: accel.isDyslexicFont ? accel.dyslexicFontType : null,
                      fontWeight: accel.isHighContrast ? FontWeight.bold : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
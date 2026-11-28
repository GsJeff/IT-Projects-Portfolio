import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/accessibility_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accel = context.watch<AccessibilityProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility Settings'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Font Size Multiplier Slider
          Text(
            'Font Size',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Slider(
            value: accel.fontSizeMultiplier,
            min: 0.5,
            max: 2.5,
            divisions: 20,
            label: '${(accel.fontSizeMultiplier * 100).toStringAsFixed(0)}%',
            onChanged: (value) {
              accel.setFontSize(value);
            },
          ),
          const SizedBox(height: 24),

          // Dark Mode Toggle
          Text(
            'Dark Mode',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SwitchListTile(
            value: accel.isDarkMode,
            onChanged: (_) {
              accel.toggleDarkMode();
            },
            title: Text(
              accel.isDarkMode ? 'Enabled' : 'Disabled',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 24),

          // High Contrast Toggle
          Text(
            'High Contrast',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SwitchListTile(
            value: accel.isHighContrast,
            onChanged: (_) {
              accel.toggleHighContrast();
            },
            title: Text(
              accel.isHighContrast ? 'Enabled' : 'Disabled',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 24),

          // Dyslexic Font Toggle
          Text(
            'Dyslexic Font',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SwitchListTile(
            value: accel.isDyslexicFont,
            onChanged: (_) {
              accel.toggleDyslexicFont();
            },
            title: Text(
              accel.isDyslexicFont ? 'Enabled' : 'Disabled',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          if (accel.isDyslexicFont)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Font:',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: accel.dyslexicFontType,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        accel.setDyslexicFontType(newValue);
                      }
                    },
                    items: ['Lexend', 'OpenDyslexic']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),

          // Letter Spacing Slider
          Text(
            'Letter Spacing',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Slider(
            value: accel.letterSpacing,
            min: 0.0,
            max: 5.0,
            divisions: 50,
            label: accel.letterSpacing.toStringAsFixed(1),
            onChanged: (value) {
              accel.setLetterSpacing(value);
            },
          ),
        ],
      ),
    );
  }
}

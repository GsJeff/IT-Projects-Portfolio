import 'package:flutter/material.dart';
import 'package:hackhive2026/category_input_page.dart';
import 'package:provider/provider.dart';

import 'services/accessibility_provider.dart';
import 'services/text_reader.dart';
import 'settings_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _disclaimerShown = false;

  @override
  void initState() {
    super.initState();
    // Show disclaimer on first entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_disclaimerShown) {
        _showDisclaimerDialog();
        _disclaimerShown = true;
      }
    });
  }

  void _showDisclaimerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return const DisclaimerDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final accel = context.watch<AccessibilityProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('DocuSense'),
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
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CategoryInputPage(
                                categoryTitle: 'Medical',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Medical',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CategoryInputPage(
                                categoryTitle: 'Financial',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Financial',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CategoryInputPage(
                                categoryTitle: 'Legal',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Legal',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'ACCESSIBILITY SETTINGS APPLIED',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              letterSpacing: accel.letterSpacing,
              fontFamily: accel.isDyslexicFont ? accel.dyslexicFontType : null,
            ),
          ),
        ),
      ),
    );
  }
}

class DisclaimerDialog extends StatefulWidget {
  const DisclaimerDialog({super.key});

  @override
  State<DisclaimerDialog> createState() => _DisclaimerDialogState();
}

class _DisclaimerDialogState extends State<DisclaimerDialog> {
  Map<String, String> files = {};

  String get disclaimerSummary => files['summary'] ?? 'Loading disclaimer...';
  String get disclaimerFull => files['full'] ?? 'Loading full disclosure...';

  bool fullDisclosureShown = false;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    try {
      final loadedFiles = await TextReader.loadAssets({
        'summary': 'assets/legal/DisclaimerSummary.txt',
        'full': 'assets/legal/FullDisclosure.txt',
      });
      setState(() {
        files = loadedFiles;
      });
    } catch (e) {
      setState(() {
        files = {
          'summary': 'Error loading disclaimer',
          'full': 'Error loading full disclosure: $e',
        };
      });
    }
  }

  void _updateDisclaimer() {
    setState(() {
      fullDisclosureShown = !fullDisclosureShown;
    });
  }

  @override
  Widget build(BuildContext context) {
    final accel = context.watch<AccessibilityProvider>();
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      title: Text(
        'Disclaimer',
        style: TextStyle(
          fontSize: 20 * accel.fontSizeMultiplier,
          letterSpacing: accel.letterSpacing,
          fontFamily: accel.isDyslexicFont ? accel.dyslexicFontType : null,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: SingleChildScrollView(
          child: Text(
            fullDisclosureShown ? disclaimerFull : disclaimerSummary,
            style: TextStyle(
              fontSize: 16 * accel.fontSizeMultiplier,
              letterSpacing: accel.letterSpacing,
              fontFamily: accel.isDyslexicFont ? accel.dyslexicFontType : null,
            ),
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: _updateDisclaimer,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            'Full Legal Disclosure',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            'I Understand',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}

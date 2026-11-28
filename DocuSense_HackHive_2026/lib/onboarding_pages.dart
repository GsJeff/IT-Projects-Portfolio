import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/accessibility_provider.dart';
import 'home_page.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accessibility Onboarding', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          FontSizeScreen(
            onNext: _nextPage,
            onBack: null,
            isFirst: true,
          ),
          DyslexicFontScreen(
            onNext: _nextPage,
            onBack: _previousPage,
          ),
          HighContrastScreen(
            onNext: _nextPage,
            onBack: _previousPage,
          ),
          TextSpacingScreen(
            onNext: _nextPage,
            onBack: _previousPage,
          ),
          DarkModeScreen(
            onNext: _nextPage,
            onBack: _previousPage,
          ),
          SummaryScreen(
            onConfirm: _finishOnboarding,
            onBack: _previousPage,
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < 5) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }
}

class FontSizeScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final bool isFirst;

  const FontSizeScreen({
    super.key,
    required this.onNext,
    this.onBack,
    this.isFirst = false,
  });

  @override
  State<FontSizeScreen> createState() => _FontSizeScreenState();
}

class _FontSizeScreenState extends State<FontSizeScreen> {
  double _fontSize = 1.0;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AccessibilityProvider>(context, listen: false);
    _fontSize = provider.fontSizeMultiplier;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Font Size',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Text(
            'Adjust the font size to make text easier to read.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 40),
          Container(
            height: 50, // Fixed height to prevent layout shift
            alignment: Alignment.center,
            child: Text(
              'Sample Text',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: (Theme.of(context).textTheme.bodyLarge?.fontSize ?? 14) * _fontSize,
              ) ?? TextStyle(fontSize: 16 * _fontSize),
            ),
          ),
          SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              double sliderWidth = constraints.maxWidth;
              double defaultPosition = (1.0 - 0.5) / (2.0 - 0.5) * sliderWidth;
              return Stack(
                alignment: Alignment.center,
                children: [
                  Slider(
                    value: _fontSize,
                    min: 0.5,
                    max: 2.0,
                    divisions: 15,
                    activeColor: Colors.blue,
                    onChanged: (value) {
                      setState(() {
                        _fontSize = value;
                      });
                    },
                  ),
                  Positioned(
                    left: defaultPosition - 1, // Center the line
                    bottom: -10,
                    child: Container(
                      width: 2,
                      height: 10,
                      color: Colors.blue,
                    ),
                  ),
                ],
              );
            },
          ),
          Text('Font Size: ${(_fontSize * 100).round()}%'),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!widget.isFirst)
                ElevatedButton(
                  onPressed: widget.onBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text('Back', style: Theme.of(context).textTheme.labelLarge),
                ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<AccessibilityProvider>(context, listen: false)
                      .setFontSize(_fontSize);
                  widget.onNext();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text('Next', style: Theme.of(context).textTheme.labelLarge),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DyslexicFontScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;

  const DyslexicFontScreen({
    super.key,
    required this.onNext,
    this.onBack,
  });

  @override
  State<DyslexicFontScreen> createState() => _DyslexicFontScreenState();
}

class _DyslexicFontScreenState extends State<DyslexicFontScreen> {
  bool _isEnabled = false;
  String _selectedFont = 'Lexend';

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AccessibilityProvider>(context, listen: false);
    _isEnabled = provider.isDyslexicFont;
    _selectedFont = provider.dyslexicFontType;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Dyslexic Font',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Text(
            'Enable a dyslexia-friendly font for improved readability.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 40),
          Switch(
            value: _isEnabled,
            onChanged: (value) {
              setState(() {
                _isEnabled = value;
              });
            },
            activeThumbColor: Colors.blue,
            inactiveThumbColor: Colors.orange,
          ),
          Text(_isEnabled ? 'Enabled' : 'Disabled',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 30),
          if (_isEnabled)
            Column(
              children: [
                Text(
                  'Choose Font:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                DropdownButton<String>(
                  value: _selectedFont,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedFont = newValue;
                      });
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
                const SizedBox(height: 20),
                Text(
                  'Sample Text',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontFamily: _selectedFont,
                      ) ??
                      TextStyle(fontFamily: _selectedFont, fontSize: 16),
                ),
              ],
            ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: widget.onBack,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: Text('Back', style: Theme.of(context).textTheme.labelLarge),
              ),
              ElevatedButton(
                onPressed: () {
                  final provider = Provider.of<AccessibilityProvider>(context, listen: false);
                  provider.setIsDyslexicFont(_isEnabled);
                  if (_isEnabled) {
                    provider.setDyslexicFontType(_selectedFont);
                  }
                  widget.onNext();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text('Next', style: Theme.of(context).textTheme.labelLarge),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HighContrastScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;

  const HighContrastScreen({
    super.key,
    required this.onNext,
    this.onBack,
  });

  @override
  State<HighContrastScreen> createState() => _HighContrastScreenState();
}

class _HighContrastScreenState extends State<HighContrastScreen> {
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AccessibilityProvider>(context, listen: false);
    _isEnabled = provider.isHighContrast;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'High Contrast',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Text(
            'Enable high contrast mode for better visibility.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
            color: _isEnabled ? Colors.black : Colors.white,
            child: Text(
              'Sample Text',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _isEnabled ? Colors.white : Colors.black,
                  ) ??
                  TextStyle(
                    color: _isEnabled ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
            ),
          ),
          const SizedBox(height: 20),
          Switch(
            value: _isEnabled,
            onChanged: (value) {
              setState(() {
                _isEnabled = value;
              });
            },
            activeThumbColor: Colors.blue,
            inactiveThumbColor: Colors.orange,
          ),
          Text(_isEnabled ? 'Enabled' : 'Disabled',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: widget.onBack,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: Text('Back', style: Theme.of(context).textTheme.labelLarge),
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<AccessibilityProvider>(context, listen: false)
                      .setIsHighContrast(_isEnabled);
                  widget.onNext();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text('Next', style: Theme.of(context).textTheme.labelLarge),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TextSpacingScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;

  const TextSpacingScreen({
    super.key,
    required this.onNext,
    this.onBack,
  });

  @override
  State<TextSpacingScreen> createState() => _TextSpacingScreenState();
}

class _TextSpacingScreenState extends State<TextSpacingScreen> {
  double _spacing = 0.0;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AccessibilityProvider>(context, listen: false);
    _spacing = provider.letterSpacing;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Text Spacing',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Text(
            'Adjust letter spacing to improve readability.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 40),
          Text(
            'Sample Text',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  letterSpacing: _spacing,
                ) ??
                TextStyle(letterSpacing: _spacing, fontSize: 16),
          ),
          const SizedBox(height: 20),
          Slider(
            value: _spacing,
            min: 0.0,
            max: 2.0,
            divisions: 20,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                _spacing = value;
              });
            },
          ),
          Text('Spacing: ${_spacing.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: widget.onBack,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: Text('Back', style: Theme.of(context).textTheme.labelLarge),
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<AccessibilityProvider>(context, listen: false)
                      .setLetterSpacing(_spacing);
                  widget.onNext();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text('Next', style: Theme.of(context).textTheme.labelLarge),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DarkModeScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;

  const DarkModeScreen({
    super.key,
    required this.onNext,
    this.onBack,
  });

  @override
  State<DarkModeScreen> createState() => _DarkModeScreenState();
}

class _DarkModeScreenState extends State<DarkModeScreen> {
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AccessibilityProvider>(context, listen: false);
    _isEnabled = provider.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Dark Mode',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Text(
            'Enable dark mode for reduced eye strain.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
            color: _isEnabled ? Colors.black : Colors.white,
            child: Text(
              'Sample Text',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _isEnabled ? Colors.white : Colors.black,
                  ) ??
                  TextStyle(
                    color: _isEnabled ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
            ),
          ),
          const SizedBox(height: 20),
          Switch(
            value: _isEnabled,
            onChanged: (value) {
              setState(() {
                _isEnabled = value;
              });
            },
            activeThumbColor: Colors.blue,
            inactiveThumbColor: Colors.orange,
          ),
          Text(_isEnabled ? 'Enabled' : 'Disabled',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: widget.onBack,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: Text('Back', style: Theme.of(context).textTheme.labelLarge),
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<AccessibilityProvider>(context, listen: false)
                      .toggleDarkMode();
                  widget.onNext();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text('Next', style: Theme.of(context).textTheme.labelLarge),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SummaryScreen extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback? onBack;

  const SummaryScreen({
    super.key,
    required this.onConfirm,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AccessibilityProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Summary',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Text(
            'Review your accessibility settings:',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 40),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('Font Size',
                      style: Theme.of(context).textTheme.bodyLarge),
                  subtitle: Text(
                    '${(provider.fontSizeMultiplier * 100).round()}%',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ListTile(
                  title: Text('Dyslexic Font',
                      style: Theme.of(context).textTheme.bodyLarge),
                  subtitle: Text(
                    provider.isDyslexicFont ? 'Enabled' : 'Disabled',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ListTile(
                  title: Text('High Contrast',
                      style: Theme.of(context).textTheme.bodyLarge),
                  subtitle: Text(
                    provider.isHighContrast ? 'Enabled' : 'Disabled',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ListTile(
                  title: Text('Text Spacing',
                      style: Theme.of(context).textTheme.bodyLarge),
                  subtitle: Text(
                    provider.letterSpacing.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ListTile(
                  title: Text('Dark Mode',
                      style: Theme.of(context).textTheme.bodyLarge),
                  subtitle: Text(
                    provider.isDarkMode ? 'Enabled' : 'Disabled',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: onBack,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: Text('Back', style: Theme.of(context).textTheme.labelLarge),
              ),
              ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text('Done', style: Theme.of(context).textTheme.labelLarge),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
# HackHive2026 - DocuSense

**DocuSense** is an AI-powered document simplification mobile application that uses Google's Generative AI to translate complex documents into accessible, easy-to-understand text. Whether you're dealing with medical forms, financial statements, or legal documents, DocuSense breaks down jargon and simplifies content for better comprehension.

## What It Does

DocuSense simplifies complex documents across three major categories:

- **Medical Documents**: Simplifies medical forms, prescriptions, and health-related terminology
- **Financial Documents**: Clarifies financial statements, contracts, and monetary concepts
- **Legal Documents**: Breaks down legal language and contracts into plain English

Users can input text directly or upload PDF files. The app then uses Google Generative AI (Gemini) to simplify and summarize the content based on the user's country/region context (for jurisdiction-specific explanations).

## Who It's Useful For

- **People with language barriers**: Non-native speakers or those unfamiliar with technical jargon
- **Users with dyslexia or reading difficulties**: Built-in OpenDyslexic and Lexend font support
- **Elderly users**: Adjustable font sizes and high-contrast modes for better readability
- **People with accessibility needs**: Comprehensive accessibility features including dark mode, letter spacing adjustment, and customizable text styling
- **General public**: Anyone seeking clearer, more concise explanations of complex documents

## Key Features

### Document Processing
- **Text Input**: Paste or type document text directly
- **PDF Upload**: Extract text from PDF files automatically
- **AI Simplification**: Uses Google Generative AI (Gemini) to simplify and summarize content
- **Country Context**: Select your country for jurisdiction-specific explanations

### Comprehensive Accessibility Suite
- **Font Size Multiplier**: Adjust text size from 50% to 250%
- **Dyslexic-Friendly Fonts**: Choose between OpenDyslexic or Lexend fonts
- **Letter Spacing**: Customize letter spacing for improved readability
- **Dark Mode**: Reduce eye strain with a dark theme
- **High Contrast Mode**: Enhanced visibility with high-contrast colors and bold text
- **Onboarding Flow**: Interactive setup wizard to configure accessibility preferences

### User Experience
- **Multi-step Onboarding**: Helps users configure accessibility settings on first launch
- **Settings Screen**: Modify accessibility preferences at any time
- **Disclaimer Dialog**: Clear legal disclaimers with full disclosure option
- **Responsive Design**: Works across Android, iOS, and web platforms

## APIs & Dependencies

### Core Dependencies
- **Flutter**: Cross-platform mobile framework
- **Provider**: State management for accessibility settings and app data
- **SharedPreferences**: Local persistence of user preferences

### AI & Content Processing
- **Google Generative AI (Gemini)**: `google_generative_ai: ^0.4.0`
  - Powers the document simplification engine
  - Provides context-aware summaries and plain-language translations
- **Syncfusion PDF**: `syncfusion_flutter_pdf: ^21.1.35`
  - Extracts text from PDF files

### UI & UX
- **Google Fonts**: `google_fonts: ^6.2.1` (for web and optional font support)
- **Custom Fonts**: OpenDyslexic and Lexend fonts embedded in assets
- **Country Picker**: `country_picker: ^2.0.27` (for jurisdiction selection)
- **File Picker**: `file_picker: ^8.0.0` (for PDF file selection)

### Configuration
- **Flutter DotEnv**: `flutter_dotenv: ^6.0.0` (for managing API keys and environment variables)

## Getting Started

### Prerequisites
- Flutter SDK (3.10.7 or higher)
- Dart SDK
- A Google Generative AI API key ([get one here](https://ai.google.dev))

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd HackHive2026
   ```

2. **Set up environment variables**
   - Create a `.env` file in the project root **and** under `assets/`
   - Add your [Google Generative AI API key](https://aistudio.google.com/app/u/1/api-keys?): 
     ```
     API_KEY=your_api_key_here
     ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

### Running the App

**On Android/iOS emulator:**
```bash
flutter run
```

**On a specific device:**
```bash
flutter run -d <device_id>
```

**List available devices:**
```bash
flutter devices
```

**Run in release mode:**
```bash
flutter run --release
```

### Building for Release

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

## Project Structure

```
lib/
├── main.dart                     # App entry point
├── home_screen.dart              # Category selection & disclaimer
├── CategoryInputPage.dart        # Document input (text/PDF)
├── output_screen.dart            # Simplified document display
├── settings_screen.dart          # Accessibility preferences
├── onboarding_flow.dart          # Initial accessibility setup
├── accessibility_provider.dart   # State management for accessibility
└── services/
    ├── ai_service.dart           # Google Generative AI integration
    └── text_reader.dart          # Asset file loading
```

## Architecture

The app uses **Provider** for reactive state management:
- **AccessibilityProvider**: Manages all accessibility settings and generates dynamic themes based on user preferences
- **AIService**: Handles communication with Google Generative AI API
- **TextReader**: Loads legal disclaimer files from assets

All UI updates are reactive—when accessibility settings change, the theme updates automatically and all widgets rebuild with new styles.

## License

This project is proprietary software. Unauthorized copying or distribution is prohibited.

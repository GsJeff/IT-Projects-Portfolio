import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'services/accessibility_provider.dart';
import 'services/ai_service.dart';
import 'output_page.dart';

class CategoryInputPage extends StatefulWidget {
  final String categoryTitle; // "Medical", "Legal", "Financial"

  const CategoryInputPage({super.key, required this.categoryTitle});

  @override
  State<CategoryInputPage> createState() => _CategoryInputPageState();
}

class _CategoryInputPageState extends State<CategoryInputPage> {
  final TextEditingController _textController = TextEditingController();
  String _selectedCountry = "Select Country";
  bool _isLoading = false;

  // --- PDF EXTRACTION LOGIC ---
  Future<void> _pickAndExtractPDF() async {
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['pdf'],
    // );

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true, // Set to true to avoid 'path' issues on Web/Android 13+
    );

    if (result != null && result.files.single.path != null) {
      setState(() => _isLoading = true);
      try {
        final File file = File(result.files.single.path!);
        final PdfDocument document = PdfDocument(
          inputBytes: await file.readAsBytes(),
        );

        // Extracting all text from the PDF
        String extractedText = PdfTextExtractor(document).extractText();
        document.dispose();

        setState(() {
          _textController.text = extractedText;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("PDF text extracted successfully!")),
        );
      } catch (e) {
        setState(() => _isLoading = false);
        debugPrint("PDF Error: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to extract PDF: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accel = context.watch<AccessibilityProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.categoryTitle} Simplifier",
          style: TextStyle(
            fontSize: 20 * accel.fontSizeMultiplier,
            letterSpacing: accel.letterSpacing,
            fontFamily: accel.isDyslexicFont ? accel.dyslexicFontType : null,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. COUNTRY SELECTION
              ListTile(
                title: Text(
                  _selectedCountry,
                  style: TextStyle(
                    fontSize: 16 * accel.fontSizeMultiplier,
                    letterSpacing: accel.letterSpacing,
                    fontFamily: accel.isDyslexicFont
                        ? accel.dyslexicFontType
                        : null,
                  ),
                ),
                trailing: const Icon(Icons.public),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showSearch: true,
                    onSelect: (Country country) {
                      setState(() => _selectedCountry = country.name);
                    },
                  );
                },
              ),
              const SizedBox(height: 20),

              // 2. TEXT INPUT AREA
              TextField(
                controller: _textController,
                maxLines: 10,
                style: TextStyle(
                  fontSize: 16 * accel.fontSizeMultiplier,
                  letterSpacing: accel.letterSpacing,
                  fontFamily: accel.isDyslexicFont
                      ? accel.dyslexicFontType
                      : null,
                ),
                decoration: InputDecoration(
                  hintText: "Paste your document text here...",
                  border: const OutlineInputBorder(),
                  labelText: "Document Text",
                  alignLabelWithHint: true,
                  labelStyle: TextStyle(
                    fontSize: 14 * accel.fontSizeMultiplier,
                    letterSpacing: accel.letterSpacing,
                    fontFamily: accel.isDyslexicFont
                        ? accel.dyslexicFontType
                        : null,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _textController.clear(),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // 3. UPLOAD PDF BUTTON
              OutlinedButton.icon(
                onPressed: _isLoading ? null : _pickAndExtractPDF,
                icon: const Icon(Icons.upload_file),
                label: Text(
                  "Upload PDF instead",
                  style: TextStyle(
                    fontSize: 14 * accel.fontSizeMultiplier,
                    letterSpacing: accel.letterSpacing,
                    fontFamily: accel.isDyslexicFont
                        ? accel.dyslexicFontType
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 4. SUBMIT BUTTON
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (_textController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please enter text or upload a PDF",
                              ),
                            ),
                          );
                          return;
                        }

                        setState(() => _isLoading = true);

                        try {
                          // Calling AI Service
                          final response = await AIService.simplifyText(
                            category: widget.categoryTitle,
                            country: _selectedCountry,
                            inputText: _textController.text,
                          );

                          if (mounted) {
                            // Successfully connecting to the Output screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Output(
                                  simplifiedText: response,
                                  category: widget.categoryTitle,
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("AI Error: $e")),
                          );
                        } finally {
                          if (mounted) setState(() => _isLoading = false);
                        }
                      },
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "Simplify & Summarize",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

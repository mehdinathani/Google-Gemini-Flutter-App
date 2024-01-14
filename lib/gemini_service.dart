import 'dart:io';

import 'package:geminiadvance/main.dart';
import 'package:google_gemini/google_gemini.dart';

class GeminiService {
  List<Map<String, dynamic>> chatMessages = [];
  File? imageFile;

  // Create Gemini Instance
  final gemini = GoogleGemini(apiKey: apiKey);

  // Text only input
  Future<void> fromText({required String query}) async {
    DateTime now = DateTime.now();
    String timestamp = "${now.hour}:${now.minute}";

    Map<String, dynamic> userMessage = {
      "role": "User",
      "text": query,
      "timestamp": timestamp,
      "image": null, // No image for text-only messages
    };

    chatMessages.add(userMessage);

    try {
      var value = await gemini.generateFromText(query);
      Map<String, dynamic> geminiMessage = {
        "role": "Gemini",
        "text": value.text,
        "timestamp": timestamp,
        "image": null, // No image for generated text
      };
      chatMessages.add(geminiMessage);
    } catch (error, stackTrace) {
      Map<String, dynamic> geminiErrorMessage = {
        "role": "Gemini",
        "text": error.toString(),
        "timestamp": timestamp,
        "image": null, // No image for error messages
      };
      chatMessages.add(geminiErrorMessage);
    }
  }

  // Text and Image input
  Future<void> fromTextAndImage(
      {required String query, required File image}) async {
    Map<String, dynamic> userMessage = {
      "role": "User",
      "text": query,
      "image": image, // Image for messages with both text and image
    };

    chatMessages.add(userMessage);
    imageFile = null;

    try {
      var value =
          await gemini.generateFromTextAndImages(query: query, image: image);
      Map<String, dynamic> geminiMessage = {
        "role": "Gemini",
        "text": value.text,
        "image": null, // No image for generated text
      };
      chatMessages.add(geminiMessage);
    } catch (error, stackTrace) {
      Map<String, dynamic> geminiErrorMessage = {
        "role": "Gemini",
        "text": error.toString(),
        "image": null, // No image for error messages
      };
      chatMessages.add(geminiErrorMessage);
    }
  }
}

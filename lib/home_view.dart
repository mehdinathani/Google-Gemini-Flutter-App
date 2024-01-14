import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geminiadvance/gemini_service.dart';
import 'package:image_picker/image_picker.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool loading = false;
  File? imageFile;

  final ImagePicker picker = ImagePicker();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _controller = ScrollController();

  GeminiService geminiService = GeminiService();

  void scrollToTheEnd() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> chatMessages = geminiService.chatMessages;

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // Schedule scrollToTheEnd after the widget has been fully built
      scrollToTheEnd();
    });

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _controller,
              itemCount: chatMessages.length,
              padding: const EdgeInsets.only(bottom: 20),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onDoubleTap: () {
                    print("Double tap");
                  },
                  onLongPress: () {
                    // Copy the message to the clipboard
                    Clipboard.setData(
                        ClipboardData(text: chatMessages[index]["text"]));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Message copied to clipboard')),
                    );
                  },
                  child: Align(
                    alignment: chatMessages[index]["role"] == "User"
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: chatMessages[index]["role"] == "User"
                            ? Colors.blue
                            : Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            chatMessages[index]["text"],
                            style: const TextStyle(color: Colors.white),
                          ),
                          if (chatMessages[index]["image"] != null)
                            Image.file(
                              chatMessages[index]["image"],
                              width: 90,
                              height: 90,
                            ),
                          if (chatMessages[index]["timestamp"] != null)
                            Text(
                              chatMessages[index]["timestamp"],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Write a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.transparent,
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                Visibility(
                  visible: !kIsWeb,
                  child: IconButton(
                    icon: const Icon(Icons.add_a_photo),
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['jpg', 'jpeg', 'png'],
                      );

                      if (result != null) {
                        setState(() {
                          imageFile = File(result.files.single.path!);
                        });
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: loading
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.send),
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });

                    if (imageFile == null) {
                      await geminiService.fromText(query: _textController.text);
                      _textController.clear();
                    } else {
                      await geminiService.fromTextAndImage(
                        query: _textController.text,
                        image: imageFile!,
                      );
                      _textController.clear();

                      setState(() {
                        imageFile = null;
                      });
                    }

                    setState(() {
                      loading = false;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: imageFile != null
          ? Container(
              margin: const EdgeInsets.only(bottom: 80),
              height: 150,
              child: Image.file(imageFile ?? File("")),
            )
          : null,
    );
  }
}

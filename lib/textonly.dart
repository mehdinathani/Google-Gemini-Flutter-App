// import 'package:flutter/material.dart';


// class TextOnly extends StatefulWidget {
//   const TextOnly({
//     super.key,
//   });

//   @override
//   State<TextOnly> createState() => _TextOnlyState();
// }

// class _TextOnlyState extends State<TextOnly> {
//   bool loading = false;
//   List textChat = [];
//   List textWithImageChat = [];

//   final TextEditingController _textController = TextEditingController();
//   final ScrollController scrollingcontroller = ScrollController();

//   // Create Gemini Instance
//   final gemini = GoogleGemini(
//     apiKey: apiKey,
//   );

//   void scrollToTheEnd() {
//     scrollingcontroller.jumpTo(scrollingcontroller.position.maxScrollExtent);
//   }

//   // Text only input
//   Future<void> fromText({required String query}) async {
//     DateTime now = DateTime.now();
//     // String timestamp = now.toString();
//     String timestamp = "${now.hour}:${now.minute}";
//     setState(() {
//       loading = true;
//       textChat.add({
//         "role": "User",
//         "text": query,
//         "timestamp": timestamp,
//       });
//       _textController.clear();
//       scrollToTheEnd();
//     });

//     await gemini.generateFromText(query).then((value) {
//       setState(() {
//         loading = false;
//         textChat.add({
//           "role": "Gemini",
//           "text": value.text,
//           "timestamp": timestamp,
//         });
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           // Schedule scrollToTheEnd after the widget has been fully built
//           scrollToTheEnd();
//         });
//       });
//     }).onError((error, stackTrace) {
//       setState(() {
//         loading = false;
//         textChat.add({
//           "role": "Gemini",
//           "text": error.toString(),
//           "timestamp": timestamp,
//         });
//       });
//       scrollToTheEnd();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//             controller: scrollingcontroller,
//             itemCount: textChat.length,
//             padding: const EdgeInsets.only(bottom: 20),
//             itemBuilder: (context, index) {
//               return ListTile(
//                 isThreeLine: true,
//                 leading: CircleAvatar(
//                   child: Text(textChat[index]["role"].substring(0, 1)),
//                 ),
//                 title: Text(
//                   "${textChat[index]["role"]} - ${textChat[index]["timestamp"]}",
//                 ),
//                 subtitle: Text(textChat[index]["text"]),
//               );
//             },
//           ),
//         ),
//         Container(
//           alignment: Alignment.bottomRight,
//           margin: const EdgeInsets.all(20),
//           padding: const EdgeInsets.symmetric(horizontal: 15.0),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10.0),
//             border: Border.all(color: Colors.grey),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _textController,
//                   decoration: InputDecoration(
//                     hintText: "Type a message",
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                         borderSide: BorderSide.none),
//                     fillColor: Colors.transparent,
//                   ),
//                   maxLines: null,
//                   keyboardType: TextInputType.multiline,
//                 ),
//               ),
//               IconButton(
//                   onPressed: scrollToTheEnd,
//                   icon: const Icon(Icons.file_download)),
//               IconButton(
//                 icon: loading
//                     ? const CircularProgressIndicator()
//                     : const Icon(Icons.send),
//                 onPressed: () async {
//                   await fromText(query: _textController.text);

//                   setState(() {
//                     scrollToTheEnd();
//                   });
//                 },
//               ),
//             ],
//           ),
//         )
//       ],
//     ));
//   }
// }

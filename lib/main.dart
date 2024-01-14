import 'package:flutter/material.dart';
import 'package:geminiadvance/config.dart';
import 'package:geminiadvance/home_view.dart';

void main() {
  runApp(const MyApp());
}

String apiKey = ConfigKeys.apiKey;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Google Gemini"),
              centerTitle: true,
              //   bottom: const TabBar(
              //     tabs: [
              //       Tab(text: "Text Only"),
              //       Tab(text: "Text with Image"),
              //     ],
              //   ),
            ),
            body: const HomeView()));
  }
}

// ------------------------------ Text Only ------------------------------



// ------------------------------ Text with Image ------------------------------



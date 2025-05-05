import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spark',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

// Splash Screen
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Spark',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 3.0,
                  fontFamily: 'Arial',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Home Page
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  final List<Map<String, String>> items = const [
    {"title": "Variable", "description": "A container for storing data."},
    {"title": "Condition", "description": "Used to perform decision making."},
    {"title": "Loop", "description": "Repeats a block of code multiple times."},
    {"title": "Function", "description": "A reusable block of code."},
    {"title": "Array", "description": "A collection of similar data types."},
    {"title": "Pointers", "description": "Stores the address of a variable."},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Interactive Variables")),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    title: item['title']!,
                    description: item['description']!,
                  ),
                ),
              );
            },
            child: Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    item['title']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Detail Page with Category Validation & AI Chat
class DetailPage extends StatefulWidget {
  final String title;
  final String description;

  const DetailPage({Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController messageController = TextEditingController();
  String aiResponse = "";

  final Map<String, List<String>> categoryKeywords = {
    "Variable": ["int", "float", "char", "string", "bool", "double"],
    "Loop": ["for", "while", "do-while"],
    "Condition": ["if", "else", "switch", "case"],
    "Function": ["void", "return", "function", "parameters"],
    "Array": ["array", "vector", "list"],
    "Pointers": ["pointer", "address", "memory", "reference"]
  };

  Future<void> sendMessage() async {
    const apiKey = "AIzaSyCOLeERQii6VXRl9gStfBC2fovhjlf4cg8";
    final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro-002:generateContent?key=$apiKey");

    String userInput = messageController.text.toLowerCase();
    String currentCategory = widget.title;
    bool isCorrectCategory = categoryKeywords[currentCategory]
            ?.any((keyword) => userInput.contains(keyword)) ??
        false;

    if (!isCorrectCategory) {
      setState(() {
        aiResponse =
            "❌ '$userInput' is not related to '$currentCategory'. Please check the correct category.";
      });
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "contents": [
            {
              "parts": [
                {"text": userInput}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          aiResponse = data["candidates"]?[0]["content"]?["parts"]?[0]
                  ["text"] ??
              "No response";
          messageController.clear();
        });
      } else {
        setState(() {
          aiResponse = "Error: ${response.statusCode} - ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        aiResponse = "Error: Unable to connect to API";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: messageController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Type your message...",
              ),
            ),
            ElevatedButton(onPressed: sendMessage, child: const Text("Send")),
            Text(aiResponse),
          ],
        ),
      ),
    );
  }
}

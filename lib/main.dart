import 'package:flutter/material.dart';
import 'tts_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Entry point of the application.
void main() {
  runApp(const MyApp());
}

/// Root widget of the application.
class MyApp extends StatelessWidget {
  /// Constructs the [MyApp] widget.
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

/// Home page of the app.
class MyHomePage extends StatefulWidget {
  /// Constructs the [MyHomePage] widget.
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/// State for [MyHomePage].
class _MyHomePageState extends State<MyHomePage> {
  TextEditingController notesController = TextEditingController();

  /// Fetches processed notes from the backend.
  ///
  /// Throws an exception if the request fails.
  Future<String> fetchProcessedNotes(String notes) async {
    // Prepare the body of the POST request
    String body = json.encode({'notes': notes});

    // Make the HTTP POST request
    // Replace 'LinkToYourPythonAnywhereScript' with the URL of your hosted backend script.
    // This script should handle requests and communicate with the OpenAI API to generate study guides.
    final response = await http.post(
      Uri.parse('LinkToYourPythonAnywhereScript'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    // Print response status code and body
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body)['study_guide'];
    } else {
      throw Exception('Failed to fetch processed notes');
    }
  }

  /// Processes notes and navigates to the TTS page.
  void _processNotesAndNavigate() async {
    try {
      String processedText = await fetchProcessedNotes(notesController.text);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TTSPage(processedText: processedText)),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Guide Builder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: notesController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Enter your notes here',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _processNotesAndNavigate,
              child: const Text('Process Notes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

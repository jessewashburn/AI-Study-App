import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/services.dart';

/// A page for text-to-speech functionality of the study guide.
class TTSPage extends StatefulWidget {
  /// The processed text to be read aloud.
  final String processedText;

  /// Constructs a [TTSPage] widget.
  const TTSPage({Key? key, required this.processedText}) : super(key: key);

  @override
  _TTSPageState createState() => _TTSPageState();
}

/// The state for [TTSPage].
class _TTSPageState extends State<TTSPage> {
  final FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;
  int startPosition = 0;
  List<int> sectionIndices = [];
  int currentSection = 0;

  @override
  void initState() {
    super.initState();
    parseTextForSections(widget.processedText);
    flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });
    flutterTts.setCompletionHandler(() {
      // Handle completion of speech
      if (currentSection < sectionIndices.length - 1) {
        setState(() {
          currentSection++;
          startPosition = sectionIndices[currentSection];
          _startSpeaking();
        });
      } else {
        setState(() {
          isPlaying = false;
        });
      }
    });
    flutterTts.setProgressHandler((String text, int startOffset, int endOffset, String word) {
      // Handle progress updates
    });
  }

  /// Parses the text and identifies section indices based on a pattern.
  void parseTextForSections(String text) {
    RegExp regExp = RegExp(r'\b[A-Z]\.'); // Pattern to find sections like A., B., etc.
    Iterable<RegExpMatch> matches = regExp.allMatches(text);
    sectionIndices = matches.map((m) => m.start).toList();
    if (sectionIndices.isNotEmpty) {
      startPosition = sectionIndices.first;
    }
  }

  /// Starts speaking the text from the current position.
  Future<void> _startSpeaking() async {
    if (currentSection < sectionIndices.length) {
      int endPosition = (currentSection < sectionIndices.length - 1)
          ? sectionIndices[currentSection + 1]
          : widget.processedText.length;
      String textToSpeak = widget.processedText.substring(startPosition, endPosition);
      await flutterTts.speak(textToSpeak);
    } else {
      setState(() {
        isPlaying = false;
      });
    }
  }

  /// Pauses the speech.
  Future<void> _pauseSpeaking() async {
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
    });
  }

  /// Jumps forward to the next section.
  Future<void> _fastForward() async {
    if (currentSection < sectionIndices.length - 1) {
      currentSection++;
      startPosition = sectionIndices[currentSection];
      if (isPlaying) {
        await flutterTts.stop();
        await _startSpeaking();
      }
    }
  }

  /// Rewinds to the previous section.
  Future<void> _rewind() async {
    if (currentSection > 0) {
      currentSection--;
      startPosition = sectionIndices[currentSection];
      if (isPlaying) {
        await flutterTts.stop();
        await _startSpeaking();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Reader'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              // Copies the processed text to the clipboard
              Clipboard.setData(ClipboardData(text: widget.processedText));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to Clipboard')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.processedText,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _rewind,
                  child: const Text('Rewind'),
                ),
                ElevatedButton(
                  onPressed: isPlaying ? _pauseSpeaking : _startSpeaking,
                  child: Text(isPlaying ? 'Pause' : 'Play'),
                ),
                ElevatedButton(
                  onPressed: _fastForward,
                  child: const Text('Forward'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of resources
    flutterTts.stop();
    super.dispose();
  }
}

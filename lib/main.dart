import 'package:flutter/material.dart';
import 'package:youtube_clone/utils/youtube_downloader.dart';
import 'screens/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Music Player',
      theme: ThemeData(
        primaryColor: const Color(0xFF1F1B24),
        scaffoldBackgroundColor: const Color(0xFF1F1B24),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}


class ButtonTest extends StatelessWidget {
  const ButtonTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(onPressed: () {
        YoutubeDownloader.getAudioStream("https://www.youtube.com/watch?v=hKwizc5nsWY&ab_channel=ArianaGrandeVevo");
      }, child: Text("Press here")),
    );
  }
}
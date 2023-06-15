import 'package:flutter/material.dart';

import './video_call_screen.dart';
import './audio_call_screen.dart';
import './chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agora Communications',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF089CFD),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF000E4B),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Communications'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton.icon(
            label: const Text('Chat'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
            icon: const Icon(Icons.chat),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            label: const Text('Video Call'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const VideoCallScreen()),
              );
            },
            icon: const Icon(Icons.video_call),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            label: const Text('Audio Call'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AudioCallScreen()),
              );
            },
            icon: const Icon(Icons.call),
          ),
        ]),
      ),
    );
  }
}

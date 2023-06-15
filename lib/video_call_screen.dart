import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
        appId: "8fe97bd038e946d6a8b4abc8e3f59024",
        channelName: "testSri",
        tempToken:
            "007eJxTYLBub32m6fXsaX70sp/NnEkVkzymLZVUn/huBYcHd7JN80oFBou0VEvzpBQDY4tUSxOzFLNEiySTxKRki1TjNFNLAyMTu9KulIZARoYEhfNMjAwQCOKzM5SkFpcEF2UyMAAAf/sfsQ=="),
  );

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    await client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: client,
              layoutType: Layout.oneToOne,
              enableHostControls: true,
            ),
            AgoraVideoButtons(
              client: client,
              addScreenSharing: false,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    client.release();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import './widgets/chat_bubble.dart';

class AgoraChatConfig {
  static const String appKey = "61865287#1061907";
  static const String user2Id = "sj001";
  static const String agoraToken2 =
      "007eJxTYAgr+/vz7sMZ3UWHTRO3tjOs5w5qNuP42fqjYLKK3hyHJkMFBou0VEvzpBQDY4tUSxOzFLNEiySTxKRki1TjNFNLAyOTntKulIZARgZzgb8MjAysQMzIAOKrMJgkWpiYmKYZ6KaZmhjrGhqmpuhaJBua6ZqkGaWZJqYZG6VZpAIArUMnkw==";

  static const String user1Id = "sri001";
  static const String agoraToken1 =
      "007eJxTYKi4M0/pgHPyZsbJKtUSOSdrpu0/6BubqSZ6/qmDnoHPMzYFBou0VEvzpBQDY4tUSxOzFLNEiySTxKRki1TjNFNLAyOThaVdKQ2BjAwfXM1ZGBlYGRiBEMRXYTBLMTRIskw00E0zNTHWNTRMTdFNskhN1k00NExMTgJqtjBIAwDxwSZg";
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final String _chatId = AgoraChatConfig.user2Id;
  final List<ChatMessage1> _messages = [];

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initSDK();
    _addChatListener();
    signIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = _messages[index];
                return ChatBubble(
                  text: message.text,
                  isSentByMe: message.isSentByMe,
                  time: message.time,
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _initSDK() async {
    ChatOptions options = ChatOptions(
      appKey: AgoraChatConfig.appKey,
      autoLogin: false,
    );
    await ChatClient.getInstance.init(options);
    // Notify the SDK that the UI is ready. After the following method is executed, callbacks within `ChatRoomEventHandler`, ` ChatContactEventHandler`, and `ChatGroupEventHandler` can be triggered.
    await ChatClient.getInstance.startCallback();
  }

  void _addChatListener() {
    ChatClient.getInstance.chatManager.addMessageEvent(
        "UNIQUE_HANDLER_ID",
        ChatMessageEvent(
          onSuccess: (msgId, msg) {
            print("send message succeed");
          },
          onProgress: (msgId, progress) {
            print("send message succeed");
          },
          onError: (msgId, msg, error) {
            print(
              "send message failed, code: ${error.code}, desc: ${error.description}",
            );
          },
        ));

    ChatClient.getInstance.chatManager.addEventHandler(
      "UNIQUE_HANDLER_ID",
      ChatEventHandler(onMessagesReceived: onMessagesReceived),
    );
  }

  void signIn() async {
    try {
      await ChatClient.getInstance.loginWithAgoraToken(
        AgoraChatConfig.user1Id,
        AgoraChatConfig.agoraToken1,
      );
      print("login succeed, userId: ${AgoraChatConfig.user1Id}");
    } on ChatError catch (e) {
      print("login failed, code: ${e.code}, desc: ${e.description}");
    }
  }

  void _sendMessage() {
    final text = _textEditingController.text.trim();
    if (text.isNotEmpty) {
      var msg = ChatMessage.createTxtSendMessage(
        targetId: _chatId,
        content: text,
      );

      ChatClient.getInstance.chatManager.sendMessage(msg);

      setState(() {
        _messages
            .add(ChatMessage1(text: text, isSentByMe: true, time: _timeString));
        _textEditingController.clear();
      });
    } else {
      print("single chat id or message content is null");
      return;
    }
  }

  void onMessagesReceived(messages) {
    for (var msg in messages) {
      switch (msg.body.type) {
        case MessageType.TXT:
          {
            ChatTextMessageBody body = msg.body as ChatTextMessageBody;

            print(
              "receive text message: ${body.content}, from: ${msg.from}",
            );
            setState(() {
              _messages.add(ChatMessage1(
                  text: body.content, isSentByMe: false, time: _timeString));
              _textEditingController.clear();
            });
          }
          break;
        case MessageType.IMAGE:
          {
            print(
              "receive image message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.VIDEO:
          {
            print(
              "receive video message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.LOCATION:
          {
            print(
              "receive location message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.VOICE:
          {
            print(
              "receive voice message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.FILE:
          {
            print(
              "receive image message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.CUSTOM:
          {
            print(
              "receive custom message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.CMD:
          {
            // Receiving command messages does not trigger the `onMessagesReceived` event, but triggers the `onCmdMessagesReceived` event instead.
          }
          break;
      }
    }
  }

  void signOut() async {
    try {
      await ChatClient.getInstance.logout(true);
      print("sign out succeed");
    } on ChatError catch (e) {
      print("sign out failed, code: ${e.code}, desc: ${e.description}");
    }
  }

  DateTime get _timeString {
    return DateTime.now();
  }

  @override
  void dispose() {
    ChatClient.getInstance.chatManager.removeMessageEvent("UNIQUE_HANDLER_ID");
    ChatClient.getInstance.chatManager.removeEventHandler("UNIQUE_HANDLER_ID");
    signOut();
    super.dispose();
  }
}

class ChatMessage1 {
  final String text;
  final bool isSentByMe;
  final DateTime time;

  ChatMessage1({
    required this.text,
    required this.isSentByMe,
    required this.time,
  });
}

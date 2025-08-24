import 'package:chat_apps/components/chat_bubble.dart';
import 'package:chat_apps/components/my_textfield.dart';
import 'package:chat_apps/services/auth/auth_service.dart';
import 'package:chat_apps/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Text controller
  final TextEditingController _messageController = TextEditingController();

  // Chat & auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // Scroll controller
  final ScrollController _scrollController = ScrollController();

  // Focus node for textfield
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Add listener to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        // Scroll down after keyboard appears
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });

    // Scroll to bottom after listview is built
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // Scroll to bottom
  void scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  // Send message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverID,
        _messageController.text,
      );

      _messageController.clear();
      scrollDown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Display messages
          Expanded(child: _buildMessageList()),

          // User input
          _buildUserInput(),
        ],
      ),
    );
  }

  // Build message list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text("Error");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        return ListView(
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  // Build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    return Container(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data["message"],
            isCurrentUser: isCurrentUser,
          ),
        ],
      ),
    );
  }

  // Build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          // Textfield
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Type a message",
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),

          // Send button
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

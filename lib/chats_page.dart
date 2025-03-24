import 'package:flutter/material.dart';
import 'navigation_service.dart';

// Placeholder data (replace with your backend data)
final List<Map<String, dynamic>> chatList = [
  {
    'name': 'Math Class',
    'lastMessage': 'Homework due tomorrow!',
    'timestamp': '10:30 AM',
    'unreadCount': 2,
  },
  {
    'name': 'Teacher John Doe',
    'lastMessage': 'See you in class.',
    'timestamp': 'Yesterday',
    'unreadCount': 0,
  },
];

@override
void initState() {
  NavigationService.setCurrentRoute('/ChatsPage');
  //WidgetsBinding.instance.addObserver(this);
}

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCFE3DD),
      body: ListView.builder(
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          final chat = chatList[index];
          return ListTile(
            title: Text(chat['name']),
            subtitle: Text(chat['lastMessage']),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(chat['timestamp']),
                if (chat['unreadCount'] > 0)
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Color(0xFF026A75),
                    child: Text(
                      chat['unreadCount'].toString(),
                      style: const TextStyle(fontSize: 12, color: Color(0xFFCFE3DD)),
                    ),
                  ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen(chatName: chat['name'])),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement new chat functionality
        },
        backgroundColor: Color(0xFF026A75),
        child: const Icon(Icons.message, color: Color(0xFFCFE3DD)),
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final String chatName;

  const ChatScreen({super.key, required this.chatName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(chatName)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Placeholder message count
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Message $index'),
                  // Add message bubble styling
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
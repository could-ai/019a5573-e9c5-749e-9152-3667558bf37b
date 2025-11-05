import 'chat_message.dart';

class ChatConversation {
  final String id;
  final String name;
  final String avatarUrl;
  final ChatMessage? lastMessage;
  final int unreadCount;
  final bool isOnline;

  ChatConversation({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.lastMessage,
    this.unreadCount = 0,
    this.isOnline = false,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatarUrl'],
      lastMessage: json['lastMessage'] != null
          ? ChatMessage.fromJson(json['lastMessage'])
          : null,
      unreadCount: json['unreadCount'] ?? 0,
      isOnline: json['isOnline'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'lastMessage': lastMessage?.toJson(),
      'unreadCount': unreadCount,
      'isOnline': isOnline,
    };
  }
}
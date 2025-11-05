import 'package:flutter/material.dart';
import '../models/chat_conversation.dart';
import '../models/chat_message.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  // بيانات تجريبية للمحادثات
  final List<ChatConversation> _conversations = [
    ChatConversation(
      id: '1',
      name: 'أحمد محمد',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      lastMessage: ChatMessage(
        id: '1',
        text: 'مرحباً، كيف حالك؟',
        senderId: '1',
        senderName: 'أحمد محمد',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isMe: false,
      ),
      unreadCount: 2,
      isOnline: true,
    ),
    ChatConversation(
      id: '2',
      name: 'سارة علي',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      lastMessage: ChatMessage(
        id: '2',
        text: 'شكراً على المساعدة',
        senderId: 'me',
        senderName: 'أنا',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isMe: true,
      ),
      unreadCount: 0,
      isOnline: false,
    ),
    ChatConversation(
      id: '3',
      name: 'محمد خالد',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
      lastMessage: ChatMessage(
        id: '3',
        text: 'متى سنلتقي؟',
        senderId: '3',
        senderName: 'محمد خالد',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isMe: false,
      ),
      unreadCount: 5,
      isOnline: true,
    ),
    ChatConversation(
      id: '4',
      name: 'فاطمة أحمد',
      avatarUrl: 'https://i.pravatar.cc/150?img=9',
      lastMessage: ChatMessage(
        id: '4',
        text: 'تمام، سأكون هناك',
        senderId: 'me',
        senderName: 'أنا',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isMe: true,
      ),
      unreadCount: 0,
      isOnline: false,
    ),
  ];

  String _searchQuery = '';

  List<ChatConversation> get _filteredConversations {
    if (_searchQuery.isEmpty) {
      return _conversations;
    }
    return _conversations
        .where((conv) => conv.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الدردشات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ChatSearchDelegate(_conversations),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // خيارات إضافية
            },
          ),
        ],
      ),
      body: _filteredConversations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد محادثات',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _filteredConversations.length,
              itemBuilder: (context, index) {
                final conversation = _filteredConversations[index];
                return _buildChatTile(conversation);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // فتح شاشة محادثة جديدة
        },
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _buildChatTile(ChatConversation conversation) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(conversation.avatarUrl),
          ),
          if (conversation.isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              conversation.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          if (conversation.lastMessage != null)
            Text(
              _formatTime(conversation.lastMessage!.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
      subtitle: Row(
        children: [
          if (conversation.lastMessage?.isMe == true)
            Icon(
              Icons.done_all,
              size: 16,
              color: Colors.blue[700],
            ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              conversation.lastMessage?.text ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: conversation.unreadCount > 0
                    ? Colors.black87
                    : Colors.grey[600],
                fontWeight: conversation.unreadCount > 0
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ),
          if (conversation.unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${conversation.unreadCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(
              conversation: conversation,
            ),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0) {
      // اليوم
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} أيام';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}

class ChatSearchDelegate extends SearchDelegate<ChatConversation?> {
  final List<ChatConversation> conversations;

  ChatSearchDelegate(this.conversations);

  @override
  String get searchFieldLabel => 'بحث في الدردشات';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = conversations
        .where((conv) => conv.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final conversation = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(conversation.avatarUrl),
          ),
          title: Text(conversation.name),
          subtitle: Text(conversation.lastMessage?.text ?? ''),
          onTap: () {
            close(context, conversation);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetailScreen(
                  conversation: conversation,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
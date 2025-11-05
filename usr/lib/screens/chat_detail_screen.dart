import 'package:flutter/material.dart';
import '../models/chat_conversation.dart';
import '../models/chat_message.dart';
import '../widgets/message_bubble.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatConversation conversation;

  const ChatDetailScreen({
    super.key,
    required this.conversation,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    // بيانات تجريبية للرسائل
    setState(() {
      _messages.addAll([
        ChatMessage(
          id: '1',
          text: 'مرحباً! كيف يمكنني مساعدتك؟',
          senderId: widget.conversation.id,
          senderName: widget.conversation.name,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isMe: false,
        ),
        ChatMessage(
          id: '2',
          text: 'مرحباً، أحتاج لبعض المساعدة في المشروع',
          senderId: 'me',
          senderName: 'أنا',
          timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 58)),
          isMe: true,
        ),
        ChatMessage(
          id: '3',
          text: 'بالتأكيد، ما هي المشكلة التي تواجهها؟',
          senderId: widget.conversation.id,
          senderName: widget.conversation.name,
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
          isMe: false,
        ),
        ChatMessage(
          id: '4',
          text: 'أواجه مشكلة في تصميم الواجهة',
          senderId: 'me',
          senderName: 'أنا',
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
          isMe: true,
        ),
        ChatMessage(
          id: '5',
          text: 'حسناً، سأساعدك في ذلك. هل يمكنك إرسال لقطة شاشة؟',
          senderId: widget.conversation.id,
          senderName: widget.conversation.name,
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
          isMe: false,
        ),
      ]);
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      senderId: 'me',
      senderName: 'أنا',
      timestamp: DateTime.now(),
      isMe: true,
    );

    setState(() {
      _messages.add(message);
      _messageController.clear();
    });

    _scrollToBottom();

    // محاكاة الرد التلقائي
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final reply = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: 'شكراً على رسالتك! سأرد عليك قريباً.',
          senderId: widget.conversation.id,
          senderName: widget.conversation.name,
          timestamp: DateTime.now(),
          isMe: false,
        );
        setState(() {
          _messages.add(reply);
        });
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.conversation.avatarUrl),
                ),
                if (widget.conversation.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.conversation.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.conversation.isOnline ? 'متصل الآن' : 'غير متصل',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              // مكالمة فيديو
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              // مكالمة صوتية
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
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
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
                          'ابدأ محادثة',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final showAvatar = index == _messages.length - 1 ||
                          _messages[index + 1].isMe != message.isMe;
                      return MessageBubble(
                        message: message,
                        showAvatar: showAvatar,
                        avatarUrl: message.isMe ? null : widget.conversation.avatarUrl,
                      );
                    },
                  ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // إرفاق ملف
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالة...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[800]
                          : Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
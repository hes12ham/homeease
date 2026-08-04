import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class ChatProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<ChatMessage> _messages = [];
  bool _isLoading = false;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  // Load messages once
  Future<void> loadMessages(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final snapshot = await _firestore
          .collection('chats')
          .doc(userId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .get();
      _messages = snapshot.docs
          .map((doc) => ChatMessage.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('Error loading messages: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  // Stream of chat messages
  Stream<List<ChatMessage>> getMessages(String userId) {
    return _firestore
        .collection('chats')
        .doc(userId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromFirestore(doc))
            .toList());
  }

  // Send message
  Future<void> sendMessage({
    required String userId,
    required String message,
    bool isFromUser = true,
  }) async {
    try {
      final msg = ChatMessage(
        id: '',
        senderId: userId,
        message: message,
        timestamp: DateTime.now(),
        isFromUser: isFromUser,
      );

      await _firestore
          .collection('chats')
          .doc(userId)
          .collection('messages')
          .add(msg.toMap());

      _messages.add(msg);
      notifyListeners();

      await _firestore.collection('chats').doc(userId).set({
        'lastMessage': message,
        'lastMessageTime': Timestamp.now(),
        'userId': userId,
        'unreadByAdmin': true,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }
}

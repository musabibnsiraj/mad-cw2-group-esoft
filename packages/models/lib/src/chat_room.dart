import 'package:equatable/equatable.dart';
import 'package:models/models.dart';
import 'package:uuid/uuid.dart';

class ChatRoom extends Equatable {
  final String id;
  final List<User> users;
  final Message? lastMessage;
  final int unreadCount;

  const ChatRoom({
    required this.id,
    required this.users,
    this.lastMessage,
    required this.unreadCount,
  });

  ChatRoom copyWith({
    String? id,
    List<User>? users,
    Message? lastMessage,
    int? unreadCount,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      users: users ?? this.users,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'] ?? const Uuid().v4(),
      users: (json['users'] is List)
          ? json['users'].map<User>((user) => User.fromJson(user)).toList()
          : [],
      unreadCount: json['unread_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'users': users,
      'unreadCount': unreadCount,
    };
  }

  @override
  List<Object?> get props => [id, users, lastMessage, unreadCount];
}

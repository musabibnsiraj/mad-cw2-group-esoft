import 'package:my_office_chat/main.dart';
import 'package:my_office_chat/screens/chat_room_screen.dart';
import 'package:models/models.dart';
import '../../widgets/common_widget.dart';
import 'package:flutter/material.dart';
import '../constant.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  List<User> allUsers = [];
  bool loading = false;

  final chatRoom = ChatRoom(
    id: '8d162274-6cb8-4776-815a-8e721ebfb76d',
    participants: const [
      User(
        id: '2e1b90e6-1750-4be0-b7b6-df04c7e611b7',
        username: 'Musab',
        phone: '0755513162',
        email: 'musab@gmail.com',
        avatarUrl: 'https://avatars.githubusercontent.com/u/47845204?v=4',
        status: 'online',
      ),
      User(
        id: 'df7a1235-d004-4b2b-8406-369c6ecfb050',
        username: 'Arsath',
        phone: '0755555555',
        email: 'arsath@gmail.com',
        avatarUrl:
            'https://static.vecteezy.com/system/resources/previews/008/442/086/non_2x/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg',
        status: 'online',
      ),
    ],
    lastMessage: Message(
      id: 'de120f3a-dbca-4330-9e2e-18b55a2fb9e5',
      chatRoomId: '8d162274-6cb8-4776-815a-8e721ebfb76d',
      senderUserId: '2e1b90e6-1750-4be0-b7b6-df04c7e611b7',
      receiverUserId: 'df7a1235-d004-4b2b-8406-369c6ecfb050',
      content: 'Hi',
      createdAt: DateTime(2023, 12, 1, 1, 0, 0),
    ),
    unreadCount: 0,
  );

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await _loadUsers();
  }

  _loadUsers() async {
    final _users = await userRepository.fetchUsers();

    setState(() {
      allUsers.addAll(_users);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('My Office Chat', elevation: 0.1),
      body: SafeArea(
          child: Stack(
        children: [
          const SizedBox(
            height: 10,
          ),
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                margin: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: appGrey)),
                ),
              ),
              if (!loading && allUsers.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 100.0),
                  child: Text('You don’t have any chats yet'),
                ),
              Expanded(
                  child: Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  itemCount: allUsers.length,
                  itemBuilder: (ctx, i) {
                    User c = allUsers.elementAt(i);
                    return SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, left: 4, right: 4),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return ChatRoomScreen(chatRoom: chatRoom);
                            }));
                          },
                          leading: CircleAvatar(
                              backgroundColor: appGreen,
                              child: Text(c.initials() ?? "")),
                          title: Text("${c.username} ${c.email}",
                              style: TextStyle(color: appTextColor)),
                          subtitle: Text(
                            c.phone,
                            style: TextStyle(color: appTextColor),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ))
            ],
          ),
          if (loading) const Spinner()
        ],
      )),
    );
  }
}

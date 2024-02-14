import 'package:my_office_chat/main.dart';
import 'package:my_office_chat/screens/chat_room_screen.dart';
import 'package:models/models.dart';
import 'package:my_office_chat/screens/contact_screen.dart';
import '../../widgets/common_widget.dart';
import 'package:flutter/material.dart';
import '../constant.dart';
import 'login_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  List<ChatRoom> chatRooms = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await _loadChats();
  }

  _loadChats() async {
    setState(() => loading = true);
    final chats = await chatRepository.fetchChatsByUserId(logedUserId);

    setState(() {
      chatRooms.addAll(chats);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        'My Office',
        actionsWidget: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _logout();
            },
          ),
        ],
      ),
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
              if (!loading && chatRooms.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 100.0),
                  child: Text('You don’t have any chats yet'),
                ),
              Expanded(
                  child: Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  itemCount: chatRooms.length,
                  itemBuilder: (ctx, i) {
                    ChatRoom chatRoom = chatRooms.elementAt(i);
                    final participants = chatRoom.users;
                    for (final participant in participants) {
                      var username = participant.username;
                      var participantId = participant.id;
                      var participantPhone = participant.phone;

                      // Skip logged-in user
                      if (participantId != logedUserId &&
                          username.isNotEmpty &&
                          participantPhone.isNotEmpty) {
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
                                  child: Text(participant.initials() ?? "")),
                              title: Text(participant.username,
                                  style: TextStyle(color: appTextColor)),
                              subtitle: Text(
                                participantPhone,
                                style: TextStyle(color: appTextColor),
                              ),
                            ),
                          ),
                        );
                      }
                    }
                    return const SizedBox(height: 0);
                  },
                ),
              ))
            ],
          ),
          if (loading) const Spinner()
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return const ContactScreen();
          }));
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.message), // Customize button color
      ),

      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.miniStartDocked,
    );
  }

  void _logout() {
    // Perform logout logic here
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(userRepository: userRepository),
      ),
    );
  }
}

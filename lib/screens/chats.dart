import 'package:my_office_chat/main.dart';
import 'package:my_office_chat/screens/chat_room_screen.dart';
import 'package:models/models.dart';
import 'package:my_office_chat/screens/contact_screen.dart';
import '../../widgets/common_widget.dart';
import 'package:flutter/material.dart';
import '../constant.dart';

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
    final chats = await chatRepository.fetchChatsByUserId(logedUserId);

    setState(() {
      chatRooms.addAll(chats);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('My Office', elevation: 0.1),
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
                      // Skip logged-in user
                      if (participant.id != logedUserId) {
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
                                participant.phone,
                                style: TextStyle(color: appTextColor),
                              ),
                            ),
                          ),
                        );
                      }
                    }
                    return null;
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
}

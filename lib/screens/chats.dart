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
                    User participant = allUsers.elementAt(i);
                    return SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, left: 4, right: 4),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return ChatRoomScreen(
                                  participantId: participant.id);
                            }));
                          },
                          leading: CircleAvatar(
                              backgroundColor: appGreen,
                              child: Text(participant.initials() ?? "")),
                          title: Text(
                              "${participant.username} ${participant.email}",
                              style: TextStyle(color: appTextColor)),
                          subtitle: Text(
                            participant.phone,
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

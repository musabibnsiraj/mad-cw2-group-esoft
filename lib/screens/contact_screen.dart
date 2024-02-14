import 'package:my_office_chat/main.dart';
import 'package:models/models.dart';
import 'package:flutter/material.dart';
import '../../widgets/common_widget.dart';
import '../constant.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
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
      appBar: appBar('Contacts', elevation: 0.1),
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
                  child: Text('You don’t have any contacts..!'),
                ),
              Expanded(
                  child: Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  itemCount: allUsers.length,
                  itemBuilder: (ctx, i) {
                    User participant = allUsers.elementAt(i);
                    final userId = participant.id;
                    if (userId != logedUserId) {
                      return SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 8.0, left: 4, right: 4),
                          child: ListTile(
                            onTap: () {},
                            leading: CircleAvatar(
                                backgroundColor: appGreen,
                                child: Text(participant.initials() ?? "")),
                            title: Text(participant.username,
                                style: TextStyle(color: appTextColor)),
                            subtitle: Text(participant.email,
                                style: TextStyle(color: appTextColor)),
                            trailing: Text(participant.phone,
                                style: TextStyle(color: appTextColor)),
                          ),
                        ),
                      );
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
    );
  }
}
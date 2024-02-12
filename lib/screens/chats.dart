import 'dart:async';
import 'package:my_office_chat/screens/chat_room_screen.dart';
import 'package:models/models.dart';
import '../helpers/utill.dart';
import '../../widgets/common_widget.dart';
import 'package:flutter/material.dart';
import '../constant.dart';
import 'package:provider/provider.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  List<User> userContacts = [
    User(
      id: 'df7a1235-d004-4b2b-8406-369c6ecfb050',
      username: 'Musab',
      phone: '0755513162',
      email: 'musab@gmail.com',
      avatarUrl: 'https://avatars.githubusercontent.com/u/47845204?v=4',
      status: 'online',
    ),
    User(
      id: '2e1b90e6-1750-4be0-b7b6-df04c7e611b7',
      username: 'Arsath',
      phone: '0755555555',
      email: 'arsath@gmail.com',
      avatarUrl:
          'https://static.vecteezy.com/system/resources/previews/008/442/086/non_2x/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg',
      status: 'online',
    )
  ];

  List<User> filteredContacts = [];
  List<User> allContacts = [
    User(
      id: 'df7a1235-d004-4b2b-8406-369c6ecfb050',
      username: 'Musab',
      phone: '0755513162',
      email: 'musab@gmail.com',
      avatarUrl: 'https://avatars.githubusercontent.com/u/47845204?v=4',
      status: 'online',
    ),
    User(
      id: '2e1b90e6-1750-4be0-b7b6-df04c7e611b7',
      username: 'Arsath',
      phone: '0755555555',
      email: 'arsath@gmail.com',
      avatarUrl:
          'https://static.vecteezy.com/system/resources/previews/008/442/086/non_2x/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg',
      status: 'online',
    )
  ];
  TextEditingController searchController = TextEditingController();
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
    await getAllContacts();
    // searchController.addListener(() {
    //   filterContacts();
    // });
  }

  // filterContacts() {
  //   List<User> filtered = [];
  //   filtered.addAll(userContacts);
  //   if (searchController.text.isNotEmpty) {
  //     filtered.retainWhere((contact) {
  //       String searchTerm = searchController.text.toLowerCase();
  //       String contactName =
  //           '${contact.firstname.toLowerCase()} ${contact.lastname.toLowerCase()}';
  //       bool matches = contactName.contains(searchTerm);
  //       if (matches == true) {
  //         return true;
  //       }

  //       String searchTermFlatten = flattenPhoneNumber(searchTerm);
  //       if (searchTermFlatten.isEmpty) return false;

  //       String contactPhone = flattenPhoneNumber(contact.phone);
  //       contactPhone = contactPhone.replaceAll(" ", "");
  //       searchTermFlatten = searchTermFlatten.replaceAll(" ", "");
  //       matches = contactPhone.contains(searchTermFlatten);
  //       if (matches == true) {
  //         return true;
  //       }

  //       return false;
  //     });
  //     setState(() {
  //       allContacts = filtered;
  //     });
  //   } else {
  //     setState(() {
  //       allContacts = userContacts;
  //     });
  //   }
  // }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  // Update your getAllContacts function
  Future<void> getAllContacts() async {
    setState(() => loading = true);
    try {
      // ContactProvider contactProvider =
      //     Provider.of<ContactProvider>(context, listen: false);
      // if (mounted) {
      //   await contactProvider.getAllContacts();
      // }
    } catch (e) {
      Utill.showError("Error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  removeContact(String id, BuildContext context) async {
    setState(() => loading = true);
    try {
      // await Provider.of<ContactProvider>(context, listen: false)
      //     .deleteContact(id);
    } catch (e) {
      Utill.showError("Error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final contactProvider = Provider.of<ContactProvider>(context, listen: true);
    // final isLoading = contactProvider.isLoading;

    final isLoading = false;

    // bool isSearching = searchController.text.isNotEmpty;
    // if (!isSearching) {
    //   userContacts = contactProvider.getAllContact;
    //   allContacts = userContacts;
    // }

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
              // ListTile(
              //   onTap: () async {
              //     // Navigator.of(context)
              //     //     .push(MaterialPageRoute(builder: (context) {
              //     //   return const NewContactScreen();
              //     // }));
              //   },
              //   leading: Container(
              //     height: 52,
              //     width: 52,
              //     margin: const EdgeInsets.only(left: 5),
              //     child: CircleAvatar(
              //       radius: 52,
              //       backgroundColor: primaryAppColor,
              //       child: Icon(
              //         Icons.add,
              //         color: appIconColor,
              //       ),
              //     ),
              //   ),
              //   title: const Text(
              //     'Add Chat',
              //     style: TextStyle(
              //       fontSize: 16,
              //       fontFamily: "Montserrat",
              //       fontWeight: FontWeight.w700,
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: SizedBox(
              //     width: MediaQuery.of(context).size.width - 10,
              //     child: TextField(
              //       controller: searchController,
              //       decoration: InputDecoration(
              //         labelText: 'Search Chat',
              //         prefixIcon: Icon(
              //           Icons.search,
              //           color: appTextColor,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
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
              if (!isLoading && !loading && userContacts.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 100.0),
                  child: Text('You don’t have any chats yet'),
                ),
              Expanded(
                  child: Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  itemCount: allContacts.length,
                  itemBuilder: (ctx, i) {
                    User c = allContacts.elementAt(i);
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.horizontal,
                      onDismissed: (!isLoading && !loading)
                          ? (direction) async {
                              setState(() {
                                // Remove the item from the list.
                                allContacts.removeAt(i);
                              });
                              await removeContact(c.id, context);
                            }
                          : null,
                      background: Container(
                        color: appRemoveColor,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 15),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: appWhite,
                                ),
                                const Text('Remove'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      secondaryBackground: Container(
                        color: appRemoveColor,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 15),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: appWhite,
                                ),
                                const Text('Remove'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      child: SizedBox(
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
                      ),
                    );
                  },
                ),
              ))
            ],
          ),
          if (loading || isLoading) const Spinner()
        ],
      )),
    );
  }
}

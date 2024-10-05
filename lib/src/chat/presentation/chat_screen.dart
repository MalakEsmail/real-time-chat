import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:realtimechat/src/chat/data/data_source/chat_remote_data_source.dart';
import 'package:realtimechat/src/chat/data/repo/chat_repo_impl.dart';
import 'package:realtimechat/src/chat/presentation/bloc/chat_bloc.dart';
import 'package:realtimechat/src/core/network/network_info.dart';
import 'package:realtimechat/src/core/utils/app_strings.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late ChatBloc chatBloc;

  @override
  void initState() {
    chatBloc = ChatBloc(
      chatRepo: ChatRepoImpl(
        networkInfo: NetworkInfoImpl(internetConnectionChecker: InternetConnectionChecker()),
        chatRemoteDataSource: ChatRemoteDataSourceImpl(),
      ),
    );
    chatBloc.add(FetchMessagesEvent());

    super.initState();
  }

  @override
  void dispose() {
    chatBloc.close(); // Close the bloc when the screen is disposed.
    _controller.dispose(); // Dispose of the controller.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          child: Text('Chat'),
          onTap: () {
            chatBloc.add(FetchMessagesEvent());
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: /* BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                print(">>>>>>> state:$state");
              },
              builder: (context, state) {
                if (state is LoadingFetchMessages) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is LoadedFetchMessages) {
                  return ListView.builder(
                    reverse: true,
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final isMe = message[AppStrings.senderIdKey] == FirebaseAuth.instance.currentUser!.uid;
                      return ListTile(
                        title: Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue : Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              message[AppStrings.textKey],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is ErrorFetchMessages) {
                  return Text(state.errorMessage);
                } else {
                  return Text("opps some thing wrong !");
                }
              },
            )*/
                StreamBuilder<QuerySnapshot>(
                    stream:
                        FirebaseFirestore.instance.collection(AppStrings.messagesCollection).orderBy(AppStrings.timestampKey).snapshots(),
                    builder: (context, snapshot) {
                      final messages = snapshot.data?.docs ?? [];

                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final isMe = messages[index][AppStrings.senderIdKey] == FirebaseAuth.instance.currentUser!.uid;
                          return ListTile(
                            title: Align(
                              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isMe ? Colors.blue : Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  messages[index][AppStrings.textKey],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Send a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      chatBloc.add(SendMessageEvent(message: _controller.text));
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}

import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:generic_social_widgets/generic_social_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const ChatPage(),
    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Googles Greatest Chat App'),
        centerTitle: false,
        actions: [
          ElevatedButton(
            onPressed: () async {
              final auth = FirebaseAuth.instance;
              if (auth.currentUser != null) {
                await auth.signOut();
              } else {
                await auth.signInAnonymously();
              }
            },
            child: const Text(
              'Log In Or Out',
            ),
          ),
        ],
      ),
      body: const ChatView(),
    );
  }
}

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check if user data is available
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
                height: 50, width: 50, child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == null) {
          // Display this when no user is logged in
          return const Center(
            child: Text("User not logged in"),
          );
        }

        // User is logged in, proceed to show the chat interface
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'User: ${snapshot.data!.uid}',
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: messagesQuery.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator()),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.size == 0) {
                    // This handles the case where there are no messages
                    return const Center(child: Text("No messages found"));
                  }
                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.size,
                    itemBuilder: (BuildContext context, int idx) {
                      //converting a Firestore document into a Message object,
                      // which is a custom data model in a Flutter application.
                      final message = Message.fromFirestore(snapshot.data!
                          .docs[idx] as DocumentSnapshot<Map<String, dynamic>>);
                      //snapshot.data!.docs[idx]: This part accesses the data
                      //from the current snapshot of the Firestore query. snapshot.data!
                      //forcefully unwraps the snapshot's data (assuming it's not null), .docs
                      //accesses the list of document snapshots returned by the query, and [idx]
                      //accesses the specific document at index idx in the list.

                      //as DocumentSnapshot<Map<String, dynamic>>: This is a type cast that
                      //tells Dart you are treating the selected document as a DocumentSnapshot
                      //containing a Map<String, dynamic>. A DocumentSnapshot is a Firestore class
                      //representing the data of a single document, and Map<String, dynamic> is a
                      //map (key-value pairs) with string keys and values of any type. This cast is
                      //necessary to ensure that the data can be passed to the fromFirestore constructor correctly.

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ChatBubble(text: message.message),
                      );
                    },
                  );
                },
              ),
            ),
            ChatTextInput(
              onSend: (message) {
                if (message.trim().isNotEmpty) {
                  FirebaseFirestore.instance.collection('messages').add(
                        Message(
                          uid: snapshot.data!.uid,
                          message: message,
                        ).toFirestore(),
                      );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

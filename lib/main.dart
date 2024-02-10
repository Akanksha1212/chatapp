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
                      final message = Message.fromFirestore(snapshot.data!
                          .docs[idx] as DocumentSnapshot<Map<String, dynamic>>);
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

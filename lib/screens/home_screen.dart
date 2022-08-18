import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/screens/login_screen.dart';
import 'package:note_app/screens/note_add_screen.dart';
import 'package:note_app/screens/note_detailed_view.dart';
import 'package:note_app/style/app_style.dart';
import 'package:note_app/widgets/notes_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void showSnackBarText(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.mainColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppStyle.mainColor,
        title: Text(
          'Your Notes',
          style: AppStyle.appBarText,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().catchError(
                    (e) =>
                        showSnackBarText('Error while logging out', Colors.red),
                  );
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (o) => const LoginScreen(),
                  ),
                  (route) => false);
              showSnackBarText('Logged out successfully', Colors.green);
            },
            child: const Text(
              'Log out',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .collection("notes")
                    .orderBy("creation_date", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data?.docs == null ||
                      snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'Add a note',
                        style: AppStyle.blackText17,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    return GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      children: snapshot.data!.docs
                          .map(
                            (note) => noteCard(() {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => NoteReaderScreen(
                                    doc: note,
                                    snapshot: note,
                                  ),
                                ),
                              );
                            }, note, context, note),
                          )
                          .toList(),
                    );
                  }
                  return const Text(
                    "There's no notes",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => const NoteEditorScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

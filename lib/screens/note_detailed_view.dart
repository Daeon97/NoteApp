// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:note_app/database/database.dart';
// import 'package:note_app/style/app_style.dart';

// class NoteReaderScreen extends StatefulWidget {
//   const NoteReaderScreen({Key? key, required this.doc, this.snapshot})
//       : super(key: key);
// final QueryDocumentSnapshot doc;
// final DocumentSnapshot? snapshot;
//   @override
//   State<NoteReaderScreen> createState() => _NoteReaderScreenState();
// }

// class _NoteReaderScreenState extends State<NoteReaderScreen> {
//   @override
//   Widget build(BuildContext context) {
// int colorId = widget.doc['color_id'];
//     return Scaffold(
//       backgroundColor: AppStyle.cardColors[colorId],
// appBar: AppBar(
//   iconTheme: const IconThemeData(
//     color: Colors.black,
//   ),
//   actions: [
//     IconButton(
//         onPressed: () {
//           showPopUp();
//         },
//         icon: const Icon(Icons.delete_outline))
//   ],
//   backgroundColor: AppStyle.cardColors[colorId],
//   elevation: 0,
// ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 widget.doc['note_title'],
//                 style: AppStyle.mainTitle,
//               ),
//               const SizedBox(
//                 height: 8,
//               ),
//               Text(
//                 widget.doc['creation_date'],
//                 style: AppStyle.date,
//               ),
//               const SizedBox(
//                 height: 28,
//               ),
//               Text(
//                 widget.doc['note_content'],
//                 style: AppStyle.mainContent,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

// void showPopUp() {
//   showDialog(
//     context: context,
//     builder: (ctx) => AlertDialog(
//       title: const Text('Are you sure ?'),
//       content: const Text('Do you want to delete the note ?'),
//       actions: [
//         TextButton(
//           onPressed: () async {
//             await DataBase()
//                 .deleteNote(id: widget.snapshot!.id, context: context);
//             if (!mounted) {}
//             ScaffoldMessenger.of(ctx).showSnackBar(
//               const SnackBar(
//                 backgroundColor: Colors.green,
//                 content: Text('Note deleted successfully'),
//               ),
//             );
//           },
//           child: const Text('Yes'),
//         ),
//         TextButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: const Text('No'),
//         ),
//       ],
//     ),
//   );
// }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/database/database.dart';
import 'package:note_app/style/app_style.dart';

class NoteReaderScreen extends StatefulWidget {
  const NoteReaderScreen({Key? key, required this.doc, this.snapshot})
      : super(key: key);
  final QueryDocumentSnapshot doc;
  final DocumentSnapshot? snapshot;
  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  late TextEditingController _titleController;
  late TextEditingController _mainController;

  String date = DateFormat.yMd().add_jm().format(DateTime.now());

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.doc['note_title']);
    _mainController = TextEditingController(text: widget.doc['note_content']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int colorId = widget.doc['color_id'];
    return Scaffold(
      backgroundColor: AppStyle.cardColors[colorId],
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
              onPressed: () {
                showPopUp();
              },
              icon: const Icon(Icons.delete_outline))
        ],
        backgroundColor: AppStyle.cardColors[colorId],
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                onFieldSubmitted: (newValue) {
                  DataBase().updateNote(
                      context: context,
                      id: widget.snapshot!.id,
                      newTitle: _titleController.text,
                      newDate: date,
                      newColorId: colorId,
                      newContent: _mainController.text);
                  // FirebaseFirestore.instance.collection("notes").add({
                  //   "note_title": newValue,
                  //   "creation_date": date,
                  //   "color_id": colorId,
                  //   "note_content": _mainController.text
                  // }).catchError(
                  //   (error) => print("Failed to add new note due to $error"),
                  // );
                },
                controller: _titleController,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Enter Note title ..'),
                style: AppStyle.mainTitle,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                widget.doc['creation_date'],
                style: AppStyle.date,
              ),
              const SizedBox(
                height: 28,
              ),
              TextFormField(
                controller: _mainController,
                onFieldSubmitted: (newValue) {
                  DataBase().updateNote(
                      context: context,
                      id: widget.snapshot!.id,
                      newTitle: _titleController.text,
                      newDate: date,
                      newColorId: widget.doc['color_id'],
                      newContent: _mainController.text);
                  // FirebaseFirestore.instance.collection("notes").add({
                  //   "note_title": _titleController.text,
                  //   "creation_date": date,
                  //   "color_id": colorId,
                  //   "note_content": newValue
                  // }).catchError(
                  //   (error) => print("Failed to add new note due to $error"),
                  // );
                },
                keyboardType: TextInputType.name,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Note content',
                ),
                style: AppStyle.mainContent,
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: Colors.indigo,
      //   label: const Text('Save'),
      //   icon: const Icon(Icons.save),
      //   onPressed: () async {
      //     FirebaseFirestore.instance.collection("notes").add({
      //       "note_title": _titleController.text,
      //       "creation_date": date,
      //       "color_id": colorId,
      //       "note_content": _mainController.text
      //     }).then(
      //       (value) {
      //         Navigator.of(context).pop();
      //       },
      //     ).catchError(
      //       (error) => print("Failed to add new note due to $error"),
      //     );
      //   },
      // ),
    );
  }

  void showPopUp() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure ?'),
        content: const Text('Do you want to delete the note ?'),
        actions: [
          TextButton(
            onPressed: () async {
              await DataBase()
                  .deleteNote(id: widget.snapshot!.id, context: context);
              if (!mounted) {}
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Note deleted successfully'),
                ),
              );
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: invalid_return_type_for_catch_error, avoid_print

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/style/app_style.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({Key? key}) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  int colorId = Random().nextInt(AppStyle.cardColors.length);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _mainController = TextEditingController();
  final _key = GlobalKey<FormState>();
  String date = DateFormat.yMd().add_jm().format(
        DateTime.now(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.cardColors[colorId],
      appBar: AppBar(
        backgroundColor: AppStyle.cardColors[colorId],
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        title: const Text(
          'Add new note',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  // onFieldSubmitted: (newValue) {
                  //   FirebaseFirestore.instance.collection("notes").add({
                  //     "note_title": newValue,
                  //     "creation_date": date,
                  //     "color_id": colorId,
                  //     "note_content": _mainController.text
                  //   }).catchError(
                  //     (error) => print("Failed to add new note due to $error"),
                  //   );
                  // },
                  controller: _titleController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Note title ..'),
                  style: AppStyle.mainTitle,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  date,
                  style: AppStyle.date,
                ),
                const SizedBox(
                  height: 28,
                ),
                TextFormField(
                  controller: _mainController,
                  // onFieldSubmitted: (newValue) {
                  //   FirebaseFirestore.instance.collection("notes").add({
                  //     "note_title": _titleController.text,
                  //     "creation_date": date,
                  //     "color_id": colorId,
                  //     "note_content": newValue
                  //   }).catchError(
                  //     (error) => print("Failed to add new note due to $error"),
                  //   );
                  // },
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        label: const Text('Save'),
        icon: const Icon(Icons.save),
        onPressed: () {
          FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection("notes")
              .add({
            "note_title": _titleController.text,
            "creation_date": date,
            "color_id": colorId,
            "note_content": _mainController.text
          }).catchError(
            (error) => print("Failed to add new note due to $error"),
          );
          Navigator.pop(context);
        },
      ),
    );
  }
}

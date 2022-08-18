import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/screens/home_screen.dart';

class DataBase {
  final fireStoreInstance = FirebaseFirestore.instance;
  final fireStoreCollection = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("notes");

  Future<void> addUser({
    required String mobileNumber,
    required String userName,
  }) async {
    fireStoreInstance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("user_info")
        .add(
      {
        "mobile_number": mobileNumber,
        "user_name": userName,
      },
    );
  }

  Future<void> deleteNote(
      {required String id, required BuildContext context}) async {
    fireStoreCollection.doc(id).delete().catchError((e) => log(e));
    Navigator.pushAndRemoveUntil(
        context,
        (MaterialPageRoute(
          builder: (a) => const HomeScreen(),
        )),
        (route) => false);
  }

  Future<void> updateNote({
    required String id,
    required BuildContext context,
    required String newTitle,
    required String newDate,
    required int newColorId,
    required String newContent,
  }) async {
    fireStoreCollection.doc(id).update({
      "note_title": newTitle,
      "creation_date": newDate,
      "color_id": newColorId,
      "note_content": newContent,
    }).catchError((e) => log(e));
    Navigator.pushAndRemoveUntil(
        context,
        (MaterialPageRoute(
          builder: (a) => const HomeScreen(),
        )),
        (route) => false);
  }
}

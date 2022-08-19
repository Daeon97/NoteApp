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
        .set(
      {
        "mobile_number": mobileNumber,
        "user_name": userName,
      },
    );
  }

  // this function checks if the user already exists
  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> userExists({
    required String mobileNumber,
  }) async {
    var querySnapshot = await fireStoreInstance
        .collection("users")
        .where("mobile_number", isEqualTo: mobileNumber)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs[0];
    } else {
      return null;
    }
  }

// this function checks if the username matches
// this will ensure that the user enters his
// correct username
  Future<bool> userNameMatches({
    required QueryDocumentSnapshot<Map<String, dynamic>> queryDocumentSnapshot,
    required String userName,
  }) async {
    if (queryDocumentSnapshot.data()["user_name"] == userName) {
      return true;
    } else {
      return false;
    }
  }

  // this function checks if the username is already taken
  // this will ensure that each user has a unique username
  Future<bool> userNameTaken({
    required String mobileNumber,
    required String userName,
  }) async {
    var querySnapshot = await fireStoreInstance
        .collection("users")
        .where("mobile_number", isNotEqualTo: mobileNumber)
        .where("user_name", isEqualTo: userName)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
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

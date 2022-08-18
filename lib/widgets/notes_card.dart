// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app/database/database.dart';
import 'package:note_app/style/app_style.dart';

Widget noteCard(Function()? onTap, QueryDocumentSnapshot doc,
    BuildContext context, DocumentSnapshot? snapshot) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppStyle.cardColors[doc["color_id"]],
        borderRadius: BorderRadius.circular(
          8,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doc['note_title'] == '' ? 'No Title' : doc['note_title'],
                style: AppStyle.mainTitle,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                doc['creation_date'],
                style: AppStyle.date,
              ),
              const SizedBox(
                height: 14,
              ),
              Text(
                doc['note_content'] == '' ? 'No content' : doc['note_content'],
                style: AppStyle.mainContent,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Are you sure ?'),
                    content: const Text('Do you want to delete the note ?'),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          await DataBase()
                              .deleteNote(id: snapshot!.id, context: context);
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(
                              duration: Duration(seconds: 1),
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
              },
              icon: const Icon(Icons.delete))
        ],
      ),
    ),
  );
}

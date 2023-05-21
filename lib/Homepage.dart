import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                final storageRef = FirebaseStorage.instance.ref();
                final imagesRef = storageRef.child("images");
                final spaceRef = storageRef.child("images/ocean.jpg");

                Directory appDocDir = await getApplicationDocumentsDirectory();
                String filePath = '${appDocDir.absolute}/ocean.jpg';
                File file = File(filePath);

                try {
                  await spaceRef.putFile(file);
                  print('Image uploaded successfully.');
                } catch (e) {
                  print('Error uploading image: $e');
                }
              },
              child: const Text('Upload image'),
            ),
          ],
        ),
      ),
    );
  }
}

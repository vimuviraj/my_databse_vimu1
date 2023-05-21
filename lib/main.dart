import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mydata_exp1/Homepage.dart';
import 'package:mydata_exp1/image.dart';
import 'package:path_provider/path_provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  get images => null;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        "Home": (context) => const MyWidget(),
        "images": (context) => ImageGet(images: images)
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {});
  }

  String imageUrl = '';
  List<String> images = [];
  Future<List<String>> getImagesFromFirestore() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('images').get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('url')) {
          String imageUrl = data['url'].toString();
          images.add(imageUrl);
        }
      }
      print('images get successfully');
    } catch (e) {
      print('Error retrieving images from Firestore: $e');
    }

    return images;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
                onPressed: () async {
                  //pick images
                  ImagePicker imagePicker = ImagePicker();
                  XFile? file =
                      await imagePicker.pickImage(source: ImageSource.camera);
                  print('${file?.path}');

                  if (file == null) return;
                  String uniqueFileName =
                      DateTime.now().microsecondsSinceEpoch.toString();

                  //get a reference to storage root
                  Reference referenceRoot = FirebaseStorage.instance.ref();
                  Reference referenceDirImges = referenceRoot.child('images');

                  // create a reference for the image to be stored
                  Reference referenceImagToUpload =
                      referenceDirImges.child(uniqueFileName);
                  try {
                    // Retrieve the collection 'images' from Firestore

                    //store the file
                    await referenceImagToUpload.putFile(File(file.path));
                    //success: get the download url
                    imageUrl = await referenceImagToUpload.getDownloadURL();

                    // Save the download URL in Firestore
                    await FirebaseFirestore.instance
                        .collection('images')
                        .doc(uniqueFileName)
                        .set({'url': imageUrl});

                    print('sucessfully upoaded');
                  } catch (e) {
                    print('Error uploading image: $e');
                  }
                },
                child: const Text('UPLOAD IMAGES')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  await getImagesFromFirestore();
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageGet(images: images)));
                },
                child: const Text('dowanlaod image')),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

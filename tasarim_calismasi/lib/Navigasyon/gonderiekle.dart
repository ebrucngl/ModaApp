import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    );
  }
}

class Gonderi extends StatefulWidget {
  @override
  _GonderiState createState() => _GonderiState();
}

class _GonderiState extends State<Gonderi> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> _upload(String inputSource) async {
    final picker = ImagePicker();
    PickedFile pickedImage;
    try {
      pickedImage = await picker.getImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920);

      final String fileName = path.basename(pickedImage.path);
      File imageFile = File(pickedImage.path);
      firebase_storage.SettableMetadata metadata =
          firebase_storage.SettableMetadata(customMetadata: <String, String>{
        'uploaded_by': '@kullaniciadi',
        'description': 'Açıklama'
      });

      try {
        await firebase_storage.FirebaseStorage.instance
            .ref(fileName)
            .putFile(imageFile, metadata);

        setState(() {});
      } on FirebaseException catch (error) {
        print(error);
      }
    } catch (err) {
      print(err);
    }
  }

  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];

    final firebase_storage.ListResult result = await storage.ref().list();
    final List<firebase_storage.Reference> allFiles = result.items;

    await Future.forEach<firebase_storage.Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final firebase_storage.FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "uploaded_by": fileMeta.customMetadata['uploaded_by'],
        "description": fileMeta.customMetadata['description']
      });
    });
    return files;
  }

  Future<void> _delete(String ref) async {
    await storage.ref(ref).delete();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        title: Text('Yeni Gönderi'),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.grass),
            onPressed: () {},
          );
        }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.teal[200])),
                  onPressed: () => _upload('camera'),
                  icon: Icon(Icons.camera_alt_outlined),
                  label: Text('Kamera'),
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.teal[200])),
                  onPressed: () => _upload('gallery'),
                  icon: Icon(Icons.folder),
                  label: Text('Galeri'),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: _loadImages(),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        final image = snapshot.data[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            dense: false,
                            leading: Image.network(image['url']),
                            title: Text(image['uploaded_by']),
                            subtitle: Text(image['description']),
                            trailing: IconButton(
                              onPressed: () => _delete(image['path']),
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

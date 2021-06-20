import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:tasarim_calismasi/Navigasyon/profil.dart';
import 'package:tasarim_calismasi/Navigasyon/profil2.dart';
import 'package:tasarim_calismasi/anasayfa.dart';
import 'package:tasarim_calismasi/widgets/progress.dart';

class ProfilDuzenle extends StatefulWidget {
  @override
  _ProfilDuzenleState createState() => _ProfilDuzenleState();
}

class _ProfilDuzenleState extends State<ProfilDuzenle> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  void initState() {
    super.initState();
    handleUser();
  }

  Future<String> url;

  DocumentSnapshot user;
  void pickImage() async {
    var randomno = Random(25);
    File imageFile;
    String fotoNo = randomno.nextInt(5000).toString();
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile == null) {
    } else {
      imageFile = File(pickedFile.path);
      await firebase_storage.FirebaseStorage.instance
          .ref(auth.currentUser.uid + '/' + fotoNo)
          .putFile(imageFile);
      await usersRef.doc(auth.currentUser.uid).update({'pp URL': fotoNo});
    }
    handleUser();
  }

  handleUser() async {
    user = await usersRef.doc(auth.currentUser.uid).get();
    String picNo;
    user.data().forEach((key, value) {
      if (key == 'pp URL') {
        picNo = value;
      }
    });
    if (picNo != null) {
      setState(() {
        url = firebase_storage.FirebaseStorage.instance
            .ref(auth.currentUser.uid + '/' + picNo)
            .getDownloadURL();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        title: Text('Profili Düzenle'),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.backspace),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Anasayfa()),
              );
            },
          );
        }),
      ),
      body: Container(
        child: Column(
          children: [
            FutureBuilder(
                future: url,
                builder: (context, snapshot) {
                  Image picImage;
                  if (!snapshot.hasData) {
                    return circularProgress();
                  }
                  picImage = Image.network(snapshot.data);

                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      alignment: Alignment.center,
                      width: 165,
                      height: 165,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: picImage.image,
                        ),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return circularProgress();
                  }

                  return Container();
                }),
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: () async {
                          pickImage();
                        },
                        child: Text('Fotoğraf Seç'),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tasarim_calismasi/Navigasyon/profil2.dart';
import 'package:tasarim_calismasi/Navigasyon/profilduzenle.dart';
import 'package:tasarim_calismasi/Navigasyon/stat_widget.dart';
import 'package:tasarim_calismasi/main.dart';
import 'package:tasarim_calismasi/constants.dart';
import 'package:tasarim_calismasi/Navigasyon/profilduzenle.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final usersRef = FirebaseFirestore.instance.collection('kullanıcılar');
  String photoUrl =
      "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png";

  final String currentUserId = auth.currentUser.uid;
  String postOrientation = "grid";
  bool isFollowing = false;
  bool isLoading = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  Image profilPhoto;
  void choiceAction(String choice) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  void initState() {
    super.initState();
    takipciGoster();
    takipEdilenGoster();
    profilFotogetir();
  }

  Future<Image> getImage(String kullanici) async {
    String picNo;
    Image picImage;
    DocumentSnapshot user;
    user = await usersRef.doc(kullanici).get();
    user.data().forEach((key, value) {
      if (key == 'pp URL') {
        picNo = value;
      }
    });
    if (picNo != null) {
      String url = await firebase_storage.FirebaseStorage.instance
          .ref(kullanici + '/' + picNo)
          .getDownloadURL();

      setState(() {
        if (url != null) photoUrl = url;
      });
      picImage = Image.network(url);
    }
    return picImage;
  }

  profilFotogetir() async {
    profilPhoto = await getImage(auth.currentUser.uid);
  }

  takipciGoster() async {
    QuerySnapshot followers =
        await usersRef.doc(auth.currentUser.uid).collection("followers").get();
    followerCount = followers.size;
  }

  takipEdilenGoster() async {
    QuerySnapshot following =
        await usersRef.doc(auth.currentUser.uid).collection("following").get();
    followingCount = following.size;
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference ref =
        FirebaseFirestore.instance.collection("kullanıcılar");

    return FutureBuilder<DocumentSnapshot>(
      future: ref.doc(auth.currentUser.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Uhh. Somethings went Wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Scaffold(
            appBar: AppBar(
              title: Text('Profil'),
              leading: Builder(builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.grass),
                  onPressed: () {},
                );
              }),
              backgroundColor: Colors.deepPurple[200],
              actions: <Widget>[
                PopupMenuButton<String>(
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context) {
                    return Constant.choices.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            backgroundColor: Colors.white,
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: CircleAvatar(
                    radius: 56,
                    backgroundImage: NetworkImage(photoUrl),
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Text(
                  "${data['userName']}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    statWidget("Gönderi", "$postCount"),
                    statWidget("Takipçi", "$followerCount"),
                    statWidget("Takip", "$followingCount"),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlineButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilDuzenle()));
                      },
                      child: Text("Profili Düzenle"),
                      padding: EdgeInsets.symmetric(
                          horizontal: 100.0, vertical: 8.0),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(
                    height: 18.0,
                    thickness: 0.6,
                    color: Colors.black87,
                  ),
                ),
                Expanded(
                  child: Container(
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            /*decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://i1.sndcdn.com/artworks-tXB4eVVQFGdnsslS-tyNCGQ-t500x500.jpg"),
                        ),
                      ),*/
                          );
                        }),
                  ),
                ),
              ],
            )),
          );
        }
        return Container();
      },
    );
  }
}

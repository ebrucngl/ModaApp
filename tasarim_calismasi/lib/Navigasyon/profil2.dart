import 'package:flutter/material.dart';
import 'package:tasarim_calismasi/Navigasyon/stat_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasarim_calismasi/main.dart';
import 'package:tasarim_calismasi/constants.dart';

String profileID;
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore fb = FirebaseFirestore.instance;
final usersRef = FirebaseFirestore.instance.collection('kullanıcılar');

class Profile extends StatefulWidget {
  Profile(String id) {
    profileID = id;
  }

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profile> {
  final followRef = usersRef.doc(profileID).collection("followers");
  final followingRef = usersRef.doc(profileID).collection("following");
  final followersRef =
      usersRef.doc(auth.currentUser.uid).collection("following");
  String buton = "Takip Et";
  String postOrientation = "grid";
  bool isFollowing = false;
  bool isLoading = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;

  void choiceAction(String choice) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  checkIfFollowing() async {
    DocumentSnapshot doc = await followersRef.doc(profileID).get();
    setState(() {
      isFollowing = doc.exists;
      if (isFollowing)
        buton = "Takibi Bırak";
      else {
        buton = "Takip Et";
      }
    });
  }

  void checkFollow() {
    if (isFollowing) {
      followRef.doc(auth.currentUser.uid).set({"timestamp": DateTime.now()});
      followersRef.doc(profileID).set({"timestamp": DateTime.now()});
      setState(() {
        buton = "Takibi Bırak";
      });
    } else {
      followRef.doc(auth.currentUser.uid).delete();
      followersRef.doc(profileID).delete();
      setState(() {
        buton = "Takip Et";
      });
    }
    getFollowers();
    getFollowing();
  }

  getFollowers() async {
    QuerySnapshot snapshot = await followRef.get();
    setState(() {
      followerCount = snapshot.size;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef.get();
    setState(() {
      followingCount = snapshot.size;
    });
  }

  CollectionReference ref =
      FirebaseFirestore.instance.collection("kullanıcılar");
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: ref.doc(profileID).get(),
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
              backgroundColor: Colors.deepPurple[200],
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
                      /*backgroundImage: NetworkImage(
                  "https://pbs.twimg.com/profile_images/1338126191824343042/eDFzNPfQ.jpg"),*/
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
                          isFollowing
                              ? isFollowing = false
                              : isFollowing = true;
                          checkFollow();
                        },
                        child: Text(buton),
                        padding: EdgeInsets.symmetric(
                            horizontal: 60.0, vertical: 8.0),
                      ),
                      OutlineButton(
                        onPressed: () {},
                        child: Text("Mesaj"),
                        padding: EdgeInsets.symmetric(
                            horizontal: 60.0, vertical: 8.0),
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}

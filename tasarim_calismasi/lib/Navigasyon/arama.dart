import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tasarim_calismasi/Navigasyon/profil2.dart';
import 'package:tasarim_calismasi/widgets/progress.dart';
import 'package:tasarim_calismasi/models/user.dart';

final usersRef = FirebaseFirestore.instance.collection('kullanıcılar');

class Arama extends StatefulWidget {
  @override
  _AramaState createState() => _AramaState();
}

class _AramaState extends State<Arama> {
  Future<QuerySnapshot> searchResultsFuture;
  TextEditingController searchController = TextEditingController();
  handleSearch(var query) {
    Future<QuerySnapshot> usersCollection =
        usersRef.where('userName', isGreaterThanOrEqualTo: query).get();
    setState(() {
      searchResultsFuture = usersCollection;
    });
  }

  clearSearch() {
    searchController.clear();
  }

  buildSearchResults() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<UserResult> searchResults = [];

        final users = snapshot.data.docs.map((doc) {
          User user = User.fromDocument(doc);
          UserResult searchResult = UserResult(user);
          searchResults.add(searchResult);
        }).toList();
        print(users);

        return ListView(
          children: searchResults,
        );
      },
    );
  }

  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Colors.deepPurple[200],
      title: Container(
        margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(50, 255, 255, 255),
          borderRadius: BorderRadius.all(Radius.circular(14.0)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Ara..",
                    hintStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: clearSearch,
                    )),
                onChanged: (value) => handleSearch(value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildNoContent() {
    return Container(
      child: GridView.count(
        crossAxisCount: 3,
        padding: EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 5),
        children: [
          Card(
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 40, top: 40),
            color: Colors.teal[100],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text('GÜNLÜK'),
            ),
          ),
          Card(
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 40, top: 40),
            color: Colors.teal[100],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text('SPOR'),
            ),
          ),
          Card(
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 40, top: 40),
            color: Colors.teal[100],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text('DAVET'),
            ),
          ),
          Card(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://i.pinimg.com/originals/77/a2/a7/77a2a78bbba57e75666e91b07803028e.jpg"),
                  )),
            ),
          ),
          Card(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(
                    "https://i.pinimg.com/originals/c2/d8/14/c2d814a0bcb0333f6886422053bb2c49.jpg"),
              )),
            ),
          ),
          Card(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(
                    "https://image.freepik.com/free-vector/flat-ivector-illustration-portrait-fashion-girl-minimalistic-trendy-style_102887-570.jpg"),
              )),
            ),
          ),
          Card(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(
                    "https://i.pinimg.com/originals/c8/58/75/c85875054f9192e1ef2467a6e798575b.jpg"),
              )),
            ),
          ),
          Card(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(
                    "https://i.pinimg.com/originals/a4/88/93/a488930492d2df3449fd0bd239469cc6.jpg"),
              )),
            ),
          ),
          Card(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(
                    "https://i.pinimg.com/originals/7d/54/20/7d5420aa99fc54cf43b17b14f047fe52.jpg"),
              )),
            ),
          ),
          Card(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(
                    "https://i.pinimg.com/originals/cc/62/2c/cc622ca2a9fcf9105ad58691e1c372d7.jpg"),
              )),
            ),
          ),
          Card(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(
                    "https://i.pinimg.com/736x/af/41/2d/af412dbf97620c7fbe2145c15b8ba6cb.jpg"),
              )),
            ),
          ),
          Card(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(
                    "https://i.pinimg.com/originals/32/f3/41/32f3416864f44ed9c03466d5372adcda.jpg"),
              )),
            ),
          ),
          Card(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(
                    "https://i.pinimg.com/originals/f5/a6/a7/f5a6a73b1a306b9f0969772223474154.jpg"),
              )),
            ),
          ),
          Card(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(
                    "https://i.pinimg.com/originals/f4/86/2c/f4862cb8a4f2bee5e2c6a7d5dbfb45ab.jpg"),
              )),
            ),
          ),
          Card(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(
                    "https://i.pinimg.com/564x/95/09/dc/9509dc176720bed1d09466d6fa2fbc4e.jpg"),
              )),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchField(),
      body:
          searchResultsFuture == null ? buildNoContent() : buildSearchResults(),
    );
  }
}

class UserResult extends StatelessWidget {
  final User user;

  UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => Profile(user.id))),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
              ),
              title: Text(
                user.displayName,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user.username,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}

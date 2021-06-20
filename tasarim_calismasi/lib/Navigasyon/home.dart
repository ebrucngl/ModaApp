import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        title: Text('Anasayfa'),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.grass),
            onPressed: () {},
          );
        }),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            itemPost(),
          ],
        ),
      ),
    );
  }

  Widget itemPost() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  /*image: DecorationImage(
                  image: NetworkImage(''),
                ),*/
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    width: 3,
                    color: Colors.black,
                  ),
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'ebrucengel7',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Image.network(
          'https://i.pinimg.com/originals/13/19/d2/1319d248eae3a1fef88fc9e397a4f6ed.jpg',
          height: 280,
          width: 380,
          fit: BoxFit.cover,
        ),
        Row(
          children: [
            new IconButton(
              icon: Icon(
                Icons.thumb_up_off_alt,
                color: Colors.black,
                size: 38.0,
              ),
              onPressed: null,
            ),
            new IconButton(
              icon: Icon(
                Icons.thumb_down_off_alt,
                color: Colors.black,
                size: 38.0,
              ),
              onPressed: null,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '10b beğeni',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          child: RichText(
            text: TextSpan(style: TextStyle(color: Colors.black), children: [
              TextSpan(
                text: 'ebrucengel7',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' Açıklama'),
            ]),
          ),
        ),
      ],
    );
  }
}

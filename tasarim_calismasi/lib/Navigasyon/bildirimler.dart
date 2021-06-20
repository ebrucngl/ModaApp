import 'package:flutter/material.dart';

class Bildirimler extends StatefulWidget {
  @override
  _BildirimlerState createState() => _BildirimlerState();
}

class _BildirimlerState extends State<Bildirimler> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        title: Text('Bildirimler'),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.grass),
            onPressed: () {},
          );
        }),
      ),
      body: Center(
        child: Text("Bildirimler"),
      ),
    );
  }
}

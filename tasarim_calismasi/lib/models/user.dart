import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String email;

  final String displayName;

  User({this.id, this.username, this.email, this.displayName});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['userUid'],
      email: doc['email'],
      username: doc['userName'],
      displayName: doc['userName'],
    );
  }
}

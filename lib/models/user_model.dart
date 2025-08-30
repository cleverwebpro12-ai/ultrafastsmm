import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final double balance;
  final String apiKey;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.balance,
    required this.apiKey,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      balance: (data['balance'] ?? 0.0).toDouble(),
      apiKey: data['apiKey'] ?? '',
    );
  }
}

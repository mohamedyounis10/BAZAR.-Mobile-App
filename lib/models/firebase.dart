import 'package:cloud_firestore/cloud_firestore.dart';

class Firebase_app {
  // Private constructor
  Firebase_app._internal();

  // Single instance of FirebaseApp
  static final Firebase_app _instance = Firebase_app._internal();

  // Factory constructor to return the single instance
  factory Firebase_app() => _instance;

  // Firebase Firestore CollectionReference
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Add any other properties or methods you need
  String id = '';
}

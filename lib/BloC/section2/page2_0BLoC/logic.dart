import 'package:bazarapp/pages/section2/page2_1.dart';
import 'package:bazarapp/pages/section4/booklistscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'state.dart';
import 'package:bazarapp/models/firebase.dart';

class Page2_0Logic extends Cubit<Page2_0state> {
  Page2_0Logic() : super(Initstate());

  Firebase_app obj = Firebase_app();
  bool showPassword = true;

  void togglePasswordVisibility() {
    showPassword = !showPassword;
    emit(TogglePasswordVisibilityState(showPassword: showPassword));
  }

  // Sign in with email and password by checking Firestore manually
  Future<void> signin(BuildContext context, String email, String pass) async {
    try {
      // Query Firestore for all users where email matches
      QuerySnapshot querySnapshot = await obj.users.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document if the email exists in Firestore
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Get the user data from the document
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Compare the password from Firestore with the provided one
        if (userData['password'] == pass) {
          // Assign the user's Firestore document ID
          obj.id = userDoc.id;
          print("User ID from Firestore: ${obj.id}");

          // Navigate to the BookListScreen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (c) => BookListScreen()),
          );
        } else {
          // Password does not match
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Incorrect password.")),
          );
        }
      } else {
        // Email does not exist in Firestore
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User email does not exist in Database.")),
        );
      }
    } catch (e) {
      // Handle any other types of exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    }

    // Emit the signin state to notify listeners
    emit(Signin());
  }
  
  // Sign in with Google
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        User? user = userCredential.user;

        if (user != null) {
          QuerySnapshot querySnapshot = await obj.users.where('email', isEqualTo: user.email).get();

          if (querySnapshot.docs.isNotEmpty) {
            DocumentSnapshot userDoc = querySnapshot.docs.first;
            obj.id = userDoc.id;
            print("User ID from Firestore: ${obj.id}");

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (c) => BookListScreen()),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (c) => Page2_1(
                emaill: user.email ?? '',
                namee: user.displayName ?? '',
              )),
            );
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    }
    emit(SignInWithGoogle());
  }

}

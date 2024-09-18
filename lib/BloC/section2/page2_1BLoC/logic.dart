import 'package:bazarapp/BloC/section2/page2_1BLoC/state.dart';
import 'package:bazarapp/pages/section2/verification_codeemail.dart';
import 'package:bloc/bloc.dart';
import 'package:bazarapp/models/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';

class Page2_1Logic extends Cubit<Page2_1state> {
  Page2_1Logic() :super(Initstate());

  bool isLengthValid = false;
  bool isNumberValid = false;
  bool isLetterValid = false;
  bool hasStartedTyping = false;

  Firebase_app obj = Firebase_app();
  EmailOTP myauth = EmailOTP();

  bool showPassword = true;

  void togglePasswordVisibility(){
    showPassword = !showPassword;
    emit(TogglePasswordVisibilityState(showPassword: showPassword));
  }

  // Email verify
  Future<bool> isEmailExists(String email) async {
    EmailOTP.config(
      appName: 'Bazar. App',
      otpType: OTPType.numeric,
      expiry: 60000,
      emailTheme: EmailTheme.v4,
      appEmail: 'BazarApp@gmail.com',
      otpLength: 4,
    );
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print("Failed to check email existence: $e");
      return false;
    }
  }

  // add user in firebase
  Future<void> addUser({required String name, required String email, required String pass}) async {
    try {
      DocumentReference docRef = await obj.users.add({
        'fullname': name,
        'email': email,
        'password': pass,

      });

      String documentId = docRef.id;
      await docRef.update({'id': documentId});

      obj.id = documentId;
      print('User added with document ID: $documentId');
      print(obj.id);
    } catch (error) {
      print("Failed to add user: $error");
    }
  }

  void register(BuildContext context ,String name, String email, String pass)async {
    if (await isEmailExists(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email already exists")),
      );
    } else {
      if (await EmailOTP.sendOTP(email: email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP has been sent")),
        );

        await addUser(
          name: name,
          email: email,
          pass: pass,
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (c) {
              return VerificationCodeEmail(
                userId: obj.id,
                myauth: myauth,
              );
            },
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP failed to send")),
        );
      }
    }
    emit(Register());
  }

  // check validate of password
  void validatePassword(String value) {
      hasStartedTyping = true;
      isLengthValid = value.length >= 8;
      isNumberValid = value.contains(RegExp(r'[0-9]'));
      isLetterValid = value.contains(RegExp(r'[A-Za-z]'));
      emit(ValidatePassword());
  }

}
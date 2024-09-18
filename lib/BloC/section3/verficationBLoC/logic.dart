import 'package:bazarapp/pages/section3/forgetpassword.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bazarapp/models/firebase.dart';
import 'package:bazarapp/BloC/section3/verficationBLoC/state.dart';

class VerficationLogic3 extends Cubit<Verficationstate>{

  VerficationLogic3() : super(Initstate());

  // Data
  Firebase_app obj=Firebase_app();
  String enteredOtp = '';  // Variable to store OTP
  String email='';

  Future<void> getEmailByUid() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users').where('uid', isEqualTo: obj.id).get();

      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data()as Map<String, dynamic>;
        email = data['email'] as String? ?? '';
      } else {
        print("No user found with the given UID.");
      }
    } catch (e) {
      print("Error getting email: $e");
    }
    emit(GetEmailByUid());
  }

  Future<void> verifyOTP(BuildContext context) async {
    try {
      // Verify the OTP using the `myauth` instance
      bool isVerified = await EmailOTP.verifyOTP(otp: enteredOtp);  // Call verifyOTP method on myauth instance

      if (isVerified) {
        print("OTP Verified Successfully!");
        print(FirebaseAuth.instance.currentUser?.uid ?? 'No user signed in');
        print(obj.id);

        // OTP is valid, navigate to the next screen or perform further actions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("OTP Verified Successfully!"),
          ),
        );

        Navigator.of(context).push(
            MaterialPageRoute(builder: (c){
              return NewPasswordScreen();
            })
        );

      } else {
        // OTP is invalid
        print("Invalid OTP! Please try again.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid OTP! Please try again."),
          ),
        );
      }
    } catch (e) {
      print("Error verifying OTP: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error verifying OTP. Please try again."),
        ),
      );
    }
    emit(VerifyOTP());
  }

  Future<void> resendOTP(BuildContext context) async {
    try {
      bool isSent = await EmailOTP.sendOTP(email: email);
      if (isSent) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("OTP has been resent successfully!"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to resend OTP. Please try again."),
          ),
        );
      }
    } catch (e) {
      print("Error resending OTP: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error resending OTP. Please try again."),
        ),
      );
    }
    emit(ResendOTP());
  }

}
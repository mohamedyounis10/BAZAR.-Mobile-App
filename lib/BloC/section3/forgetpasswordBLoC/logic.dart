import 'package:bazarapp/BloC/section3/forgetpasswordBLoC/state.dart';
import 'package:bazarapp/models/firebase.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Forgetpasswordlogic extends Cubit<Forgetpasswordstate> {

  Forgetpasswordlogic() : super(Initstate());

  Firebase_app obj=Firebase_app();

  bool isLengthValid = false;
  bool isNumberValid = false;
  bool isLetterValid = false;
  bool hasStartedTyping = false;

  bool show1 = true;
  bool show2 = true;


  void togglePasswordVisibility1() {
    show1 = !show1;
    emit(TogglePasswordVisibilityState1(show1: show1));
  }

  void togglePasswordVisibility2() {
    show1 = !show2;
    emit(TogglePasswordVisibilityState2(show2: show2));
  }

  // update Password
  Future<void> updatePassword( String password) async {
    try {
      // Get the current authenticated user
      User? user = FirebaseAuth.instance.currentUser;

      // Check if the user is not null (i.e., the user is signed in)
      if (user != null) {
        // Update the password
        await user.updatePassword(password);
        print("Password updated successfully");
      } else {
        print("No user is signed in");
      }
    } catch (e) {
      print(e.toString());
    }
    try {
      // Get a reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get a reference to the user document using the UID
      DocumentReference userDoc = firestore.collection('users').doc(obj.id);

      // Update the phone number field
      await userDoc.update({
        'password': password, // Add or update the phoneNumber field
      });

      print('Phone number updated successfully.');
    } catch (e) {
      print('Failed to update phone number: $e');
    }
    emit(UpdatePassword());
  }

  // validate Password
  void validatePassword(String value) {
      hasStartedTyping = true;
      isLengthValid = value.length >= 8;
      isNumberValid = value.contains(RegExp(r'[0-9]'));
      isLetterValid = value.contains(RegExp(r'[A-Za-z]'));
      emit(ValidityPassword());
  }

}
import 'package:bazarapp/models/firebase.dart';
import 'package:bazarapp/pages/section2/successverification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Phonenumber extends StatelessWidget {
  // Data
  TextEditingController phonenumber = TextEditingController();
  Firebase_app obj = Firebase_app();
  FirebaseAuth auth = FirebaseAuth.instance;

  // Function
  Future<void> addPhoneNumber( String phoneNumber) async {
    try {
      // Get a reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get a reference to the user document using the UID
      DocumentReference userDoc = firestore.collection('users').doc(obj.id);

      // Update the phone number field
      await userDoc.update({
        'phonenumber': phoneNumber, // Add or update the phoneNumber field
      });

      print('Phone number updated successfully.');
    } catch (e) {
      print('Failed to update phone number: $e');
    }
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),

            // Phone number
            Column(
              children: [
                Text(
                  "Phone Number",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Please enter your phone number, so we can",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "more easily deliver your order",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Phone number input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Phone Number",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Container(
                  width: 327,
                  height: 56,
                  color: Color(0xFFF5F5F5),
                  child: TextFormField(
                    controller: phonenumber,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Color(0xFF54408C),
                      ),
                      hintText: 'Your Phone Number',
                      hintStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // Continue
            Container(
              width: 327,
              height: 56,
              child: MaterialButton(
                onPressed: () {
                  addPhoneNumber(phonenumber.text);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return Successverification(); // change after test
                    }),
                  );
                },
                color: Color(0xFF54408C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:bazarapp/models/firebase.dart';
import 'package:bazarapp/pages/section2/page2_0.dart';
import 'package:bazarapp/pages/section3/verification_codeemail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';

class Page3_1 extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final EmailOTP emailOTP = EmailOTP();
  Firebase_app obj = Firebase_app(); // Ensure this is defined correctly

  Future<String?> getUserIdByEmail(String email) async {

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

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.id; // Return the document ID
      } else {
        return null; // Return null if no document is found
      }
    } catch (e) {
      print("Failed to get user ID: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),  // Back button
          onPressed: () {
            Navigator.of(context).pop();  // Navigate back
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,  // Transparent AppBar with no shadow
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),  // Add horizontal padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reset Password',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),

            Text(
              'Please enter your email, we will send a verification code to your email.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 32),

            Text(
              'Email',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),

            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'example@email.com',
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 32),

            Center(
              child: Container(
                width: 327,
                height: 56,
                child: MaterialButton(
                  onPressed: () async {
                    final email = emailController.text;
                    final userId = await getUserIdByEmail(email);
                    if (userId != null) {
                      try {
                        obj.id = userId; // Set obj.id to the retrieved user ID

                        // Replace with your method to send OTP
                        if (await EmailOTP.sendOTP(email: email)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("OTP has been sent")),
                          );

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return VerificationCodeEmail(
                                  userId: obj.id, // Pass obj.id to the next screen
                                  myauth: emailOTP,
                                );
                              },
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("OTP failed to send")),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error sending OTP: $e")),
                        );
                      }
                    } else {
                      // If email is not found, pop the current page and return to the previous one
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Email not found")),
                      );
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (c){
                            return Page2_0();
                          })); // Navigate back to the previous page
                    }
                  },
                  color: Color(0xFF54408C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Text(
                    'Send',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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

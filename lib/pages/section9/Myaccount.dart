import 'package:bazarapp/models/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Myaccount extends StatefulWidget {

  @override
  _MyaccountState createState() => _MyaccountState();
}

class _MyaccountState extends State<Myaccount> {

  // Data
  Firebase_app obj = Firebase_app(); // Updated to use singleton
  bool showPassword = true;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();

    // Fetch user data
    fetchUserData();
  }

  // Functions
   // fetchUserData
  Future<void> fetchUserData() async {
    try {
      // Debugging: Check if obj.id is set correctly
      print("Fetching data for user ID: ${obj.id}");

      // Get user document from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(obj.id).get();

      if (userDoc.exists) {
        // Set text field values
        var userData = userDoc.data() as Map<String, dynamic>;
        print("User data fetched: $userData"); // Debugging: Print fetched data
        setState(() {
          nameController.text = userData['fullname'] ?? '';
          emailController.text = userData['email'] ?? '';
          phoneController.text = userData['phonenumber'] ?? '';
          passwordController.text = userData['password'] ?? '';
        });
      } else {
        print("No such document!"); // Debugging: Document not found
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user data: $e')),
      );
    }
  }

   // updateUserData
  Future<void> updateUserData() async {
    try {
      // Get the current authenticated user
      User? user = FirebaseAuth.instance.currentUser;

      // Check if the user is not null (i.e., the user is signed in)
      if (user != null) {
        // Update the password
        await user.updatePassword(passwordController.text);
        print("Password updated successfully");
      } else {
        print("No user is signed in");
      }
    } catch (e) {
      print(e.toString());
    }
    try {
      // Get the current user data from controllers
      final updatedData = {
        'fullname': nameController.text,
        'email': emailController.text,
        'phonenumber': phoneController.text,
        'password': passwordController.text,
      };

      // Update user document in Firestore
      await FirebaseFirestore.instance.collection('users').doc(obj.id).update(updatedData);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User data updated successfully')),
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update user data: $e')),
      );
    }
  }

  // Ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text('My Account', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
           Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // profile image
              Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/img_2.png',),
                  radius: 45,
                ),
              ),

              // name
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name",
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
                      controller: nameController,
                      keyboardType: TextInputType.text,
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
                        hintText: 'Your Name',
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
              
              // email
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Email",
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
                      controller: emailController,
                      keyboardType: TextInputType.text,
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
                        hintText: 'Your Email',
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
              
              // phone number
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Phone number",
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
                      controller: phoneController,
                      keyboardType: TextInputType.text,
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
                        hintText: 'Your Phone number',
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
              
              // password
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Password",
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
                      controller: passwordController,
                      obscureText: showPassword,
                      keyboardType: TextInputType.text,
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
                        hintText: 'Your Password',
                        hintStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          icon: Icon(
                            showPassword ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // save changes
              SizedBox(height: 30),
              Container(
                width: 327,
                height: 48,
                child: MaterialButton(
                  onPressed: updateUserData, // Call updateUserData
                  color: Color(0xFF54408C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Text('Save Changes', style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


import 'dart:async';
import 'package:bazarapp/pages/section1/page1_1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget{
  @override
  State<Splashscreen> createState() => _Page1_1State();
}

class _Page1_1State extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 2 seconds before navigating to the home page
    Timer(
        Duration(seconds: 2), () {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => Page1_1()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF54408C),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/Screenshot_2024-08-14_141927-removebg-preview.png',scale: 4,),
                SizedBox(width: 10,),
                Text('Bazar.', style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),),
              ],
            )
              ),
          Positioned(
            left: -15, // Position it at the left edge
            bottom: 0, // Position it at the bottom edge
            child: Image.asset('assets/images/img_13.png',
              width:316, // Set desired width
              height: 315, // Set desired height
              fit: BoxFit.cover, // Adjust image scaling if needed
            ),
          ),
        ]
      ),
    );
  }
}


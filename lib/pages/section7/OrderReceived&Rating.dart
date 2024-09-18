import 'package:bazarapp/models/firebase.dart';
import 'package:bazarapp/pages/section4/booklistscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Orderreceived_rating extends StatefulWidget {
  @override
  _Orderreceived_ratingState createState() => _Orderreceived_ratingState();
}

class _Orderreceived_ratingState extends State<Orderreceived_rating> {
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image
              Image.asset("assets/images/img_14.png"),

              SizedBox(height: 20),

              // Title
              Text(
                "You Received The Order!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 10),

              // Order Number
              Text(
                "Your Order",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              SizedBox(height: 20),

              // Feedback Section
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      "Tell us your feedback 🙌",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Lorem ipsum dolor sit amet consectetur. Digrossim magna vitae.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 20),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating;
                        });
                        print('Rating: $_rating');
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // Done Button
              Container(
                width: double.infinity,
                height: 56,
                child: MaterialButton(
                  onPressed: () {
                    print('User Rating: $_rating');
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (c) {
                        return BookListScreen();
                      }),
                    );
                  },
                  color: Color(0xFF54408C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

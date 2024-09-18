import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Helpscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Color(0xFF54408C),
        title: Text(
          'Help Center',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Color(0xFF54408C),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(15),
            color: Color(0xFF54408C),
            width: double.infinity,
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Help Center',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Tell us how we can help',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                Text(
                  'Chapter are standing by for service & support',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 175 ,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey.shade300,
                            child: Icon(Icons.email)),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'bazar@gmail.com',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey.shade300,
                            child: Icon(Icons.phone)),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Phone Number',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          '01000000000',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

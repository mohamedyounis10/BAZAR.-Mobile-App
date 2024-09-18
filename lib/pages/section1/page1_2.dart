import 'package:bazarapp/pages/section1/page1_1.dart';
import 'package:bazarapp/pages/section1/page1_3.dart';
import 'package:bazarapp/pages/section2/page2_0.dart';
import 'package:flutter/material.dart';

class Page1_2 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
          surfaceTintColor:Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (c) {
                  return Page1_1();
                }),
              );
            },
            icon: Icon(Icons.arrow_back),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextButton(
                onPressed:(){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (c){
                        return Page1_3();
                      })
                  );
                },
                child: Text('Skip', style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF54408C)
                ),),
              ),
            ),
          ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('assets/images/img_10.png',scale: 1,),
            Column(
              children: [
                Text('Your Bookish Soulmate', style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),),
                Text('Awaits', style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),),
              ],
            ),
            Column(
              children: [
                Text('Let us be your guide to the perfect read.', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey
                ),),
                Text('Discover books tailored to your tastes', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey
                ),),
                Text('for a truly rewarding experience.', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey
                ),),
              ],
            ),
            SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) =>
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    width: index == 1 ? 12.0 : 8.0, // Middle dot is larger
                    height: index == 1 ? 12.0 : 8.0, // Middle dot is larger
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == 1 ? Color(0xFF54408C) : Colors.grey, // Middle dot colored
                    ),
                  )
              ),
            ),

            SizedBox(height: 10,),
            Column(
              children: [
                Container(
                  width:327,
                  height: 56,
                  child: MaterialButton(
                    onPressed: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (c){
                            return Page1_3();
                          })
                      );
                    },
                    color: Color(0xFF54408C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Border radius
                    ),
                    child:Text('Continue', style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  width:327,
                  height: 56,
                  child: MaterialButton(
                    onPressed: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (c){
                            return Page2_0();
                          })
                      );
                    },
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Border radius
                    ),
                    child:Text('Sign in', style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF54408C),
                    ),),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
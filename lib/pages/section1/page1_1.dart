import 'package:bazarapp/pages/section1/page1_2.dart';
import 'package:bazarapp/pages/section2/page2_0.dart';
import 'package:flutter/material.dart';

class Page1_1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (c) {
                        return Page1_2();
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
            Image.asset('assets/images/img_7.png', scale: 1,),
            Column(
              children: [
                Text('Now reading books', style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),),
                Text('will be easier', style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),),
              ],
            ),
            Column(
              children: [
                Text(' Discover new worlds, join a vibrant', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey
                ),),
                Text('reading community. Start your reading', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey
                ),),
                Text('adventure effortlessly with us.', style: TextStyle(
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
                    width: index == 0 ? 12.0 : 8.0,
                    height: index == 0 ? 12.0 : 8.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == 0 ? Color(0xFF54408C) : Colors.grey,
                    ),
                  )
              ),
            ),

            SizedBox(height: 10,),
            Column(
              children: [
                Container(
                  width: 327,
                  height: 56,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (c) {
                            return Page1_2();
                          })
                      );
                    },
                    color: Color(0xFF54408C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Border radius
                    ),
                    child: Text('Continue', style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  width: 327,
                  height: 56,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (c) {
                            return Page2_0();
                          })
                      );
                    },
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Border radius
                    ),
                    child: Text('Sign in', style: TextStyle(
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

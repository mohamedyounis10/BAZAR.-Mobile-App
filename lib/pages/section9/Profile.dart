import 'package:bazarapp/models/firebase.dart';
import 'package:bazarapp/pages/section1/1.splashscreen.dart';
import 'package:bazarapp/pages/section2/page2_0.dart';
import 'package:bazarapp/pages/section4/booklistscreen.dart';
import 'package:bazarapp/pages/section4/shoppingcartscreen.dart';
import 'package:bazarapp/pages/section5/category.dart';
import 'package:bazarapp/pages/section6/setlocation.dart';
import 'package:bazarapp/pages/section9/Myaccount.dart';
import 'package:bazarapp/pages/section9/favoritesbooks.dart';
import 'package:bazarapp/pages/section9/helpcenter.dart';
import 'package:bazarapp/pages/section9/orders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget{
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex=3;
  Firebase_app obj=Firebase_app();
  late String name='';
  late String phonenumber='';
  late String address='';


  Future<void> fetchUserData() async   {
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
          name = userData['fullname'] ?? '';
          phonenumber= userData['phonenumber'] ?? '';
          address= userData['address'] ?? '';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the respective page based on the index
    if (index == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BookListScreen()));
    } else if (index == 1) {
       Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen())); // Navigate to CategoryScreen
    } else if (index == 2) {
      Navigator.push(context,
         MaterialPageRoute(builder: (context) => ShoppingCartScreen()));
    } else if (index == 3) {
       Navigator.push(context, MaterialPageRoute(builder: (context) => Profile())); // Example, replace with actual ProfileScreen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text('Profile' ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(padding: const EdgeInsets.all(15),
            child:
            Row(
              children: [
                CircleAvatar(radius: 30,
                  backgroundImage: AssetImage('assets/images/img_2.png',),),
                SizedBox(width: 15,),
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold)
                      ,),
                    Text(phonenumber,style: TextStyle(
                        color: Colors.grey),
                    )
                  ],
                ),
                Spacer(),
                TextButton(onPressed: (){
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext build) {
                        return FractionallySizedBox(
                            heightFactor: 0.4,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Logout Title
                                    Text(
                                      'Logout',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),

                                    // Description text
                                    Text(
                                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 20),

                                    // Logout button
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await FirebaseAuth.instance.signOut();
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (c){
                                                return Page2_0();
                                              })
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 4,
                                          backgroundColor: Color(0xFF54408C), // Set background color
                                          padding: EdgeInsets.symmetric(vertical: 15),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: Text(
                                          'Logout',
                                          style: TextStyle(fontSize: 20,color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15),

                                    // Cancel button
                                    SizedBox(
                                      width: double.infinity,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26, // Shadow color
                                              blurRadius: 10, // How soft the shadow is
                                              offset: Offset(0, 5), // Position of the shadow (horizontal, vertical)
                                            ),
                                          ],
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close the dialog
                                          },
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.black, // Text color when pressed
                                            padding: EdgeInsets.symmetric(vertical: 15),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            backgroundColor: Colors.white, // Button background color
                                          ),
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xFF54408C), // Set text color to yellow
                                              fontWeight: FontWeight.bold, // Make the text bold (optional)
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                        );
                      });
                },
                  child: Text('Logout',style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.red
                  ),),
                )
              ],
            ),
          ),

          Divider(),
          Padding(padding: EdgeInsets.all(10)),

          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor:Colors.grey.shade200,
              child:Icon(Icons.person,color: Color(0xFF54408C),),
            ),

            title: Text('My Account',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>
                  Myaccount()
              ) );
            },

          ),
          Padding(padding: EdgeInsets.all(15)),

          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor:Colors.grey.shade200,
              child:Icon(Icons.location_on,color: Color(0xFF54408C),),
            ),

            title: Text('Address',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold),),
            onTap: (){
             showModalBottomSheet(
                 context: context,
                 isScrollControlled: true,
                 builder: (BuildContext build) {
                   return FractionallySizedBox(
                       heightFactor: 0.4,
                       child: Card(
                     color: Colors.white,
                     elevation: 2,
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                     child: Padding(
                       padding: const EdgeInsets.all(16.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           // Address icon on the left
                           Column(
                             children: [
                               CircleAvatar(
                                 radius: 20,
                                 backgroundColor: Color(0xFFE5DEF8),
                                 child: Icon(
                                   Icons.location_pin,
                                   color: Color(0xFF54408C),
                                   size: 24,
                                 ),
                               ),
                             ],
                           ),
                           SizedBox(width: 10),
                           // Content on the right
                           Expanded(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                   'Address',
                                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                 ),
                                 SizedBox(height: 5),
                                 Text(
                                   address,
                                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                   softWrap: true, // Ensures text wraps if too long
                                 ),
                                 SizedBox(height: 10),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   children: [
                                     TextButton(
                                       onPressed: () {
                                         Navigator.of(context).push(
                                             MaterialPageRoute(builder: (c){
                                               return SetLocationScreen();
                                             })
                                         );
                                       },
                                       style: TextButton.styleFrom(
                                         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                         backgroundColor: Color(0xFF54408C),
                                         shape: RoundedRectangleBorder(
                                           borderRadius: BorderRadius.circular(10),
                                         ),
                                       ),
                                       child: Text(
                                         'Set Address',
                                         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                       ),
                                     ),
                                   ],
                                 ),
                               ],
                             ),
                           ),
                         ],
                       ),
                     ),
                       )
                   );
                 });
            },
          ),
          Padding(padding: EdgeInsets.all(15)),

          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor:Colors.grey.shade200,
              child:Icon(Icons.favorite,color: Color(0xFF54408C),),
            ),

            title: Text('Your Favorites',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold),),
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (c){
                    return FavoritesBooks();
                  })
              );
              },
          ),
          Padding(padding: EdgeInsets.all(15)),

          ListTile(
            leading:  CircleAvatar(
              radius: 25,
              backgroundColor:Colors.grey.shade200,
              child:Icon(Icons.history,color: Color(0xFF54408C),),
            ),

            title: Text('Orders History',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold),),
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (c){
                    return Orders();
                  })
              );
            },
          ),
          Padding(padding: EdgeInsets.all(15)),

          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor:Colors.grey.shade200,
              child: Icon(Icons.help,color: Color(0xFF54408C),),
            ),
            title: Text('Help Center',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold),),
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (c){
                  return Helpscreen();
                })
              );
            },
          )

        ],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        backgroundColor: Colors.white,
        onDestinationSelected: _onItemTapped,
        height: 80,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home,
              color: _selectedIndex == 0 ? Color(0xFF54408C) : Colors.grey,
            ),
            label: "HOME",
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt,
              color: _selectedIndex == 1 ? Color(0xFF54408C) : Colors.grey,
            ),
            label: 'Category',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart,
              color: _selectedIndex == 2 ? Color(0xFF54408C) : Colors.grey,
            ),
            label: "Cart",
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined,
              color: _selectedIndex == 3 ? Color(0xFF54408C) : Colors.grey,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
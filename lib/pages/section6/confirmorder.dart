import 'dart:math';

import 'package:bazarapp/models/book.dart';
import 'package:bazarapp/models/firebase.dart';
import 'package:bazarapp/models/user.dart';
import 'package:bazarapp/pages/section6/setlocation.dart';
import 'package:bazarapp/pages/section7/orderstatus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConfirmOrderScreen extends StatefulWidget {
  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  User_app user = User_app();
  late Future<String> addressFuture;
  late String time;
  bool isLoading = true; // Initialize the loading state
  late double shipping;
  Firebase_app obj = Firebase_app();

  @override
  void initState() {
    super.initState();
    addressFuture = getAddress();
    time = generateFormattedDateTimeWithOffset();
    shipping = generateShippingCost();
  }

  Future<String> getAddress() async {
    final firestore = FirebaseFirestore.instance;

    try {
      final document = await firestore.collection('users').doc(obj.id).get();
      if (document.exists) {
        var fieldValue = document.data()?['address'];
        if (fieldValue != null && fieldValue.isNotEmpty) {
          return fieldValue.toString();
        } else {
          return '';
        }
      } else {
        return '';
      }
    } catch (e) {
      print('Error fetching document: $e');
      return '';
    }
  }

  Future<void> _updateAddress() async {
    String updatedAddress = await getAddress();
    if (updatedAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No address found. Please set an address.')),
      );
    } else {
      setState(() {
        addressFuture = Future.value(updatedAddress);
      });
    }
  }

  Future<void> updateOrderedCart({required String deliveryTime, required double shippingCost}) async {
    try {
      // Get a reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get a reference to the user document using the UID
      DocumentReference userDoc = firestore.collection('users').doc(obj.id);

      // Prepare the orderedCart data to be stored as a single order
      List<Map<String, dynamic>> cartData = user.shoppingCart.map((cartItem) {
        final book = cartItem.keys.first;
        final bookDetails = cartItem[book]!;

        return {
          'book': {
            'id': book.id,
            'title': book.title,
            'about': book.description,
            'price': book.price,
            'photo': book.thumbnail,
            'publisher': book.publisher,
            'averageRating': book.averageRating,
            // Add other book fields if needed
          },
          'quantity': bookDetails,
        };
      }).toList();

      // Create the order data
      Map<String, dynamic> orderData = {
        'books': cartData,
        'deliveryTime': deliveryTime,
        'shippingCost': shippingCost,
      };

      // Get current document data
      DocumentSnapshot userSnapshot = await userDoc.get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

        // Check if 'orderedCart' exists
        if (userData.containsKey('orderedCart')) {
          // Append the new order to the existing orderedCart
          List<Map<String, dynamic>> existingCart = List<Map<String, dynamic>>.from(userData['orderedCart']);
          existingCart.add(orderData);
          await userDoc.update({
            'orderedCart': existingCart,
          });
        } else {
          // Create a new orderedCart with the first order
          await userDoc.update({
            'orderedCart': [orderData],
          });
        }
        print('OrderedCart updated successfully.');
      } else {
        print('User document does not exist.');
      }
    } catch (e) {
      print('Failed to update orderedCart: $e');
    }
  }

  String generateFormattedDateTimeWithOffset() {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Add the specified number of days to the current date
    DateTime futureDate = now.add(Duration(days: 2));

    // Define your desired format, e.g., "yyyy-MM-dd HH:mm:ss"
    DateFormat dateFormat = DateFormat('yyyy-MM-dd ');

    // Format the future date and return it as a string
    return dateFormat.format(futureDate);
  }

  double calctotal(List<Map<Book, int>> books) {
    double total = 0;
    // Loop through each map entry and add its total price to the sum
    books.forEach((bookMap) {
      bookMap.forEach((book, quantity) {
        total += book.price * quantity;
      });
    });

    return total;
  }

  double generateShippingCost() {
    double freeShippingThreshold = 50.0; // Free shipping for orders over this amount
    double minRandomShippingCost = 50.0; // Minimum random shipping cost
    double maxRandomShippingCost = 100.0; // Maximum random shipping cost

    // Generate a random shipping cost between minRandomShippingCost and maxRandomShippingCost
    final random = Random();
    double shippingCost = minRandomShippingCost + random.nextDouble() * (maxRandomShippingCost - minRandomShippingCost);

    return shippingCost;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 28),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Confirm Order',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildAddressSection(),
            SizedBox(height: 16),
            _buildSummarySection(),
            SizedBox(height: 16),
            _buildDateTimeSection(),
            SizedBox(height: 16),
            _buildPaymentMethodSection(), // Add this line
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            final address = await addressFuture;

            if (address == null || address.isEmpty || address == 'Address field not found') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Address not found. Please press on "Set Address" to set your address.'),
                  duration: Duration(seconds: 3),
                ),
              );
            } else {
              // العنوان موجود، قم بتحديث الطلب
              await updateOrderedCart(shippingCost: shipping, deliveryTime: time);
              print(address);

              // الانتقال إلى شاشة تفاصيل الطلب
              Navigator.of(context).push(
                MaterialPageRoute(builder: (c) {
                  return OrderDetailsScreen(shipping: shipping, time: time);
                }),
              );
            }
          },
          child: Text(
            'Order',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF54408C),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }


  Widget _buildAddressSection() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<String>(
          future: addressFuture,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final address = snapshot.data ?? 'Address not found';
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Address',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          address,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                          softWrap: true,
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () async {
                                final result = await Navigator.of(context).push(
                                  MaterialPageRoute(builder: (c) {
                                    return SetLocationScreen();
                                  }),
                                );

                                // Update the address after coming back from SetLocationScreen
                                if (result != null) {
                                  _updateAddress();
                                }
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                backgroundColor: Color(0xFF54408C),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Set Address',
                                style: TextStyle(color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Text('Address not found');
            }
          },
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: user.shoppingCart.length,
              separatorBuilder: (BuildContext context, int index) => Divider(
                color: Colors.grey,
              ),
              itemBuilder: (context, index) {
                final cartItem = user.shoppingCart[index];
                final book = cartItem.keys.first;
                final quantity = cartItem[book]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Quantity: $quantity',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Price for each : \$${book.price.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Price: \$${(book.price * quantity).toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 10),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${calctotal(user.shoppingCart).toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeSection() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expected Delivery Time',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              time,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                showPaymentOptions(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Payment Method',
                    style: TextStyle(fontSize: 18),
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPaymentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      backgroundColor: Colors.white, // Set background color to yellow
      builder: (BuildContext context) {
        return FractionallySizedBox(
            heightFactor: 0.4,
            child:  Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Your Payments',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.money,
                      color: Colors.white,
                    ),
                  ),
                  title: Text('Cash'),
                ),
              ),
            ],
          ),
        )
        );
      },
    );
  }

}

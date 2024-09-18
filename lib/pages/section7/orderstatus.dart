import 'package:bazarapp/models/firebase.dart';
import 'package:bazarapp/models/user.dart';
import 'package:bazarapp/pages/section7/OrderReceived&Rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatefulWidget {
  late double shipping;
  late String time;

  OrderDetailsScreen({required this.shipping , required this.time});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  Firebase_app obj = Firebase_app();
  User_app u = User_app();
  late String name = '';

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    try {
      // Debugging: Check if obj.id is set correctly
      print("Fetching data for user ID: ${obj.id}");

      // Get user document from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(obj.id)
          .get();

      if (userDoc.exists) {
        // Set text field values
        var userData = userDoc.data() as Map<String, dynamic>;
        print("User data fetched: $userData"); // Debugging: Print fetched data
        setState(() {
          name = userData['fullname'] ?? '';
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
  Widget build(BuildContext context) {
    double subtotal = u.shoppingCart.fold(
        0, (total, item) => total + item.keys.first.price * item.values.first);
    double totalPayment = subtotal + widget.shipping;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thank You and Order Summary
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Thank you 👋',
                    style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold
                        ,color: Colors.black),
                  ),
                  SizedBox(height: 8),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF54408C),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Order',
                    style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold ,color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Order Details
            Text(
              'Order Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Order Items
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  for (var item in u.shoppingCart)
                    _buildOrderItem(item.keys.first.title,
                        item.keys.first.price.toStringAsFixed(2), item.values.first),
                  Divider(),
                  _buildOrderSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
                  _buildOrderSummaryRow('Shipping', '\$${widget.shipping.toStringAsFixed(2)}'),
                  Divider(),
                  _buildOrderSummaryRow('Total Payment', '\$${totalPayment.toStringAsFixed(2)}', isTotal: true),
                  SizedBox(height: 10),
                  _buildOrderSummaryRow('Delivery in', '${widget.time}'),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Order Status Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 120, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(48),
                  ),
                  backgroundColor: Colors.grey[100],
                ),
                onPressed: () {
                 u.shoppingCart.clear();
                 Navigator.of(context).push(
                   MaterialPageRoute(builder: (c){
                     return Orderreceived_rating();
                   })
                 );
                },
                child: Text(
                  'Order Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF54408C),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build each order item row
  Widget _buildOrderItem(String itemName, String price, int quantity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${quantity}x  $itemName'),
          Text('\$$price'),
        ],
      ),
    );
  }

  // Function to build order summary row
  Widget _buildOrderSummaryRow(String label, String value,
      {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Color(0xFF54408C) : Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Color(0xFF54408C) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

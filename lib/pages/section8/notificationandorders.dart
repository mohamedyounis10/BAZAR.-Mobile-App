import 'package:bazarapp/models/firebase.dart';
import 'package:bazarapp/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class Notificationandorders extends StatefulWidget {
  @override
  _NotificationandordersState createState() => _NotificationandordersState();
}

class _NotificationandordersState extends State<Notificationandorders> {

  // Data
  Firebase_app obj = Firebase_app();
  List<Map<String, dynamic>> orders = [];
  User_app user = User_app();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  // Functions
  Future<void> _initializeData() async {
    try {
      List<Map<String, dynamic>> fetchedOrders = await getOrderedCart();
      setState(() {
        orders = fetchedOrders;
        print('Orders fetched: $orders'); // Debugging print
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getOrderedCart() async {
    final firestore = FirebaseFirestore.instance;
    try {
      final document = await firestore.collection('users').doc(obj.id).get();

      if (document.exists) {
        var orderedCartData = document.data()?['orderedCart'];

        if (orderedCartData != null && orderedCartData is List) {
          print('Fetched ordered cart data: $orderedCartData'); // Debugging print
          return List<Map<String, dynamic>>.from(orderedCartData.map((order) {
            return {
              'books': List<Map<String, dynamic>>.from(order['books'].map((bookItem) {
                return {
                  'book': {
                    'id': bookItem['book']['id'],
                    'title': bookItem['book']['title'],
                    'about': bookItem['book']['about'],
                    'price': bookItem['book']['price'],
                    'photo': bookItem['book']['photo'],
                    'publisher': bookItem['book']['publisher'],
                    'averageRating': bookItem['book']['averageRating'],
                  },
                  'quantity': bookItem['quantity'],
                };
              })),
              'deliveryTime': order['deliveryTime'] ?? 'Unknown Delivery Time',
              'shippingCost': (order['shippingCost'] ?? 0.0).toDouble(),
            };
          }).toList());
        } else {
          print('Ordered cart data is not a list or is null'); // Debugging print
          return [];
        }
      } else {
        print('Document does not exist'); // Debugging print
        return [];
      }
    } catch (e) {
      print('Error fetching ordered cart: $e');
      return [];
    }
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Notification',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Orders',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              if (orders.isEmpty)
                _buildNoOrdersWidget()
              else
                for (var i = 0; i < orders.length; i++) ...[
                  Row(children: <Widget>[
                    Expanded(
                      child: new Container(
                          margin: const EdgeInsets.only(left: 0.0, right: 20.0),
                          child: Divider(
                            color: Colors.grey,
                            height: 36,
                          )),
                    ),
                    Text('Order ${i + 1}'),
                    Expanded(
                      child: new Container(
                          margin: const EdgeInsets.only(left: 20.0, right: 0.0),
                          child: Divider(
                            color: Colors.grey,
                            height: 36,
                          )),
                    ),
                  ]),
                  for (var bookItem in orders[i]['books']) ...[
                    ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          bookItem['book']['photo'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            return Icon(Icons.error, color: Colors.red);
                          },
                        ),
                      ),
                      title: Text(bookItem['book']['title']),
                      subtitle: Text('Quantity: ${bookItem['quantity']}'),
                    ),
                    Divider(),
                  ],
                  ListTile(
                    title: Text(
                      orders[i]['deliveryTime'],
                      style: TextStyle(color: getDeliveryStatusColor(getDeliveryStatus(orders[i]['deliveryTime']))),
                    ),
                    subtitle: Text(
                      getDeliveryStatus(orders[i]['deliveryTime']),
                      style: TextStyle(color: getDeliveryStatusColor(getDeliveryStatus(orders[i]['deliveryTime']))),
                    ),
                    trailing: Icon(
                      getDeliveryStatus(orders[i]['deliveryTime']) == "Delivered" ? Icons.check_circle : Icons.local_shipping,
                      color: getDeliveryStatusColor(getDeliveryStatus(orders[i]['deliveryTime'])),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoOrdersWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/img_4.png', // Path to your no orders image
            width: 100,
            height: 100,
          ),
          SizedBox(height: 20),
          Text(
            'There is no notifications about orders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  String getDeliveryStatus(String deliveryTime) {
    try {
      DateTime deliveryDate = DateFormat("yyyy-MM-dd").parse(deliveryTime);
      DateTime currentDate = DateTime.now();

      if (deliveryDate.isBefore(currentDate)) {
        return "Delivered";
      } else {
        return "In Transit";
      }
    } catch (e) {
      print('Error parsing date: $e');
      return "Unknown Status";
    }
  }

  Color getDeliveryStatusColor(String status) {
    if (status == "Delivered") {
      return Colors.green;
    } else if (status == "In Transit") {
      return Colors.grey;
    } else {
      return Colors.black;
    }
  }
}

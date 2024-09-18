import 'package:bazarapp/models/firebase.dart';
import 'package:bazarapp/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Firebase_app obj = Firebase_app();
  List<Map<String, dynamic>> orders = [];
  User_app user = User_app();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      List<Map<String, dynamic>> fetchedOrders = await getOrderedCart();
      setState(() {
        orders = fetchedOrders;
      });
    } catch (e) {
      print('Error fetching data: $e');
      // You can also display an error message to the user
    }
  }

  Future<List<Map<String, dynamic>>> getOrderedCart() async {
    final firestore = FirebaseFirestore.instance;
    try {
      final document = await firestore.collection('users').doc(obj.id).get();

      if (document.exists) {
        var orderedCartData = document.data()?['orderedCart'];

        if (orderedCartData != null && orderedCartData is List) {
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
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching ordered cart: $e');
      return [];
    }
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Orders History',
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
                    SizedBox(height: 4),
                    Text(
                      'Orders',
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Color(0xFF54408C)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Orders Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: orders.isNotEmpty
                      ? [
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
                          trailing: Text('\$${(bookItem['book']['price']).toStringAsFixed(2)}'),
                        ),
                        Divider(),
                      ],
                      ListTile(
                        title: Text('Shipping Cost'),
                        trailing: Text('\$${orders[i]['shippingCost'].toStringAsFixed(2)}'),
                      ),
                      ListTile(
                        title: Text('Total Cost'),
                        trailing: Text(
                          '\$${(orders[i]['books'].fold(0, (previousValue, element) => previousValue + (element['book']['price'] * element['quantity'])) + orders[i]['shippingCost']).toStringAsFixed(2)}',
                        ),
                      ),
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
                    ]
                  ]
                      : [
                    Text('No orders found.'),
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

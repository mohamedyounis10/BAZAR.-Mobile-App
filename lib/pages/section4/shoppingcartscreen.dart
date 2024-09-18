import 'package:bazarapp/models/user.dart';
import 'package:bazarapp/pages/section6/confirmorder.dart';
import 'package:bazarapp/pages/section8/notificationandorders.dart';
import 'package:flutter/material.dart';
import 'package:bazarapp/pages/section4/booklistscreen.dart';
import 'package:bazarapp/pages/section4/bookscreendetails.dart';
import 'package:bazarapp/pages/section5/category.dart';
import 'package:bazarapp/pages/section9/profile.dart';

class ShoppingCartScreen extends StatefulWidget {
  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  int _selectedIndex = 2; // Track the selected page

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the respective page based on the index
    if (index == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BookListScreen()));
    } else if (index == 1) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CategoryScreen()));
    } else if (index == 2) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ShoppingCartScreen()));
    } else if (index == 3) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Profile()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final u = User_app(); // Get the singleton instance

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          'My Cart',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, size: 28),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Notificationandorders(),
                ),
              );
            },
          ),
        ],
      ),
      body: u.shoppingCart.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart,
              size: 100,
              color: Colors.grey[300],
            ),
            SizedBox(height: 20),
            Text(
              'There are no products in your cart.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: u.shoppingCart.length,
              itemBuilder: (context, index) {
                final cartItem = u.shoppingCart[index];
                final book = cartItem.keys.first;
                final numberOfCopies = cartItem.values.first;

                return ListTile(
                  leading: Image.network(
                    book.thumbnail,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(book.title),
                  subtitle: Text('Price: \$${book.price.toStringAsFixed(2)}\nCopies: $numberOfCopies'),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        // Find the index of the cart item
                        final indexToRemove = u.shoppingCart.indexWhere((item) => item.keys.first == book);
                          // Remove the book from the cart
                          u.shoppingCart.removeAt(indexToRemove);
                        }
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailScreen(b: book),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: 327,
              height: 56,
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (c){
                    return ConfirmOrderScreen();
                  }));
                },
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Border radius
                ),
                child: Text(
                  'Confirm Order',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF54408C),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        backgroundColor: Colors.white,
        onDestinationSelected: _onItemTapped,
        height: 80,
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home,
              color: _selectedIndex == 0 ? Color(0xFF54408C) : Colors.grey,
            ),
            label: "HOME",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.list_alt,
              color: _selectedIndex == 1 ? Color(0xFF54408C) : Colors.grey,
            ),
            label: 'Category',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.shopping_cart,
              color: _selectedIndex == 2 ? Color(0xFF54408C) : Colors.grey,
            ),
            label: "Cart",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.account_circle_outlined,
              color: _selectedIndex == 3 ? Color(0xFF54408C) : Colors.grey,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

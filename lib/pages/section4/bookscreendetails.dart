import 'package:bazarapp/models/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:bazarapp/models/book.dart';
import 'package:bazarapp/models/user.dart';
import 'package:bazarapp/pages/section4/foreach.dart';
import 'package:bazarapp/pages/section4/shoppingcartscreen.dart';

class BookDetailScreen extends StatefulWidget {
  final Book b;

  BookDetailScreen({required this.b});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  Firebase_app obj = Firebase_app();
  User_app u = User_app();
  int count = 1;
  bool isFavorite = false; // Track favorite status
  List<Book> favoriteBooks = [];

  @override
  void initState() {
    super.initState();
    _checkIfFavorite(); // Check if book is in favorites when screen loads
  }

  Future<void> _checkIfFavorite() async {
    List<Book> favorites = await getFavoriteList(); // Fetch the favorite list
    setState(() {
      // Check if the current book is in the favorite list
      isFavorite = favorites.any((book) => book.id == widget.b.id);
    });
  }

  void _addToCart() {
    setState(() {
      u.shoppingCart.add({widget.b: count});
      print(u.shoppingCart);
    });

    // Show Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to cart successfully!'),
        duration: Duration(seconds: 2), // Duration for how long the Snackbar is visible
        backgroundColor: Colors.green, // Background color of the Snackbar
        behavior: SnackBarBehavior.floating, // Snackbar appearance
      ),
    );
  }


  Future<List<Book>> getFavoriteList() async {
    final firestore = FirebaseFirestore.instance;
    List<Book> books = [];
    try {
      final document = await firestore.collection('users').doc(obj.id).get();
      if (document.exists) {
        var favoriteListData = document.data()?['favoriteList'];
        if (favoriteListData != null && favoriteListData is Map) {
          for (var entry in favoriteListData.entries) {
            var bookData = entry.value as Map<String, dynamic>;
            Book book = Book.fromMap(bookData);
            books.add(book);
          }
        } else {
          print('No favorite list or the favorite list is not a map.');
        }
      } else {
        print('User document does not exist.');
      }
    } catch (e) {
      print('Error fetching favorite books: $e');
    }
    return books;
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite; // Toggle favorite status
      if (isFavorite) {
        u.favoriteCart.add(widget.b); // Add to local favorite cart
      } else {
        u.favoriteCart.remove(widget.b); // Remove from local favorite cart
      }
    });
    updateFavoriteList();
  }

  Future<void> updateFavoriteList() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference userDoc = firestore.collection('users').doc(obj.id);

      // Fetch the current favorite list
      DocumentSnapshot userSnapshot = await userDoc.get();
      Map<String, dynamic> favoriteList = {};

      // Check if the favoriteList exists and is a map
      if (userSnapshot.exists) {
        var userData = userSnapshot.data() as Map<String, dynamic>?;
        if (userData != null && userData['favoriteList'] is Map) {
          favoriteList = Map<String, dynamic>.from(userData['favoriteList']);
        }
      }

      // Convert book to a map (serialization)
      Map<String, dynamic> bookMap = {
        'id': widget.b.id,
        'title': widget.b.title,
        'description': widget.b.description,
        'thumbnail': widget.b.thumbnail,
        'author': widget.b.author.toMap(),
        'vendor': widget.b.vendor.toMap(),
        'averageRating': widget.b.averageRating,
        'price': widget.b.price,
      };

      // Convert book ID to a string
      String bookId = widget.b.id;

      // Update the favorite list
      if (isFavorite) {
        // Add the book object to the favorite list
        favoriteList[bookId] = bookMap;
      } else {
        // Remove the book object from the favorite list
        favoriteList.remove(bookId);
      }

      // Update the favorite list in Firestore
      await userDoc.update({'favoriteList': favoriteList});
      print('Favorite list updated successfully.');

    } catch (e) {
      print('Failed to update favorite list: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Text(
          widget.b.title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          overflow: TextOverflow.ellipsis, // Handle long title
          maxLines: 2, // Limit the number of lines for the title
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, size: 28),
        ),
      ),
      backgroundColor: Colors.white, // Light background color
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Book Image
                Center(
                  child: Container(
                    width: 200,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(widget.b.thumbnail),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Book Title and Favorite Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.b.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Color(0xFF54408C) : Colors.grey,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // Publisher Name
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForEachScreen(
                          'Vendor',
                          widget.b.vendor.name ?? 'Vendor',
                          '',
                          widget.b.vendor.about ?? 'No information available.',
                          widget.b.vendor.vindphoto ?? '',
                          widget.b.vendor.rating,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    widget.b.publisher,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),

                // Author Name
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForEachScreen(
                          'Author',
                          widget.b.author.name ?? 'Author',
                          widget.b.author.job ?? 'Unknown Job',
                          widget.b.author.about ?? 'No information available.',
                          widget.b.author.photoPath ?? '',
                          widget.b.author.averageRating,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    widget.b.author.name,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),

                // Description
                Text(
                  widget.b.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 16),

                // Rating Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Review',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: widget.b.averageRating, // The static value
                          itemCount: 5,
                          itemSize: 25,
                          direction: Axis.horizontal,
                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '(${widget.b.averageRating.toStringAsFixed(2)})',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 16),

                // Quantity and Price Section
                Row(
                  children: [
                    Row(
                      children: [
                        // Decrease quantity
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline, size: 25),
                          onPressed: () {
                            if (count > 1) {
                              setState(() {
                                count--;
                              });
                            }
                          },
                        ),
                        Text(
                          count.toString(),
                          style: TextStyle(color: Colors.black87, fontSize: 20),
                        ),
                        // Increase quantity, limited by available copies
                        IconButton(
                          icon: Icon(Icons.add_circle_outline, size: 25, color: Color(0xFF54408C)),
                          onPressed: () {
                            setState(() {
                              count++;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(width: 16),
                    // Display the price
                    Text(
                      "\$${widget.b.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                // Add to cart
                Container(
                  width: 120,
                  height: 48,
                  child: MaterialButton(
                    onPressed: _addToCart,
                    color: Color(0xFF54408C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // Border radius
                    ),
                    child: Text(
                      'Add Cart',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // buttons
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 210,
                      height: 48,
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Color(0xFF54408C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0), // Border radius
                        ),
                        child: Text(
                          'Continue Shopping',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => ShoppingCartScreen())
                        );
                      },
                      child: Text(
                        'View Cart',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF54408C),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

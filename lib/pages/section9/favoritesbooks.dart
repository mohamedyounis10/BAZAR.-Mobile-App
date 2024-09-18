import 'package:bazarapp/models/book.dart';
import 'package:bazarapp/models/firebase.dart';
import 'package:bazarapp/pages/section4/bookscreendetails.dart'; // Ensure this is the correct path
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoritesBooks extends StatefulWidget {
  @override
  _FavoritesBooksState createState() => _FavoritesBooksState();
}

class _FavoritesBooksState extends State<FavoritesBooks> {
  Firebase_app obj = Firebase_app(); // Assuming this gives you the Firebase instance and `id`
  List<Book> favoriteBooks = []; // Store favorite books here

  @override
  void initState() {
    super.initState();
    _initializeData(); // Fetch the data when the widget initializes
  }

  Future<void> _initializeData() async {
    List<Book> fetchedBooks = await getFavoriteList(); // Fetch favorite books from Firestore
    setState(() {
      favoriteBooks = fetchedBooks; // Update the UI with the fetched books
    });
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

  Future<void> removeBookFromFavorites(Book book) async {
    final firestore = FirebaseFirestore.instance;
    try {
      DocumentReference userDoc = firestore.collection('users').doc(obj.id);

      await userDoc.update({
        'favoriteList': FieldValue.arrayRemove([book.id])
      });

      setState(() {
        favoriteBooks.remove(book);
      });
    } catch (e) {
      print('Error removing book from favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Favorite Books',
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
        child: favoriteBooks.isEmpty
            ? Center(child: Text('No favorite books found.'))
            : ListView.builder(
          itemCount: favoriteBooks.length,
          itemBuilder: (context, index) {
            return _buildFavoriteBookItem(favoriteBooks[index]);
          },
        ),
      ),
    );
  }

  Widget _buildFavoriteBookItem(Book book) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8),
        leading: Image.network(book.thumbnail, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(book.title),
        subtitle: Text('Author: ${book.author.name}'), // Display author name
        trailing: IconButton(
          icon: Icon(Icons.favorite, color: Color(0xFF54408C)),
          onPressed: () {
            removeBookFromFavorites(book);
          },
        ),
    );
  }
}

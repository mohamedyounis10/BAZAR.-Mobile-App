import 'package:flutter/material.dart';
import 'package:bazarapp/models/book.dart'; // Import your Book model
import 'package:bazarapp/pages/section4/bookscreendetails.dart'; // Import your BookDetailScreen

class CategoryBooksScreen extends StatelessWidget {
  final String category;
  final List<Book> books;

  CategoryBooksScreen({required this.category, required this.books});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          'Books in $category',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: books.isEmpty
          ? Center(child: Text('No books available in this category.'))
          : ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0), // Add vertical padding between items
            child: Container(
              decoration:  BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  border: Border.all(
                    color: Colors.grey.shade300, // Border color
                    width: 1.0, // Border width
                  ),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(8.0),
                leading: Image.network(
                  book.thumbnail,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(book.title),
                subtitle: Text('Author: ${book.authors}'),
                trailing: Text(
                  'Rating: ${book.averageRating.toStringAsFixed(1)}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailScreen(b: book),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

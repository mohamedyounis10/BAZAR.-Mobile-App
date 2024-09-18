import 'package:flutter/material.dart';
import 'package:bazarapp/apicore//logic.dart';
import 'package:bazarapp/models/book.dart';
import 'package:bazarapp/pages/section4/bookscreendetails.dart';

class Searchscreen extends StatefulWidget {
  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  TextEditingController searchController = TextEditingController();
  final BookService _bookService = BookService();
  List<Book> _searchResults = [];
  bool _isLoading = false;

  void search() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Book> results = await _bookService.searchBooks(searchController.text);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text(
          'Search',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              keyboardType: TextInputType.text,
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, size: 28, color: Colors.grey),
                hintText: 'Search for books',
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onFieldSubmitted: (_) => search(),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  Book book = _searchResults[index];
                  return ListTile(
                    leading: book.thumbnail.isNotEmpty
                        ? Image.network(
                      book.thumbnail,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                        : Icon(Icons.book, size: 50, color: Colors.grey),
                    title: Text(book.title),
                    subtitle: Text(book.publisher),
                    trailing: Text(book.averageRating.toStringAsFixed(2)),
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
          ],
        ),
      ),
    );
  }
}

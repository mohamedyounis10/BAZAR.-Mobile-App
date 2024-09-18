import 'package:flutter/material.dart';
import 'package:bazarapp/apicore/logic.dart'; // Import your BookService logic
import 'package:bazarapp/models/author.dart';
import 'package:bazarapp/models/book.dart';
import 'package:bazarapp/models/vendor.dart';
import 'package:bazarapp/pages/section4/foreach.dart';
import 'package:bazarapp/pages/section5/searchscreen.dart';

class Authorsscreen extends StatefulWidget {
  @override
  State<Authorsscreen> createState() => _AuthorsscreenState();
}

class _AuthorsscreenState extends State<Authorsscreen> {
  final BookService _bookService = BookService();

  late Future<List<Book>> books;

  @override
  void initState() {
    super.initState();
    books = _bookService.AllBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          'Authors',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, size: 28, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: 28, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (c){
                    return Searchscreen();
                  })
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Check the authors',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(height: 8),
            Text(
              'Authors',
              style: TextStyle(color: Color(0xFF54408C), fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            Expanded(
              child: FutureBuilder<List<Book>>(
                future: books,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Failed to load authors'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No authors found'));
                  } else {
                    List<Book> books = snapshot.data!;
                    return ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        return AuthorListTile(a:books[index].author );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthorListTile extends StatelessWidget {
  final Author a;

  const AuthorListTile({Key? key, required this.a}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ForEachScreen(
                  'Author',
                  a.name ?? 'Author', // Provide a default value
                  a.job ?? 'Unknown Job',
                  a.about ?? 'No information available.',
                  a.photoPath ?? '', // Default to empty string if the path is null
                  a.averageRating,
                )
            ),
          );
      },
      child:ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8.0),
        leading: CircleAvatar(
          backgroundImage: AssetImage(a.photoPath),
          radius: 28,
        ),
        title: Text(
          a.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          a.job ?? '', // Assuming there's a description field
          style: TextStyle(color: Colors.grey[600]),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        trailing: Text(a.averageRating.toStringAsFixed(2)?? '',
          style: TextStyle(color: Colors.grey[600]),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ) ,
    );
  }
}

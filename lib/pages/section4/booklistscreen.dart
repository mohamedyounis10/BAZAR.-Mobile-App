import 'package:bazarapp/models/user.dart';
import 'package:bazarapp/pages/section8/notificationandorders.dart';
import 'package:bazarapp/pages/section9/Profile.dart';
import 'package:flutter/material.dart';
import 'package:bazarapp/apicore/logic.dart';
import 'package:bazarapp/models/author.dart';
import 'package:bazarapp/models/book.dart';
import 'package:bazarapp/models/vendor.dart';
import 'package:bazarapp/pages/section4/authorsscreen.dart';
import 'package:bazarapp/pages/section4/bookscreendetails.dart';
import 'package:bazarapp/pages/section5/category.dart';
import 'package:bazarapp/pages/section5/categoryscreen.dart';
import 'package:bazarapp/pages/section4/foreach.dart';
import 'package:bazarapp/pages/section5/searchscreen.dart';
import 'package:bazarapp/pages/section4/shoppingcartscreen.dart';
import 'package:bazarapp/pages/section4/vendorsscreen.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}
class _BookListScreenState extends State<BookListScreen> {
  final BookService _bookService = BookService();
  late Future<List<Book>> allBooks;
  late Future<List<Book>> amineBooks;
  late Future<List<Book>> adventureBooks;
  late Future<List<Book>> novelBooks;
  late Future<List<Book>> horrorBooks;
  late Future<List<Vendor>> publishers;
  int _selectedIndex = 0; // Track the selected page
  final u = User_app();

  @override
  void initState() {
    super.initState();
    allBooks=_bookService.AllBooks();
    amineBooks = _bookService.AmineBooks();
    adventureBooks = _bookService.AdventureBooks();
    novelBooks = _bookService.NovelBooks();
    horrorBooks = _bookService.HorrorBooks();
    publishers = allBooks.then((bookList) => _bookService.getPublishers(bookList));// Converting books to publishers
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the respective page based on the index
    if (index == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BookListScreen()));
    } else if (index == 1) {
       Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen())); // Navigate to CategoryScreen
    } else if (index == 2) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ShoppingCartScreen()));
    } else if (index == 3) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Profile())); // Example, replace with actual ProfileScreen
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white, // when  make scroll not change color
        title: Text('Home', style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20
        ),),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (c){
                  return Searchscreen();
                })
              );
            },
            icon: Icon(Icons.search, size: 28,)),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, size: 28,),
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
      body: ListView(
        children: [
          ListTile(
              title: Text('Most Popular',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FutureBuilder<List<Book>>(
                  future: novelBooks,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Failed to load special offers'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No special offers available'));
                    }
                    return front_book(snapshot.data![0], 'Novel');
                  },
                ),
                FutureBuilder<List<Book>>(
                  future: novelBooks,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Failed to load special offers'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No special offers available'));
                    }
                    return front_book(snapshot.data![3], 'Novel');
                  },
                ),
              ],
            ),
          ),

          _buildSection('Amine', amineBooks),
          _buildSection('Horror', horrorBooks),
          _buildSection('Novel', novelBooks),

          // author
          ListTile(
              title: Text('Authors',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              trailing: TextButton(onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (c){
                    return Authorsscreen();
                  })
                );
              },
                child: Text('See all',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                ,)
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // problem in author display because some of books not have author and
                  // have books more 1 author
                  FutureBuilder<List<Book>>(
                    future: novelBooks,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Failed to load authors'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No special offers available'));
                      }

                      // Filter books that have an author
                      final booksWithAuthor = snapshot.data!
                          .where((book) => book.author != null && book.author!.name.isNotEmpty)
                          .toList();

                      // Get the first 3 books with authors or fewer if there aren't enough
                      final booksToShow = booksWithAuthor.length >= 3
                          ? booksWithAuthor.sublist(0, 3)
                          : booksWithAuthor;

                      // Display the books in a list with spacing
                      return Row(
                        children: booksToShow.map((book) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16.0), // Add space after each card
                            child: styleCard(book.author), // Replace with your actual widget
                          );
                        }).toList(),
                      );
                    },
                  ),

                  FutureBuilder<List<Book>>(
                    future: novelBooks,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Failed to load authors'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No special offers available'));
                      }

                      // Filter books that have an author
                      final booksWithAuthor = snapshot.data!
                          .where((book) => book.author != null && book.author!.name.isNotEmpty)
                          .toList();


                      // Get the first 3 books with authors or fewer if there aren't enough
                      final booksToShow = booksWithAuthor.length >= 3
                          ? booksWithAuthor.sublist(0, 3)
                          : booksWithAuthor;

                      // Display the books in a list with spacing
                      return Row(
                        children: booksToShow.map((book) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16.0), // Add space after each card
                            child: styleCard(book.author), // Replace with your actual widget
                          );
                        }).toList(),
                      );
                    },
                  )
    ],
              ),
            ),
          ),

          // vendors
          ListTile(
              title: Text('Vendors',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              trailing: TextButton(onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (c){
                    return VendorScreen();
                  })
              );},
                child: Text('See all',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                ,)
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  FutureBuilder<List<Vendor>>(
                    future: publishers,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Failed to load vendors'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No vendors available'));
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: snapshot.data!.map((vendor) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child:styleCard_vendor(vendor), // VendorWidget needs to be defined or imported
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ],
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
            icon: Icon(Icons.home,
              color: _selectedIndex == 0 ? Color(0xFF54408C) : Colors.grey,
            ),
            label: "HOME",
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt,
              color: _selectedIndex == 1 ? Color(0xFF54408C) : Colors.grey,
            ),
            label: 'Category',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart,
              color: _selectedIndex == 2 ? Color(0xFF54408C) : Colors.grey,
            ),
            label: "Cart",
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined,
              color: _selectedIndex == 3 ? Color(0xFF54408C) : Colors.grey,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget book_show(Book b) {
    return Container(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container for the book's image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity, // Adjust width as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(b.thumbnail), // Display book thumbnail
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 8), // Add space between image and text
          // Container for the book's title and price
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    b.title, // Display book title
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    // Ensure text does not overflow
                    maxLines: 1, // Limit title to one line
                  ),
                ),
                SizedBox(height: 4), // Add space between title and price
                Text(
                  "\$${b.price.toStringAsFixed(2)}", // Display book price
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget front_book(Book b, String title) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    BookDetailScreen(b: b),
              ),
            );
          },
          child: Container(
            width: 350,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFFAF9FD),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder for Book Cover Image
                Container(
                  width: 120,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[300], // Placeholder color
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      b.thumbnail,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 16),

                // Book Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Author Name
                      Text(
                        b.author.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      // Book Title
                      Text(
                        b.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Genre
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 16),
                      // Price Container
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xFF54408C),
                          // Background color of the price container
                          borderRadius: BorderRadius.circular(
                              12), // Rounded corners
                        ),
                        child: Text(
                          "\$${b.price.toStringAsFixed(2)}",
                          // Display book price
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Text color
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }

  Widget _buildSection(String title, Future<List<Book>> bookFuture) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            trailing: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return FutureBuilder<List<Book>>(
                        future: bookFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text('No books found'));
                          } else {
                            return CategoryBooksScreen(
                              category: title,
                              books: snapshot.data!,
                            );
                          }
                        },
                      );
                    },
                  ),
                );
              },
              child: Text(
                'See all',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          FutureBuilder<List<Book>>(
            future: bookFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No books found'));
              } else {
                return Container(
                  height: 220, // Adjust the height as needed
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final book = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookDetailScreen(b: book),
                            ),
                          );
                        },
                        child: Container(
                          width: 130, // Adjust the width as needed
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          child: book_show(book),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget styleCard(Author a){
    return GestureDetector(
        onTap: (){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ForEachScreen(
              'Author',
              a.name ?? 'Author', // Provide a default value
              a.job,
              a.about?? 'No information available.',
              a.photoPath ?? '', // Default to empty string if the path is null
              a.averageRating,
            )
        ),
      );
    },
    child:Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
        decoration: BoxDecoration(
        shape: BoxShape.circle, // Circular shape
          border: Border.all(color: Colors.black, width: 2), // Black border with a width of 3
          ),
              child: CircleAvatar(radius: 51,backgroundImage: AssetImage(a.photoPath),
              ),
            ),
            Center(
              child: Container(
              constraints: BoxConstraints(
                maxWidth: 100, // Adjust the width as needed
              ),
              child: Text(
                a.name ?? 'Author',
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                maxLines: 1, // Allow up to 2 lines
              ),
                        ),
            ),
            Container(
                height: 20,child: Text("${a.job}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),))
          ],
        ),
      ),
    )
    );
  }

  Widget styleCard_vendor(Vendor v){
    return GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ForEachScreen(
                  'Vendors',
                  v.name ?? 'Vendor', // Provide a default value
                  '',
                  v.about?? 'No information available.',
                  v.vindphoto ?? '', // Default to empty string if the path is null
                  v.rating,
                )
            ),
          );
        },
        child:Container(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Circular shape
                    border: Border.all(color: Colors.black, width: 2), // Black border with a width of 3
                  ),
                  child: CircleAvatar(radius: 51,backgroundImage: AssetImage(v.vindphoto),
                  ),
                ),
                Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 100, // Adjust the width as needed
                    ),
                    child: Text(
                      v.name ?? 'Vendor',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                      maxLines: 1, // Allow up to 2 lines
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

}





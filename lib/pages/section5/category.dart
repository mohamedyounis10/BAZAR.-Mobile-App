import 'package:bazarapp/pages/section8/notificationandorders.dart';
import 'package:bazarapp/pages/section9/Profile.dart';
import 'package:flutter/material.dart';
import 'package:bazarapp/models/book.dart';
import 'package:bazarapp/apicore/logic.dart';
import 'package:bazarapp/pages/section4/booklistscreen.dart';
import 'package:bazarapp/pages/section4/bookscreendetails.dart';
import 'package:bazarapp/pages/section4/shoppingcartscreen.dart'; // Assuming you have a service file for fetching data

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Book>> amineBooks;
  late Future<List<Book>> adventureBooks;
  late Future<List<Book>> novelBooks;
  late Future<List<Book>> horrorBooks;

  final BookService _bookService = BookService(); // Book service instance
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();

    // Initialize future book lists
    amineBooks = _bookService.AmineBooks();
    adventureBooks = _bookService.AdventureBooks();
    novelBooks = _bookService.NovelBooks();
    horrorBooks = _bookService.HorrorBooks();

    // Initialize the TabController with 5 categories
    _tabController = TabController(length: 5, vsync: this, initialIndex: 0);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the respective page based on the index
    if (index == 0) {
      Navigator.of(context).pop();
    } else if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen())); // Navigate to CategoryScreen
    } else if (index == 2) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ShoppingCartScreen()));
    } else if (index == 3) {
         Navigator.push(context, MaterialPageRoute(builder: (context) => Profile())); // Example, replace with actual ProfileScreen
    }
  }

  void _switchTab(int index) {
    if (index >= 0 && index < _tabController.length) {
      _tabController.animateTo(index);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text('Catehory', style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20
        ),),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back, size: 28,)),
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
        bottom: TabBar(
          isScrollable: true,
          labelColor: Color(0xFF54408C),
          unselectedLabelColor: Colors.black54,
          indicatorColor: Color(0xFF54408C),
          controller: _tabController,
          tabs: [
            Tab(text: 'All'),
            Tab(text: 'Anime'),
            Tab(text: 'Adventure'),
            Tab(text: 'Novel'),
            Tab(text: 'Horror'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildCategoryGridView(), // Page 1 with categories
          buildFutureBookGridView(amineBooks),
          buildFutureBookGridView(adventureBooks),
          buildFutureBookGridView(novelBooks),
          buildFutureBookGridView(horrorBooks),
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

  // Widget to handle future book list and display grid view
  Widget buildCategoryGridView() {
    // Example data for the first page (you can replace this with actual categories if needed)
    List<Map> categories = [
      {'title': 'Anime', 'url': 'assets/images/anime.png', 'index': 1},
      {'title': 'Adventure', 'url': 'assets/images/adven.png', 'index': 2},
      {'title': 'Novel', 'url': 'assets/images/novel.png', 'index': 3},
      {'title': 'Horror', 'url': 'assets/images/horror.png', 'index': 4},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(15.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () {
            _switchTab(category['index']);
          },
          child: Container(
            width: double.infinity, // Ensure the item takes full width of the grid cell
            height: 200, // Adjust the height of the entire item here
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder image for categories
                Container(
                  height: 190, // Height of the image
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    image: DecorationImage(
                      image: AssetImage(category['url']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        category['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget to handle future book list and display grid view
  Widget buildFutureBookGridView(Future<List<Book>> futureBooks) {
    return FutureBuilder<List<Book>>(
      future: futureBooks,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No books available.'));
        }
        return BookGridView(books: snapshot.data!);
      },
    );
  }
}

// A reusable widget for displaying books in a grid
class BookGridView extends StatelessWidget {
  final List<Book> books;

  const BookGridView({required this.books});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return BookItem(book: books[index]);
        },
      ),
    );
  }
}

// Book item widget
class BookItem extends StatelessWidget {
  final Book book;
  BookItem({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (c){
            return BookDetailScreen(b:book);
          })
        );
      },
      child: Container(
        width: double.infinity, // Ensure the item takes full width of the grid cell
        height: 200, // Adjust the height of the entire item here
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Image
            Container(
              height: 170, // Height of the book image
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                image: DecorationImage(
                  image: NetworkImage(book.thumbnail), // Ensure this path is correct
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        book.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      book.price.toStringAsFixed(2),
                      style: TextStyle(color: Colors.purple),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




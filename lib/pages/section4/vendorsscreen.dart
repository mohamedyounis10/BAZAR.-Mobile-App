import 'package:flutter/material.dart';
import 'package:bazarapp/apicore/logic.dart'; // Import your BookService logic
import 'package:bazarapp/models/book.dart';
import 'package:bazarapp/models/vendor.dart';
import 'package:bazarapp/pages/section4/foreach.dart';
import 'package:bazarapp/pages/section5/searchscreen.dart';

class VendorScreen extends StatefulWidget {
  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  final BookService _bookService = BookService();

  late Future<List<Book>> books;
  late Future<List<Vendor>> publishers;

  @override
  void initState() {
    super.initState();
    books=_bookService.AllBooks();
    publishers = books.then((bookList) => _bookService.getPublishers(bookList)); // Converting books to publishers
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white, // when  make scroll not change color
        title: Text(
          'Vendors',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
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
            icon: Icon(Icons.search, size: 28),
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
              'Our Vendors',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(height: 8),

            Text(
              'Vendors',
              style: TextStyle(color: Color(0xFF54408C), fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            Expanded(
              child: FutureBuilder<List<Vendor>>(
                future: publishers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Failed to load vendors'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No vendors found'));
                  } else {
                    List<Vendor> vendors = snapshot.data!;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: vendors.length,
                      itemBuilder: (context, index) {
                        return VendorWidget(vendor: vendors[index]);
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

class VendorWidget extends StatelessWidget {
  final Vendor vendor;

  const VendorWidget({Key? key, required this.vendor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ForEachScreen(
                'Vendor',
                vendor.name ?? 'Vendor', // Provide a default value
                '',
                vendor.about?? 'No information available.',
                vendor.vindphoto ?? '', // Default to empty string if the path is null
                vendor.rating,
              )
          ),
        );
      },
      child:Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Image.asset(vendor.vindphoto, fit: BoxFit.contain),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          vendor.name,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Icon(
              Icons.star,
              color: index < vendor.rating ? Colors.orange : Colors.grey,
              size: 16,
            );
          }),
        ),
      ],
    ) ,
    ) ;
  }
}

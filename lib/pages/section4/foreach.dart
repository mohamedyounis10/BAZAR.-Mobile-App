import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ForEachScreen extends StatelessWidget {
  String title_bar ; // author or vendor
  String name ;
  String job;
  String about ;
  String url;
  double rating ;

  ForEachScreen(this.title_bar,this.name,this.job,this.about,this.url,this.rating);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          title_bar,
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
                Column(
                  children: [
                    // Image
                    Center(
                      child: Container(
                        width: 250,
                        height: 250, // Set both width and height to be equal for a perfect circle
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // Circular shape
                          border: Border.all(color: Colors.black, width: 2), // Black border with a width of 3
                          image: DecorationImage(
                            image: AssetImage(url), // Replace with your image path
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),

                    // job
                    Text(
                      job,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 8),

                    // Name
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),

                    // Rating Section
                    Row(
                      mainAxisSize: MainAxisSize.min,
                        children: [
                          RatingBarIndicator(
                            rating: rating, // The static value
                            itemCount: 5,
                            itemSize: 27,
                            direction: Axis.horizontal,
                            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '(${rating.toStringAsFixed(2)})',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: 16),

                // Description
                Text(
                  'About',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  about,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

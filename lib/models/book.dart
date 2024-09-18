import 'dart:math';
import 'package:bazarapp/models/author.dart';
import 'package:bazarapp/models/vendor.dart';

class Book {
  final String id;
  final String title;
  final String description;
  final String thumbnail;
  final String authors;
  final String publisher;
  final double averageRating;
  final double price;

  // Author and Vendor instances
  final Author author;
  final Vendor vendor;

  Book({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.authors,
    required this.publisher,
    required this.averageRating,
    required this.price,
    required this.author,
    required this.vendor,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    double generateRandomPrice() {
      final Random random = Random();
      return 50 + random.nextDouble() * 50; // Generates price between 50 and 100
    }

    double generateRandomRating() {
      final Random random = Random();
      double mean = 4.0;
      double stddev = 1.0;
      double rating = mean + stddev * random.nextDouble();
      return rating.clamp(0.0, 5.0);
    }

    double getPrice(Map<String, dynamic>? saleInfo) {
      if (saleInfo == null || saleInfo['retailPrice'] == null) {
        return generateRandomPrice();
      }
      return (saleInfo['retailPrice']['amount'] as num?)?.toDouble() ?? generateRandomPrice();
    }

    double getRating(Map<String, dynamic>? volumeInfo) {
      if (volumeInfo == null || volumeInfo['averageRating'] == null) {
        return generateRandomRating();
      }
      return (volumeInfo['averageRating'] as num?)?.toDouble() ?? generateRandomRating();
    }

    String getAuthors(List<dynamic>? authorsList) {
      if (authorsList == null || authorsList.isEmpty) {
        return 'No Authors';
      }
      return authorsList.map((author) => author.toString()).join(', ');
    }

    return Book(
      id: json['id'] as String? ?? 'No ID',
      title: json['volumeInfo']['title'] as String? ?? 'No Title',
      description: json['volumeInfo']['description'] as String? ?? 'No Description',
      thumbnail: json['volumeInfo']['imageLinks'] != null
          ? json['volumeInfo']['imageLinks']['thumbnail'] as String
          : 'https://via.placeholder.com/150', // Placeholder image
      authors: getAuthors(json['volumeInfo']['authors'] as List<dynamic>?),
      publisher: json['volumeInfo']['publisher'] as String? ?? 'No Publisher',
      averageRating: getRating(json['volumeInfo'] as Map<String, dynamic>?),
      price: getPrice(json['saleInfo'] as Map<String, dynamic>?),
      author: Author(name: getAuthors(json['volumeInfo']['authors'] as List<dynamic>?)), // Handle author initialization
      vendor: Vendor(name: json['volumeInfo']['publisher'] as String? ?? 'No Publisher'), // Handle vendor initialization
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'authors': authors,
      'publisher': publisher,
      'averageRating': averageRating,
      'price': price,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'authors': authors,
      'publisher': publisher,
      'averageRating': averageRating,
      'price': price,
      'author': author.toMap(), // Convert Author to map
      'vendor': vendor.toMap(), // Convert Vendor to map
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as String? ?? 'No ID',
      title: map['title'] as String? ?? 'No Title',
      description: map['description'] as String? ?? 'No Description',
      thumbnail: map['thumbnail'] as String? ?? 'https://via.placeholder.com/150', // Placeholder image
      authors: map['authors'] as String? ?? 'No Authors',
      publisher: map['publisher'] as String? ?? 'No Publisher',
      averageRating: (map['averageRating'] as num?)?.toDouble() ?? 0.0,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      author: Author.fromMap(map['author'] ?? {}), // Provide default empty map if null
      vendor: Vendor.fromMap(map['vendor'] ?? {}), // Provide default empty map if null
    );
  }
}

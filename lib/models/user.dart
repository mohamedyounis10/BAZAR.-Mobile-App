import 'package:bazarapp/models/book.dart';

class User_app {
  // Private constructor
  User_app._privateConstructor();

  // Singleton instance
  static final User_app _instance = User_app._privateConstructor();

  // Factory method to return the singleton instance
  factory User_app() {
    return _instance;
  }

  // Shopping cart with book and number of copies
  List<Map<Book, int>> shoppingCart = [];
  List<Book> favoriteCart = [];
  List<Map<Book, int>> orderedCart = [];
}

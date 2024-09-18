// book_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bazarapp/models/book.dart';
import 'package:bazarapp/models/vendor.dart';

class BookService {
  Future<List<Book>> AllBooks() async {
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=Fiction&maxResults=40'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Book> books =
      (data['items'] as List).map((item) => Book.fromJson(item)).toList();
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<List<Book>> AmineBooks() async {
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=amine+manga&maxResults=39'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Book> books =
      (data['items'] as List).map((item) => Book.fromJson(item)).toList();
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<List<Book>> AdventureBooks() async {
    final response = await http.get(Uri.parse(
        "https://www.googleapis.com/books/v1/volumes?q=action+adventure&maxResults=39"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Book> books =
      (data['items'] as List).map((item) => Book.fromJson(item)).toList();
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<List<Book>> NovelBooks() async {
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=novel&maxResults=39'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Book> books =
      (data['items'] as List).map((item) => Book.fromJson(item)).toList();
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<List<Book>> HorrorBooks() async {
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=horroe&maxResults=39'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Book> books =
      (data['items'] as List).map((item) => Book.fromJson(item)).toList();
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<List<Book>> searchBooks(String query) async {
    final response = await http.get(Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query&maxResults=40'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Book> books = (data['items'] as List).map((item) => Book.fromJson(item)).toList();
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<List<Vendor>> getPublishers(List<Book> books) async {
    List<Vendor> vendors = books.map((book) {
      String publisherName = book.publisher ?? 'Unknown';
      return Vendor(
        name: publisherName,
      );
    }).toList();

    vendors = vendors.toSet().toList();
    return vendors;
  }
}

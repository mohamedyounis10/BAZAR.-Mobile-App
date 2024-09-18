import 'dart:math';

class Vendor {
  String name;
  String vindphoto;
  String about;
  double rating; // Added property for vendor rating

  // Constructor with initializer list for vindphoto and rating
  Vendor({
    required this.name,
    String? about,
    String? vindphoto, // Added parameter for vindphoto
    double? rating, // Added parameter for rating
  })  : vindphoto = vindphoto ?? 'assets/images/vendorLogo.png', // Initialize vindphoto with a default image path
        rating = rating ?? _generateRandomRating(), // Initialize rating with a random value
        about = about ?? _generateRandomAbout() { // Initialize about with a default value if not provided
    // No additional code needed in the constructor body
  }

  // Function to generate a random "about" text
  static String _generateRandomAbout() {
    List<String> phrases = [
      "is a leading vendor known for high-quality products and excellent customer service.",
      "offers a wide range of products, catering to diverse customer needs.",
      "is renowned for its commitment to sustainability and ethical business practices.",
      "provides top-notch support and assistance to all its clients.",
      "has been a trusted name in the industry for many years.",
      "is dedicated to providing an exceptional shopping experience.",
      "specializes in offering exclusive products at competitive prices.",
      "is known for its innovative solutions and cutting-edge technology.",
      "frequently receives positive feedback for its outstanding service.",
      "is a go-to choice for customers seeking reliability and quality."
    ];

    Random random = Random();
    int numberOfPhrases = random.nextInt(3) + 2; // Choose between 2 to 4 phrases
    List<String> selectedPhrases = [];

    for (int i = 0; i < numberOfPhrases; i++) {
      selectedPhrases.add(phrases[random.nextInt(phrases.length)]);
    }

    return selectedPhrases.join(" "); // Return generated "about" text
  }

  // Function to generate a random average rating between 0 and 5
  static double _generateRandomRating() {
    Random random = Random();
    return random.nextDouble() * 5; // Generates rating between 0 and 5
  }

  // Convert Vendor instance to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'vindphoto': vindphoto,
      'about': about,
      'rating': rating,
    };
  }

  // Create a Vendor instance from a map
  factory Vendor.fromMap(Map<String, dynamic> map) {
    return Vendor(
      name: map['name'] ?? '',
      about: map['about'] ?? _generateRandomAbout(),
      vindphoto: map['vindphoto'] ?? 'assets/images/vendorLogo.png',
      rating: (map['rating'] ?? _generateRandomRating()).toDouble(),
    );
  }
}

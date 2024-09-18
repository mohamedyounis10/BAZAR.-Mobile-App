import 'dart:math';

class Author {
  String name;
  String job;
  String photoPath; // Store the path as a string, not as an Image widget
  String? about;
  double averageRating;

  Author({
    required this.name,
    String? job,
    String? photoPath,
    double? averageRating,
    String? about,
  })  : job = job ?? _generateRandomJob(),
        photoPath = photoPath ?? 'assets/images/Author.png', // Store the image path
        averageRating = averageRating ?? _generateRandomRating(),
        about = about ?? _generateRandomAbout();

  // Function to generate a random "about" text
  static String _generateRandomAbout() {
    List<String> phrases = [
      "is a highly acclaimed author known for their captivating storytelling.",
      "has a unique style that blends modern themes with classic literature.",
      "is passionate about bringing new perspectives to light through their writing.",
      "enjoys exploring complex characters and intricate plotlines.",
      "has been writing since a young age, drawing inspiration from personal experiences.",
      "often writes about the nuances of human relationships and societal issues.",
      "is not only an author but also a dedicated advocate for literacy and education.",
      "frequently participates in literary festivals and enjoys connecting with readers.",
      "has won numerous awards for their exceptional contributions to literature.",
      "is known for their engaging and thought-provoking narratives."
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

  // Function to generate a random job title
  static String _generateRandomJob() {
    List<String> jobs = [
      "Author",
      "Novelist",
      "Poet",
      "Playwright",
      "Screenwriter",
      "Editor",
      "Literary Critic",
      "Journalist",
      "Creative Writer",
      "Book Reviewer",
      "Publisher",
      "Scriptwriter",
      "Content Creator"
    ];

    Random random = Random();
    return jobs[random.nextInt(jobs.length)];
  }

  factory Author.fromMap(Map<String, dynamic> map) {
    return Author(
      name: map['name'],
      job: map['job'],
      about: map['about'],
      photoPath: map['photoPath'],
      averageRating: map['averageRating'],
    );
  }

  // Convert Author instance to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'job': job,
      'about': about,
      'photoPath': photoPath,
      'averageRating': averageRating,
    };
  }
}

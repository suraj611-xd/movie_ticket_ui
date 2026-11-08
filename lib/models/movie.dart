import 'package:flutter/material.dart';

class Movie {
  final String title;
  final String genre;
  final String language;
  final String duration;
  final String certificate;
  final double rating;
  final String description;
  final List<String> cast;
  final List<Color> colors;
  final IconData icon;

  const Movie({
    required this.title,
    required this.genre,
    required this.language,
    required this.duration,
    required this.certificate,
    required this.rating,
    required this.description,
    required this.cast,
    required this.colors,
    required this.icon,
  });
}

const List<Movie> movies = [
  Movie(
    title: 'Midnight Express',
    genre: 'Thriller',
    language: 'English',
    duration: '2h 10m',
    certificate: 'UA',
    rating: 8.4,
    description:
        'A night train, a missing briefcase and twelve suspects. A detective has until sunrise to find the truth before the train reaches its final stop.',
    cast: ['Arjun Rao', 'Meera Nair', 'Daniel Cole'],
    colors: [Color(0xFF0F2027), Color(0xFF2C5364)],
    icon: Icons.train,
  ),
  Movie(
    title: 'Neon Skyline',
    genre: 'Sci-Fi',
    language: 'English',
    duration: '2h 32m',
    certificate: 'UA',
    rating: 8.9,
    description:
        'In a city that never sleeps, a young engineer discovers a hidden signal from the stars that could change humanity forever.',
    cast: ['Kiara Singh', 'Leo Martin', 'Anil Kapoor'],
    colors: [Color(0xFF41295A), Color(0xFF2F0743)],
    icon: Icons.rocket_launch,
  ),
  Movie(
    title: 'The Last Monsoon',
    genre: 'Drama',
    language: 'Hindi',
    duration: '2h 05m',
    certificate: 'U',
    rating: 8.1,
    description:
        'A family returns to their ancestral village for one final monsoon, and old secrets rise with the river.',
    cast: ['Radhika Sen', 'Vikram Iyer', 'Pooja Menon'],
    colors: [Color(0xFF134E5E), Color(0xFF71B280)],
    icon: Icons.water_drop,
  ),
  Movie(
    title: 'Laugh Out Loud',
    genre: 'Comedy',
    language: 'Telugu',
    duration: '2h 00m',
    certificate: 'U',
    rating: 7.6,
    description:
        'Three college friends start a food truck business and accidentally become famous. Chaos, friendship and plenty of laughs follow.',
    cast: ['Sai Teja', 'Anjali Rao', 'Naveen Babu'],
    colors: [Color(0xFFF2994A), Color(0xFFF2C94C)],
    icon: Icons.sentiment_very_satisfied,
  ),
  Movie(
    title: "Dragon's Oath",
    genre: 'Fantasy',
    language: 'English',
    duration: '2h 45m',
    certificate: 'UA',
    rating: 8.7,
    description:
        'A young knight swears an oath to a sleeping dragon and must unite five kingdoms before the ancient flame awakens.',
    cast: ['Ethan Hale', 'Sofia Reyes', 'Marcus Webb'],
    colors: [Color(0xFF8E0E00), Color(0xFF1F1C18)],
    icon: Icons.auto_awesome,
  ),
  Movie(
    title: 'Cricket Crazy',
    genre: 'Sport',
    language: 'Hindi',
    duration: '2h 20m',
    certificate: 'U',
    rating: 7.9,
    description:
        'A small-town coach and a team of underdogs chase the state championship with nothing but heart and a broken bat.',
    cast: ['Rohit Verma', 'Neha Joshi', 'Sameer Khan'],
    colors: [Color(0xFF1D976C), Color(0xFF93F9B9)],
    icon: Icons.sports_cricket,
  ),
  Movie(
    title: 'Whispers',
    genre: 'Horror',
    language: 'English',
    duration: '1h 50m',
    certificate: 'A',
    rating: 7.2,
    description:
        'A new family moves into an old house where the walls seem to whisper at night. Some voices should never be answered.',
    cast: ['Clara Bennett', 'Tom Hardy Jr.', 'Ivy Lane'],
    colors: [Color(0xFF232526), Color(0xFF414345)],
    icon: Icons.nightlight_round,
  ),
];

const List<String> showTimes = ['10:30 AM', '1:45 PM', '5:00 PM', '8:15 PM', '10:45 PM'];

List<String> get genres => ['All', ...{for (final m in movies) m.genre}];

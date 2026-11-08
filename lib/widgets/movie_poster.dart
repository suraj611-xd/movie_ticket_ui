import 'package:flutter/material.dart';

import '../models/movie.dart';

/// A gradient "poster" with an icon, so the app needs no image files.
class MoviePoster extends StatelessWidget {
  final Movie movie;
  final bool big;

  const MoviePoster({super.key, required this.movie, this.big = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: movie.colors,
        ),
      ),
      child: Stack(
        children: [
          Center(child: Icon(movie.icon, size: big ? 96 : 44, color: Colors.white70)),
          if (!big)
            Positioned(
              left: 6,
              right: 6,
              bottom: 8,
              child: Text(
                movie.title,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}

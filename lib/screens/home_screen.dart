import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../widgets/movie_poster.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _genre = 'All';
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final list = movies.where((m) {
      final okGenre = _genre == 'All' || m.genre == _genre;
      final okQuery = m.title.toLowerCase().contains(_query.toLowerCase());
      return okGenre && okQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.movie_creation_outlined),
            SizedBox(width: 8),
            Text('CineBook', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search movies',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: genres
                  .map((g) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(g),
                          selected: _genre == g,
                          onSelected: (_) => setState(() => _genre = g),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Now Showing', style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? const Center(child: Text('No movies found'))
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 480,
                      mainAxisExtent: 170,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: list.length,
                    itemBuilder: (_, i) => _MovieCard(movie: list[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final Movie movie;
  const _MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailsScreen(movie: movie)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 112,
              child: Hero(tag: 'poster-${movie.title}', child: MoviePoster(movie: movie)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(movie.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text('${movie.genre} \u2022 ${movie.language}', style: theme.textTheme.bodySmall),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text('${movie.rating}/10'),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text('${movie.duration} \u2022 ${movie.certificate}', style: theme.textTheme.bodySmall),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.tonal(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => DetailsScreen(movie: movie)),
                        ),
                        child: const Text('Book Tickets'),
                      ),
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

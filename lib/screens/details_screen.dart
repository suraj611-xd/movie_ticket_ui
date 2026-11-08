import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../utils/format.dart';
import '../widgets/movie_poster.dart';
import 'seat_screen.dart';

class DetailsScreen extends StatefulWidget {
  final Movie movie;
  const DetailsScreen({super.key, required this.movie});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final List<DateTime> _dates = List.generate(7, (i) => DateTime.now().add(Duration(days: i)));
  int _dateIndex = 0;
  String? _time;

  @override
  Widget build(BuildContext context) {
    final m = widget.movie;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(m.title)),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: _time == null
                  ? null
                  : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SeatScreen(movie: m, date: _dates[_dateIndex], time: _time!),
                        ),
                      ),
              icon: const Icon(Icons.event_seat),
              label: Text(_time == null ? 'Choose a showtime' : 'Select Seats'),
            ),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  height: 220,
                  child: Hero(tag: 'poster-${m.title}', child: MoviePoster(movie: m, big: true)),
                ),
              ),
              const SizedBox(height: 16),
              Text(m.title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text('${m.rating}/10', style: theme.textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(label: Text(m.genre)),
                  Chip(label: Text(m.language)),
                  Chip(label: Text(m.duration)),
                  Chip(label: Text(m.certificate)),
                ],
              ),
              const SizedBox(height: 16),
              Text('Story', style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(m.description),
              const SizedBox(height: 16),
              Text('Cast', style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(m.cast.join('  \u2022  ')),
              const SizedBox(height: 20),
              Text('Select date', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              SizedBox(
                height: 76,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _dates.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final d = _dates[i];
                    return ChoiceChip(
                      showCheckmark: false,
                      selected: _dateIndex == i,
                      onSelected: (_) => setState(() => _dateIndex = i),
                      label: SizedBox(
                        width: 44,
                        height: 52,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(weekdayShort[d.weekday - 1]),
                            Text('${d.day}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text('Select showtime', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: showTimes
                    .map((t) => ChoiceChip(
                          label: Text(t),
                          selected: _time == t,
                          onSelected: (_) => setState(() => _time = t),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

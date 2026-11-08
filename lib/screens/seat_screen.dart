import 'dart:math';

import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../utils/format.dart';
import 'ticket_screen.dart';

const String _rows = 'ABCDEFGH';
const int _cols = 10;
const int _maxSeats = 8;

int priceForRow(int r) => r < 3 ? 150 : (r < 6 ? 200 : 300);
String tierForRow(int r) => r < 3 ? 'SILVER' : (r < 6 ? 'GOLD' : 'PLATINUM');

class SeatScreen extends StatefulWidget {
  final Movie movie;
  final DateTime date;
  final String time;

  const SeatScreen({super.key, required this.movie, required this.date, required this.time});

  @override
  State<SeatScreen> createState() => _SeatScreenState();
}

class _SeatScreenState extends State<SeatScreen> {
  late final Set<String> _booked;
  final Set<String> _selected = {};

  @override
  void initState() {
    super.initState();
    _booked = _generateBooked();
  }

  /// Some seats are already "booked"; the pattern depends on movie, date and time.
  Set<String> _generateBooked() {
    int seed = 0;
    for (final c in '${widget.movie.title}${widget.time}${widget.date.day}'.codeUnits) {
      seed = (seed * 31 + c) & 0x7fffffff;
    }
    final rnd = Random(seed);
    final s = <String>{};
    while (s.length < 22) {
      s.add('${_rows[rnd.nextInt(_rows.length)]}${rnd.nextInt(_cols) + 1}');
    }
    return s;
  }

  int _price(String id) => priceForRow(_rows.indexOf(id[0]));

  int get _total => _selected.fold(0, (sum, id) => sum + _price(id));

  List<String> get _sortedSeats {
    final l = _selected.toList();
    l.sort((a, b) {
      if (a[0] != b[0]) return a[0].compareTo(b[0]);
      return int.parse(a.substring(1)).compareTo(int.parse(b.substring(1)));
    });
    return l;
  }

  void _toggle(String id) {
    if (_booked.contains(id)) return;
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else if (_selected.length >= _maxSeats) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You can book up to 8 seats at a time')),
        );
      } else {
        _selected.add(id);
      }
    });
  }

  Widget _seat(String id, double size) {
    final cs = Theme.of(context).colorScheme;
    final booked = _booked.contains(id);
    final selected = _selected.contains(id);
    final Color fill = booked ? Colors.grey.shade800 : (selected ? cs.primary : Colors.transparent);
    final Color border = booked ? Colors.grey.shade800 : (selected ? cs.primary : Colors.white54);

    return GestureDetector(
      onTap: () => _toggle(id),
      child: Container(
        width: size,
        height: size,
        margin: const EdgeInsets.all(3),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fill,
          border: Border.all(color: border),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8), bottom: Radius.circular(3)),
        ),
        child: Text(
          id.substring(1),
          style: TextStyle(
            fontSize: 10,
            color: booked ? Colors.grey.shade600 : (selected ? cs.onPrimary : Colors.white70),
          ),
        ),
      ),
    );
  }

  Widget _row(int r, double size) {
    final label = SizedBox(
      width: 20,
      child: Text(_rows[r], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white54)),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        label,
        for (int c = 1; c <= _cols; c++) ...[
          if (c == 6) const SizedBox(width: 22),
          _seat('${_rows[r]}$c', size),
        ],
        label,
      ],
    );
  }

  Widget _legend(String text, Color fill, Color border) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: fill,
              border: Border.all(color: border),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final seats = _sortedSeats;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.movie.title, style: const TextStyle(fontSize: 18)),
            Text('${fmtDate(widget.date)} \u2022 ${widget.time}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.white12))),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      seats.isEmpty ? 'No seats selected' : '${seats.length} seat${seats.length == 1 ? '' : 's'}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(seats.isEmpty ? 'Tap a seat to select' : seats.join(', '),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              FilledButton(
                onPressed: seats.isEmpty
                    ? null
                    : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TicketScreen(
                              movie: widget.movie,
                              date: widget.date,
                              time: widget.time,
                              seats: seats,
                              total: _total,
                            ),
                          ),
                        ),
                child: Text('Pay \u20B9$_total'),
              ),
            ],
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final avail = min(constraints.maxWidth, 640.0) - 32;
          final size = ((avail - 62) / _cols - 6).clamp(22.0, 40.0).toDouble();
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: LinearGradient(colors: [Colors.transparent, cs.primary, Colors.transparent]),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Center(
                    child: Text('SCREEN THIS WAY',
                        style: TextStyle(fontSize: 11, letterSpacing: 2, color: Colors.white54)),
                  ),
                  const SizedBox(height: 16),
                  for (int r = 0; r < _rows.length; r++) ...[
                    if (r == 0 || r == 3 || r == 6)
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 4, left: 4),
                        child: Text('${tierForRow(r)}  \u2022  \u20B9${priceForRow(r)}',
                            style: const TextStyle(fontSize: 11, letterSpacing: 1, color: Colors.white54)),
                      ),
                    _row(r, size),
                  ],
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20,
                    runSpacing: 8,
                    children: [
                      _legend('Available', Colors.transparent, Colors.white54),
                      _legend('Selected', cs.primary, cs.primary),
                      _legend('Booked', Colors.grey.shade800, Colors.grey.shade800),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

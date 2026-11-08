import 'dart:math';

import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../utils/format.dart';

class TicketScreen extends StatefulWidget {
  final Movie movie;
  final DateTime date;
  final String time;
  final List<String> seats;
  final int total;

  const TicketScreen({
    super.key,
    required this.movie,
    required this.date,
    required this.time,
    required this.seats,
    required this.total,
  });

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  late final String _bookingId =
      'CB${(DateTime.now().millisecondsSinceEpoch % 1000000).toString().padLeft(6, '0')}';

  Widget _info(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, letterSpacing: 1, color: Colors.black54)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final m = widget.movie;
    final bg = Theme.of(context).scaffoldBackgroundColor;

    Widget notch(bool left) => Positioned(
          left: left ? -14 : null,
          right: left ? null : -14,
          top: 0,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          ),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Your Ticket'), automaticallyImplyLeading: false),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              children: [
                const Icon(Icons.check_circle, color: Colors.greenAccent, size: 48),
                const SizedBox(height: 8),
                const Text('Booking Confirmed!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          gradient: LinearGradient(colors: m.colors),
                        ),
                        child: Row(
                          children: [
                            Icon(m.icon, color: Colors.white, size: 40),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(m.title,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                  Text('${m.genre} \u2022 ${m.language} \u2022 ${m.duration}',
                                      style: const TextStyle(color: Colors.white70)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Wrap(
                          spacing: 32,
                          runSpacing: 16,
                          children: [
                            _info('DATE', fmtDate(widget.date)),
                            _info('TIME', widget.time),
                            _info('SCREEN', 'Screen 3'),
                            _info('TICKETS', '${widget.seats.length}'),
                            _info('SEATS', widget.seats.join(', ')),
                            _info('AMOUNT PAID', '\u20B9${widget.total}'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 28,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: CustomPaint(painter: _DashedLinePainter()),
                              ),
                            ),
                            notch(true),
                            notch(false),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 110,
                              height: 110,
                              child: CustomPaint(painter: _FakeQrPainter(_bookingId)),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _info('BOOKING ID', _bookingId),
                                  const SizedBox(height: 12),
                                  const Text('Show this ticket at the entrance',
                                      style: TextStyle(fontSize: 12, color: Colors.black54)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                    icon: const Icon(Icons.home),
                    label: const Text('Back to Home'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black38
      ..strokeWidth = 1.5;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, size.height / 2), Offset(x + 6, size.height / 2), paint);
      x += 12;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A decorative QR-style pattern generated from the booking id (not a real QR code).
class _FakeQrPainter extends CustomPainter {
  final String data;
  _FakeQrPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    const n = 21;
    final cell = size.width / n;
    final black = Paint()..color = Colors.black;
    final white = Paint()..color = Colors.white;

    int seed = 7;
    for (final c in data.codeUnits) {
      seed = (seed * 31 + c) & 0x7fffffff;
    }
    final rnd = Random(seed);

    bool isFinder(int x, int y) =>
        (x < 7 && y < 7) || (x >= n - 7 && y < 7) || (x < 7 && y >= n - 7);

    for (int y = 0; y < n; y++) {
      for (int x = 0; x < n; x++) {
        if (isFinder(x, y)) continue;
        if (rnd.nextBool()) {
          canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), black);
        }
      }
    }

    void finder(int ox, int oy) {
      canvas.drawRect(Rect.fromLTWH(ox * cell, oy * cell, 7 * cell, 7 * cell), black);
      canvas.drawRect(Rect.fromLTWH((ox + 1) * cell, (oy + 1) * cell, 5 * cell, 5 * cell), white);
      canvas.drawRect(Rect.fromLTWH((ox + 2) * cell, (oy + 2) * cell, 3 * cell, 3 * cell), black);
    }

    finder(0, 0);
    finder(n - 7, 0);
    finder(0, n - 7);
  }

  @override
  bool shouldRepaint(covariant _FakeQrPainter oldDelegate) => oldDelegate.data != data;
}

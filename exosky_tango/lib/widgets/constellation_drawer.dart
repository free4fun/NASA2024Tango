import 'package:flutter/material.dart';

class ConstellationDrawer extends StatefulWidget {
  const ConstellationDrawer({Key? key}) : super(key: key);

  @override
  _ConstellationDrawerState createState() => _ConstellationDrawerState();
}

class _ConstellationDrawerState extends State<ConstellationDrawer> {
  final List<List<Offset>> _lines = [];
  List<Offset> _currentLine = [];
  String _constellationName = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  _currentLine = [details.localPosition];
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  _currentLine.add(details.localPosition);
                });
              },
              onPanEnd: (details) {
                setState(() {
                  _lines.add(List.from(_currentLine));
                  _currentLine.clear();
                });
              },
              child: CustomPaint(
                painter: ConstellationPainter(_lines, _currentLine),
                child: Container(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter constellation name',
                    ),
                    onChanged: (value) {
                      _constellationName = value;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: _saveConstellation,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _saveConstellation() {
    // Here you would save the constellation to a database or state management system
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Constellation "$_constellationName" saved')),
    );
    setState(() {
      _lines.clear();
      _constellationName = '';
    });
  }
}

class ConstellationPainter extends CustomPainter {
  final List<List<Offset>> lines;
  final List<Offset> currentLine;

  ConstellationPainter(this.lines, this.currentLine);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;

    for (var line in lines) {
      for (int i = 0; i < line.length - 1; i++) {
        canvas.drawLine(line[i], line[i + 1], paint);
      }
    }

    for (int i = 0; i < currentLine.length - 1; i++) {
      canvas.drawLine(currentLine[i], currentLine[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

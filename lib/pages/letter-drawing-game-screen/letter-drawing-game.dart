// ignore_for_file: library_private_types_in_public_api, file_names

import 'dart:developer';

import 'package:flutter/material.dart';

class LetterDrawingGame extends StatefulWidget {
  final String character; // Letra ou número para praticar
  final double strokeWidth;
  final Color traceColor;
  final Color outlineColor;

  const LetterDrawingGame({
    super.key,
    required this.character,
    this.strokeWidth = 8.0,
    this.traceColor = Colors.blue,
    this.outlineColor = Colors.grey,
  });

  @override
  _LetterDrawingGameState createState() => _LetterDrawingGameState();
}

class _LetterDrawingGameState extends State<LetterDrawingGame> {
  List<Offset?> points = [];
  bool isCorrect = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              points.add(renderBox.globalToLocal(details.globalPosition));
            });
          },
          onPanEnd: (details) {
            setState(() {
              points.add(null);
              isCorrect = checkIfCorrect();
              log('isCorrect: $isCorrect');

              if (isCorrect) {
                _showSuccessDialog();
              }
            });
          },
          child: CustomPaint(
            size: Size.infinite,
            painter: _DrawingPainter(
              points: points,
              character: widget.character,
              strokeWidth: widget.strokeWidth,
              traceColor: widget.traceColor,
              outlineColor: widget.outlineColor,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                points.clear();
                isCorrect = false;
              });
            },
            child: const Text("Limpar"),
          ),
        ),
      ],
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Parabéns!"),
          content: const Text("Você desenhou corretamente!"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  bool checkIfCorrect() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    // Criar um contorno aproximado da letra usando TextPainter e uma área de interseção
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: widget.character,
        style: TextStyle(
          fontSize: size.width * 0.7,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Calcular a posição da letra no centro
    Offset offset = Offset(
      size.width / 2 - textPainter.width / 2,
      size.height / 2 - textPainter.height / 2,
    );

    // Criar um retângulo que cerca a área do texto
    Rect textRect = offset & Size(textPainter.width, textPainter.height);

    // Verifica a precisão do traçado
    int pointsInside = 0;
    int threshold =
        (points.length * 0.8).toInt(); // 80% dos pontos devem estar dentro

    for (var point in points) {
      if (point != null && textRect.contains(point)) {
        pointsInside++;
      }
    }
    log('pointsInside: $pointsInside');
    log('pointsThreshold: $threshold');

    // Verifica se pelo menos 80% dos pontos estão dentro do retângulo ao redor da letra
    return pointsInside >= threshold;
  }
}

class _DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final String character;
  final double strokeWidth;
  final Color traceColor;
  final Color outlineColor;

  _DrawingPainter({
    required this.points,
    required this.character,
    required this.strokeWidth,
    required this.traceColor,
    required this.outlineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint tracePaint = Paint()
      ..color = traceColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round;

    // Desenhar o contorno da letra usando TextPainter
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: character,
        style: TextStyle(
          fontSize: size.width * 0.7,
          fontWeight: FontWeight.bold,
          color: outlineColor.withOpacity(0.3),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.width / 2 - textPainter.width / 2,
        size.height / 2 - textPainter.height / 2,
      ),
    );

    // Traçado do usuário
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, tracePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

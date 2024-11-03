// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';

class ColorShapeSortingGame extends StatefulWidget {
  const ColorShapeSortingGame({super.key});

  @override
  _ColorShapeSortingGameState createState() => _ColorShapeSortingGameState();
}

class _ColorShapeSortingGameState extends State<ColorShapeSortingGame> {
  final List<Map<String, dynamic>> items = [
    {'shape': 'circle', 'color': Colors.blue},
    {'shape': 'square', 'color': Colors.red},
    {'shape': 'circle', 'color': Colors.red},
    {'shape': 'square', 'color': Colors.blue},
  ];

  // Define os recipientes de classificação
  final List<Map<String, dynamic>> targetContainers = [
    {'shape': 'circle', 'color': Colors.blue},
    {'shape': 'square', 'color': Colors.red},
    {'shape': 'circle', 'color': Colors.red},
    {'shape': 'square', 'color': Colors.blue},
  ];

  // Define as respostas corretas para cada recipiente
  final Map<String, int> correctCounts = {
    'circle_blue': 0,
    'square_red': 0,
    'circle_red': 0,
    'square_blue': 0,
  };

  // Controla a quantidade atual em cada recipiente
  final Map<String, int> currentCounts = {
    'circle_blue': 0,
    'square_red': 0,
    'circle_red': 0,
    'square_blue': 0,
  };

  // Função de feedback para classificação correta
  void checkClassification(String key) {
    if (currentCounts[key] == correctCounts[key]) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Correto!"),
          content: const Text("Você classificou corretamente!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Tente novamente"),
          content: const Text("Classificação incorreta."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  // Lógica para reiniciar o jogo
  void resetGame() {
    currentCounts.updateAll((key, value) => 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jogo de Classificação de Cores e Formas"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Arraste os objetos para o recipiente correto!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: targetContainers.map((target) {
                String key =
                    '${target['shape']}_${(target['color'] as Color).toString()}';

                return DragTarget<Map<String, dynamic>>(
                  onAccept: (item) {
                    setState(() {
                      if (item['shape'] == target['shape'] &&
                          item['color'] == target['color']) {
                        currentCounts[key] = currentCounts[key]! + 1;
                        checkClassification(key);
                      }
                    });
                  },
                  onWillAccept: (item) =>
                      item!['shape'] == target['shape'] &&
                      item['color'] == target['color'],
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      width: 80,
                      height: 100,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: target['color'].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(
                            target['shape'] == 'circle' ? 40 : 0),
                        border: Border.all(
                          color: target['color'],
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${target['shape'].toUpperCase()} ${target['color'] == Colors.blue ? "Azul" : "Vermelho"}',
                            style: TextStyle(
                              fontSize: 12,
                              color: target['color'],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '(${currentCounts[key]})',
                            style: TextStyle(
                              fontSize: 16,
                              color: currentCounts[key] == correctCounts[key]
                                  ? Colors.green
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Exibir os itens para arrastar
            Wrap(
              spacing: 8,
              children: items.map((item) {
                return Draggable<Map<String, dynamic>>(
                  data: item,
                  feedback: Material(
                    color: Colors.transparent,
                    child: ShapeWidget(
                      shape: item['shape'],
                      color: item['color'],
                    ),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.3,
                    child: ShapeWidget(
                      shape: item['shape'],
                      color: item['color'],
                    ),
                  ),
                  child: ShapeWidget(
                    shape: item['shape'],
                    color: item['color'],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget auxiliar para renderizar as formas
class ShapeWidget extends StatelessWidget {
  final String shape;
  final Color color;

  const ShapeWidget({required this.shape, required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        shape: shape == 'circle' ? BoxShape.circle : BoxShape.rectangle,
      ),
    );
  }
}

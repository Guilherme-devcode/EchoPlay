// ignore_for_file: library_private_types_in_public_api, file_names, collection_methods_unrelated_type, unrelated_type_equality_checks, deprecated_member_use

import 'package:flutter/material.dart';

class CountingAndGroupingGame extends StatefulWidget {
  const CountingAndGroupingGame({super.key});

  @override
  _CountingAndGroupingGameState createState() =>
      _CountingAndGroupingGameState();
}

class _CountingAndGroupingGameState extends State<CountingAndGroupingGame> {
  final List<String> fruits = ['🍎', '🍌', '🍓']; // Tipos de frutas
  final Map<String, int> targetCounts = {
    '🍎': 2,
    '🍌': 3,
    '🍓': 2
  }; // Alvos para cada fruta
  final Map<String, int> currentCounts = {
    '🍎': 0,
    '🍌': 0,
    '🍓': 0
  }; // Contagem atual em cada recipiente

  bool isTrashVisible = false; // Controla a visibilidade da lixeira

  // Função para verificar se o agrupamento está correto
  void checkGrouping() {
    bool isCorrect = true;
    targetCounts.forEach((fruit, target) {
      if (currentCounts[fruit] != target) {
        isCorrect = false;
      }
    });

    if (isCorrect) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Parabéns!"),
          content: const Text("Você completou o agrupamento corretamente!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  resetGame();
                });
              },
              child: const Text("Próximo"),
            ),
          ],
        ),
      );
    }
  }

  // Reseta o jogo para o próximo nível ou reiniciar
  void resetGame() {
    currentCounts.updateAll((key, value) => 0);
    isTrashVisible = false;
  }

  // Lógica para quando a fruta é removida
  void removeFruit(String fruit) {
    setState(() {
      if (currentCounts[fruit]! > 0) {
        currentCounts[fruit] = currentCounts[fruit]! - 1;
        isTrashVisible = false; // Oculta a lixeira após remover
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jogo de Contagem e Agrupamento"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Arraste as frutas para os recipientes corretos!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: targetCounts.entries.map((entry) {
                    String fruit = entry.key;
                    return Draggable<String>(
                      data: fruit,
                      onDragStarted: () {
                        // Exibe a lixeira ao iniciar o arraste
                        setState(() {
                          isTrashVisible = true;
                        });
                      },
                      onDragEnd: (details) {
                        // Oculta a lixeira ao finalizar o arraste
                        setState(() {
                          isTrashVisible = false;
                        });
                      },
                      feedback: Material(
                        color: Colors.transparent,
                        child: Text(
                          fruit,
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                      childWhenDragging: Container(
                        width: 80,
                        height: 140,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                      ),
                      child: DragTarget<String>(
                        onAccept: (data) {
                          setState(() {
                            if (data == fruit) {
                              currentCounts[data] = currentCounts[data]! + 1;
                              checkGrouping();
                            }
                          });
                        },
                        onWillAccept: (data) => data == fruit,
                        builder: (context, candidateData, rejectedData) {
                          return Container(
                            width: 80,
                            height: 140,
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: currentCounts[fruit] == entry.value
                                  ? Colors.green[200]
                                  : Colors.blue[100],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  fruit,
                                  style: const TextStyle(
                                    fontSize: 30,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${entry.value}', // Número alvo
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '(${currentCounts[fruit]})', // Quantidade atual
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: currentCounts[fruit] == entry.value
                                        ? Colors.green
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // Exibir sacos de frutas individuais
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: fruits.map((fruit) {
                    return Column(
                      children: [
                        Text(
                          "Saco de $fruit",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Draggable<String>(
                          data: fruit,
                          feedback: Material(
                            color: Colors.transparent,
                            child: Text(
                              fruit,
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.5,
                            child: Text(
                              fruit,
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                          child: Text(
                            fruit,
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          // Exibir lixeira centralizada se estiver visível
          if (isTrashVisible)
            Positioned(
              top: 80, // Posiciona a lixeira acima da pergunta
              left: MediaQuery.of(context).size.width / 2 -
                  40, // Centraliza horizontalmente
              child: DragTarget<String>(
                onAccept: (data) {
                  removeFruit(data);
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.red[200],
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.delete,
                      size: 40,
                      color: Colors.black,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

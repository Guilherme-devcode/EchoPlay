// ignore_for_file: library_private_types_in_public_api, file_names

import 'dart:math';

import 'package:flutter/material.dart';

class WordCompletionGameScreen extends StatefulWidget {
  const WordCompletionGameScreen({super.key});

  @override
  _WordCompletionGameScreenState createState() =>
      _WordCompletionGameScreenState();
}

class _WordCompletionGameScreenState extends State<WordCompletionGameScreen> {
  final String correctAnswer = "OVELHA"; // Palavra correta
  List<String> selectedLetters = [];
  List<String> keyboardLetters = [];
  List<int> missingLetterIndices = [];

  @override
  void initState() {
    super.initState();
    // Definir os índices das letras que estarão faltando
    missingLetterIndices = [
      1,
      4
    ]; // Especifique os índices das letras faltantes
    keyboardLetters = generateKeyboardLetters();
  }

  // Gera letras para o teclado, incluindo as letras da palavra correta
  List<String> generateKeyboardLetters() {
    List<String> keyboard = [];
    for (var index in missingLetterIndices) {
      keyboard.add(correctAnswer[index]); // Apenas letras faltantes no teclado
    }
    Random random = Random();
    while (keyboard.length < 8) {
      // Gera letras extras até ter 8 no total
      String randomLetter = String.fromCharCode(65 + random.nextInt(26));
      if (!keyboard.contains(randomLetter)) {
        keyboard.add(randomLetter);
      }
    }
    keyboard.shuffle();
    return keyboard;
  }

  // Adiciona uma letra selecionada pelo usuário
  void onLetterPressed(String letter) {
    setState(() {
      if (selectedLetters.length < missingLetterIndices.length) {
        selectedLetters.add(letter);
      }
    });
  }

  // Remove a última letra selecionada
  void onDeletePressed() {
    setState(() {
      if (selectedLetters.isNotEmpty) {
        selectedLetters.removeLast();
      }
    });
  }

  // Verifica se a palavra formada está correta
  void onFinishPressed() {
    bool isCorrect = true;
    for (int i = 0; i < missingLetterIndices.length; i++) {
      if (selectedLetters[i] != correctAnswer[missingLetterIndices[i]]) {
        isCorrect = false;
        break;
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isCorrect ? "Correto!" : "Tente novamente"),
        content: Text(isCorrect
            ? "Parabéns! Você completou a palavra corretamente."
            : "A resposta está incorreta. Tente novamente."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );

    if (isCorrect) {
      setState(() {
        selectedLetters.clear();
        keyboardLetters = generateKeyboardLetters();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dividir o teclado em duas linhas para exibição
    List<String> topRow = keyboardLetters.sublist(0, 4);
    List<String> bottomRow = keyboardLetters.sublist(4);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete a Palavra"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.red),
          onPressed: () {},
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/apple.png', // Substitua pela imagem correspondente
              width: 100,
              height: 100,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.error,
                size: 100,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            // Exibe os espaços para as letras da palavra, com letras faltando
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                correctAnswer.length,
                (index) {
                  bool isMissing = missingLetterIndices.contains(index);
                  return Container(
                    width: 30,
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(width: 2)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      isMissing
                          ? (missingLetterIndices.indexOf(index) <
                                  selectedLetters.length
                              ? selectedLetters[
                                  missingLetterIndices.indexOf(index)]
                              : "_")
                          : correctAnswer[index],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isMissing ? Colors.black : Colors.green,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Exibe o teclado dividido em duas linhas
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: topRow.map((letter) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                        onPressed:
                            selectedLetters.length < missingLetterIndices.length
                                ? () => onLetterPressed(letter)
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          letter,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: bottomRow.map((letter) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                        onPressed:
                            selectedLetters.length < missingLetterIndices.length
                                ? () => onLetterPressed(letter)
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          letter,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Botões de controle (Apagar e Finalizar)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed:
                      selectedLetters.isNotEmpty ? onDeletePressed : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Apagar"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed:
                      selectedLetters.length == missingLetterIndices.length
                          ? onFinishPressed
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 40),
                  ),
                  child: const Text("FINISH", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

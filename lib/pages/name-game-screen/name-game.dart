// ignore_for_file: library_private_types_in_public_api, file_names

import 'dart:math';

import 'package:flutter/material.dart';

class NameGameScreen extends StatefulWidget {
  const NameGameScreen({super.key});

  @override
  _NameGameScreenState createState() => _NameGameScreenState();
}

class _NameGameScreenState extends State<NameGameScreen> {
  final String correctAnswer = "CUSCUZ";
  List<String> selectedLetters = [];
  List<String> keyboardLetters = [];

  @override
  void initState() {
    super.initState();
    keyboardLetters = generateKeyboardLetters();
  }

  List<String> generateKeyboardLetters() {
    List<String> keyboard = [];
    keyboard.addAll(correctAnswer.split(''));
    Random random = Random();
    while (keyboard.length < 8) {
      String randomLetter = String.fromCharCode(65 + random.nextInt(26));
      if (!keyboard.contains(randomLetter)) {
        keyboard.add(randomLetter);
      }
    }

    keyboard.shuffle();
    return keyboard;
  }

  void onLetterPressed(String letter) {
    setState(() {
      if (selectedLetters.length < correctAnswer.length) {
        selectedLetters.add(letter);
      }
    });
  }

  void onDeletePressed() {
    setState(() {
      if (selectedLetters.isNotEmpty) {
        selectedLetters.removeLast();
      }
    });
  }

  void onFinishPressed() {
    String answer = selectedLetters.join();
    if (answer == correctAnswer) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Correto!"),
          content: const Text("Parabéns! Você acertou."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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
          content: const Text("A resposta está incorreta."),
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

  @override
  Widget build(BuildContext context) {
    List<String> topRow = keyboardLetters.sublist(0, 4);
    List<String> bottomRow = keyboardLetters.sublist(4);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Adivinhe o Objeto"),
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
              'assets/img/apple.png',
              width: 100,
              height: 100,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.error,
                size: 100,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                correctAnswer.length,
                (index) => Container(
                  width: 30,
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(width: 2)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    index < selectedLetters.length
                        ? selectedLetters[index]
                        : "",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: (index < selectedLetters.length &&
                              selectedLetters[index] == correctAnswer[index])
                          ? Colors.green
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: topRow.map((letter) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                        onPressed: selectedLetters.length < correctAnswer.length
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
                        onPressed: selectedLetters.length < correctAnswer.length
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
                  onPressed: selectedLetters.length == correctAnswer.length
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

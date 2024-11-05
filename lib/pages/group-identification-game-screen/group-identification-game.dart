// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:echoplay/shared/primary-button/primary-button-component.dart';
import 'package:echoplay/shared/secondary-button/secondary-button-component.dart';
import 'package:flutter/material.dart';

class GroupIdentificationGame extends StatefulWidget {
  const GroupIdentificationGame({super.key});

  @override
  _GroupIdentificationGameState createState() =>
      _GroupIdentificationGameState();
}

class _GroupIdentificationGameState extends State<GroupIdentificationGame> {
  // Lista de perguntas possíveis
  final List<String> questions = [
    "Select all Fruits",
    "Select all Animals",
    "Select all Vegetables"
  ];

  // Lista de categorias de imagens (exemplo)
  final List<Map<String, dynamic>> items = [
    {'image': 'assets/img/apple.png', 'type': 'Fruit'},
    {'image': 'assets/img/orange.png', 'type': 'Fruit'},
    {'image': 'assets/img/lemon.png', 'type': 'Fruit'},
    {'image': 'assets/img/lion.png', 'type': 'Animal'},
    {'image': 'assets/img/pig.png', 'type': 'Animal'},
    {'image': 'assets/img/monkey.png', 'type': 'Animal'},
    {'image': 'assets/img/corn.png', 'type': 'Vegetable'},
    {'image': 'assets/img/eggplant.png', 'type': 'Vegetable'},
    {'image': 'assets/img/tomato.png', 'type': 'Vegetable'},
  ];

  // Controle de seleção e pergunta atual
  String currentQuestion = "";
  List<int> selectedItems = [];
  int maxSelectableItems = 0;

  @override
  void initState() {
    super.initState();
    _setNewQuestion();
  }

  void _setNewQuestion() {
    // Escolhe uma pergunta aleatoriamente
    setState(() {
      currentQuestion = (questions..shuffle()).first;
      selectedItems.clear();
      _setMaxSelectableItems();
    });
  }

  void _setMaxSelectableItems() {
    String correctType = "";
    if (currentQuestion.contains("Fruits")) {
      correctType = "Fruit";
    } else if (currentQuestion.contains("Animals")) {
      correctType = "Animal";
    } else if (currentQuestion.contains("Vegetables")) {
      correctType = "Vegetable";
    }

    // Conta o número de itens do tipo correto
    maxSelectableItems =
        items.where((item) => item['type'] == correctType).length;
  }

  void _onItemTapped(int index) {
    setState(() {
      // Alterna a seleção do item
      if (selectedItems.contains(index)) {
        selectedItems.remove(index); // Deselect item
      } else if (selectedItems.length < maxSelectableItems) {
        selectedItems.add(index); // Select item
      }
    });
  }

  void _checkAnswer() {
    String correctType = "";
    if (currentQuestion.contains("Fruits")) {
      correctType = "Fruit";
    } else if (currentQuestion.contains("Animals")) {
      correctType = "Animal";
    } else if (currentQuestion.contains("Vegetables")) {
      correctType = "Vegetable";
    }

    bool isCorrect =
        selectedItems.every((index) => items[index]['type'] == correctType) &&
            selectedItems.length == maxSelectableItems;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isCorrect ? "Correct!" : "Try Again"),
        content: Text(isCorrect
            ? "You selected the correct items!"
            : "Some selected items are incorrect. Try again."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (isCorrect) {
                _setNewQuestion();
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Identify the Group"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            currentQuestion,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                bool isSelected = selectedItems.contains(index);

                return GestureDetector(
                  onTap: () => _onItemTapped(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.yellow : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 2),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          item['image'],
                          width: 50,
                          height: 50,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.error,
                            size: 50,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(item['type']),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PrimaryButton(
              onPressed: selectedItems.length == maxSelectableItems
                  ? _checkAnswer
                  : null,
              text: 'JOGAR!',
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SecondaryButton(
              onPressed: selectedItems.length == maxSelectableItems
                  ? _checkAnswer
                  : null,
              text: 'JOGAR!',
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ignore_for_file: library_private_types_in_public_api

import 'package:echoplay/pages/welcome-screen/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const EchoPlayApp());
}

class EchoPlayApp extends StatelessWidget {
  const EchoPlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EchoPlay',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 24.0),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final FlutterTts flutterTts = FlutterTts();
  List<dynamic> voices = [];

  @override
  void initState() {
    super.initState();
    _configurarTTS();
  }

  Future _configurarTTS() async {
    await flutterTts.setVoice(
        {"name": "Microsoft Maria - Portuguese (Brazil)", "locale": "pt-BR"});
    await flutterTts.setLanguage("pt-BR");
    await flutterTts.setSpeechRate(1);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    _narrarTexto('Bem-vindo ao EkoPlay! Toque em um botão para começar.');
  }

  Future _narrarTexto(String texto) async {
    await flutterTts.stop();
    await flutterTts.speak(texto);
  }

  void _vibrar() {
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('EchoPlay'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _vibrar();
                _narrarTexto('Iniciar Jogo');
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text(
                'Iniciar Jogo',
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _vibrar();
                _narrarTexto('Instruções');
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text(
                'Instruções',
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _vibrar();
                _narrarTexto('Configurações');
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text(
                'Configurações',
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // 1. Garante que o Flutter iniciou os motores
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Tenta iniciar o Firebase de forma segura (sem crashar)
  try {
    await Firebase.initializeApp();
    debugPrint("Firebase iniciado com sucesso");
  } catch (e) {
    debugPrint("Erro ao iniciar Firebase (App continuará rodando): $e");
  }
  
  runApp(const FanimesApp());
}

class FanimesApp extends StatelessWidget {
  const FanimesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: const Color(0xFF0D0D0D),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "FÂNIMES",
                style: TextStyle(
                  color: Color(0xFF673AB7),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text("Versão de Recuperação Ativa", style: TextStyle(color: Colors.white54)),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF673AB7)),
                onPressed: () {},
                child: const Text("Entrar como ADM Geral", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


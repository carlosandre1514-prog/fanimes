import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Inicializa o Firebase. Se falhar, ele pula para o app sem travar.
    await Firebase.initializeApp().timeout(const Duration(seconds: 5));
  } catch (e) {
    print("Firebase indisponivel: $e");
  }
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PaginaTeste(),
  ));
}

class PaginaTeste extends StatelessWidget {
  const PaginaTeste({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF673AB7), size: 100),
            const SizedBox(height: 20),
            const Text("APP DESTRANCADO!", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Carlos, se voce esta vendo isso,\no código subiu certo!", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF673AB7)),
              onPressed: () => print("Botao Aura funcionando"),
              child: const Text("TESTAR BOTÃO ROXO"),
            )
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  // 1. Garante que o Flutter esteja pronto
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Inicializa o Firebase antes de abrir o app
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Erro Firebase: $e");
  }
  
  runApp(const FanimesApp());
}

class FanimesApp extends StatelessWidget {
  const FanimesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0D0D), // Preto Elétrico
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _idx = 4; // Começa na aba Perfil para testar o ADM
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // Atualiza a tela se o usuário logar ou deslogar
    FirebaseAuth.instance.authStateChanges().listen((u) {
      if (mounted) setState(() => user = u);
    });
  }

  @override
  Widget build(BuildContext context) {
    // RECONHECIMENTO DO CARLOS
    bool isCarlos = user?.email == "carlosandre.ad1514@gmail.com";
    const Color roxoAura = Color(0xFF673AB7);

    return Scaffold(
      // 3. Ajusta o layout para o teclado não cobrir o chat
      resizeToAvoidBottomInset: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("FÃNIMES", style: TextStyle(color: roxoAura, fontWeight: FontWeight.bold)),
      ),
      body: _idx == 4 ? _abaPerfil(isCarlos, roxoAura) : const Center(child: Text("Em breve...")),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
        selectedItemColor: roxoAura,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Biblioteca"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Busca"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Agenda"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }

  Widget _abaPerfil(bool adm, Color cor) {
    return Column(
      children: [
        const SizedBox(height: 30),
        CircleAvatar(radius: 50, backgroundColor: Colors.white10, child: Icon(Icons.person, color: cor, size: 45)),
        const SizedBox(height: 15),
        Text(user?.email ?? "Visitante", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        // 4. Correção: Exibe ADM Geral se for o Carlos
        Text(adm ? "ADM Geral" : "Membro", style: TextStyle(color: cor, fontWeight: FontWeight.bold)),
        const Divider(height: 50, color: Colors.white12, indent: 40, endIndent: 40),
        ListTile(leading: Icon(Icons.bug_report, color: cor), title: const Text("Relatar Problema")),
        ListTile(leading: Icon(Icons.palette, color: cor), title: const Text("Cores do App")),
        if (user != null) 
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent), 
            title: const Text("Sair"), 
            onTap: () => FirebaseAuth.instance.signOut()
          ),
      ],
    );
  }
}


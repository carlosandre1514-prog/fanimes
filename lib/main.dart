import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  // Garante que o Flutter carregue antes de tudo
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Inicializa o Firebase com um tempo limite para não travar o app
    await Firebase.initializeApp().timeout(const Duration(seconds: 10));
  } catch (e) {
    print("Erro ao carregar Firebase: $e");
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
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
      ),
      // O Scaffold agora gerencia o redimensionamento para o teclado não cobrir o chat
      home: const SelectionArea(child: MainNavigation()),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _idx = 4; // Abre no Perfil para conferir o ADM
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((u) {
      if (mounted) setState(() => user = u);
    });
  }

  @override
  Widget build(BuildContext context) {
    // RECONHECIMENTO AUTOMÁTICO DO CARLOS
    bool isCarlos = user?.email == "carlosandre.ad1514@gmail.com";
    const Color roxoAura = Color(0xFF673AB7);

    return Scaffold(
      // Evita que o teclado empurre o layout de forma errada
      resizeToAvoidBottomInset: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("FÃNIMES", style: TextStyle(color: roxoAura, fontWeight: FontWeight.bold)),
      ),
      body: _idx == 4 ? _perfil(isCarlos, roxoAura) : const Center(child: Text("Em breve...")),
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

  Widget _perfil(bool isAdm, Color cor) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),
          CircleAvatar(radius: 50, backgroundColor: Colors.white10, child: Icon(Icons.person, color: cor, size: 45)),
          const SizedBox(height: 15),
          Text(user?.email ?? "Visitante", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          // CORREÇÃO: Agora exibe ADM Geral se for o seu e-mail
          Text(isAdm ? "ADM Geral" : "Usuário", style: TextStyle(color: cor)),
          const Divider(height: 50, color: Colors.white12, indent: 40, endIndent: 40),
          ListTile(leading: Icon(Icons.bug_report, color: cor), title: const Text("Relatar Problema")),
          ListTile(leading: Icon(Icons.palette, color: cor), title: const Text("Cores do App")),
          if (user != null) 
            ListTile(leading: const Icon(Icons.logout, color: Colors.redAccent), title: const Text("Sair"), onTap: () => FirebaseAuth.instance.signOut()),
        ],
      ),
    );
  }
}


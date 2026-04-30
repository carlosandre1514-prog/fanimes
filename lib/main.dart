import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Erro ao iniciar Firebase: $e");
  }
  runApp(const FanimesApp());
}

const Color roxoAura = Color(0xFF673AB7);

class FanimesApp extends StatelessWidget {
  const FanimesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
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
  int _idx = 4; // Começa no Perfil para você ver o cargo de ADM
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // Escuta mudanças no login para atualizar o perfil
    FirebaseAuth.instance.authStateChanges().listen((u) => setState(() => user = u));
  }

  @override
  Widget build(BuildContext context) {
    // Validação do seu e-mail para ADM Geral
    bool isCarlos = user?.email == "carlosandre.ad1514@gmail.com";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            if (isCarlos) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Acessando Painel Administrativo...", style: TextStyle(color: Colors.white)), backgroundColor: roxoAura),
              );
            }
          },
          child: const Text("FÃNIMES", style: TextStyle(color: roxoAura, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        ),
        centerTitle: true,
      ),
      body: _idx == 4 ? _abaPerfil(isCarlos) : Center(child: Text("Aba $_idx", style: const TextStyle(color: Colors.white54))),
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

  Widget _abaPerfil(bool adm) {
    return Column(
      children: [
        const SizedBox(height: 30),
        const CircleAvatar(radius: 50, backgroundColor: Colors.white10, child: Icon(Icons.person, color: roxoAura, size: 45)),
        const SizedBox(height: 15),
        Text(user?.email ?? "Visitante", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        // Exibição do cargo corrigida
        Text(adm ? "ADM Geral" : "Usuário Comum", style: const TextStyle(color: roxoAura, fontWeight: FontWeight.w500)),
        const Divider(height: 50, color: Colors.white12, indent: 40, endIndent: 40),
        ListTile(leading: const Icon(Icons.bug_report, color: roxoAura), title: const Text("Relatar Problema"), onTap: () {}),
        ListTile(leading: const Icon(Icons.support_agent, color: roxoAura), title: const Text("Suporte ao Usuário"), onTap: () {}),
        if (user != null) 
          ListTile(leading: const Icon(Icons.logout, color: Colors.redAccent), title: const Text("Sair"), onTap: () => FirebaseAuth.instance.signOut()),
      ],
    );
  }
}


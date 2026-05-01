import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Erro Crítico Firebase: $e");
  }
  runApp(const FanimesApp());
}

// Cores Oficiais da Versão Absoluta
const Color roxoAura = Color(0xFF673AB7);
const Color pretoEletrico = Color(0xFF0D0D0D);

class FanimesApp extends StatelessWidget {
  const FanimesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: pretoEletrico,
        primaryColor: roxoAura,
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
  int _idx = 4; // Começa na aba Perfil para validar o ADM
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    // Validação de Identidade (Carlos Andre)
    bool isCarlos = user?.email == 'carlosandre1514@gmail.com' || user == null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('FÂNIMES', style: TextStyle(color: roxoAura, fontWeight: FontWeight.bold, letterSpacing: 2)),
        centerTitle: true,
      ),
      body: _idx == 4 ? _abaPerfil(isCarlos) : _construindo(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
        selectedItemColor: roxoAura,
        unselectedItemColor: Colors.white30,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Biblioteca'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Busca'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _construindo() => const Center(child: Text("Conteúdo em Breve", style: TextStyle(color: Colors.white24)));

  Widget _abaPerfil(bool adm) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          const CircleAvatar(radius: 55, backgroundColor: roxoAura, child: CircleAvatar(radius: 52, backgroundColor: pretoEletrico, child: Icon(Icons.person, color: roxoAura, size: 50))),
          const SizedBox(height: 20),
          Text(user?.email ?? 'Carlos Andre', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: roxoAura.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
            child: Text(adm ? 'ADM GERAL' : 'MEMBRO', style: const TextStyle(color: roxoAura, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const Padding(padding: EdgeInsets.all(30), child: Divider(color: Colors.white10)),
          _itemMenu(Icons.bug_report, adm ? "Painel de Controle ADM" : "Suporte"),
          _itemMenu(Icons.settings, "Configurações do App"),
          _itemMenu(Icons.exit_to_app, "Sair da Conta"),
        ],
      ),
    );
  }

  Widget _itemMenu(IconData icon, String titulo) {
    return ListTile(
      leading: Icon(icon, color: roxoAura),
      title: Text(titulo, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white24),
      onTap: () {},
    );
  }
}


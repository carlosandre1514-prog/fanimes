import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Erro Firebase: $e");
  }
  runApp(const FanimesApp());
}

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
  int _idx = 4;
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
    bool isCarlos = user?.email == 'carlosandre1514@gmail.com' || user == null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('FÃNIMES', style: TextStyle(color: roxoAura, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _idx == 4 ? _abaPerfil(isCarlos) : const Center(child: Text('Beta 1 - Carregando...')),
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

  Widget _abaPerfil(bool adm) {
    return Column(
      children: [
        const SizedBox(height: 30),
        const CircleAvatar(radius: 50, backgroundColor: Colors.white10, child: Icon(Icons.person, color: roxoAura, size: 45)),
        const SizedBox(height: 15),
        Text(user?.email ?? 'Carlos Andre', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(adm ? 'ADM Geral' : 'Membro', style: const TextStyle(color: roxoAura, fontWeight: FontWeight.bold)),
        const Divider(height: 50, color: Colors.white12, indent: 40, endIndent: 40),
        const ListTile(leading: Icon(Icons.bug_report, color: roxoAura), title: Text('Painel ADM Geral')),
      ],
    );
  }
}


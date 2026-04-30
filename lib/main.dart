import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Inicialização robusta para evitar a tela vermelha
    await Firebase.initializeApp().timeout(const Duration(seconds: 10));
  } catch (e) {
    debugPrint("Firebase Offline: $e");
  }
  runApp(const FanimesApp());
}

// Cores Oficiais que definiste
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
  int _selectedIndex = 4; // Abre no Perfil para veres o ADM Geral
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
    // Reconhece-te como administrador pelo e-mail
    bool isCarlosAdm = user?.email == "carlosandre.ad1514@gmail.com";

    return Scaffold(
      // Resolve o problema do teclado tapar o conteúdo
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("FÃNIMES", style: TextStyle(color: roxoAura, fontWeight: FontWeight.bold, letterSpacing: 2)),
        centerTitle: true,
        actions: [
          if (isCarlosAdm) 
            IconButton(icon: const Icon(Icons.admin_panel_settings, color: roxoAura), onPressed: () {}),
        ],
      ),
      body: _selectedIndex == 4 ? _perfil(isCarlosAdm) : _emDesenvolvimento(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        selectedItemColor: roxoAura,
        unselectedItemColor: Colors.white30,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.video_library), label: 'Biblioteca'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Busca'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _perfil(bool adm) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          const CircleAvatar(radius: 50, backgroundColor: Colors.white10, child: Icon(Icons.person, color: roxoAura, size: 50)),
          const SizedBox(height: 15),
          Text(user?.email ?? "Utilizador Conectado", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          // Agora o cargo aparece corretamente em Roxo Aura
          Text(adm ? "ADM Geral" : "Membro Premium", style: const TextStyle(color: roxoAura, fontWeight: FontWeight.bold)),
          const Divider(height: 60, color: Colors.white12, indent: 40, endIndent: 40),
          _itemMenu(Icons.bug_report, "Relatar Bug / Sugestões"),
          _itemMenu(Icons.palette, "Personalizar App"),
          _itemMenu(Icons.help_outline, "Suporte ao Utilizador"),
          if (user != null) 
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.redAccent),
              title: const Text("Sair da Conta"),
              onTap: () => FirebaseAuth.instance.signOut(),
            ),
        ],
      ),
    );
  }

  Widget _itemMenu(IconData icon, String titulo) {
    return ListTile(
      leading: Icon(icon, color: roxoAura),
      title: Text(titulo),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white24),
      onTap: () {},
    );
  }

  Widget _emDesenvolvimento() {
    return const Center(child: Text("Em desenvolvimento...", style: TextStyle(color: Colors.white30)));
  }
}


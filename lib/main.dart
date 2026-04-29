import 'package:flutter/material.dart';

void main() {
  runApp(const FanimesApp());
}

class FanimesApp extends StatelessWidget {
  const FanimesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FÃNIMES',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF673AB7),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0D0D0D), elevation: 0),
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
  int _selectedIndex = 0;

  // Lista de páginas funcionais
  final List<Widget> _pages = [
    const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.play_circle_fill, size: 80, color: Colors.deepPurpleAccent), SizedBox(height: 10), Text("Início FÃNIMES")])),
    const Center(child: Text("Minha Biblioteca", style: TextStyle(fontSize: 20))),
    const Center(child: Text("Pesquisar Animes", style: TextStyle(fontSize: 20))),
    const Center(child: Text("Agenda de Lançamentos", style: TextStyle(fontSize: 20))),
    const Center(child: Text("Meu Perfil", style: TextStyle(fontSize: 20))),
  ];

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: 300,
        child: Column(
          children: [
            const Text("Notificações", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.deepPurpleAccent),
              title: const Text("Novo episódio disponível!"),
              subtitle: const Text("Assista agora mesmo."),
              trailing: IconButton(icon: const Icon(Icons.delete_sweep, color: Colors.redAccent), onPressed: () {}),
            ),
            const Spacer(),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Fechar"))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // Título estilizado com cores diferentes
        title: GestureDetector(
          onTap: () {
            // Acesso ao Painel ADM
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Acessando Painel Administrativo..."), backgroundColor: Colors.deepPurple),
            );
          },
          child: RichText(
            text: const TextSpan(
              style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.bold, fontSize: 20),
              children: [
                TextSpan(text: 'FÃ', style: TextStyle(color: Colors.deepPurpleAccent)), // FÃ em roxo
                TextSpan(text: 'NIMES', style: TextStyle(color: Colors.white)), // NIMES em branco
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: _showNotifications,
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF0D0D0D),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.video_library), label: 'Biblioteca'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Busca'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}


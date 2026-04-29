import 'package:flutter/material.dart';

void main() => runApp(const FanimesApp());

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

  // --- FUNÇÃO DE NOTIFICAÇÕES (MANTIDA) ---
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

  // --- INTERFACES DAS ABAS ---

  Widget _buildHome() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("Continuar Assistindo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(height: 160, decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.play_circle_outline, size: 50, color: Colors.deepPurpleAccent)),
        const SizedBox(height: 25),
        const Text("Lançamentos do Dia", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizedBox(height: 180, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: 5, itemBuilder: (ctx, i) => Container(width: 120, margin: const EdgeInsets.only(right: 12), decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(8))))),
      ],
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Pesquisar anime...",
          prefixIcon: const Icon(Icons.search, color: Colors.deepPurpleAccent),
          filled: true,
          fillColor: const Color(0xFF1A1A1A),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return Column(
      children: [
        const SizedBox(height: 40),
        const CircleAvatar(radius: 50, backgroundColor: Color(0xFF1A1A1A), child: Icon(Icons.person, size: 60, color: Colors.grey)),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF673AB7), minimumSize: const Size(double.infinity, 50)),
            child: const Text("LOGIN / CADASTRAR", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const Divider(color: Colors.grey, thickness: 0.5, indent: 30, endIndent: 30, height: 40),
        ListTile(leading: const Icon(Icons.settings, color: Colors.deepPurpleAccent), title: const Text("Configurações"), onTap: () {}),
        ListTile(leading: const Icon(Icons.support_agent, color: Colors.deepPurpleAccent), title: const Text("Suporte"), onTap: () {}),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [_buildHome(), const Center(child: Text("Biblioteca")), _buildSearch(), const Center(child: Text("Agenda")), _buildProfile()];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Acesso Admin"), backgroundColor: Colors.deepPurple)),
          child: RichText(
            text: const TextSpan(
              style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.bold, fontSize: 20),
              children: [
                TextSpan(text: 'FÃ', style: TextStyle(color: Colors.deepPurpleAccent)),
                TextSpan(text: 'NIMES', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.white), onPressed: _showNotifications),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
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


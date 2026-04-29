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

  Widget _buildAnimeRail(String title, List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // CORRIGIDO AQUI!
            children: [
              Row(
                children: [
                  Container(width: 4, height: 18, color: Colors.deepPurpleAccent),
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              GestureDetector(
                onTap: () => setState(() => _selectedIndex = 1), 
                child: const Text("Ver tudo >", style: TextStyle(color: Colors.grey, fontSize: 13)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16),
            itemCount: 6,
            itemBuilder: (ctx, i) => _animeCard(tags[i % tags.length]),
          ),
        ),
      ],
    );
  }

  Widget _animeCard(String tag) {
    return Container(
      width: 125,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 6,
            left: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: tag.contains("EP") ? Colors.blue : (tag == "DUB" ? Colors.green : Colors.red),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(tag, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter, 
            child: Padding(
              padding: EdgeInsets.all(8), 
              child: Text("Anime Name", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12))
            )
          ),
        ],
      ),
    );
  }

  Widget _buildHome() {
    return ListView(
      children: [
        Container(
          height: 230,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFF1A1A1A),
          ),
          child: Stack(
            children: [
              Center(child: Icon(Icons.play_circle_fill, size: 60, color: Colors.deepPurpleAccent.withOpacity(0.8))),
              const Positioned(
                bottom: 15,
                left: 15,
                child: Text("Destaque da Semana", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        _buildAnimeRail("Continuar Assistindo", ["EP 08", "EP 02"]),
        _buildAnimeRail("Lançamentos de Hoje", ["DUB", "LEG", "DUB"]),
        _buildAnimeRail("Isekai", ["LEG", "LEG"]),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHome(),
      const Center(child: Text("Biblioteca")),
      const Center(child: Text("Busca")),
      const Center(child: Text("Agenda")),
      const Center(child: Text("Perfil")),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.bold, fontSize: 20),
            children: [
              TextSpan(text: 'FÃ', style: TextStyle(color: Colors.deepPurpleAccent)),
              TextSpan(text: 'NIMES', style: TextStyle(color: Colors.white)),
            ],
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


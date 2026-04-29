import 'package:flutter/material.dart';

void main() => runApp(const FanimesApp());

const Color roxoAura = Color(0xFF673AB7);
const Color pretoEletrico = Color(0xFF0D0D0D);
const Color brancoTexto = Colors.white;

class FanimesApp extends StatelessWidget {
  const FanimesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FÃNIMES',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: roxoAura,
        scaffoldBackgroundColor: pretoEletrico,
        appBarTheme: const AppBarTheme(backgroundColor: pretoEletrico, elevation: 0),
      ),
      home: const MainNavigation(),
    );
  }
}

class Anime {
  final String nome, sinopse, genero, status, idioma, tipo, diaLancamento;
  final List<String> episodios;
  Anime({required this.nome, required this.sinopse, required this.genero, required this.status, required this.idioma, required this.tipo, required this.episodios, required this.diaLancamento});
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  String? userEmail;
  String currentRole = 'Usuário';
  bool isLogged = false;
  bool hasPendingPromotion = true;

  List<Anime> allAnimes = [];

  void _handleLoginSuccess(String email) {
    setState(() {
      userEmail = email;
      isLogged = true;
      if (email == 'carlosandre@fanimes.com') {
        currentRole = 'Geral';
      }
    });
  }

  void _handleLogout() { setState(() { userEmail = null; isLogged = false; currentRole = 'Usuário'; }); }

  @override
  Widget build(BuildContext context) {
    final List<Widget> telas = [
      const Center(child: Text("Home (Vazia)")),
      BibliotecaAba(animes: allAnimes),
      PesquisaAba(animes: allAnimes),
      const Center(child: Text("Agenda")),
      PerfilAba(isLogged: isLogged, currentRole: currentRole, userEmail: userEmail, onLogin: _handleLoginSuccess, onLogout: _handleLogout),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            if (currentRole == 'Geral') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PainelAdmAba(hasAlerta: hasPendingPromotion)));
            }
          },
          child: RichText(
            text: const TextSpan(
              style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.bold, fontSize: 20),
              children: [
                TextSpan(text: 'FÃ', style: TextStyle(color: roxoAura)),
                TextSpan(text: 'NIMES', style: TextStyle(color: brancoTexto)),
              ],
            ),
          ),
        ),
        actions: [IconButton(icon: const Icon(Icons.notifications_none, color: roxoAura), onPressed: () {})],
      ),
      body: telas[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: pretoEletrico,
        selectedItemColor: roxoAura,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Biblioteca'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Pesquisa'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class PesquisaAba extends StatelessWidget {
  final List<Anime> animes;
  const PesquisaAba({super.key, required this.animes});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar',
              prefixIcon: const Icon(Icons.search, color: roxoAura),
              filled: true,
              fillColor: Colors.white10,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
            ),
          ),
        ),
        const Expanded(child: Center(child: Text('Nenhum anime para buscar ainda', style: TextStyle(color: Colors.white60)))),
      ],
    );
  }
}

class BibliotecaAba extends StatelessWidget {
  final List<Anime> animes;
  const BibliotecaAba({super.key, required this.animes});

  Widget _buildFiltro(String label, List<String> opcoes) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 45),
      color: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), 
        side: const BorderSide(color: roxoAura, width: 0.5) // CORRIGIDO: side em vez de border
      ),
      child: Chip(label: Row(mainAxisSize: MainAxisSize.min, children: [Text(label), const Icon(Icons.arrow_drop_down, size: 18)]), backgroundColor: Colors.white10),
      itemBuilder: (context) => opcoes.map((o) => PopupMenuItem(value: o, child: Text(o))).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFiltro("Gênero", ["Ação", "Isekai", "Romance", "Shonen"]),
              const SizedBox(width: 8),
              _buildFiltro("Status", ["Concluído", "Em andamento", "Pausado"]),
              const SizedBox(width: 8),
              _buildFiltro("Idioma", ["Legendado", "Dublado"]),
            ],
          ),
        ),
        const Expanded(child: Center(child: Text("Nenhum anime adicionado.", style: TextStyle(color: Colors.white60)))),
      ],
    );
  }
}

class PerfilAba extends StatelessWidget {
  final bool isLogged;
  final String currentRole;
  final String? userEmail;
  final Function(String) onLogin;
  final VoidCallback onLogout;

  const PerfilAba({super.key, required this.isLogged, required this.currentRole, this.userEmail, required this.onLogin, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Column(
          children: [
            const CircleAvatar(radius: 50, backgroundColor: roxoAura, child: Icon(Icons.account_circle, color: Colors.white, size: 50)),
            const SizedBox(height: 12),
            Text(isLogged ? "Logado" : "Não Logado", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            if (!isLogged)
              ElevatedButton(
                onPressed: () => onLogin('carlosandre@fanimes.com'),
                style: ElevatedButton.styleFrom(backgroundColor: roxoAura),
                child: const Text("Login / Cadastro"),
              )
            else
              Text("$userEmail - $currentRole", style: const TextStyle(color: roxoAura)),
          ],
        ),
        const SizedBox(height: 30),
        ListTile(leading: const Icon(Icons.bug_report, color: roxoAura), title: const Text("Suporte / Sugestões"), onTap: () {}),
        if (isLogged) ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text("Sair"), onTap: onLogout),
      ],
    );
  }
}

class PainelAdmAba extends StatelessWidget {
  final bool hasAlerta;
  const PainelAdmAba({super.key, required this.hasAlerta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Painel ADM"),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(icon: const Icon(Icons.notifications, color: roxoAura), onPressed: () {}),
              if (hasAlerta)
                Positioned(
                  right: 8, top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: const Text(
                      '1', 
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center, // CORRIGIDO: Removido o textAlign duplicado
                    ),
                  ),
                )
            ],
          )
        ],
      ),
      body: const Center(child: Text("Funções ADM aqui")),
    );
  }
}


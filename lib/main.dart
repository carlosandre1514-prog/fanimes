import 'package:flutter/material.dart';

void main() => runApp(const FanimesApp());

// --- IDENTIDADE VISUAL ---
const Color roxoAura = Color(0xFF673AB7);
const Color pretoEletrico = Color(0xFF0D0D0D);
const Color brancoTexto = Colors.white;

class FanimesApp extends StatelessWidget {
  const FanimesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FÃNIMES BETA 1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: roxoAura,
        scaffoldBackgroundColor: pretoEletrico,
        appBarTheme: const AppBarTheme(backgroundColor: pretoEletrico, elevation: 0),
        splashColor: roxoAura.withOpacity(0.3),
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
  bool isLogged = false;
  String currentRole = 'Visitante';
  String userNick = "Carlos Andre"; 
  String diaSelecionado = "Qua";

  @override
  Widget build(BuildContext context) {
    final List<Widget> telas = [
      const Center(child: Text("Home - Trilhos de Animes")),
      const BibliotecaAba(),
      const PesquisaAba(),
      AgendaAba(diaAtivo: diaSelecionado, onDiaChange: (d) => setState(() => diaSelecionado = d)),
      PerfilAba(
        isLogged: isLogged, 
        userNick: userNick,
        currentRole: currentRole, 
        onLogin: (role) => setState(() { isLogged = true; currentRole = role; }),
        onLogout: () => setState(() { isLogged = false; currentRole = 'Visitante'; }),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            if (currentRole == 'ADM Geral') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PainelAdmAba()));
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
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: roxoAura), 
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Central de Notificações"), backgroundColor: roxoAura)
              );
            }
          )
        ],
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
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Busca'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

// --- BIBLIOTECA COM MENUS PROPORCIONAIS ---
class BibliotecaAba extends StatefulWidget {
  const BibliotecaAba({super.key});
  @override
  State<BibliotecaAba> createState() => _BibliotecaAbaState();
}

class _BibliotecaAbaState extends State<BibliotecaAba> {
  final List<String> generos = ["Ação", "Aventura", "Comédia", "Drama", "Romance", "Psicológico", "Terror (Horror)", "Suspense", "Mistério", "Fantasia", "Sobrenatural", "Magia", "Ficção Científica", "Espaço", "Isekai", "Reencarnação", "Escolar", "Esportes", "Crime", "Policial", "Samurai", "Militar", "Mecha", "Superpoderes", "Battle Shounen", "Artes Marciais", "Harem", "Ecchi", "Hentai", "Seinen", "Shounen", "Tragédia", "Thriller", "Vampiros", "Demônios", "Apocalipse"];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMenuDropdown("Gênero", generos),
              _buildMenuDropdown("Status", ["Concluído", "Em andamento", "Pausado"]),
              _buildMenuDropdown("Idioma", ["Dublado", "Legendado"]),
            ],
          ),
        ),
        const Expanded(child: Center(child: Text("Lista de Animes"))),
      ],
    );
  }

  Widget _buildMenuDropdown(String label, List<String> itens) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 45),
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ActionChip(
        backgroundColor: Colors.white10,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            const Icon(Icons.arrow_drop_down, size: 18),
          ],
        ),
        onPressed: null, // O PopupMenuButton cuida do clique
      ),
      onSelected: (value) {},
      itemBuilder: (context) => itens.map((item) => PopupMenuItem<String>(
        value: item,
        height: 35,
        child: Text(item, style: const TextStyle(fontSize: 13)),
      )).toList(),
    );
  }
}

// --- PAINEL ADM ---
class PainelAdmAba extends StatelessWidget {
  const PainelAdmAba({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Painel Administrativo"), actions: const []),
      body: ListView(
        children: [
          _admTile(Icons.verified_user, "Autorizar Promoções", null),
          _admTile(Icons.create_new_folder, "Criar e Nomear Trilhos", null),
          _admTile(Icons.add_circle, "Adicionar Anime", null),
          _admTile(Icons.message, "Suporte ao Usuário", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const VerTicketsPage()));
          }),
          _admTile(Icons.people, "Gerenciar Usuários", null),
        ],
      ),
    );
  }
  Widget _admTile(IconData i, String t, VoidCallback? action) => ListTile(
    leading: Icon(i, color: roxoAura), 
    title: Text(t), 
    onTap: action ?? () {}
  );
}

// --- TELA DE TICKETS (SUPORTE ADM) ---
class VerTicketsPage extends StatelessWidget {
  const VerTicketsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mensagens de Suporte")),
      body: const Center(child: Text("Nenhuma mensagem nova")),
    );
  }
}

// --- LOGIN / CADASTRO ---
class AuthPage extends StatefulWidget {
  final Function(String) onLogin;
  const AuthPage({super.key, required this.onLogin});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isCadastro = false;
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _senhaCtrl = TextEditingController();
  void _autenticar() {
    if (_emailCtrl.text == "carlos@adm.com" && _senhaCtrl.text == "123") {
      widget.onLogin("ADM Geral");
    } else {
      widget.onLogin("Usuário");
    }
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isCadastro ? "Cadastro" : "Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          if (isCadastro) const TextField(decoration: InputDecoration(labelText: "Nickname", filled: true, fillColor: Colors.white10)),
          const SizedBox(height: 10),
          TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: "E-mail", filled: true, fillColor: Colors.white10)),
          const SizedBox(height: 10),
          TextField(controller: _senhaCtrl, obscureText: true, decoration: const InputDecoration(labelText: "Senha", filled: true, fillColor: Colors.white10)),
          const SizedBox(height: 20),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: roxoAura, minimumSize: const Size(double.infinity, 50)), onPressed: _autenticar, child: Text(isCadastro ? "CADASTRAR" : "ENTRAR")),
          TextButton(onPressed: () => setState(() => isCadastro = !isCadastro), child: Text(isCadastro ? "Já tem conta? Entrar" : "Não possui conta? Cadastre-se", style: const TextStyle(color: roxoAura)))
        ]),
      ),
    );
  }
}

// --- OUTRAS TELAS ---
class EnviarSuportePage extends StatelessWidget {
  const EnviarSuportePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Relatar Problema")), body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [const TextField(maxLines: 5, decoration: InputDecoration(hintText: "Descreva aqui...", filled: true, fillColor: Colors.white10, border: OutlineInputBorder())), const SizedBox(height: 20), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: roxoAura), onPressed: () => Navigator.pop(context), child: const Text("ENVIAR TICKET"))])));
}

class PesquisaAba extends StatelessWidget {
  const PesquisaAba({super.key});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(16), child: TextField(decoration: InputDecoration(hintText: 'Buscar Animes', prefixIcon: const Icon(Icons.search, color: roxoAura), filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none))));
}

class AgendaAba extends StatelessWidget {
  final String diaAtivo;
  final Function(String) onDiaChange;
  const AgendaAba({super.key, required this.diaAtivo, required this.onDiaChange});
  @override
  Widget build(BuildContext context) {
    List<String> dias = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"];
    return Column(children: [SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: dias.map((d) => Padding(padding: const EdgeInsets.all(8.0), child: ChoiceChip(label: Text(d), selected: diaAtivo == d, selectedColor: roxoAura, onSelected: (v) => onDiaChange(d)))).toList())), const Expanded(child: Center(child: Text("Lançamentos")))]);
  }
}

class PerfilAba extends StatelessWidget {
  final bool isLogged;
  final String userNick, currentRole;
  final Function(String) onLogin;
  final VoidCallback onLogout;
  const PerfilAba({super.key, required this.isLogged, required this.userNick, required this.currentRole, required this.onLogin, required this.onLogout});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Center(child: CircleAvatar(radius: 60, backgroundColor: Colors.white10, child: Icon(Icons.person, size: 50, color: roxoAura))),
        const SizedBox(height: 10),
        Center(child: Text(isLogged ? userNick : "Visitante", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
        if (isLogged) Center(child: Text(currentRole, style: const TextStyle(color: roxoAura))),
        const SizedBox(height: 25),
        if (!isLogged) ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: roxoAura), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AuthPage(onLogin: onLogin))), child: const Text("LOGIN / CADASTRO")),
        const Divider(height: 40),
        ListTile(leading: const Icon(Icons.bug_report, color: roxoAura), title: const Text("Relatar Problema"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EnviarSuportePage()))),
        const ListTile(leading: Icon(Icons.shuffle), title: Text("Reprodução Aleatória")),
        const ListTile(leading: Icon(Icons.download), title: Text("Downloads")),
        if (isLogged) ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text("Sair", style: TextStyle(color: Colors.red)), onTap: onLogout),
      ],
    );
  }
}


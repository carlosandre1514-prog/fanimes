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

// --- NAVEGAÇÃO PRINCIPAL ---
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
            // Apenas ADM Geral acessa o painel clicando no título
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
        // O ícone de notificações CONTINUA na Home (MainNavigation)
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
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Busca'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

// --- TELA DE LOGIN COM SEGURANÇA ADM ---
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
  final TextEditingController _nickCtrl = TextEditingController();

  void _autenticar() {
    // Validação estrita para ADM Geral conforme solicitado
    if (_emailCtrl.text == "carlos@adm.com" && _senhaCtrl.text == "123") {
      widget.onLogin("ADM Geral");
      Navigator.pop(context);
    } else {
      // Login comum para outros e-mails
      widget.onLogin("Usuário");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isCadastro ? "Criar Conta" : "Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          if (isCadastro) TextField(controller: _nickCtrl, decoration: const InputDecoration(labelText: "Nickname", filled: true, fillColor: Colors.white10)),
          const SizedBox(height: 10),
          TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: "E-mail", filled: true, fillColor: Colors.white10)),
          const SizedBox(height: 10),
          TextField(controller: _senhaCtrl, obscureText: true, decoration: const InputDecoration(labelText: "Senha", filled: true, fillColor: Colors.white10)),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: roxoAura, minimumSize: const Size(double.infinity, 50)),
            onPressed: _autenticar, 
            child: Text(isCadastro ? "CADASTRAR" : "ENTRAR")
          ),
          TextButton(
            onPressed: () => setState(() => isCadastro = !isCadastro),
            child: Text(isCadastro ? "Já tem conta? Entrar" : "Não possui conta? Cadastre-se", style: const TextStyle(color: roxoAura))
          )
        ]),
      ),
    );
  }
}

// --- PAINEL ADM (NOTIFICAÇÃO REMOVIDA AQUI) ---
class PainelAdmAba extends StatelessWidget {
  const PainelAdmAba({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Painel Administrativo"),
        // Sininho removido desta AppBar específica
        actions: const [], 
      ),
      body: ListView(
        children: [
          _admTile(Icons.verified_user, "Autorizar Promoções"),
          _admTile(Icons.create_new_folder, "Criar e Nomear Trilhos"),
          _admTile(Icons.add_circle, "Adicionar Anime"),
          _admTile(Icons.message, "Suporte ao Usuário"),
          _admTile(Icons.people, "Gerenciar Usuários"),
        ],
      ),
    );
  }

  Widget _admTile(IconData i, String t) => ListTile(
    leading: Icon(i, color: roxoAura), 
    title: Text(t),
    onTap: () {}, // Funcionalidades futuras
  );
}

// --- RESTANTE DAS ABAS (BIBLIOTECA, BUSCA, AGENDA, PERFIL) ---
// (Mantivemos a lógica dos gêneros e o suporte funcional do código anterior)

class BibliotecaAba extends StatefulWidget {
  const BibliotecaAba({super.key});
  @override
  State<BibliotecaAba> createState() => _BibliotecaAbaState();
}

class _BibliotecaAbaState extends State<BibliotecaAba> {
  String? filtroAberto;
  final List<String> generos = ["Ação", "Aventura", "Comédia", "Drama", "Romance", "Psicológico", "Terror (Horror)", "Suspense", "Mistério", "Fantasia", "Sobrenatural", "Magia", "Ficção Científica", "Espaço", "Isekai", "Reencarnação", "Escolar", "Esportes", "Crime", "Policial", "Samurai", "Militar", "Mecha", "Superpoderes", "Battle Shounen", "Artes Marciais", "Harem", "Ecchi", "Hentai", "Seinen", "Shounen", "Tragédia", "Thriller", "Vampiros", "Demônios", "Apocalipse"];
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _botaoFiltro("Gênero"),
            _botaoFiltro("Status"),
            _botaoFiltro("Idioma"),
          ],
        ),
        if (filtroAberto != null) 
          Container(
            height: 200,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
            child: ListView(children: _getItensFiltro()),
          ),
        const Expanded(child: Center(child: Text("Lista de Animes Filtrados"))),
      ],
    );
  }

  Widget _botaoFiltro(String label) => ActionChip(
    backgroundColor: filtroAberto == label ? roxoAura : Colors.white10,
    label: Text(label),
    onPressed: () => setState(() => filtroAberto = filtroAberto == label ? null : label),
  );

  List<Widget> _getItensFiltro() {
    if (filtroAberto == "Gênero") return generos.map((g) => ListTile(title: Text(g), dense: true)).toList();
    if (filtroAberto == "Status") return ["Concluído", "Em andamento", "Pausado"].map((s) => ListTile(title: Text(s), dense: true)).toList();
    if (filtroAberto == "Idioma") return ["Dublado", "Legendado"].map((i) => ListTile(title: Text(i), dense: true)).toList();
    return [];
  }
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
    return Column(children: [SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: dias.map((d) => Padding(padding: const EdgeInsets.all(8.0), child: ChoiceChip(label: Text(d), selected: diaAtivo == d, selectedColor: roxoAura, onSelected: (v) => onDiaChange(d)))).toList())), const Expanded(child: Center(child: Text("Lançamentos agendados")))]);
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
        _tile(context, Icons.bug_report, "Relatar Problema / Sugestões", isAction: true),
        _tile(context, Icons.shuffle, "Reprodução Aleatória"),
        _tile(context, Icons.download, "Downloads"),
        _tile(context, Icons.wallpaper, "Papéis de Parede"),
        if (isLogged) _tile(context, Icons.logout, "Sair da Conta", color: Colors.red, onTap: onLogout),
      ],
    );
  }
  Widget _tile(BuildContext context, IconData i, String t, {Color color = Colors.white, bool isAction = false, VoidCallback? onTap}) {
    return ListTile(leading: Icon(i, color: isAction ? roxoAura : color), title: Text(t, style: TextStyle(color: color)), onTap: onTap ?? () {
      if (isAction) Navigator.push(context, MaterialPageRoute(builder: (context) => const EnviarSuportePage()));
    });
  }
}

class EnviarSuportePage extends StatelessWidget {
  const EnviarSuportePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Relatar Problema")), body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [const TextField(maxLines: 5, decoration: InputDecoration(hintText: "Descreva o bug ou sugestão...", filled: true, fillColor: Colors.white10, border: OutlineInputBorder())), const SizedBox(height: 20), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: roxoAura), onPressed: () => Navigator.pop(context), child: const Text("ENVIAR TICKET"))])));
}


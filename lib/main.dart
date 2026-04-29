import 'package:flutter/material.dart';

void main() => runApp(const FanimesApp());

// --- IDENTIDADE VISUAL ---
const Color roxoAura = Color(0xFF673AB7);
const Color pretoEletrico = Color(0xFF0D0D0D);
const Color brancoTexto = Colors.white;

// Memória temporária (Simulação)
List<Map<String, String>> ticketsSuporte = [];
List<Map<String, dynamic>> mensagensComunidade = [
  {"user": "Adm_Bot", "msg": "Bem-vindos à comunidade FÃNIMES!", "isMe": false},
];
List<Map<String, String>> solicitacoesPromocao = [
  {"user": "Ana_User", "cargo": "Vice-Adm"},
];

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

  void _mostrarParabens(String novoCargo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.stars, color: roxoAura, size: 50),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("PARABÉNS!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: roxoAura)),
            const SizedBox(height: 10),
            Text("Você foi promovido(a) a $novoCargo!", textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OBRIGADO!", style: TextStyle(color: roxoAura)))
        ],
      ),
    );
  }

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
        leading: IconButton(
          icon: const Icon(Icons.chat_bubble_outline, color: roxoAura),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatComunidadePage(userNick: userNick))),
        ),
        title: GestureDetector(
          onTap: () {
            if (currentRole == 'ADM Geral') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PainelAdmAba(
                onPromover: (cargo) => _mostrarParabens(cargo),
              )));
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
          PopupMenuButton(
            icon: const Icon(Icons.notifications_none, color: roxoAura),
            offset: const Offset(0, 50),
            color: Colors.grey[900],
            itemBuilder: (context) => [
              const PopupMenuItem(child: Text("Notificações", style: TextStyle(fontWeight: FontWeight.bold, color: roxoAura))),
              PopupMenuItem(child: ListTile(title: const Text("Nova Promoção Disponível", style: TextStyle(fontSize: 12)))),
            ],
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

// --- PAINEL ADM FUNCIONAL ---
class PainelAdmAba extends StatelessWidget {
  final Function(String) onPromover;
  const PainelAdmAba({super.key, required this.onPromover});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Painel Administrativo")),
      body: ListView(
        children: [
          _admTile(Icons.verified_user, "Autorizar Promoções", onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SolicitacoesPromocaoPage(onAprovar: onPromover)));
          }),
          _admTile(Icons.message, "Suporte ao Usuário", onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const VerTicketsPage()));
          }),
          _admTile(Icons.create_new_folder, "Criar e Nomear Trilhos"),
          _admTile(Icons.add_circle, "Adicionar Anime"),
          _admTile(Icons.people, "Gerenciar Usuários"),
        ],
      ),
    );
  }
  Widget _admTile(IconData i, String t, {VoidCallback? onTap}) => ListTile(leading: Icon(i, color: roxoAura), title: Text(t), onTap: onTap);
}

// --- TELA DE SOLICITAÇÕES DE PROMOÇÃO ---
class SolicitacoesPromocaoPage extends StatelessWidget {
  final Function(String) onAprovar;
  const SolicitacoesPromocaoPage({super.key, required this.onAprovar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Solicitações")),
      body: ListView.builder(
        itemCount: solicitacoesPromocao.length,
        itemBuilder: (context, index) {
          var s = solicitacoesPromocao[index];
          return ListTile(
            title: Text(s['user']!),
            subtitle: Text("Cargo: ${s['cargo']}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: () {
                  onAprovar(s['cargo']!);
                  Navigator.pop(context);
                }),
                IconButton(icon: const Icon(Icons.close, color: Colors.red), onPressed: () {}),
              ],
            ),
          );
        },
      ),
    );
  }
}

// --- PERFIL (COM PAPÉIS DE PAREDE RESTAURADOS) ---
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
        ListTile(leading: const Icon(Icons.bug_report, color: roxoAura), title: const Text("Relatar Problema"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EnviarSuportePage(userNick: userNick)))),
        const ListTile(leading: Icon(Icons.wallpaper, color: Colors.white), title: Text("Papéis de Parede")), // RESTAURADO
        const ListTile(leading: Icon(Icons.shuffle), title: Text("Reprodução Aleatória")),
        const ListTile(leading: Icon(Icons.download), title: Text("Downloads")),
        if (isLogged) ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text("Sair", style: TextStyle(color: Colors.red)), onTap: onLogout),
      ],
    );
  }
}

// --- BATE-PAPO DA COMUNIDADE ---
class ChatComunidadePage extends StatefulWidget {
  final String userNick;
  const ChatComunidadePage({super.key, required this.userNick});
  @override
  State<ChatComunidadePage> createState() => _ChatComunidadePageState();
}

class _ChatComunidadePageState extends State<ChatComunidadePage> {
  final TextEditingController _chatCtrl = TextEditingController();
  void _enviarMsg() {
    if (_chatCtrl.text.isNotEmpty) {
      setState(() {
        mensagensComunidade.add({"user": widget.userNick, "msg": _chatCtrl.text, "isMe": true});
        _chatCtrl.clear();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Comunidade")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: mensagensComunidade.length,
              itemBuilder: (context, index) {
                var m = mensagensComunidade[index];
                return Align(
                  alignment: m['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(color: m['isMe'] ? roxoAura : Colors.white10, borderRadius: BorderRadius.circular(10)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(m['user'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70)), Text(m['msg'])]),
                  ),
                );
              },
            ),
          ),
          Padding(padding: const EdgeInsets.all(10), child: Row(children: [Expanded(child: TextField(controller: _chatCtrl, decoration: const InputDecoration(hintText: "Digite uma mensagem...", filled: true, fillColor: Colors.white10))), IconButton(icon: const Icon(Icons.send, color: roxoAura), onPressed: _enviarMsg)]))
        ],
      ),
    );
  }
}

// --- BIBLIOTECA (PADRÃO BETA 1) ---
class BibliotecaAba extends StatelessWidget {
  const BibliotecaAba({super.key});
  @override
  Widget build(BuildContext context) {
    final List<String> generos = ["Ação", "Aventura", "Comédia", "Drama", "Romance", "Psicológico", "Terror (Horror)", "Suspense", "Mistério", "Fantasia", "Sobrenatural", "Magia", "Ficção Científica", "Espaço", "Isekai", "Reencarnação", "Escolar", "Esportes", "Crime", "Policial", "Samurai", "Militar", "Mecha", "Superpoderes", "Battle Shounen", "Artes Marciais", "Harem", "Ecchi", "Hentai", "Seinen", "Shounen", "Tragédia", "Thriller", "Vampiros", "Demônios", "Apocalipse"];
    return Column(children: [Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildMenu(context, "Gênero", generos), _buildMenu(context, "Status", ["Concluído", "Em andamento", "Pausado"]), _buildMenu(context, "Idioma", ["Dublado", "Legendado"])]))]);
  }
  Widget _buildMenu(BuildContext context, String label, List<String> itens) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 45), color: Colors.grey[900],
      child: ActionChip(backgroundColor: Colors.white10, label: Row(mainAxisSize: MainAxisSize.min, children: [Text(label), const Icon(Icons.arrow_drop_down, size: 18)])),
      itemBuilder: (context) => itens.map((item) => PopupMenuItem<String>(height: 35, child: Text(item, style: const TextStyle(fontSize: 13)))).toList(),
    );
  }
}

// --- OUTROS ---
class VerTicketsPage extends StatelessWidget {
  const VerTicketsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Tickets")), body: ticketsSuporte.isEmpty ? const Center(child: Text("Vazio")) : ListView.builder(itemCount: ticketsSuporte.length, itemBuilder: (context, index) => ListTile(title: Text(ticketsSuporte[index]['user']!), subtitle: Text(ticketsSuporte[index]['msg']!))));
}

class EnviarSuportePage extends StatelessWidget {
  final String userNick;
  const EnviarSuportePage({super.key, required this.userNick});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Suporte")), body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [const TextField(maxLines: 5, decoration: InputDecoration(hintText: "Descreva o erro...", filled: true, fillColor: Colors.white10)), const SizedBox(height: 20), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: roxoAura), onPressed: () => Navigator.pop(context), child: const Text("ENVIAR"))])));
}

class AuthPage extends StatelessWidget {
  final Function(String) onLogin;
  const AuthPage({super.key, required this.onLogin});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Login")), body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [const TextField(decoration: InputDecoration(labelText: "E-mail", filled: true, fillColor: Colors.white10)), const SizedBox(height: 20), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: roxoAura, minimumSize: const Size(double.infinity, 50)), onPressed: () { onLogin("Usuário"); Navigator.pop(context); }, child: const Text("ENTRAR"))])));
}

class PesquisaAba extends StatelessWidget { const PesquisaAba({super.key}); @override Widget build(BuildContext context) => const Center(child: Text("Busca")); }
class AgendaAba extends StatelessWidget { final String diaAtivo; final Function(String) onDiaChange; const AgendaAba({super.key, required this.diaAtivo, required this.onDiaChange}); @override Widget build(BuildContext context) => const Center(child: Text("Agenda")); }


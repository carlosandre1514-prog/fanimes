import 'package:flutter/material.dart';

void main() => runApp(const FanimesApp());

// --- CONSTANTES DE DESIGN ---
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
      ),
      home: const MainNavigation(),
    );
  }
}

// --- MODELOS ---
class SupportTicket {
  final String id, userNick, userEmail, message;
  SupportTicket({required this.id, required this.userNick, required this.userEmail, required this.message});
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
  bool temNotificacaoAdm = true;

  // Tickets de suporte simulados
  List<SupportTicket> tickets = [
    SupportTicket(id: "1", userNick: "Carlos01", userEmail: "carlos@teste.com", message: "Erro ao carregar os episódios."),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> telas = [
      const Center(child: Text("Home - Lista de Trilhos")),
      const BibliotecaAba(),
      const PesquisaAba(),
      AgendaAba(diaAtivo: diaSelecionado, onDiaChange: (d) => setState(() => diaSelecionado = d)),
      PerfilAba(
        isLogged: isLogged, 
        userNick: userNick,
        currentRole: currentRole, 
        onLogin: (email) => setState(() {
          isLogged = true;
          currentRole = (email == 'carlos@adm.com') ? 'Geral' : 'Usuário';
        }),
        onLogout: () => setState(() { isLogged = false; currentRole = 'Visitante'; }),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            if (currentRole == 'Geral') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PainelAdmAba(temAlerta: temNotificacaoAdm, tickets: tickets)));
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

// --- ABA: BIBLIOTECA (RESTAURADA E COMPLETA) ---
class BibliotecaAba extends StatelessWidget {
  const BibliotecaAba({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFiltro("Gênero"),
              _buildFiltro("Status"),
              _buildFiltro("Idioma"),
            ],
          ),
        ),
        const Expanded(child: Center(child: Text("Nenhum anime na biblioteca ainda."))),
      ],
    );
  }
  Widget _buildFiltro(String label) => Chip(
    label: Row(children: [Text(label), const Icon(Icons.arrow_drop_down, size: 18)]),
    backgroundColor: Colors.white10,
  );
}

// --- ABA: PESQUISA (RESTAURADA E COMPLETA) ---
class PesquisaAba extends StatelessWidget {
  const PesquisaAba({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Busca',
          prefixIcon: const Icon(Icons.search, color: roxoAura),
          filled: true,
          fillColor: Colors.white10,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}

// --- ABA: AGENDA (INTACTA) ---
class AgendaAba extends StatelessWidget {
  final String diaAtivo;
  final Function(String) onDiaChange;
  const AgendaAba({super.key, required this.diaAtivo, required this.onDiaChange});

  @override
  Widget build(BuildContext context) {
    List<String> dias = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"];
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: dias.map((d) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ChoiceChip(
                label: Text(d),
                selected: diaAtivo == d,
                selectedColor: roxoAura,
                onSelected: (v) => onDiaChange(d),
              ),
            )).toList(),
          ),
        ),
        const Expanded(child: Center(child: Text("Lançamentos de Hoje"))),
      ],
    );
  }
}

// --- ABA: PERFIL (NICKNAME ABAIXO DA FOTO) ---
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
        Center(child: Text(isLogged ? currentRole : "", style: const TextStyle(color: roxoAura, fontSize: 14))),
        const SizedBox(height: 20),
        if (!isLogged) ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: roxoAura), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AuthPage(onLogin: onLogin))), child: const Text("LOGIN / CADASTRO")),
        const Divider(height: 40),
        _buildListTile(context, Icons.bug_report, "Relatar Problema / Sugestão", isAction: true),
        _buildListTile(context, Icons.shuffle, "Reprodução Aleatória"),
        _buildListTile(context, Icons.download, "Downloads"),
        _buildListTile(context, Icons.wallpaper, "Papéis de Parede"),
        if (isLogged) _buildListTile(context, Icons.logout, "Sair da Conta", color: Colors.red, onTap: onLogout),
      ],
    );
  }
  Widget _buildListTile(BuildContext context, IconData icon, String title, {Color color = Colors.white, bool isAction = false, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: isAction ? roxoAura : color),
      title: Text(title, style: TextStyle(color: color)),
      onTap: onTap ?? () { if (isAction) Navigator.push(context, MaterialPageRoute(builder: (context) => const EnviarSuportePage())); },
    );
  }
}

// --- PAINEL ADM (COMPLETO) ---
class PainelAdmAba extends StatelessWidget {
  final bool temAlerta;
  final List<SupportTicket> tickets;
  const PainelAdmAba({super.key, required this.temAlerta, required this.tickets});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Painel Administrativo"),
        actions: [
          Stack(children: [
            const IconButton(icon: Icon(Icons.notifications, color: roxoAura), onPressed: null),
            if (temAlerta) Positioned(right: 10, top: 10, child: Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle), constraints: const BoxConstraints(minWidth: 14, minHeight: 14), child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 8), textAlign: TextAlign.center)))
          ])
        ],
      ),
      body: ListView(
        children: [
          _admTile(Icons.verified_user, "Autorizar Promoções"),
          _admTile(Icons.create_new_folder, "Criar e Nomear Trilhos"),
          _admTile(Icons.add_circle, "Adicionar Anime"),
          _admTile(Icons.message, "Suporte ao Usuário", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => VerTicketsPage(tickets: tickets)))),
          _admTile(Icons.people, "Gerenciar Usuários"),
        ],
      ),
    );
  }
  Widget _admTile(IconData i, String t, {VoidCallback? onTap}) => ListTile(leading: Icon(i, color: roxoAura), title: Text(t), onTap: onTap);
}

// --- PÁGINAS DE SUPORTE E LOGIN ---
class VerTicketsPage extends StatelessWidget {
  final List<SupportTicket> tickets;
  const VerTicketsPage({super.key, required this.tickets});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tickets Recebidos")),
      body: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, i) => ListTile(
          title: Text("De: ${tickets[i].userNick}"),
          subtitle: Text(tickets[i].message),
          trailing: TextButton(onPressed: () {}, child: const Text("Responder", style: TextStyle(color: roxoAura))),
        ),
      ),
    );
  }
}

class AuthPage extends StatelessWidget {
  final Function(String) onLogin;
  const AuthPage({super.key, required this.onLogin});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login / Cadastro")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          const TextField(decoration: InputDecoration(labelText: "E-mail", filled: true, fillColor: Colors.white10)),
          const SizedBox(height: 10),
          const TextField(obscureText: true, decoration: InputDecoration(labelText: "Senha", filled: true, fillColor: Colors.white10)),
          const SizedBox(height: 20),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: roxoAura, minimumSize: const Size(double.infinity, 50)), onPressed: () { onLogin('carlos@adm.com'); Navigator.pop(context); }, child: const Text("ENTRAR")),
        ]),
      ),
    );
  }
}

class EnviarSuportePage extends StatelessWidget {
  const EnviarSuportePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Relatar Problema")), body: const Center(child: Text("Formulário de Ticket")));
}


import 'package:flutter/material.dart';

void main() => runApp(const FanimesApp());

// --- CORES PADRONIZADAS DO PROJETO ---
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

// --- MODELO ---
class Anime {
  final String nome, sinopse, genero, status, idioma, tipo, diaLancamento;
  final List<String> episodios;
  Anime({required this.nome, required this.sinopse, required this.genero, required this.status, required this.idioma, required this.tipo, required this.episodios, required this.diaLancamento});
}

class UserTicket {
  final String userName, userEmail, description, date;
  UserTicket({required this.userName, required this.userEmail, required this.description, required this.date});
}

// --- NAVEGAÇÃO PRINCIPAL ---
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  String? userEmail; // Define se o usuário está logado
  String currentRole = 'Usuário'; // Role padrão: Usuário
  bool isLogged = false;
  bool hasPendingPromotion = true; // Simula notificação pendente ADM

  // Stub de animes - começa vazio
  List<Anime> allAnimes = [];

  void _onItemTapped(int index) { setState(() => _selectedIndex = index); }

  void _handleLoginSuccess(String email) {
    setState(() {
      userEmail = email;
      isLogged = true;
      // Lógica de reconhecimento de admin por e-mail fixo
      if (email == 'carlosandre@fanimes.com') { // E-mail ADM do Carlos
        currentRole = 'Geral';
      } else {
        currentRole = 'Usuário';
      }
    });
  }

  void _handleLogout() { setState(() { userEmail = null; isLogged = false; currentRole = 'Usuário'; }); }

  @override
  Widget build(BuildContext context) {
    final List<Widget> telas = [
      const HomeAba(),
      BibliotecaAba(animes: allAnimes),
      PesquisaAba(animes: allAnimes),
      const AgendaAba(),
      PerfilAba(
        isLogged: isLogged, 
        currentRole: currentRole, 
        userEmail: userEmail, 
        onLogin: _handleLoginSuccess, 
        onLogout: _handleLogout
      ),
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
        onTap: _onItemTapped,
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

// --- ABA: PESQUISA (CORRIGIDA COM BARRA DE BUSCA) ---
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
              hintStyle: const TextStyle(color: Colors.white60),
              prefixIcon: const Icon(Icons.search, color: roxoAura),
              filled: true,
              fillColor: Colors.white10, // Preto Elétrico clarinho
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        // Exibe "Comece a buscar" se vazio
        if (animes.isEmpty)
          const Expanded(child: Center(child: Text('Nenhum anime para buscar ainda', style: TextStyle(color: Colors.white60)))),
        if (animes.isNotEmpty)
          Expanded(child: ListView.builder(itemCount: animes.length, itemBuilder: (c, i) => ListTile(title: Text(animes[i].nome))))
      ],
    );
  }
}

// --- ABA: BIBLIOTECA (DROPDOWNS QUE NÃO CONFLITAM) ---
class BibliotecaAba extends StatelessWidget {
  final List<Anime> animes;
  const BibliotecaAba({super.key, required this.animes});

  Widget _buildFiltroDropdown(String label, List<String> opcoes) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 45), // Posição abaixo do chip
      color: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), border: Border.all(color: roxoAura, width: 0.5)),
      child: Chip(
        label: Row(mainAxisSize: MainAxisSize.min, children: [Text(label), const Icon(Icons.arrow_drop_down, size: 18)]), 
        backgroundColor: Colors.white10
      ),
      onSelected: (val) {},
      itemBuilder: (context) => opcoes.map((o) => PopupMenuItem(value: o, child: Text(o, style: const TextStyle(fontSize: 14)))).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                _buildFiltroDropdown("Gênero", ["Ação", "Isekai", "Xianxia", "Romance", "Shonen", "Seinen", "Aventura"]),
                const SizedBox(width: 8),
                _buildFiltroDropdown("Status", ["Concluído", "Em andamento", "Pausado"]),
                const SizedBox(width: 8),
                _buildFiltroDropdown("Idioma", ["Legendado", "Dublado"]),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
        // Cards cinzas removidos. Só exibe se houver animes.
        if (animes.isEmpty)
          const Expanded(child: Center(child: Text("Nenhum anime adicionado. Use o Painel ADM.", style: TextStyle(color: Colors.white60)))),
        if (animes.isNotEmpty)
          Expanded(child: GridView.builder(padding: const EdgeInsets.all(10), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.7), itemCount: animes.length, itemBuilder: (c, i) => Card(color: Colors.white10))),
      ],
    );
  }
}

// --- ABA: PERFIL (CORRIGIDA COM LOGIN/CADASTRO) ---
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
        if (!isLogged) // Estado NÃO LOGADO
          Column(
            children: [
              const CircleAvatar(radius: 50, backgroundColor: roxoAura, child: Icon(Icons.account_circle, color: Colors.white, size: 50)),
              const SizedBox(height: 12),
              const Text("Não Logado", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(onLogin: onLogin))); },
                style: ElevatedButton.styleFrom(backgroundColor: roxoAura, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                child: const Text("Login / Cadastro", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        if (isLogged) // Estado LOGADO
          Column(
            children: [
              const CircleAvatar(radius: 50, backgroundColor: roxoAura, child: Icon(Icons.person_outline, color: Colors.white, size: 50)),
              const SizedBox(height: 12),
              const Text("Nome do Usuário (Carlos?)", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // Simulado
              Text("$userEmail - $currentRole", style: const TextStyle(color: roxoAura, fontWeight: FontWeight.bold)),
            ],
          ),
        const SizedBox(height: 30),
        _buildItem(context, Icons.bug_report, "Relatar Problema / Sugestão", color: roxoAura, onTap: () {
          // Lógica de redirecionar para página de envio de ticket (usuário escreve)
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SubmitTicketPage()));
        }),
        _buildItem(context, Icons.shuffle, "Reprodução Aleatória"),
        _buildItem(context, Icons.download, "Configurações de Download"),
        if (isLogged)
          _buildItem(context, Icons.logout, "Sair da Conta", color: Colors.redAccent.withOpacity(0.3), onTap: onLogout),
      ],
    );
  }

  Widget _buildItem(BuildContext context, IconData icon, String label, {Color color = Colors.white10, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
          child: Row(children: [Icon(icon), const SizedBox(width: 15), Text(label), const Spacer(), const Icon(Icons.arrow_forward_ios, size: 14)]),
        ),
      ),
    );
  }
}

// --- PAINEL ADM (SININHO CORRIGIDO COM NÚMERO) ---
class PainelAdmAba extends StatelessWidget {
  final bool hasAlerta;
  const PainelAdmAba({super.key, required this.hasAlerta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Painel do Administrador"),
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
                    child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), textAlign: textAlign: TextAlign.center),
                  ),
                )
            ],
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("CONTROLE DE ACESSO", style: TextStyle(color: roxoAura, fontWeight: FontWeight.bold, fontSize: 12)),
          _buildAdmItem(Icons.verified_user, "Autorizar Promoções", "Ver solicitações de Vice para Sub"),
          const Divider(height: 30),
          const Text("CONTEÚDO", style: TextStyle(color: roxoAura, fontWeight: FontWeight.bold, fontSize: 12)),
          _buildAdmItem(Icons.create_new_folder, "Criar e Nomear Trilhos", "Gerenciar categorias"),
          _buildAdmItem(Icons.add_to_photos, "Adicionar Anime e Descrição", "Cadastrar novos títulos"),
          _buildAdmItem(Icons.edit_note, "Editar Anime ou Sinopse", "Atualizar informações"),
          const Divider(height: 30),
          const Text("SUPORTE E RELATÓRIOS", style: TextStyle(color: roxoAura, fontWeight: FontWeight.bold, fontSize: 12)),
          _buildAdmItem(Icons.bug_report, "Visualizar Tickets de Suporte", "Ler sugestões e bugs enviados", onTap: () {
            // Lógica de redirecionar para a página que lista os tickets recebidos
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewTicketsPage()));
          }),
          _buildAdmItem(Icons.people_alt, "Gerenciar Usuários", "Acessar base de dados"),
        ],
      ),
    );
  }

  Widget _buildAdmItem(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: roxoAura),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.white60)),
      onTap: onTap ?? () {},
    );
  }
}

// --- PÁGINAS STUBS (HOME, AGENDA, ETC.) ---
class HomeAba extends StatelessWidget { const HomeAba({super.key}); @override Widget build(BuildContext context) => const Center(child: Text("Home (Lista Vazia)")); }
class AgendaAba extends StatelessWidget { const AgendaAba({super.key}); @override Widget build(BuildContext context) => const Center(child: Text("Agenda")); }
class LoginPage extends StatelessWidget { final Function(String) onLogin; const LoginPage({super.key, required this.onLogin}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Login / Cadastro")), body: Center(child: ElevatedButton(onPressed: () { onLogin('carlosandre@fanimes.com'); Navigator.pop(context); }, child: const Text("Simular Login do Carlos ADM")))); }
class SubmitTicketPage extends StatelessWidget { const SubmitTicketPage({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Enviar Ticket")), body: const Center(child: Text("Aqui o usuário escreve o bug"))); }
class ViewTicketsPage extends StatelessWidget { const ViewTicketsPage({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Tickets Recebidos")), body: const Center(child: Text("Aqui o ADM lê os bugs recebidos"))); }


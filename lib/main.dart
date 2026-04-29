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
  String? userEmail;
  String diaSelecionado = "Qua";
  bool temNotificacaoAdm = true; // Só aparece a bolinha se for true

  void _onItemTapped(int index) { setState(() => _selectedIndex = index); }

  @override
  Widget build(BuildContext context) {
    final List<Widget> telas = [
      const Center(child: Text("Home (Sem animes ainda)")),
      const BibliotecaAba(),
      const PesquisaAba(),
      AgendaAba(diaAtivo: diaSelecionado, onDiaChange: (d) => setState(() => diaSelecionado = d)),
      PerfilAba(
        isLogged: isLogged, 
        currentRole: currentRole, 
        onLogin: (email) => setState(() {
          isLogged = true;
          userEmail = email;
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => PainelAdmAba(temAlerta: temNotificacaoAdm)));
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

// --- AGENDA (RECUPERADA) ---
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
        const Expanded(child: Center(child: Text("Lançamentos do dia"))),
      ],
    );
  }
}

// --- PERFIL (RECUPERADO E COMPLETO) ---
class PerfilAba extends StatelessWidget {
  final bool isLogged;
  final String currentRole;
  final Function(String) onLogin;
  final VoidCallback onLogout;

  const PerfilAba({super.key, required this.isLogged, required this.currentRole, required this.onLogin, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const CircleAvatar(radius: 50, backgroundColor: Colors.white10, child: Icon(Icons.person, size: 50, color: roxoAura)),
        const SizedBox(height: 10),
        Center(child: Text(isLogged ? currentRole : "Usuário Desconectado", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        const SizedBox(height: 20),
        if (!isLogged)
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: roxoAura),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AuthPage(onLogin: onLogin))),
            child: const Text("LOGIN / CADASTRO"),
          ),
        const Divider(height: 40),
        _item(context, Icons.bug_report, "Relatar Problema / Sugestões", isAction: true),
        _item(context, Icons.shuffle, "Reprodução Aleatória"),
        _item(context, Icons.download, "Downloads"),
        _item(context, Icons.wallpaper, "Papéis de Parede"),
        if (isLogged) _item(context, Icons.logout, "Sair da Conta", color: Colors.red, onTap: onLogout),
      ],
    );
  }

  Widget _item(BuildContext context, IconData icon, String text, {Color color = Colors.white, bool isAction = false, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: isAction ? roxoAura : color),
      title: Text(text, style: TextStyle(color: color)),
      onTap: onTap ?? () {
        if (isAction) Navigator.push(context, MaterialPageRoute(builder: (context) => const EnviarSuportePage()));
      },
    );
  }
}

// --- PAINEL ADM (TUDO RECUPERADO E CORRIGIDO) ---
class PainelAdmAba extends StatelessWidget {
  final bool temAlerta;
  const PainelAdmAba({super.key, required this.temAlerta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Painel Administrativo"),
        actions: [
          Stack(
            children: [
              const IconButton(icon: Icon(Icons.notifications, color: roxoAura), onPressed: null),
              if (temAlerta)
                Positioned(
                  right: 10, top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                    child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 8), textAlign: TextAlign.center),
                  ),
                )
            ],
          )
        ],
      ),
      body: ListView(
        children: [
          const ListTile(leading: Icon(Icons.verified_user), title: Text("Autorizar Promoções")),
          const ListTile(leading: Icon(Icons.create_new_folder), title: Text("Criar Trilhos")),
          const ListTile(leading: Icon(Icons.add_circle), title: Text("Adicionar Anime")),
          const ListTile(leading: Icon(Icons.edit), title: Text("Editar Dados")),
          ListTile(
            leading: const Icon(Icons.message, color: roxoAura),
            title: const Text("Suporte ao Usuário"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const VerTicketsPage())),
          ),
          const ListTile(leading: Icon(Icons.people), title: Text("Gerenciar Usuários")),
        ],
      ),
    );
  }
}

// --- PÁGINA DE LOGIN/CADASTRO (ESTILO PAINEL ADM) ---
class AuthPage extends StatelessWidget {
  final Function(String) onLogin;
  const AuthPage({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Acessar FÃNIMES")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: "Nickname", filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 10),
            TextField(decoration: InputDecoration(labelText: "E-mail", filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 10),
            TextField(obscureText: true, decoration: InputDecoration(labelText: "Senha", filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: roxoAura, minimumSize: const Size(double.infinity, 50)),
              onPressed: () { onLogin('carlos@adm.com'); Navigator.pop(context); },
              child: const Text("ENTRAR"),
            ),
            TextButton(onPressed: () {}, child: const Text("Não possui conta? Cadastre-se", style: TextStyle(color: roxoAura))),
            const Divider(height: 40),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.g_mobiledata, size: 30),
              label: const Text("Entrar com Google"),
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            )
          ],
        ),
      ),
    );
  }
}

// --- PÁGINAS DE SUPORTE ---
class EnviarSuportePage extends StatelessWidget {
  const EnviarSuportePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Relatar Problema")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const TextField(maxLines: 5, decoration: InputDecoration(hintText: "Descreva o problema ou sugestão...", filled: true, fillColor: Colors.white10, border: OutlineInputBorder())),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: roxoAura), child: const Text("ENVIAR AOS ADMS"))
          ],
        ),
      ),
    );
  }
}

class VerTicketsPage extends StatelessWidget {
  const VerTicketsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tickets de Suporte")),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) => ListTile(
          title: const Text("Nickname: Carlos01"),
          subtitle: const Text("E-mail: usuario@teste.com\nProblema: O app fechou sozinho."),
          isThreeLine: true,
          trailing: TextButton(onPressed: () {}, child: const Text("Responder", style: TextStyle(color: roxoAura))),
        ),
      ),
    );
  }
}

// STUBS RESTANTES
class BibliotecaAba extends StatelessWidget { const BibliotecaAba({super.key}); @override Widget build(BuildContext context) => const Center(child: Text("Biblioteca")); }
class PesquisaAba extends StatelessWidget { const PesquisaAba({super.key}); @override Widget build(BuildContext context) => const Center(child: Text("Pesquisa")); }


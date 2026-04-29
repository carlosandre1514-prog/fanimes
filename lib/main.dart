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

// --- MODELO DE DADOS ---
class Anime {
  final String nome, sinopse, genero, status, idioma, tipo, diaLancamento;
  final List<String> episodios;
  Anime({required this.nome, required this.sinopse, required this.genero, required this.status, required this.idioma, required this.tipo, required this.episodios, required this.diaLancamento});
}

// --- NAVEGAÇÃO PRINCIPAL ---
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  String meuCargo = 'Geral'; 
  String diaSelecionado = "Qua";
  bool temNotificacaoAdm = true;

  List<Anime> todosAnimes = [
    Anime(nome: "Solo Leveling", sinopse: "Onde o mais fraco se torna o mais forte.", genero: "Isekai", status: "Em andamento", idioma: "Dublado", tipo: "TV", diaLancamento: "Sáb", episodios: ["Episódio 01"]),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> telas = [
      const Center(child: Text("Home FÃNIMES (Trilhos)")),
      BibliotecaAba(animes: todosAnimes),
      PesquisaAba(animes: todosAnimes),
      AgendaAba(diaAtivo: diaSelecionado, onDiaChange: (d) => setState(() => diaSelecionado = d)),
      PerfilAba(cargo: meuCargo),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PainelAdmAba(cargo: meuCargo, temAlerta: temNotificacaoAdm))),
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

// --- ABA: BIBLIOTECA (CORREÇÃO DO ERRO DO BORDER AQUI) ---
class BibliotecaAba extends StatelessWidget {
  final List<Anime> animes;
  const BibliotecaAba({super.key, required this.animes});

  Widget _buildFiltroDropdown(String label, List<String> opcoes) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 45),
      color: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), 
        side: const BorderSide(color: roxoAura, width: 0.5) // Correção: de 'border' para 'side'
      ),
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
                _buildFiltroDropdown("Status", ["Concluído", "Finalizado", "Em andamento", "Pausado"]),
                const SizedBox(width: 8),
                _buildFiltroDropdown("Idioma", ["Legendado", "Dublado"]),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
        Expanded(child: GridView.builder(padding: const EdgeInsets.all(10), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.7), itemCount: animes.length, itemBuilder: (c, i) => Card(color: Colors.white10))),
      ],
    );
  }
}

// --- ABA: PERFIL ---
class PerfilAba extends StatelessWidget {
  final String cargo;
  const PerfilAba({super.key, required this.cargo});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        GestureDetector(
          onTap: () {}, 
          child: Column(
            children: [
              const CircleAvatar(radius: 50, backgroundColor: roxoAura, child: Icon(Icons.camera_alt, color: Colors.white, size: 30)),
              const SizedBox(height: 12),
              const Text("Carlos Andre", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(cargo, style: const TextStyle(color: roxoAura, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            ],
          ),
        ),
        const SizedBox(height: 30),
        _buildItem(Icons.bug_report, "Suporte ao Cliente", color: roxoAura),
        _buildItem(Icons.shuffle, "Reprodução Aleatória"),
        _buildItem(Icons.download, "Configurações de Download"),
        _buildItem(Icons.wallpaper, "Papéis de Parede"),
        _buildItem(Icons.share, "Compartilhar Aplicativo"),
        _buildItem(Icons.logout, "Sair da Conta", color: Colors.redAccent.withOpacity(0.3)),
      ],
    );
  }

  Widget _buildItem(IconData icon, String label, {Color color = Colors.white10}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
          child: Row(children: [Icon(icon), const SizedBox(width: 15), Text(label, style: const TextStyle(fontWeight: FontWeight.w500)), const Spacer(), const Icon(Icons.arrow_forward_ios, size: 14)]),
        ),
      ),
    );
  }
}

// --- PAINEL ADM ---
class PainelAdmAba extends StatelessWidget {
  final String cargo;
  final bool temAlerta;
  const PainelAdmAba({super.key, required this.cargo, required this.temAlerta});

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
              if (temAlerta)
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
          ListTile(leading: const Icon(Icons.verified_user), title: const Text("Autorizar Promoções"), subtitle: const Text("Ver solicitações de Vice para Sub"), onTap: () {}),
          const Divider(height: 30),
          const Text("CONTEÚDO", style: TextStyle(color: roxoAura, fontWeight: FontWeight.bold, fontSize: 12)),
          ListTile(leading: const Icon(Icons.create_new_folder), title: const Text("Criar e Nomear Trilhos"), onTap: () {}),
          ListTile(leading: const Icon(Icons.add_to_photos), title: const Text("Adicionar Anime e Descrição"), onTap: () {}),
          ListTile(leading: const Icon(Icons.edit_note), title: const Text("Editar Anime ou Sinopse"), onTap: () {}),
          const Divider(height: 30),
          const Text("SISTEMA", style: TextStyle(color: roxoAura, fontWeight: FontWeight.bold, fontSize: 12)),
          ListTile(leading: const Icon(Icons.bug_report), title: const Text("Tickets de Suporte (Bugs)"), onTap: () {}),
          ListTile(leading: const Icon(Icons.people_alt), title: const Text("Gerenciar Usuários"), onTap: () {}),
        ],
      ),
    );
  }
}

// --- STUBS ---
class PesquisaAba extends StatelessWidget { final List<Anime> animes; const PesquisaAba({super.key, required this.animes}); @override Widget build(BuildContext context) => const Center(child: Text("Busca")); }
class AgendaAba extends StatelessWidget { final String diaAtivo; final Function(String) onDiaChange; const AgendaAba({super.key, required this.diaAtivo, required this.onDiaChange}); @override Widget build(BuildContext context) => Column(children: [SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"].map((d) => Padding(padding: const EdgeInsets.all(8), child: ChoiceChip(label: Text(d), selected: diaAtivo == d, selectedColor: roxoAura, onSelected: (v) => onDiaChange(d)))).toList()))]); }


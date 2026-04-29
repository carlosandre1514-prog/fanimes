import 'package:flutter/material.dart';

void main() => runApp(const FanimesApp());

// --- CORES PADRONIZADAS ---
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
  final String nome;
  final String sinopse;
  final String genero;
  final String status;
  final String idioma;
  final String tipo; 
  final List<String> episodios;
  final String diaLancamento;

  Anime({
    required this.nome, required this.sinopse, required this.genero, 
    required this.status, required this.idioma, required this.tipo,
    required this.episodios, required this.diaLancamento,
  });
}

// --- NAVEGAÇÃO ---
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  String meuCargo = 'Geral'; // Simulado como reconhecido pelo e-mail do Carlos
  String diaSelecionado = "Qua";
  String filtroTipo = "TV";

  List<Anime> todosAnimes = [
    Anime(nome: "Solo Leveling", sinopse: "O mais fraco se torna forte.", genero: "Isekai", status: "Em andamento", idioma: "Dublado", tipo: "TV", diaLancamento: "Sáb", episodios: ["Ep 01"]),
    Anime(nome: "Re:Zero", sinopse: "Mundo de fantasia cruel.", genero: "Isekai", status: "Em andamento", idioma: "Legendado", tipo: "TV", diaLancamento: "Qua", episodios: ["Ep 01"]),
  ];

  void _abrirNotificacoes(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Stack(
        children: [
          Positioned(
            top: 50, right: 10,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 200,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(8), border: Border.all(color: roxoAura)),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Notificações", style: TextStyle(color: roxoAura, fontWeight: FontWeight.bold)),
                    Divider(color: Colors.white10),
                    Text("Nenhuma novidade agora.", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> telas = [
      HomeAba(animes: todosAnimes),
      BibliotecaAba(animes: todosAnimes, tipoSelecionado: filtroTipo, onTipoChange: (v)=> setState(()=> filtroTipo = v)),
      PesquisaAba(animes: todosAnimes),
      AgendaAba(animes: todosAnimes, diaAtivo: diaSelecionado, onDiaChange: (d) => setState(()=> diaSelecionado = d)),
      PerfilAba(cargo: meuCargo),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PainelAdmAba(cargo: meuCargo, animes: todosAnimes))),
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
        actions: [IconButton(icon: const Icon(Icons.notifications_none, color: roxoAura), onPressed: () => _abrirNotificacoes(context))],
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

// --- ABA: PESQUISA (FUNCIONAL EM TEMPO REAL) ---
class PesquisaAba extends StatefulWidget {
  final List<Anime> animes;
  const PesquisaAba({super.key, required this.animes});
  @override
  State<PesquisaAba> createState() => _PesquisaAbaState();
}

class _PesquisaAbaState extends State<PesquisaAba> {
  List<Anime> filtrados = [];
  @override
  void initState() { filtrados = widget.animes; super.initState(); }

  void _filtrar(String query) {
    setState(() {
      filtrados = widget.animes.where((a) => a.nome.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: _filtrar,
            decoration: InputDecoration(
              hintText: "Pesquisar animes...",
              prefixIcon: const Icon(Icons.search, color: roxoAura),
              filled: true, fillColor: Colors.white10,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filtrados.length,
            itemBuilder: (context, i) => ListTile(
              onTap: () {},
              leading: Container(width: 50, color: Colors.white10),
              title: Text(filtrados[i].nome),
              subtitle: Text(filtrados[i].idioma, style: const TextStyle(color: roxoAura)),
            ),
          ),
        ),
      ],
    );
  }
}

// --- ABA: BIBLIOTECA (FILTROS FUNCIONAIS) ---
class BibliotecaAba extends StatelessWidget {
  final List<Anime> animes;
  final String tipoSelecionado;
  final Function(String) onTipoChange;
  const BibliotecaAba({super.key, required this.animes, required this.tipoSelecionado, required this.onTipoChange});

  void _mostrarFiltro(BuildContext context, String titulo, List<String> opcoes) {
    showModalBottomSheet(
      context: context,
      backgroundColor: pretoEletrico,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(padding: const EdgeInsets.all(16), child: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, color: roxoAura))),
          ...opcoes.map((o) => ListTile(title: Text(o), onTap: () => Navigator.pop(context))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(onPressed: () => onTipoChange("TV"), child: Text("TV", style: TextStyle(color: tipoSelecionado == "TV" ? roxoAura : Colors.white))),
            TextButton(onPressed: () => onTipoChange("Filmes"), child: Text("Filmes", style: TextStyle(color: tipoSelecionado == "Filmes" ? roxoAura : Colors.white))),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ActionChip(label: const Text("Gêneros"), onPressed: () => _mostrarFiltro(context, "Gêneros", ["Ação", "Isekai", "Xianxia"]), backgroundColor: Colors.white10),
              const SizedBox(width: 8),
              ActionChip(label: const Text("Status"), onPressed: () => _mostrarFiltro(context, "Status", ["Em andamento", "Concluído", "Pausado"]), backgroundColor: Colors.white10),
              const SizedBox(width: 8),
              ActionChip(label: const Text("Idioma"), onPressed: () => _mostrarFiltro(context, "Idioma", ["Dublado", "Legendado"]), backgroundColor: Colors.white10),
            ],
          ),
        ),
        Expanded(child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), itemCount: animes.length, itemBuilder: (c, i) => Card(color: Colors.white10, child: Center(child: Text(animes[i].nome, style: const TextStyle(fontSize: 10))))))
      ],
    );
  }
}

// --- ABA: AGENDA (CLICÁVEL) ---
class AgendaAba extends StatelessWidget {
  final List<Anime> animes;
  final String diaAtivo;
  final Function(String) onDiaChange;
  const AgendaAba({super.key, required this.animes, required this.diaAtivo, required this.onDiaChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"].map((dia) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ChoiceChip(
                label: Text(dia), selected: diaAtivo == dia,
                selectedColor: roxoAura, onSelected: (v) => onDiaChange(dia),
              ),
            )).toList(),
          ),
        ),
        Expanded(child: Center(child: Text("Lançamentos de $diaAtivo")))
      ],
    );
  }
}

// --- ABA: PERFIL (BOTÕES COM ANIMAÇÃO) ---
class PerfilAba extends StatelessWidget {
  final String cargo;
  const PerfilAba({super.key, required this.cargo});

  Widget _botaoPerfil(IconData icon, String titulo, {Color color = Colors.white10, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Icon(icon, color: brancoTexto),
              const SizedBox(width: 10),
              Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 14),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _botaoPerfil(Icons.person, "Carlos Andre - $cargo", color: roxoAura),
        _botaoPerfil(Icons.bug_report, "Central de Suporte e Bugs", color: roxoAura),
        _botaoPerfil(Icons.shuffle, "Reprodução Aleatória"),
        _botaoPerfil(Icons.download, "Configurações de Download"),
        _botaoPerfil(Icons.logout, "Sair", color: Colors.redAccent.withOpacity(0.3)),
      ],
    );
  }
}

// --- PAINEL ADM ---
class PainelAdmAba extends StatelessWidget {
  final String cargo;
  final List<Anime> animes;
  const PainelAdmAba({super.key, required this.cargo, required this.animes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Painel Administrativo")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("GERENCIAR CONTEÚDO", style: TextStyle(color: roxoAura, fontSize: 12)),
          ListTile(leading: const Icon(Icons.add_box), title: const Text("Adicionar Novo Anime"), onTap: () {}),
          ListTile(leading: const Icon(Icons.edit), title: const Text("Editar Anime Existente"), onTap: () {
            // Aqui abriria a lista para pesquisar e editar
          }),
          const Divider(),
          const Text("RELATÓRIOS", style: TextStyle(color: roxoAura, fontSize: 12)),
          ListTile(leading: const Icon(Icons.message), title: const Text("Tickets de Suporte"), onTap: () {}),
        ],
      ),
    );
  }
}

class HomeAba extends StatelessWidget {
  final List<Anime> animes;
  const HomeAba({super.key, required this.animes});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Home do FÃNIMES"));
  }
}


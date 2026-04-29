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

// --- MODELOS DE DADOS ---
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
    required this.nome, 
    required this.sinopse, 
    required this.genero, 
    required this.status, 
    required this.idioma, 
    required this.tipo,
    required this.episodios,
    required this.diaLancamento,
  });
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

  List<String> trilhosAtivos = ["Xianxia", "Isekai"];
  List<Anime> todosAnimes = [
    Anime(
      nome: "Solo Leveling", 
      sinopse: "Onde o mais fraco se torna o mais forte...", 
      genero: "Isekai", status: "Em andamento", idioma: "Dublado", tipo: "TV",
      diaLancamento: "Sábado", episodios: ["Episódio 01", "Episódio 02", "Episódio 03"]
    ),
    Anime(
      nome: "Re:Zero", 
      sinopse: "Subaru morre e volta no tempo para salvar seus amigos em um mundo de fantasia cruel.", 
      genero: "Isekai", status: "Em andamento", idioma: "Legendado", tipo: "TV",
      diaLancamento: "Quarta", episodios: ["Episódio 01", "Episódio 02"]
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> telas = [
      HomeAba(trilhos: trilhosAtivos, animes: todosAnimes),
      BibliotecaAba(animes: todosAnimes),
      PesquisaAba(animes: todosAnimes),
      AgendaAba(animes: todosAnimes),
      PerfilAba(cargo: meuCargo),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            if (meuCargo != 'Usuario') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PainelAdmAba(cargo: meuCargo)));
            }
          },
          child: RichText(
            text: const TextSpan(
              style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.bold, fontSize: 20),
              children: [
                TextSpan(text: 'FÃ', style: TextStyle(color: Colors.deepPurpleAccent)),
                TextSpan(text: 'NIMES', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
        actions: [IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {})],
      ),
      body: telas[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0D0D0D),
        selectedItemColor: Colors.deepPurpleAccent,
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

// --- ABA: HOME ---
class HomeAba extends StatelessWidget {
  final List<String> trilhos;
  final List<Anime> animes;
  const HomeAba({super.key, required this.trilhos, required this.animes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: trilhos.length,
      itemBuilder: (context, index) {
        String trilhoNome = trilhos[index];
        var listaNoTrilho = animes.where((a) => a.genero == trilhoNome).toList();
        if (listaNoTrilho.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(width: 4, height: 20, color: Colors.deepPurpleAccent),
                  const SizedBox(width: 8),
                  Text(trilhoNome, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16),
                itemCount: listaNoTrilho.length,
                itemBuilder: (context, i) => GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetalheAnimeAba(anime: listaNoTrilho[i]))),
                  child: Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
                    child: Center(child: Text(listaNoTrilho[i].nome, textAlign: TextAlign.center)),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// --- ABA: PESQUISA (LISTA VERTICAL IGUAL PRINT) ---
class PesquisaAba extends StatelessWidget {
  final List<Anime> animes;
  const PesquisaAba({super.key, required this.animes});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Pesquisar animes...",
              prefixIcon: const Icon(Icons.search, color: Colors.deepPurpleAccent),
              filled: true,
              fillColor: Colors.white10,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: animes.length,
            itemBuilder: (context, i) => ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetalheAnimeAba(anime: animes[i]))),
              leading: Container(width: 70, height: 100, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(4))),
              title: Text(animes[i].nome, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(animes[i].sinopse, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(4)), child: Text(animes[i].idioma, style: const TextStyle(fontSize: 10))),
                      const SizedBox(width: 5),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(4)), child: Text(animes[i].tipo, style: const TextStyle(fontSize: 10))),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// --- ABA: BIBLIOTECA (FILTROS HYDRA) ---
class BibliotecaAba extends StatelessWidget {
  final List<Anime> animes;
  const BibliotecaAba({super.key, required this.animes});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(children: [const Text("TV", style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)), Container(height: 2, width: 30, color: Colors.deepPurpleAccent)]),
              const Text("Filmes", style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: ["Gênero", "Status", "Idioma"].map((f) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Chip(label: Text(f), backgroundColor: Colors.white10, side: BorderSide.none),
            )).toList(),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.7, mainAxisSpacing: 10, crossAxisSpacing: 10),
            itemCount: animes.length,
            itemBuilder: (context, i) => GestureDetector(
               onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetalheAnimeAba(anime: animes[i]))),
               child: Container(
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
                child: Center(child: Text(animes[i].nome, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10))),
              ),
            ),
          ),
        ),
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
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              const CircleAvatar(radius: 30, backgroundColor: Colors.deepPurpleAccent, child: Icon(Icons.person, color: Colors.white)),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Carlos Andre", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Nível: $cargo", style: const TextStyle(color: Colors.deepPurpleAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: Colors.green.shade700, borderRadius: BorderRadius.circular(10)),
          child: const Row(
            children: [
              Icon(Icons.bug_report, color: Colors.white),
              SizedBox(width: 10),
              Text("Relatar bugs ou sugestões", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const ListTile(leading: Icon(Icons.shuffle), title: Text("Reprodução Aleatória"), trailing: Icon(Icons.arrow_forward_ios, size: 14)),
        const ListTile(leading: Icon(Icons.download), title: Text("Configurações de Download"), trailing: Icon(Icons.arrow_forward_ios, size: 14)),
        const ListTile(leading: Icon(Icons.wallpaper), title: Text("Wallpapers"), trailing: Icon(Icons.arrow_forward_ios, size: 14)),
        const ListTile(leading: Icon(Icons.share), title: Text("Compartilhar App"), trailing: Icon(Icons.arrow_forward_ios, size: 14)),
        const ListTile(leading: Icon(Icons.logout, color: Colors.redAccent), title: Text("Sair", style: TextStyle(color: Colors.redAccent))),
      ],
    );
  }
}

// --- PÁGINA: DETALHE DO ANIME (SINOPSE + EPISÓDIOS) ---
class DetalheAnimeAba extends StatelessWidget {
  final Anime anime;
  const DetalheAnimeAba({super.key, required this.anime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(anime.nome)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(height: 220, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)), child: const Center(child: Icon(Icons.image, size: 80, color: Colors.white24))),
          const SizedBox(height: 20),
          const Text("SINOPSE", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          Text(anime.sinopse, style: const TextStyle(height: 1.5, color: Colors.white70)),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("EPISÓDIOS", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent)),
              Text("${anime.episodios.length} Episódios", style: const TextStyle(fontSize: 12, color: Colors.white54)),
            ],
          ),
          const SizedBox(height: 15),
          ...anime.episodios.map((ep) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              leading: const Icon(Icons.play_circle_fill, color: Colors.deepPurpleAccent),
              title: Text(ep, style: const TextStyle(fontSize: 14)),
              onTap: () {},
            ),
          )).toList(),
        ],
      ),
    );
  }
}

// --- ABA: AGENDA ---
class AgendaAba extends StatelessWidget {
  final List<Anime> animes;
  const AgendaAba({super.key, required this.animes});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Row(
            children: ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"].map((dia) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: ChoiceChip(
                label: Text(dia), 
                selected: dia == "Qua", 
                selectedColor: Colors.deepPurpleAccent,
                backgroundColor: Colors.white10,
                onSelected: (val) {},
              ),
            )).toList(),
          ),
        ),
        const Expanded(child: Center(child: Text("Lançamentos de hoje aparecerão aqui"))),
      ],
    );
  }
}

// --- PÁGINA: PAINEL ADMINISTRADOR (PÁGINA INTEIRA) ---
class PainelAdmAba extends StatelessWidget {
  final String cargo;
  const PainelAdmAba({super.key, required this.cargo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Painel do Administrador")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text("Controle de Hierarquia ($cargo)", style: const TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          if (cargo == "Geral") 
            const ListTile(leading: Icon(Icons.verified_user), title: Text("Aprovar Promoções de Vice"), trailing: Icon(Icons.notifications_active, color: Colors.orange)),
          
          const Divider(height: 40),
          const Text("Gerenciamento de Conteúdo", style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
          const ListTile(leading: Icon(Icons.create_new_folder), title: Text("Criar e Nomear Trilhos")),
          const ListTile(leading: Icon(Icons.add_circle), title: Text("Adicionar Anime e Descrição")),
          const ListTile(leading: Icon(Icons.edit), title: Text("Editar Sinopse de Anime")),
          
          const Divider(height: 40),
          const Text("Comunidade e Suporte", style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
          const ListTile(leading: Icon(Icons.people), title: Text("Gerenciar Usuários")),
          const ListTile(leading: Icon(Icons.chat_bubble), title: Text("Ver Sugestões e Bugs")),
        ],
      ),
    );
  }
}


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
  
  // LOGICA DE CARGOS: 'Geral', 'Vice', 'Sub' ou 'Usuario'
  String meuCargo = 'Geral'; 
  String meuNick = 'Carlos Andre';

  // SIMULAÇÃO DO BANCO DE DADOS (O que você vai gerenciar no Painel)
  final List<Map<String, dynamic>> catalogo = [
    {"nome": "Solo Leveling", "genero": "Isekai", "tag": "EP 12", "status": "Em andamento", "dia": "Sábado"},
    {"nome": "Artes das Sombras", "genero": "Xianxia", "tag": "DUB", "status": "Em andamento", "dia": "Quarta"},
    {"nome": "Re:Zero", "genero": "Isekai", "tag": "LEG", "status": "Em andamento", "dia": "Quarta"},
  ];

  // ABRIR PAINEL ADM (O SEGREDO)
  void _abrirPainelAdm() {
    if (meuCargo == 'Usuario') return; // Usuário comum não vê nada
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("PAINEL $meuCargo", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent)),
            const Divider(color: Colors.white24),
            ListTile(leading: const Icon(Icons.people), title: const Text("Gerenciar Usuários")),
            ListTile(leading: const Icon(Icons.video_collection), title: const Text("Adicionar/Marcar Gêneros")),
            ListTile(leading: const Icon(Icons.support_agent), title: const Text("Tickets de Suporte")),
          ],
        ),
      ),
    );
  }

  // WIDGET DOS TRILHOS DA HOME
  Widget _buildTrilho(String titulo) {
    var listaFiltrada = catalogo.where((a) => a['genero'] == titulo).toList();
    if (listaFiltrada.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(titulo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16),
            itemCount: listaFiltrada.length,
            itemBuilder: (ctx, i) => Container(
              width: 120,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
              child: Center(child: Text(listaFiltrada[i]['nome'], textAlign: TextAlign.center)),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        centerTitle: true,
        title: GestureDetector(
          onTap: _abrirPainelAdm, // O BOTÃO SECRETO ESTÁ AQUI
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
      body: _selectedIndex == 0 
        ? ListView(children: [ _buildTrilho("Xianxia"), _buildTrilho("Isekai"), _buildTrilho("Ação") ])
        : const Center(child: Text("Próximas abas sendo carregadas...")),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0D0D0D),
        selectedItemColor: Colors.deepPurpleAccent,
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


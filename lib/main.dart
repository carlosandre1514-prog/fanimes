import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FanimesApp());
}

const Color roxoAura = Color(0xFF673AB7);
const Color pretoEletrico = Color(0xFF0D0D0D);

class FanimesApp extends StatelessWidget {
  const FanimesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: roxoAura,
        scaffoldBackgroundColor: pretoEletrico,
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
  User? user;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((u) => setState(() => user = u));
  }

  @override
  Widget build(BuildContext context) {
    // LEI MÁXIMA: Identificação do ADM Geral pelo E-mail
    bool isAdmGeral = user?.email == "carlosandre.ad1514@gmail.com";

    final List<Widget> telas = [
      const Center(child: Text("Home - Trilhos de Animes")),
      const Center(child: Text("Biblioteca - Gêneros")),
      const Center(child: Text("Busca de Animes")),
      const Center(child: Text("Agenda de Lançamentos")),
      PerfilAba(user: user, isAdm: isAdmGeral),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: pretoEletrico,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chat_bubble_outline, color: roxoAura),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatComunidade())),
        ),
        // BOTÃO SECRETO NO NOME DO APP
        title: GestureDetector(
          onTap: () {
            if (isAdmGeral) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PainelAdmAba()));
            }
          },
          child: const Text("FÃNIMES", style: TextStyle(color: roxoAura, fontWeight: FontWeight.bold, letterSpacing: 3)),
        ),
        centerTitle: true,
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

// --- CHAT COM CORREÇÃO DE POSICIONAMENTO ---
class ChatComunidade extends StatefulWidget {
  const ChatComunidade({super.key});
  @override
  State<ChatComunidade> createState() => _ChatComunidadeState();
}

class _ChatComunidadeState extends State<ChatComunidade> {
  final _msgCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Comunidade")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('chat').orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                var docs = snapshot.data!.docs;
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    bool isMe = docs[i]['user'] == FirebaseAuth.instance.currentUser?.email;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? roxoAura : Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(docs[i]['msg'] ?? '', style: const TextStyle(color: Colors.white)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // BARRA DE DIGITAÇÃO AJUSTADA PARA SAMSUNG
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 10, left: 10, right: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    decoration: InputDecoration(
                      hintText: "Digite aqui...",
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: roxoAura,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      if (_msgCtrl.text.isNotEmpty) {
                        FirebaseFirestore.instance.collection('chat').add({
                          'user': FirebaseAuth.instance.currentUser?.email ?? 'Anônimo',
                          'msg': _msgCtrl.text,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                        _msgCtrl.clear();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- ABA PERFIL COM TODOS OS ITENS ---
class PerfilAba extends StatelessWidget {
  final User? user;
  final bool isAdm;
  const PerfilAba({super.key, this.user, required this.isAdm});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Center(child: CircleAvatar(radius: 55, backgroundColor: Colors.white10, child: Icon(Icons.person, color: roxoAura, size: 50))),
        const SizedBox(height: 12),
        Center(child: Text(user?.email ?? "Visitante", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        Center(child: Text(isAdm ? "ADM Geral" : "Membro", style: const TextStyle(color: roxoAura))),
        const Divider(height: 50, color: Colors.white24),
        
        ListTile(leading: const Icon(Icons.bug_report, color: roxoAura), title: const Text("Relatar Problema"), onTap: () {}),
        ListTile(leading: const Icon(Icons.support_agent, color: roxoAura), title: const Text("Suporte ao Usuário"), onTap: () {}),
        ListTile(leading: const Icon(Icons.lightbulb_outline, color: roxoAura), title: const Text("Enviar Sugestão"), onTap: () {}),
        ListTile(leading: const Icon(Icons.wallpaper), title: const Text("Papéis de Parede"), onTap: () {}),
        
        if (user != null) 
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent), 
            title: const Text("Sair da Conta"), 
            onTap: () => FirebaseAuth.instance.signOut()
          ),
        
        if (user == null)
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: roxoAura),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthPage())),
            child: const Text("FAZER LOGIN"),
          ),
      ],
    );
  }
}

// --- TELA DE LOGIN ---
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _e = TextEditingController();
  final _s = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Acesso")),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(children: [
          TextField(controller: _e, decoration: const InputDecoration(labelText: "E-mail")),
          TextField(controller: _s, decoration: const InputDecoration(labelText: "Senha"), obscureText: true),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: roxoAura, minimumSize: const Size(double.infinity, 50)),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(email: _e.text, password: _s.text);
                Navigator.pop(context);
              } catch (e) {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _e.text, password: _s.text);
                Navigator.pop(context);
              }
            },
            child: const Text("ENTRAR / CADASTRAR"),
          )
        ]),
      ),
    );
  }
}

// --- PAINEL DE ADM (ACESSÍVEL PELO NOME SECRETO) ---
class PainelAdmAba extends StatelessWidget {
  const PainelAdmAba({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Painel Administrativo")),
      body: const Center(child: Text("Olá, Carlos! O controle total está aqui.")),
    );
  }
}


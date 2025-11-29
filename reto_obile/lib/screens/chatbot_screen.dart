import 'package:flutter/material.dart';
import '../widgets/AppHeader.dart';
import '../widgets/SideMenu.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _mensajeController = TextEditingController();
  bool _loading = false;
  String? _respuesta;

  void handleSend() async {
    if (_mensajeController.text.isEmpty) return;

    setState(() {
      _loading = true;
      _respuesta = null;
    });

    await Future.delayed(const Duration(seconds: 1)); // Simula respuesta del bot

    setState(() {
      _respuesta = "Bot dice: ${_mensajeController.text}";
      _mensajeController.clear();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      drawer: const SideMenu(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF0f172a), Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header con menú
                AppHeader(
                  title: "Agente de IA",
                  onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                const SizedBox(height: 24),

                // Card de chat
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _mensajeController,
                        maxLines: 3,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Escribe tu mensaje...",
                          hintStyle: TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.white10,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.red.withOpacity(0.3)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : handleSend,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _loading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  "Enviar",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                      if (_respuesta != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            _respuesta!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

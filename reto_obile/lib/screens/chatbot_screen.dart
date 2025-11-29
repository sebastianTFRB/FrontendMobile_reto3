import 'package:flutter/material.dart';
import '../widgets/AppHeader.dart';
import '../widgets/SideMenu.dart';
import '../services/lead_agent_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _mensajeController = TextEditingController();
  final LeadAgentService _chatService = LeadAgentService();
  final ScrollController _scrollController = ScrollController();

  bool _loading = false;
  List<ChatMessage> messages = [];

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void handleSend() async {
    final userMsg = _mensajeController.text.trim();
    if (userMsg.isEmpty) return;

    setState(() {
      messages.add(ChatMessage(text: userMsg, isUser: true));
      _loading = true;
    });

    _mensajeController.clear();
    _scrollToBottom();

    try {
      // 🔥 Ahora sí llama a tu API real
      final botReply = await _chatService.sendMessage(userMsg);

      setState(() {
        messages.add(ChatMessage(text: botReply, isUser: false));
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        messages.add(ChatMessage(text: "⚠️ Error: $e", isUser: false));
      });
    }

    setState(() => _loading = false);
  }

  Widget _buildBubble(ChatMessage msg) {
    final alignment =
        msg.isUser ? Alignment.centerRight : Alignment.centerLeft;

    final bgColor = msg.isUser ? Colors.red : Colors.white10;
    final txtColor = Colors.white;

    return Align(
      alignment: alignment,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: Colors.red.withOpacity(msg.isUser ? 0.4 : 0.2)),
        ),
        child: Text(msg.text, style: TextStyle(color: txtColor)),
      ),
    );
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
                AppHeader(
                  title: "Agente de IA",
                  onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                const SizedBox(height: 24),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: messages.length,
                            itemBuilder: (_, i) {
                              return _buildBubble(messages[i]);
                            },
                          ),
                        ),

                        const SizedBox(height: 12),

                        TextField(
                          controller: _mensajeController,
                          maxLines: 2,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Escribe un mensaje...",
                            hintStyle: TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.white10,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Colors.red.withOpacity(0.3)),
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
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    "Enviar",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ],
                    ),
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

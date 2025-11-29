import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class LeadAgentService {
  static final LeadAgentService _instance = LeadAgentService._internal();
  factory LeadAgentService() => _instance;

  LeadAgentService._internal();

  /// Ruta correcta según tu API FastAPI
  final String apiUrl = "http://10.0.2.2:8000/api/chatbot/";

  final uuid = const Uuid();

  String? _contactKey;

  Future<String> getContactKey() async {
    if (_contactKey != null) return _contactKey!;
    _contactKey = uuid.v4();
    return _contactKey!;
  }

  /// Llama al chatbot conversacional de tu backend
  Future<String> sendMessage(String message) async {
    final contactKey = await getContactKey();

    final body = {
      "contact_key": contactKey,
      "message": message,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        /// 👇 Esto cambia, porque el backend devuelve más cosas
        return data["reply"] ?? "Sin respuesta del agente.";
      } else {
        return "⚠️ Error del servidor: ${response.statusCode}";
      }
    } catch (e) {
      return "❌ Error de conexión: $e";
    }
  }
}

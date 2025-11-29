import 'package:flutter/material.dart';
import '../services/lead_service.dart';
import '../models/lead_model.dart';
import '../widgets/BlurCircle.dart';
import '../widgets/AppHeader.dart';


class LeadDetailScreen extends StatefulWidget {
  final int leadId;
  const LeadDetailScreen({required this.leadId});

  @override
  _LeadDetailScreenState createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen> {
  final LeadService service = LeadService();
  Lead? lead;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadLead();
  }

  Future<void> loadLead() async {
    final data = await service.getLeadById(widget.leadId);
    setState(() {
      lead = data;
      loading = false;
    });
  }

  Widget info(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text("$label: ${value ?? '—'}", style: const TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo gradiente
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Color(0xFF0f172a), Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Círculos difuminados
          const BlurCircle(width: 240, height: 240, color: Color.fromRGBO(255,0,0,0.15), top: -120, left: -80),
          const BlurCircle(width: 180, height: 180, color: Color.fromRGBO(255,255,255,0.08), top: 300, left: 150),
          // Contenido
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppHeader(title: "Detalle del Lead", onMenuTap: () {}),
                  const SizedBox(height: 20),
                  loading
                      ? const Center(child: CircularProgressIndicator())
                      : Expanded(
                          child: ListView(
                            children: [
                              info("Nombre", lead?.fullName),
                              info("Email", lead?.email),
                              info("Teléfono", lead?.phone),
                              info("Zona", lead?.preferredArea),
                              info("Presupuesto", lead?.budget?.toString()),
                              info("Urgencia", lead?.urgency),
                              info("Categoría", lead?.category),
                              info("Score", lead?.intentScore?.toString()),
                              info("Notas", lead?.notes),
                              info("Estado", lead?.status),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

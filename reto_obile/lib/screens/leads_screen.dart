import 'package:flutter/material.dart';
import '../services/lead_service.dart';
import '../models/lead_model.dart';
import 'lead_detail_screen.dart';
import '../widgets/BlurCircle.dart'; // Widget de círculos difuminados
import '../widgets/AppHeader.dart';
import '../widgets/FeatureCard.dart';

class LeadListScreen extends StatefulWidget {
  @override
  _LeadListScreenState createState() => _LeadListScreenState();
}

class _LeadListScreenState extends State<LeadListScreen> {
  final LeadService leadService = LeadService();
  List<Lead> leads = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadLeads();
  }

  Future<void> _loadLeads() async {
    final data = await leadService.getLeads();
    setState(() {
      leads = data;
      loading = false;
    });
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
          const BlurCircle(width: 240, height: 240, color: Color.fromRGBO(255,0,0,0.15), top: 500, left: 200),
          // Contenido
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppHeader(title: "Leads", onMenuTap: () {}), // Puedes agregar drawer si quieres
                  const SizedBox(height: 20),
                  loading
                      ? const Center(child: CircularProgressIndicator())
                      : Expanded(
                          child: ListView.builder(
                            itemCount: leads.length,
                            itemBuilder: (context, index) {
                              final lead = leads[index];
                              return FeatureCard(
                                title: lead.fullName ?? "Sin nombre",
                                desc: "Categoría: ${lead.category ?? 'N/A'}",
                                icon: Icons.person,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LeadDetailScreen(leadId: lead.id),
                                    ),
                                  );
                                },
                              );
                            },
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

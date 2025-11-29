import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/SideMenu.dart';
import '../widgets/AppHeader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SideMenu(),
      body: Stack(
        children: [
          // Fondo gradiente
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.black, Color(0xFF0f172a), Colors.black],
              ),
            ),
          ),

          // Círculos difuminados
          Positioned(
            top: -120,
            left: -80,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -100,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            right: MediaQuery.of(context).size.width * 0.25,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Contenido
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    AppHeader(
                      title: "Full House Lead Agent",
                      onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                    const SizedBox(height: 20),

                    // Título resumido
                    const Text(
                      "Encuentra y prioriza leads inmobiliarios con IA",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Clasifica automáticamente los leads en A/B/C y sugiere acciones.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Cards de características uno debajo de otro
                    _featureCard(
                      title: 'Clasifica A/B/C',
                      desc: 'Intención y urgencia',
                      icon: Icons.auto_graph,
                    ),
                    const SizedBox(height: 12),
                    _featureCard(
                      title: 'Propiedades curadas',
                      desc: 'Precios y datos confiables',
                      icon: Icons.shield,
                    ),
                    const SizedBox(height: 12),
                    _featureCard(
                      title: 'Network effect',
                      desc: 'Más inmobiliarias = mejor modelo',
                      icon: Icons.smart_toy,
                    ),
                    const SizedBox(height: 24),

                    // Card de métricas
                    _metricsCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureCard({required String title, required String desc, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.redAccent, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          _metricRow("Leads clasificados", "148"),
          _metricRow("Distribución A/B/C", "46 / 62 / 40", valueColor: Colors.redAccent),
          _metricRow("Eficiencia del agente", "82%", valueColor: Colors.greenAccent),
          _metricRow("Tiempo ahorrado", "3m17s"),
        ],
      ),
    );
  }

  Widget _metricRow(String label, String value, {Color valueColor = Colors.white}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

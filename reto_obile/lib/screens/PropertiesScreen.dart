import 'package:flutter/material.dart';
import 'package:reto_obile/models/propiety_model.dart';
import 'package:reto_obile/services/propety_service.dart';
import '../widgets/BlurCircle.dart';
import '../widgets/AppHeader.dart';
import '../widgets/SideMenu.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({Key? key}) : super(key: key);

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  late Future<List<Property>> _propertiesFuture;
  final propertyService = PropertyService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _propertiesFuture = propertyService.getAllProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SideMenu(), // ✅ Aquí usamos tu widget SideMenu
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
          const BlurCircle(width: 180, height: 180, color: Color.fromRGBO(255,255,255,0.08), top: 200, left: 100),

          // Contenido principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppHeader(
                    title: "Propiedades",
                    onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: FutureBuilder<List<Property>>(
                      future: _propertiesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: Colors.red));
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          );
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text(
                              'No hay propiedades',
                              style: TextStyle(color: Colors.white70),
                            ),
                          );
                        }

                        final properties = snapshot.data!;
                        return ListView.builder(
                          itemCount: properties.length,
                          itemBuilder: (context, index) {
                            final property = properties[index];
                            return _propertyCard(property);
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

  Widget _propertyCard(Property property) {
    return GestureDetector(
      onTap: () {
        // Aquí puedes navegar al detalle de la propiedad
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              property.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              property.location ?? '',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${property.price.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${property.bedrooms} hab. • ${property.bathrooms} baños',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:reto_obile/screens/home_screen.dart';
import 'package:reto_obile/screens/posts_screen.dart';
import '../screens/chatbot_screen.dart';
import '../screens/stats_screen.dart';
import '../screens/new_post_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black.withOpacity(0.9),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFf87171), Color(0xFFb91c1c)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              "Menú",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          _drawerItem(
            context,
            icon: Icons.home,
            title: "home",
            screen: const HomeScreen(),
          ),
          _drawerItem(
            context,
            icon: Icons.chat,
            title: "Chatbot",
            screen: const ChatbotScreen(),
          ),
          _drawerItem(
            context,
            icon: Icons.chat,
            title: "My Posts",
            screen: const PostsScreen(),
          ),
          _drawerItem(
            context,
            icon: Icons.bar_chart,
            title: "Estadísticas",
            screen: const StatsScreen(),
          ),
          _drawerItem(
            context,
            icon: Icons.add_box,
            title: "Crear Publicación",
            screen: const NewPostScreen(),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context,
      {required IconData icon, required String title, required Widget screen}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context); // Cierra el drawer
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:reto_obile/screens/home_screen.dart';
import '../widgets/login/logaut/custom_input.dart';
import '../widgets/login/logaut/custom_button.dart';
import 'register_screen.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  bool showPassword = false;
  String? feedback;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con gradiente + círculos difuminados
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.black, Color(0xFF0f172a), Colors.black],
              ),
            ),
          ),
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Card principal
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.shade900.withOpacity(0.8),
                      Colors.black.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [Color(0xFFf87171), Color(0xFFb91c1c)]),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 8,
                                  offset: Offset(2, 2),
                                )
                              ],
                              border: Border.all(color: Colors.red.shade500),
                            ),
                            child: const Icon(Icons.home, color: Colors.white, size: 32),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "FULL HOUSE",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Real Estate Lead Qualification",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 12, letterSpacing: 1.5),
                      ),
                      const SizedBox(height: 24),

                      // Feedback de error
                      if (feedback != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            border: Border.all(color: Colors.amber.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning, color: Colors.amber, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  feedback!,
                                  style: const TextStyle(color: Colors.amber),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Inputs
                      CustomInput(
                        label: "Correo",
                        controller: emailCtrl,
                        icon: Icons.mail,
                      ),
                      const SizedBox(height: 16),
                      CustomInput(
                        label: "Contraseña",
                        controller: passCtrl,
                        obscure: !showPassword,
                        icon: Icons.lock,
                        suffixIcon: IconButton(
                          icon: Icon(
                            showPassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.red.shade500,
                          ),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Botón Login
                      CustomButton(
                        text: loading ? "Ingresando..." : "Ingresar",
                        gradient: const LinearGradient(
                          colors: [Color(0xFFf87171), Color(0xFFb91c1c)],
                        ),
                        onPressed: () {
                          if (loading) return;
                          _handleLogin();
                        },
                      ),
                      const SizedBox(height: 16),

                      // Texto registro
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("¿No tienes cuenta? ", style: TextStyle(color: Colors.grey)),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const RegisterScreen()),
                              );
                            },
                            child: Text(
                              "Regístrate",
                              style: TextStyle(
                                color: Colors.red.shade500,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    setState(() {
      feedback = null;
      loading = true;
    });

    final auth = AuthService();

    try {
      final token = await auth.login(
        emailCtrl.text.trim(),
        passCtrl.text,
      );

      // Guardar role y agency_id para uso global
      final prefs = await SharedPreferences.getInstance();
      final role = prefs.getString('role') ?? '';
      final agencyId = prefs.getInt('agency_id');

      print('Usuario rol: $role');
      print('Usuario agency_id: $agencyId');

      // Login exitoso → navegar a pantalla principal
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      setState(() {
        feedback = e is ApiError ? e.message : "Error desconocido";
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/login/logaut/custom_input.dart';
import '../widgets/login/logaut/custom_button.dart';
import 'login_screen.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final TextEditingController confirmPassCtrl = TextEditingController();

  bool showPassword = false;
  String? feedback;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                      CustomInput(
                        label: "Nombre",
                        controller: nameCtrl,
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
                      CustomInput(
                        label: "Confirmar Contraseña",
                        controller: confirmPassCtrl,
                        obscure: !showPassword,
                        icon: Icons.lock,
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: loading ? "Creando..." : "Crear Cuenta",
                        gradient: const LinearGradient(
                          colors: [Color(0xFFf87171), Color(0xFFb91c1c)],
                        ),
                        onPressed: () {
                          if (loading) return;
                          _handleRegister();
                        },
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Tu cuenta será creada como administrador de agencia",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("¿Ya tienes cuenta? ", style: TextStyle(color: Colors.grey)),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                              );
                            },
                            child: Text(
                              "Inicia sesión",
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

  Future<void> _handleRegister() async {
    if (passCtrl.text != confirmPassCtrl.text) {
      setState(() {
        feedback = "Las contraseñas no coinciden";
      });
      return;
    }

    setState(() {
      feedback = null;
      loading = true;
    });

    try {
      final auth = AuthService();
      final user = await auth.register(
        emailCtrl.text.trim(),
        passCtrl.text,
        nameCtrl.text.trim(),
      );

      setState(() {
        feedback = "Cuenta creada. Redirigiendo a login...";
        loading = false;
      });

      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (e, st) {
      setState(() {
        loading = false;
        feedback = e is ApiError ? e.message : "Error al registrar";
      });
      print("Error en registro: $e");
      print("Stacktrace: $st");
    }
  }
}

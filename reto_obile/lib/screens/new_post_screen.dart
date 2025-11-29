import 'dart:io';
import 'package:flutter/material.dart';
import 'package:reto_obile/widgets/login/logaut/custom_input.dart';
import 'package:reto_obile/widgets/login/logaut/post_image_picker.dart';
import '../widgets/AppHeader.dart';
import '../widgets/SideMenu.dart';
import '../services/post_service.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();
  File? selectedImage;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PostService _postService = PostService();

  bool _loading = false;

  void _handlePublish() async {
    if (titleCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("El título es obligatorio")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      // Crear lista de archivos para enviar
      final photos = <File>[selectedImage!];
      final videos = <File>[]; // Si quieres agregar videos, implementa otro picker

      await _postService.createPost(
        title: titleCtrl.text,
        description: descCtrl.text,
        photos: photos,
        videos: videos,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Publicación enviada correctamente")),
      );

      // Limpiar formulario
      titleCtrl.clear();
      descCtrl.clear();
      setState(() => selectedImage = null);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al publicar: $e")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                // Header con menú hamburguesa
                AppHeader(
                  title: "Nueva Publicación",
                  onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                const SizedBox(height: 24),

                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
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
                          // Selector de imagen
                          PostImagePicker(
                            onImageSelected: (img) {
                              setState(() => selectedImage = img);
                            },
                          ),
                          const SizedBox(height: 20),

                          // Inputs de título y descripción
                          CustomInput(label: "Título", controller: titleCtrl),
                          const SizedBox(height: 16),
                          CustomInput(label: "Descripción", controller: descCtrl),
                          const SizedBox(height: 20),

                          // Botón publicar
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _handlePublish,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _loading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                      "Publicar",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
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

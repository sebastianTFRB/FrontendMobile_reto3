import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PostImagePicker extends StatefulWidget {
  final Function(File?) onImageSelected;

  const PostImagePicker({super.key, required this.onImageSelected});

  @override
  State<PostImagePicker> createState() => _PostImagePickerState();
}

class _PostImagePickerState extends State<PostImagePicker> {
  File? imageFile;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() => imageFile = File(picked.path));
      widget.onImageSelected(imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        imageFile == null
            ? Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 70),
              )
            : Image.file(imageFile!, height: 150),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: pickImage,
          child: const Text("Seleccionar Imagen"),
        )
      ],
    );
  }
}

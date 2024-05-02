import 'dart:io';

import 'package:estetica_app/src/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef OnImageSelected = Function(File imageFile);

// ignore: must_be_immutable
class ImagePickerWidget extends StatelessWidget {
  final String? imagePath;
  final OnImageSelected onImageSelected;

  const ImagePickerWidget({
    super.key,
    this.imagePath,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      width: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(105),
        border: Border.all(
          color: AppColors.primaryColor,
          width: 4,
        ),
        gradient: const RadialGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColorLight,
          ],
        ),
        image: imagePath != null
            ? imagePath!.startsWith('http')
                ? DecorationImage(
                    image: Image.network(imagePath!).image, fit: BoxFit.cover)
                : DecorationImage(
                    image: FileImage(File(imagePath!)),
                    fit: BoxFit.cover,
                  )
            : null,
      ),
      child: IconButton(
        icon: const Icon(
          Icons.camera_alt,
          size: 30,
          color: Colors.white,
        ),
        onPressed: () {
          _showPickerOption(context);
        },
      ),
    );
  }

  void _showPickerOption(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Tomar una foto'),
              onTap: () {
                Navigator.pop(context);
                _showPickeImage(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Seleccionar una foto de la galería'),
              onTap: () {
                Navigator.pop(context);
                _showPickeImage(context, ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  void _showPickeImage(BuildContext context, source) async {
    var image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      onImageSelected(File(image.path));
    }
  }
}

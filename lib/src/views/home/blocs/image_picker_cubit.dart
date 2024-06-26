import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

class ImagePickerCubit extends Cubit<String> {
  File? imageFile;

  ImagePickerCubit() : super('');

  void setImageFile(File image) {
    imageFile = image;
    emit(imageFile!.path);
  }

  void removeImage() {
    imageFile = null;
    emit('');
  }
}

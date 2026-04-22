import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageService {
  static final picker = ImagePicker();

  static Future<File?> pickCamera() async {
    final file = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (file == null) return null;

    return crop(File(file.path));
  }

  static Future<File?> pickGallery() async {
    final file = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (file == null) return null;

    return crop(File(file.path));
  }

  static Future<File?> crop(File file) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: file.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.original,
          ],
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.original,
          ],
        ),
      ],
    );

    if (cropped == null) return null;

    return File(cropped.path);
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ComposeBottomIconWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final Function(File) onImageIconSelcted;
  const ComposeBottomIconWidget(
      {Key? key,
      required this.textEditingController,
      required this.onImageIconSelcted})
      : super(key: key);

  @override
  _ComposeBottomIconWidgetState createState() =>
      _ComposeBottomIconWidgetState();
}

class _ComposeBottomIconWidgetState extends State<ComposeBottomIconWidget> {
  bool reachToWarning = false;
  bool reachToOver = false;
  late Color wordCountColor;
  String post = '';

  @override
  void initState() {
    wordCountColor = Colors.blue;
    super.initState();
  }

  Widget _bottomIconWidget() {
    return IconButton(
        onPressed: () {
          setImage(ImageSource.gallery);
        },
        icon: Icon(
          Iconsax.picture_frame,
          size: 30,
          color: Colors.white,
        ));
  }

  Future<void> setImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: source, imageQuality: 100);

    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ],
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          widget.onImageIconSelcted(File(croppedFile.path));
        });
      } else {
        print("Image cropping was cancelled or failed.");
      }
    } else {
      print("Image picking was cancelled or failed.");
    }
  }

  double getPostLimit() {
    if (/*post == null || */ post.isEmpty) {
      return 0.0;
    }
    if (post.length > 500) {
      return 1.0;
    }
    var length = post.length;
    var val = length * 100 / 28000.0;
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _bottomIconWidget(),
    );
  }
}

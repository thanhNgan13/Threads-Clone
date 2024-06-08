import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_exercises/providers/UserProvider.dart';
import 'package:final_exercises/screens/notification/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:image_cropper/image_cropper.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _displayNameController = TextEditingController();
  late TextEditingController _bioController = TextEditingController();
  late TextEditingController _linkController = TextEditingController();

  bool _isNameEdited = false;
  bool _isBioEdited = false;
  bool _isPhotoEdited = false;
  bool _isLoading = false;

  File? _image;

  @override
  void initState() {
    UserProvider state = Provider.of<UserProvider>(context, listen: false);

    _displayNameController.text = state.currentUser?.username ?? '';
    _bioController.text = state.currentUser?.biography ?? '';

    _displayNameController.addListener(() {
      setState(() {
        _isNameEdited =
            _displayNameController.text != (state.currentUser?.username ?? '');
      });
    });
    _bioController.addListener(() {
      setState(() {
        _isBioEdited =
            _bioController.text != (state.currentUser?.biography ?? '');
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _bioController.dispose();
    _linkController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> getImage(BuildContext context, ImageSource source,
      Function(File) onImageSelected) async {
    ImagePicker()
        .pickImage(source: source, imageQuality: 100)
        .then((XFile? file) async {
      await ImageCropper.platform.cropImage(
        sourcePath: file!.path,
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
      ).then((value) => setState(() {
            onImageSelected(File(value!.path));
          }));
    });
  }

  Future<void> _submitButton() async {
    if (_displayNameController.text.length > 100) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        backgroundColor: Colors.white,
        content: Container(
            alignment: Alignment.center,
            height: 30,
            child: Text(
              'Max Len: 100 char',
              style: TextStyle(
                  fontFamily: "icons.ttf",
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w900),
            )),
      ));
      return;
    }
    if (_bioController.text.length > 100) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        backgroundColor: Colors.white,
        content: Container(
            alignment: Alignment.center,
            height: 30,
            child: Text(
              'Max Len: 100 char',
              style: TextStyle(
                  fontFamily: "icons.ttf",
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w900),
            )),
      ));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    var state = Provider.of<UserProvider>(context, listen: false);
    var model = state.currentUser!.copyWith(
      name: _displayNameController.text,
      biography: _bioController.text,
    );

    try {
      if (_isPhotoEdited) {
        await state.updateUserProfile(
          model,
          image: _image,
        );
      } else {
        await state.updateUserProfile(
          model,
        );
      }

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        backgroundColor: Colors.white,
        content: Container(
            alignment: Alignment.center,
            height: 30,
            child: Text(
              'Failed to update profile. Please try again.',
              style: TextStyle(
                  fontFamily: "icons.ttf",
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w900),
            )),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Bỏ nút back mặc định

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: EdgeInsets.only(left: 15, top: 5),
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400)))),
            Text(
              "Edit profile",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: GestureDetector(
                  onTap: (_isNameEdited || _isBioEdited || _isPhotoEdited)
                      ? _submitButton
                      : null,
                  child: Text("Done",
                      style: TextStyle(
                          color:
                              (_isNameEdited || _isBioEdited || _isPhotoEdited)
                                  ? Colors.blue
                                  : Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.w600))),
            )
          ],
        ),
        backgroundColor: Color.fromARGB(255, 29, 29, 29),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 300,
                  width: 330,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 25, 25, 25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 10,
                                    ),
                                    Text(
                                      "Name",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                    CupertinoTextField(
                                      controller: _displayNameController,
                                      prefix: Icon(
                                        Icons.lock_outline_rounded,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                      placeholder: state.currentUser!.name,
                                      placeholderStyle: TextStyle(
                                          color: Colors.grey, fontSize: 18),
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    Container(
                                      height: 5,
                                    ),
                                    Container(
                                      width: 300,
                                      height: 0.5,
                                      color: Colors.grey,
                                    ),
                                    Container(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 30,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          CupertinoTheme(
                                            data: CupertinoThemeData(
                                              brightness: Brightness
                                                  .dark, // Définir le mode sombre
                                            ),
                                            child: CupertinoActionSheet(
                                              title: Text(
                                                  'Change your photo profile'),
                                              message: Text(
                                                  'Choose an image or take a photo to set your new photo profile'),
                                              actions: <Widget>[
                                                CupertinoActionSheetAction(
                                                  child:
                                                      Text('Open your gallery'),
                                                  onPressed: () {
                                                    getImage(context,
                                                        ImageSource.gallery,
                                                        (file) {
                                                      setState(() {
                                                        _image = file;
                                                        _isPhotoEdited = true;
                                                      });
                                                    });
                                                    setState(() {});
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                CupertinoActionSheetAction(
                                                  child:
                                                      Text('Take a new photo'),
                                                  onPressed: () {
                                                    getImage(context,
                                                        ImageSource.camera,
                                                        (file) {
                                                      setState(() {
                                                        _image = file;
                                                        _isPhotoEdited = true;
                                                      });
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                              cancelButton:
                                                  CupertinoActionSheetAction(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          ));
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 25,
                                  backgroundImage: (_image != null
                                      ? FileImage(_image!)
                                      : CachedNetworkImageProvider(
                                          scale: 2,
                                          state.currentUser!.profileImageUrl!,
                                        ) as ImageProvider),
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bio",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              ),
                              CupertinoTextField(
                                controller: _bioController,
                                prefix: state.currentUser!.biography!.isEmpty
                                    ? Icon(
                                        Icons.add,
                                        size: 15,
                                        color: Colors.white,
                                      )
                                    : null,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                                placeholder:
                                    state.currentUser!.biography!.isNotEmpty
                                        ? state.currentUser!.biography
                                        : 'Write bio',
                                placeholderStyle:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              Container(
                                height: 10,
                              ),
                              Container(
                                width: 300,
                                height: 0.5,
                                color: Colors.grey,
                              ),
                              Container(
                                height: 20,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Link",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              ),
                              CupertinoTextField(
                                controller: _linkController,
                                prefix: Icon(
                                  Icons.add,
                                  size: 15,
                                  color: Colors.white,
                                ),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                                placeholder: 'Add Link',
                                placeholderStyle:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

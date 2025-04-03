import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarPicker extends StatefulWidget {
  final double radius;
  final String? avatar;
  final Function? onSuccess;

  const AvatarPicker({super.key, required this.radius, this.avatar, this.onSuccess});

  @override
  State<AvatarPicker> createState() => AvatarPickerState();
}

class AvatarPickerState extends State<AvatarPicker> {

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source, BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
      if (widget.onSuccess == null) return;
      widget.onSuccess!(_image);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pickImage(ImageSource.gallery, context);
      },
      child: CircleAvatar(
        radius: widget.radius,
        backgroundImage: _image != null
            ? FileImage(_image!)
            : widget.avatar != null
            ? NetworkImage(widget.avatar!)
            : const AssetImage('assets/images/avatar.jpg'),
        child: _image == null && widget.avatar == null
            ? Icon(Icons.person, size: widget.radius)
            : null,
      ),
    );
  }
}

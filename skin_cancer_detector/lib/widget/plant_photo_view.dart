import 'dart:io';
import 'package:flutter/material.dart';

import '../styles.dart';

class PhotoView extends StatelessWidget {
  final File? file;
  const PhotoView({super.key, this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxHeight:
              file == null ? 70 : MediaQuery.of(context).size.height / 2.5),
      decoration: BoxDecoration(
          border: Border.all(width: file == null ? 0 : 2, color: Colors.black),
          borderRadius: BorderRadius.circular(5)),
      child: (file == null)
          ? _buildEmptyView()
          : Image.file(file!, fit: BoxFit.cover),
    );
  }

  Widget _buildEmptyView() {
    return const Center(
        child: Text(
      'Please pick a photo',
      style: kAnalyzingTextStyle,
    ));
  }
}

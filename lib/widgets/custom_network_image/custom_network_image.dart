import 'dart:io';

import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final File? selectedFile;
  final String? placeHolder;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  const CustomNetworkImage({
    Key? key,
    this.imageUrl,
    this.width = 100,
    this.height = 100,
    this.borderRadius,
    this.selectedFile,
    this.placeHolder,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(10.0),
      child: selectedFile != null ?
          Image.file(
            selectedFile!,
            width: width,
            height: height,
            fit: BoxFit.cover,
          )
          : imageUrl==null || imageUrl!.isEmpty ?  Image.asset(
        placeHolder??'assets/logo/Placeholder_image.webp',
        width: width,
        height: height,
        fit: fit,
      ): FadeInImage.assetNetwork(
        width: width,
        height: height,
        placeholder: placeHolder??'assets/logo/Placeholder_image.webp',
        image: imageUrl!,
        fit: fit,
        imageErrorBuilder: (context, error, stackTrace) {
          return Image.asset(
            placeHolder??'assets/logo/Placeholder_image.webp',
            width: width,
            height: height,
            fit: fit,
          );
        },
      ),
    );
  }
}

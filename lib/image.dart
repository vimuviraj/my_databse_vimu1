import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ImageGet extends StatefulWidget {
  final List<String> images;
  const ImageGet({super.key, required this.images});

  @override
  State<ImageGet> createState() => _ImageGetState();
}

class _ImageGetState extends State<ImageGet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
            height: 200, width: 200, child: Image.network(widget.images.first)),
      ),
    );
  }
}

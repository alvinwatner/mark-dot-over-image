import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_painter/image_painter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class MobileExample extends StatefulWidget {
  const MobileExample({Key? key}) : super(key: key);

  @override
  State<MobileExample> createState() => _MobileExampleState();
}

class _MobileExampleState extends State<MobileExample> {
  final ImagePainterController _controller = ImagePainterController(
    color: Colors.green,
    strokeWidth: 4,
    mode: PaintMode.line,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select From Map"),
        actions: [],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: saveImage,
        child: Text("Mark Location"),
      ),
      body: ImagePainter.network(
        "https://www.spiritoffreedom.com.au/wp-content/uploads/2022/03/Main-Deck-B-1024x354.png",
        onMarked: (isMarked) {
          log("image is marked = $isMarked");
        },
        controller: _controller,
        scalable: true,
        textDelegate: TextDelegate(),
      ),
    );
  }

  void saveImage() async {
    final image = await _controller.exportImage();
    final imageName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final directory = (await getApplicationDocumentsDirectory()).path;
    await Directory('$directory/sample').create(recursive: true);
    final fullPath = '$directory/sample/$imageName';
    final imgFile = File('$fullPath');
    if (image != null) {
      imgFile.writeAsBytesSync(image);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey[700],
          padding: const EdgeInsets.only(left: 10),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Image Exported successfully.",
                  style: TextStyle(color: Colors.white)),
              TextButton(
                onPressed: () => OpenFile.open("$fullPath"),
                child: Text(
                  "Open",
                  style: TextStyle(
                    color: Colors.blue[200],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}

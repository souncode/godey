import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'dart:html' as html;

class Labeling extends StatefulWidget {
  const Labeling({super.key});

  @override
  State<Labeling> createState() => _LabelingState();
}

class _LabelingState extends State<Labeling> {
  List<Map<String, dynamic>> imageAssets = [];
  Map<String, dynamic>? selectedImage;
  String imageInfo = '';
  Future<void> loadImagesFromFolder() async {
    final input = html.FileUploadInputElement();
    input.multiple = true;
    input.accept = 'image/*';
    input.click();

    await input.onChange.first;

    final files = input.files;
    if (files != null) {
      List<Map<String, dynamic>> images = [];
      for (final file in files) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        await reader.onLoad.first;
        final bytes = reader.result as Uint8List;
        images.add({'bytes': bytes, 'name': file.name});
      }
      setState(() {
        imageAssets = images;
        selectedImage = null;
        imageInfo = '';
      });
    }
  }

  void selectImage(Map<String, dynamic> image) {
    final bytes = image['bytes'] as Uint8List;
    setState(() {
      selectedImage = image;
      imageInfo =
          'Name: ${image['name']}\nSize: ${(bytes.lengthInBytes / 1024).toStringAsFixed(2)} KB';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_arrow,
        children: [
          SpeedDialChild(
            child: Icon(Icons.file_download),
            label: "Add",
            onTap: () {
              loadImagesFromFolder();
            },
          ),
          SpeedDialChild(child: Icon(Icons.plus_one), label: "Add"),
          SpeedDialChild(child: Icon(Icons.exposure_minus_1), label: "Minus"),
          SpeedDialChild(child: Icon(Icons.text_fields), label: "Edit"),
          SpeedDialChild(child: Icon(Icons.zoom_in), label: "Zoom in"),
          SpeedDialChild(child: Icon(Icons.zoom_out), label: "Zoom out"),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // số cột
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1, // tỉ lệ vuông
                ),
                itemCount: imageAssets.length,
                itemBuilder: (context, index) {
                  final image = imageAssets[index];
                  return GestureDetector(
                    onTap: () => selectImage(image),
                    child: Stack(
                      children: [
                        GridTile(
                          footer: Container(
                            color: Colors.black54,
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 6,
                            ),
                            child: Text(
                              image['name'] ?? 'Không tên',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          child: Image.memory(
                            image['bytes'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        // nút xóa nhỏ góc trên phải
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                // nếu ảnh đang chọn trùng ảnh xóa thì bỏ chọn luôn
                                if (selectedImage == image) {
                                  selectedImage = null;
                                  imageInfo = '';
                                }
                                imageAssets.removeAt(index);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(2),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child:
                        selectedImage != null
                            ? Image.memory(selectedImage!['bytes'])
                            : const Center(child: Text("Chọn ảnh để gán nhãn")),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(12),
              child: Text(imageInfo),
            ),
          ),
        ],
      ),
    );
  }
}

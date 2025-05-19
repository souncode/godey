import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:godey/widgets/bounding_box.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;

class Labeling extends StatefulWidget {
  const Labeling({super.key});

  @override
  State<Labeling> createState() => _LabelingState();
}

class _LabelingState extends State<Labeling> {
  bool isDrawingBox = false;
  Offset? startPoint;
  Offset? endPoint;

  List<Map<String, dynamic>> boundingBoxes = [];

  List<Map<String, dynamic>> imageAssets = [];
  Map<String, dynamic>? selectedImage;
  String imageInfo = '';

  Future<bool> deleteImageOnServer({
    required String folder,
    required String filename,
  }) async {
    final uri = Uri.parse(
      'http://soun.mooo.com:3000/uploads?folder=$folder&filename=$filename',
    );

    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      print('✅ Deleted $filename on server');
      return true;
    } else {
      print(
        '❌ Failed to delete $filename on server, status: ${response.statusCode}',
      );
      return false;
    }
  }

  Future<void> fetchImagesFromServer() async {
    final uri = Uri.parse(
      'http://soun.mooo.com:3000/uploads/list?folder=soun_user_1',
    );
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      List<Map<String, dynamic>> images = [];
      for (var item in data) {
        final imageUrl = item['url'];
        final imageName = item['name'];

        try {
          final imageResp = await http.get(Uri.parse(imageUrl));

          final contentType = imageResp.headers['content-type'];
          final bytes = imageResp.bodyBytes;

          if (imageResp.statusCode == 200 &&
              contentType != null &&
              contentType.startsWith('image/') &&
              bytes.isNotEmpty) {
            images.add({'bytes': bytes, 'name': imageName});
            print('✅ Loaded image: $imageName (${bytes.lengthInBytes} bytes)');
          } else {
            print(
              '⚠️ Skipped invalid image: $imageName (${imageResp.statusCode}, Content-Type: $contentType, Size: ${bytes.length})',
            );
          }
        } catch (e) {
          print('❌ Error loading image $imageName: $e');
        }
      }

      setState(() {
        imageAssets = images;
        selectedImage = null;
        imageInfo = '';
      });
    } else {
      print(
        '❌ Error loading images from server. Status code: ${response.statusCode}',
      );
    }
  }

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

        // Upload ảnh lên server qua API
        final uri = Uri.parse(
          'http://soun.mooo.com:3000/uploads?folder=soun_user_1',
        );
        final request = http.MultipartRequest('POST', uri)
          ..files.add(
            http.MultipartFile.fromBytes(
              'images', // key bên API
              bytes,
              filename: file.name,
            ),
          );

        final response = await request.send();
        if (response.statusCode == 200) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(
            SnackBar(content: Text('✅ Uploaded ${file.name}')),
          );
          print('✅ Uploaded ${file.name}');
        } else {
          final messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(
            SnackBar(content: Text('❌ Failed to upload ${file.name}')),
          );
          print('❌ Failed to upload ${file.name}');
        }

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

  void _showLabelDialog(int index) {
    final controller = TextEditingController(
      text: boundingBoxes[index]['label'],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter label'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'e.g. person, car...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  boundingBoxes[index]['label'] = controller.text.trim();
                });
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
          SpeedDialChild(
            child: Icon(Icons.plus_one),
            label: "Add",
            onTap: () {
              setState(() {
                isDrawingBox = true;
              });
            },
          ),
          SpeedDialChild(child: Icon(Icons.exposure_minus_1), label: "Minus"),
          SpeedDialChild(child: Icon(Icons.text_fields), label: "Edit"),
          SpeedDialChild(child: Icon(Icons.zoom_in), label: "Zoom in"),
          SpeedDialChild(child: Icon(Icons.zoom_out), label: "Zoom out"),
          SpeedDialChild(
            child: Icon(Icons.refresh),
            label: "Load from server",
            onTap: () => fetchImagesFromServer(),
          ),
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
                            onTap: () async {
                              final folder =
                                  'soun_user_1'; // folder bạn đang dùng
                              final filename = image['name'];

                              final success = await deleteImageOnServer(
                                folder: folder,
                                filename: filename,
                              );

                              if (success) {
                                setState(() {
                                  if (selectedImage == image) {
                                    selectedImage = null;
                                    imageInfo = '';
                                  }
                                  imageAssets.removeAt(index);
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to delete $filename on server',
                                    ),
                                  ),
                                );
                              }
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
                            ? GestureDetector(
                              onPanStart: (details) {
                                if (isDrawingBox) {
                                  setState(() {
                                    startPoint = details.localPosition;
                                    endPoint = details.localPosition;
                                  });
                                }
                              },
                              onPanUpdate: (details) {
                                if (isDrawingBox) {
                                  setState(() {
                                    endPoint = details.localPosition;
                                  });
                                }
                              },
                              onPanEnd: (details) {
                                if (isDrawingBox &&
                                    startPoint != null &&
                                    endPoint != null) {
                                  setState(() {
                                    boundingBoxes.add({
                                      'rect': Rect.fromPoints(
                                        startPoint!,
                                        endPoint!,
                                      ),
                                      'label': '',
                                    });
                                    startPoint = null;
                                    endPoint = null;
                                    isDrawingBox = false;
                                  });
                                }
                              },
                              child: Stack(
                                children: [
                                  Image.memory(selectedImage!['bytes']),
                                  ...boundingBoxes.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final box = entry.value;
                                    return BoundingBoxWidget(
                                      rect: box['rect'],
                                      label: box['label'],
                                      onTap: () => _showLabelDialog(index),
                                      onUpdate: (newRect) {
                                        setState(() {
                                          boundingBoxes[index]['rect'] =
                                              newRect;
                                        });
                                      },
                                    );
                                  }),
                                  if (startPoint != null && endPoint != null)
                                    Positioned(
                                      left: startPoint!.dx,
                                      top: startPoint!.dy,
                                      width:
                                          (endPoint!.dx - startPoint!.dx).abs(),
                                      height:
                                          (endPoint!.dy - startPoint!.dy).abs(),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.blue,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )
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

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:godey/responsive/vision/server_api.dart';
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
  final List<String> classLabels = ['person', 'car', 'cat', 'dog', 'bottle'];

  List<Map<String, dynamic>> boundingBoxes = [];

  List<Map<String, dynamic>> imageAssets = [];
  Map<String, dynamic>? selectedImage;
  String imageInfo = '';

  Future<void> fetchImagesFromServer() async {
    final uri = Uri.parse(
      'http://soun.mooo.com:3000/uploads/list?folder=soun_user_1',
    );
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      List<Map<String, dynamic>> images = [];
      for (var item in data) {
        final imageUrl = item['url']; // full image
        final thumbUrl = item['thumbUrl']; // lightweight thumbnail
        final imageName = item['name'];
        final labelUrl = item['labelUrl'];
        final boundingBoxes = item['boundingBoxes'];

        try {
          // Ưu tiên load thumbnail để nhẹ
          final thumbResp = await http.get(Uri.parse(thumbUrl));

          final contentType = thumbResp.headers['content-type'];
          final bytes = thumbResp.bodyBytes;

          if (thumbResp.statusCode == 200 &&
              contentType != null &&
              contentType.startsWith('image/') &&
              bytes.isNotEmpty) {
            images.add({
              'bytes': bytes, // Thumbnail bytes để hiển thị nhanh
              'originalUrl': imageUrl, // Lưu lại link ảnh gốc
              'name': imageName,
              'labelUrl': labelUrl,
              'boundingBoxes': boundingBoxes,
            });

            print(
              '✅ Loaded thumbnail: $imageName (${bytes.lengthInBytes} bytes)',
            );
          } else {
            print(
              '⚠️ Skipped invalid thumbnail: $imageName (${thumbResp.statusCode}, Content-Type: $contentType, Size: ${bytes.length})',
            );
          }
        } catch (e) {
          print('❌ Error loading thumbnail $imageName: $e');
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

  void selectImage(Map<String, dynamic> image) async {
    final originalUrl = image['originalUrl'];

    try {
      final response = await http.get(Uri.parse(originalUrl));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        setState(() {
          selectedImage = image;
          image['bytes'] = bytes; // Lưu lại nếu muốn dùng sau
          boundingBoxes =
              (image['boundingBoxes'] as List<dynamic>? ?? [])
                  .map(
                    (box) => {
                      'rect': Rect.fromLTWH(
                        (box['rect']['x'] as num).toDouble(),
                        (box['rect']['y'] as num).toDouble(),
                        (box['rect']['width'] as num).toDouble(),
                        (box['rect']['height'] as num).toDouble(),
                      ),
                      'label': box['label'],
                    },
                  )
                  .toList();
          imageInfo =
              'Name: ${image['name']}\nSize: ${(bytes.lengthInBytes / 1024).toStringAsFixed(2)} KB';
        });
      } else {
        print('❌ Failed to load full image ${image['name']}');
      }
    } catch (e) {
      print('❌ Error loading full image: $e');
    }
  }

  Future<void> saveLabeledImageToServer({
    required String imageName,
    required String folder,
    required List<Map<String, dynamic>> boundingBoxes,
  }) async {
    final url = Uri.parse('http://soun.mooo.com:3000/uploads/label');

    final image = selectedImage;
    if (image == null) return;

    final decodedImage = await decodeImageFromList(image['bytes']);
    final imageWidth = decodedImage.width.toDouble();
    final imageHeight = decodedImage.height.toDouble();

    final List<String> yoloLabels =
        boundingBoxes
            .map((box) {
              final rectMap = box['rect'] as Map<String, dynamic>;
              final rect = Rect.fromLTWH(
                (rectMap['left'] ?? 0.0).toDouble(),
                (rectMap['top'] ?? 0.0).toDouble(),
                (rectMap['width'] ?? 0.0).toDouble(),
                (rectMap['height'] ?? 0.0).toDouble(),
              );

              final label = box['label'];
              final classIndex = classLabels.indexOf(label);
              if (classIndex == -1) return '';

              final xCenter = ((rect.left + rect.width / 2) / imageWidth).clamp(
                0.0,
                1.0,
              );
              final yCenter = ((rect.top + rect.height / 2) / imageHeight)
                  .clamp(0.0, 1.0);
              final width = (rect.width / imageWidth).clamp(0.0, 1.0);
              final height = (rect.height / imageHeight).clamp(0.0, 1.0);

              return '$classIndex $xCenter $yCenter $width $height';
            })
            .where((line) => line.isNotEmpty)
            .toList();

    try {
      print('Sending to server:');
      print(
        jsonEncode({
          'name': imageName,
          'folder': folder,
          'yoloContent': yoloLabels.join('\n'),
          'boundingBoxes': boundingBoxes,
        }),
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': imageName,
          'folder': folder,
          'boundingBoxes': boundingBoxes,
          'yoloContent': yoloLabels.join('\n'),
        }),
      );

      if (response.statusCode == 200) {
        print('✅ YOLO label saved');
      } else {
        print('❌ Failed to save YOLO label: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('❌ Error saving YOLO label: $e');
    }
  }

  void _showLabelDialog(int index) {
    String? selectedLabel = boundingBoxes[index]['label'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Class select'),
          content: DropdownButton<String>(
            isExpanded: true,
            value: selectedLabel!.isNotEmpty ? selectedLabel : null,
            hint: const Text('Class'),
            items:
                classLabels.map((label) {
                  return DropdownMenuItem<String>(
                    value: label,
                    child: Text(label),
                  );
                }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  boundingBoxes[index]['label'] = value;
                });
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  boundingBoxes.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
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
          SpeedDialChild(
            onTap: () {
              if (selectedImage == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('❗ Vui lòng chọn ảnh để lưu')),
                );
                return;
              }

              final processedBoxes =
                  boundingBoxes.map((box) {
                    final rect = box['rect'] as Rect;
                    return {
                      'label': box['label'],
                      'rect': {
                        'x': rect.left,
                        'y': rect.top,
                        'width': rect.width,
                        'height': rect.height,
                      },
                    };
                  }).toList();

              saveLabeledImageToServer(
                imageName: selectedImage!['name'],
                folder: 'soun_user_1',
                boundingBoxes: processedBoxes,
              );
            },
            child: const Icon(Icons.save),
            label: "Save",
          ),

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
                                size: 5,
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
            flex: 5,

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
                                'rect': Rect.fromPoints(startPoint!, endPoint!),
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
                                    boundingBoxes[index]['rect'] = newRect;
                                  });
                                },
                              );
                            }),
                            if (startPoint != null && endPoint != null)
                              Positioned(
                                left: startPoint!.dx,
                                top: startPoint!.dy,
                                width: (endPoint!.dx - startPoint!.dx).abs(),
                                height: (endPoint!.dy - startPoint!.dy).abs(),
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
                      : const Center(child: Text("Select")),
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

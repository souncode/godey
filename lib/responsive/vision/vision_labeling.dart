import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:godey/responsive/vision/server_api.dart';
import 'package:godey/widgets/bounding_box.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

class Labeling extends StatefulWidget {
  const Labeling({super.key});

  @override
  State<Labeling> createState() => _LabelingState();
}

class _LabelingState extends State<Labeling> {
  double imageScale = 1.0;
  Size? imageDisplaySize;
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


  void selectImage(Map<String, dynamic> image) async {
    final originalUrl = image['originalUrl'];
    try {
      final response = await http.get(Uri.parse(originalUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final decodedImage = await decodeImageFromList(bytes);
        setState(() {
          selectedImage = image;
          image['bytes'] = bytes;
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
              'Name: ${image['name']}\nSize: ${(bytes.lengthInBytes / 1024).toStringAsFixed(2)} KB\nOriginal size: ${decodedImage.width} x ${decodedImage.height}';
          imageScale = 1.0;
          imageDisplaySize = null;
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
            label: "DownLoad Zip",
            onTap: () {
              // uploadImagesToServer();
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.file_upload),
            label: "Upload",
            onTap: () {
              uploadImagesToServer(context,"soun_user_2","project1");
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
              color: Colors.grey.shade300,
              child:
                  selectedImage == null
                      ? const Center(child: Text('Select an image'))
                      : LayoutBuilder(
                        builder: (context, constraints) {
                          final imageBytes =
                              selectedImage!['bytes'] as Uint8List;

                          return FutureBuilder<ui.Image>(
                            future: decodeImageFromList(imageBytes),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              final image = snapshot.data!;
                              final originalWidth = image.width.toDouble();
                              final originalHeight = image.height.toDouble();

                              // Tính scale để vừa với box chứa (constraints)
                              final scaleX =
                                  constraints.maxWidth / originalWidth;
                              final scaleY =
                                  constraints.maxHeight / originalHeight;
                              final scale = scaleX < scaleY ? scaleX : scaleY;

                              final displayWidth = originalWidth * scale;
                              final displayHeight = originalHeight * scale;

                              // Lưu scale & size để dùng khi vẽ box
                              imageScale = scale;
                              imageDisplaySize = Size(
                                displayWidth,
                                displayHeight,
                              );

                              return Center(
                                child: GestureDetector(
                                  onPanStart: (details) {
                                    final localPosition = (context
                                                .findRenderObject()
                                            as RenderBox)
                                        .globalToLocal(details.globalPosition);

                                    final dx = localPosition.dx;
                                    final dy = localPosition.dy;

                                    // Chuyển về tọa độ ảnh gốc
                                    final x = dx / imageScale;
                                    final y = dy / imageScale;

                                    setState(() {
                                      startPoint = Offset(x, y);
                                      endPoint = null;
                                      isDrawingBox = true;
                                    });
                                  },
                                  onPanUpdate: (details) {
                                    if (!isDrawingBox) return;

                                    final localPosition = (context
                                                .findRenderObject()
                                            as RenderBox)
                                        .globalToLocal(details.globalPosition);

                                    final dx = localPosition.dx;
                                    final dy = localPosition.dy;

                                    final x = dx / imageScale;
                                    final y = dy / imageScale;

                                    setState(() {
                                      endPoint = Offset(x, y);
                                    });
                                  },
                                  onPanEnd: (details) {
                                    if (!isDrawingBox ||
                                        startPoint == null ||
                                        endPoint == null)
                                      return;

                                    final left =
                                        startPoint!.dx < endPoint!.dx
                                            ? startPoint!.dx
                                            : endPoint!.dx;
                                    final top =
                                        startPoint!.dy < endPoint!.dy
                                            ? startPoint!.dy
                                            : endPoint!.dy;
                                    final width =
                                        (startPoint!.dx - endPoint!.dx).abs();
                                    final height =
                                        (startPoint!.dy - endPoint!.dy).abs();

                                    final newRect = Rect.fromLTWH(
                                      left,
                                      top,
                                      width,
                                      height,
                                    );

                                    setState(() {
                                      boundingBoxes.add({
                                        'rect': newRect,
                                        'label': '',
                                      });
                                      startPoint = null;
                                      endPoint = null;
                                      isDrawingBox = false;
                                    });
                                  },
                                  child: SizedBox(
                                    width: displayWidth,
                                    height: displayHeight,
                                    child: Stack(
                                      children: [
                                        Image.memory(
                                          imageBytes,
                                          fit: BoxFit.contain,
                                          width: displayWidth,
                                          height: displayHeight,
                                        ),
                                        ...boundingBoxes.asMap().entries.map((
                                          entry,
                                        ) {
                                          final idx = entry.key;
                                          final box = entry.value;
                                          final rect = box['rect'] as Rect;
                                          final label = box['label'] as String;
                                          final displayRect = Rect.fromLTWH(
                                            rect.left * imageScale,
                                            rect.top * imageScale,
                                            rect.width * imageScale,
                                            rect.height * imageScale,
                                          );

                                          return BoundingBoxWidget(
                                            rect: displayRect,
                                            label: label,
                                            onUpdate: (updatedDisplayRect) {
                                              final updatedRect = Rect.fromLTWH(
                                                updatedDisplayRect.left /
                                                    imageScale,
                                                updatedDisplayRect.top /
                                                    imageScale,
                                                updatedDisplayRect.width /
                                                    imageScale,
                                                updatedDisplayRect.height /
                                                    imageScale,
                                              );
                                              setState(() {
                                                boundingBoxes[idx]['rect'] =
                                                    updatedRect;
                                              });
                                            },
                                            onTap: () => _showLabelDialog(idx),
                                          );
                                        }),
                                        if (startPoint != null &&
                                            endPoint != null)
                                          Positioned(
                                            left: (startPoint!.dx * imageScale)
                                                .clamp(0, displayWidth),
                                            top: (startPoint!.dy * imageScale)
                                                .clamp(0, displayHeight),
                                            width: ((endPoint!.dx -
                                                            startPoint!.dx)
                                                        .abs() *
                                                    imageScale)
                                                .clamp(0, displayWidth),
                                            height: ((endPoint!.dy -
                                                            startPoint!.dy)
                                                        .abs() *
                                                    imageScale)
                                                .clamp(0, displayHeight),
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
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
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

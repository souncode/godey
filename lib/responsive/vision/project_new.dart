import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:godey/responsive/vision/server_api.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Upload()));
}

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  int _currentStep = 0;
  final List<String> _steps = ["Create Project", "Add Images", "Review"];

  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _classNameController = TextEditingController();
  List<String> _classList = [];
  int _editingIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 48.0,
            ),
            child: Column(
              children: [
                _buildStepperUI(),
                const SizedBox(height: 40),
                if (_currentStep == 0) ...[
                  const Text(
                    "Create Project",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _projectNameController,
                      decoration: const InputDecoration(
                        labelText: "Project Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Class name input + add/update button
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _classNameController,
                      decoration: const InputDecoration(
                        labelText: "Class Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      String text = _classNameController.text.trim();
                      if (text.isEmpty) return;

                      setState(() {
                        if (_editingIndex == -1) {
                          // Add new class nếu chưa có
                          if (!_classList.contains(text)) {
                            _classList.add(text);
                          }
                        } else {
                          // Update class đang sửa
                          if (!_classList.contains(text) ||
                              _classList[_editingIndex] == text) {
                            _classList[_editingIndex] = text;
                          }
                          _editingIndex = -1;
                        }
                        _classNameController.clear();
                      });
                    },
                    child: Text(_editingIndex == -1 ? "Add" : "Update"),
                  ),
                  const SizedBox(height: 20),

                  // Hiển thị danh sách class đã thêm
                  SizedBox(
                    width: 300,
                    child:
                        _classList.isEmpty
                            ? const Text("No classes added yet.")
                            : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _classList.length,
                              separatorBuilder: (_, __) => const Divider(),
                              itemBuilder: (context, index) {
                                final className = _classList[index];
                                return ListTile(
                                  title: Text(className),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (_editingIndex == index) {
                                          // Nếu đang sửa cái này, hủy sửa
                                          _editingIndex = -1;
                                          _classNameController.clear();
                                        }
                                        _classList.removeAt(index);
                                      });
                                    },
                                  ),
                                  onTap: () {
                                    // Bấm vào để sửa class
                                    setState(() {
                                      _editingIndex = index;
                                      _classNameController.text = className;
                                    });
                                  },
                                );
                              },
                            ),
                  ),
                  const SizedBox(height: 20),
                ] else if (_currentStep == 1) ...[
                  const Icon(Icons.image, size: 100, color: Colors.grey),
                  const SizedBox(height: 8),
                  const Text("Images need to be geotagged JPGs."),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      uploadImagesToServer(context,"soun_user_2","project1");
                    },
                    child: const DottedBorderBox(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Click on Next, to proceed further",
                    style: TextStyle(color: Colors.green),
                  ),
                  const SizedBox(height: 20),
                ] else ...[
                  const Text("XXXXXXXXXXX", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (_currentStep > 0) _currentStep--;
                        });
                      },
                      child: const Text("Back"),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_currentStep < 2) _currentStep++;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: const Text("Next"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepperUI() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_steps.length, (index) {
        return Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor:
                  index == _currentStep ? Colors.blue : Colors.grey.shade300,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: index == _currentStep ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              _steps[index],
              style: TextStyle(
                color: index == _currentStep ? Colors.black : Colors.grey,
              ),
            ),
            if (index < _steps.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.arrow_forward_ios, size: 14),
              ),
          ],
        );
      }),
    );
  }
}

class DottedBorderBox extends StatelessWidget {
  const DottedBorderBox({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      dashPattern: [6, 4],
      color: Colors.black,
      strokeWidth: 1,
      borderType: BorderType.RRect,
      radius: const Radius.circular(8),
      child: Container(
        height: 150,
        width: 300,
        alignment: Alignment.center,
        child: Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: "Drag and drop image files or "),
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    // TODO: open file picker
                  },
                  child: Text(
                    "browse",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

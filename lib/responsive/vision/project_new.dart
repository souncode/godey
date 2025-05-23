import 'package:flutter/material.dart';
import 'package:godey/const/constant.dart';

void main() {
  runApp(const MaterialApp(home: ProjectSelectionPage()));
}

class ProjectSelectionPage extends StatelessWidget {
  const ProjectSelectionPage({super.key});

  void showSelection(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You selected: $title'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Create a new Project',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'This is process',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ProjectCard(
                      buttonColor: Colors.blue,
                      icon: Icons.file_open,
                      title: 'Create New Project',
                      description:
                          'Setting project information, class , etc ..',
                      onPressed:
                          () => showSelection(context, 'Create New Project'),
                    ),
                    Container(
                      width: 1,
                      height: 300,
                      color: const Color.fromARGB(255, 81, 84, 91),
                    ),
                    ProjectCard(
                      buttonColor: Colors.grey,
                      icon: Icons.file_upload,
                      title: 'Upload Pre-processed Data',
                      description: 'Raw Image to labeling',
                      onPressed:
                          () => showSelection(
                            context,
                            'Upload Pre-processed Data',
                          ),
                    ),
                    Container(
                      width: 1,
                      height: 300,
                      color: const Color.fromARGB(255, 81, 84, 91),
                    ),
                    ProjectCard(
                      buttonColor: Colors.grey,
                      icon: Icons.label,
                      title: 'Labeling',
                      description: 'Label position of things',
                      onPressed: () => showSelection(context, 'Labeling'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onPressed;
  final Color buttonColor; // Thêm dòng này

  const ProjectCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onPressed,
    required this.buttonColor, // Thêm dòng này
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 64, color: Colors.black),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              ElevatedButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Get Started'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor, // Sử dụng màu riêng
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

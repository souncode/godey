import 'package:flutter/material.dart';
import 'package:godey/responsive/vision/server_api.dart';
import 'package:godey/responsive/vision/vision_home.dart';
import 'package:intl/intl.dart';

class AllProjectsPage extends StatefulWidget {
  final VoidCallback? onProjectCreated;
 

  const AllProjectsPage({
    super.key,
    this.onProjectCreated,
 
  });

  @override
  State<AllProjectsPage> createState() => _AllProjectsPageState();
}

class _AllProjectsPageState extends State<AllProjectsPage> {
  final String _userID = "6831f177ead28d72e8803dc8";
  List<dynamic> _projects = [];
  bool _isLoading = true;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  Future<void> _fetchProjects() async {
    final payload = {"user": _userID};
    final data = await ServerApi.getProject(payload);

    setState(() {
      _projects = data["successRes"] ?? [];
      _isLoading = false;
    });
  }

  void _editProject(dynamic project) {
    print("Edit ${project['name']}");
  }

  void _deleteProject(dynamic project) {
    print("Delete ${project['_id']}");
  }

  String formatDate(String dateString) {
    try {
      final dt = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(dt);
    } catch (_) {
      return "N/A";
    }
  }

  Widget _buildPopupMenu(dynamic project) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') _editProject(project);
        if (value == 'delete') _deleteProject(project);
      },
      itemBuilder:
          (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
    );
  }

  Widget _buildProjectCard(dynamic project) {
    final name = project["name"] ?? "Untitled";
    final created = formatDate(project["time"] ?? "");
    final id = project["_id"] ?? "No ID";

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VisionHomePage(projectId: id, index: 2),
          ),
        );
        print("Project ID: $id");
      },
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Stack(
            children: [
              Positioned(top: 0, right: 0, child: _buildPopupMenu(project)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.folder, size: 40, color: Colors.blue),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Created: $created",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(dynamic project) {
    final name = project["name"] ?? "Untitled";
    final created = formatDate(project["time"] ?? "");
    final id = project["_id"] ?? "No ID";

    return ListTile(
      leading: const Icon(Icons.folder, color: Colors.blue),
      title: Text(name),
      subtitle: Text("Created: $created"),
      trailing: _buildPopupMenu(project),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VisionHomePage(projectId: id, index: 2),
          ),
        );
        print("Project ID: $id");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Projects"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Add Project",
            onPressed: () {
              widget.onProjectCreated?.call();
            },
          ),
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _projects.isEmpty
              ? const Center(child: Text("No projects found."))
              : Padding(
                padding: const EdgeInsets.all(16),
                child:
                    _isGridView
                        ? GridView.builder(
                          itemCount: _projects.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 1.4,
                              ),
                          itemBuilder: (context, index) {
                            return _buildProjectCard(_projects[index]);
                          },
                        )
                        : ListView.builder(
                          itemCount: _projects.length,
                          itemBuilder: (context, index) {
                            return _buildListTile(_projects[index]);
                          },
                        ),
              ),
    );
  }
}

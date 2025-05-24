import 'package:flutter/material.dart';
import 'package:godey/responsive/vision/project_new.dart';
import 'package:godey/responsive/vision/project_view.dart';
import 'package:godey/responsive/vision/server_api.dart';

class Projects extends StatefulWidget {
  final void Function(String)? onProjectSelected;
  const Projects({super.key, this.onProjectSelected});

  @override
  State<Projects> createState() => _ProjectsState();
}

String _userID = "6831f177ead28d72e8803dc8";
bool _hasProject = false;
bool _isLoading = true;

class _ProjectsState extends State<Projects> {
  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future<void> getdata() async {
    final Map<String, dynamic> payload = {"user": _userID};
    final data = await ServerApi.getProject(payload);
    print(data);
    setState(() {
      final list = data["successRes"];
      _hasProject = list != null && list is List && list.isNotEmpty;
      _isLoading = false;
      print(_hasProject);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.blue,
            child:
                _hasProject
                    ? AllProjectsPage(
                      onProjectCreated: () {
                        setState(() {
                          _hasProject = false;
                        });
                      },
                    )
                    : Upload(
                      onProjectCreateCancel: () {
                        setState(() {
                          getdata();
                          if (_hasProject) {
                            _hasProject = true;
                          } else {
                            _hasProject = false;
                          }
                        });
                      },
                    ),
          ),
        ),
      ],
    );
  }
}

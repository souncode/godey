import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class ServerApi {
  static Future<bool> deleteImageOnServer({
    required String folder,
    required String filename,
  }) async {
    final uri = Uri.parse(
      'http://soun.mooo.com:3000/uploads?folder=$folder&filename=$filename',
    );
    print('$uri');
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

  static Future<bool> uploadImagesToServer(
    BuildContext context,
    String user,
    String project,
  ) async {
    final input = html.FileUploadInputElement();
    input.multiple = true;
    input.accept = 'image/*';
    input.click();

    await input.onChange.first;
    final files = input.files;
    if (files == null || files.isEmpty) {
      return false;
    }

    bool allSuccess = true;

    for (final file in files) {
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      await reader.onLoad.first;
      final bytes = reader.result as Uint8List;

      final uri = Uri.parse(
        'http://soun.mooo.com:3000/uploads?folder=${user}/${project}&project=${project}',
      );

      final request = http.MultipartRequest('POST', uri)
        ..files.add(
          http.MultipartFile.fromBytes('images', bytes, filename: file.name),
        );

      final response = await request.send();

      if (response.statusCode == 200) {
        print('✅ Uploaded ${file.name}');
      } else {
        allSuccess = false;
        print('❌ Failed to upload ${file.name}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Failed to upload ${file.name}')),
        );
      }
    }

    return allSuccess;
  }

  static Future<String?> addProject(Map<String, dynamic> data) async {
    const String url = "http://soun.mooo.com:3000/addproject";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> resJson = json.decode(response.body);
        return resJson["successRes"]["_id"]; // Trả về projectId
      } else {
        print("API failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("API Error: $e");
    }
    return null; // Trả về null nếu thất bại
  }

  static Future<Map<String, dynamic>> getProject(
    Map<String, dynamic> data,
  ) async {
    const String url = "http://soun.mooo.com:3000/getproject";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> resJson = json.decode(response.body);
        return resJson;
      } else {
        print("API failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("API Error: $e");
    }
    return {};
  }
}

Future<List<String>> fetchClassLabels({
  required String projectId,
  required String userId,
}) async {
  const String url = "http://soun.mooo.com:3000/getproject";

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"user": userId}), // ✅ Đã truyền đúng
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> resJson = json.decode(response.body);
      print("Full response: $resJson");

      if (resJson.containsKey('successRes')) {
        List<dynamic> projects = resJson['successRes'];
        print("Project IDs: ${projects.map((p) => p['_id']).toList()}");

        final project = projects.firstWhere(
          (proj) => proj['_id'].toString() == projectId.toString(),
          orElse: () => null,
        );

        if (project != null && project['classes'] is List) {
          print("Found project: $project");
          return List<String>.from(project['classes']);
        } else {
          print("Project not found or classes invalid.");
        }
      }
    } else {
      print("API failed with status: ${response.statusCode}");
    }
  } catch (e) {
    print("API Error: $e");
  }

  return [];
}


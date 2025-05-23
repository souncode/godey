 import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

Future<bool> deleteImageOnServer({
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
    Future<void> uploadImagesToServer(BuildContext context, String user,String project ) async {
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
          'http://soun.mooo.com:3000/uploads?folder=${user}/${project}',
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
    }
  }


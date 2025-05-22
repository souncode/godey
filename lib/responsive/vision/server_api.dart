 import 'package:http/http.dart' as http;

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

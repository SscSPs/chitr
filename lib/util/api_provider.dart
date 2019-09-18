import 'dart:convert';

import 'package:chitr/home/model/ImageModel.dart';
import 'package:chitr/values/strings.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  Future<ImageModel> getRandomImages(int count) async {
    var url =
        '${apiUrl}editors_choice=true&per_page=$count&orientation=vertical';
    final response = await http.get(url);
    print(url);
    print("BODY : " + response.body);
    if (response.statusCode == 200) {
      return ImageModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get images');
    }
  }

  Future<ImageModel> getSearchedImages(String query, int page) async {
    final response = await http.get('${apiUrl}q=$query&page=$page&orientation=vertical');
    if (response.statusCode == 200) {
      return ImageModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get images');
    }
  }
}

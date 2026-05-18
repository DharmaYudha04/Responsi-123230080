import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/space_item.dart';

class SpaceApiService {
  static const String _baseUrl = 'https://api.spaceflightnewsapi.net/v4';

  Future<List<SpaceItem>> fetchItems(String endpoint) async {
    final uri = Uri.parse('$_baseUrl/$endpoint/');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data. Kode: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final results = decoded['results'] as List<dynamic>? ?? [];

    return results
        .map((item) => SpaceItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<SpaceItem> fetchDetail({
    required String detailPath,
    required int id,
  }) async {
    final uri = Uri.parse('$_baseUrl/$detailPath/$id/');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil detail. Kode: ${response.statusCode}');
    }

    return SpaceItem.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ukl_produktif/services/url.dart' as url;
import 'package:ukl_produktif/models/matkul_model.dart';
import 'package:ukl_produktif/models/response_data_map.dart';

class MatkulService {
  Future<List<MatkulModel>> getMatkul() async {
    final response = await http.get(Uri.parse('${url.baseUrl}getmatkul'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> matkulList = jsonResponse['data'];

      return matkulList.map((matkul) => MatkulModel.fromJson(matkul)).toList();
    } else {
      throw Exception('Failed to load matkul');
    }
  }

  Future<ResponseDataMap> selectMatkul(Map<String, dynamic> data) async {
    var uri = Uri.parse("${url.baseUrl}selectmatkul");

    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print(responseData);
      return ResponseDataMap(
        status: responseData["status"],
        message: responseData["message"],
        data: responseData,
      );
    } else {
      return ResponseDataMap(
        status: false,
        message:
            "Gagal menyimpan data mata kuliah dengan kode error ${response.statusCode}",
      );
    }
  }
}

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:ukl_produktif/services/url.dart' as url;
import 'package:ukl_produktif/models/response_data_map.dart';

class UserService {
  Future registerUser(Map<String, String> data, File? foto) async {
    var uri = Uri.parse(url.baseUrl + "register");
    var request = http.MultipartRequest("POST", uri);

    // Tambahkan field text
    request.fields.addAll(data);

    // Tambahkan file jika ada
    if (foto != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'foto',
          foto.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("Response code: ${response.statusCode}");
      print("Response body: ${response.body}");

      var responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseData["status"] == true) {
          return ResponseDataMap(
            status: true,
            message: "Sukses menambah user",
            data: responseData,
          );
        } else {
          var message = '';
          if (responseData["message"] is Map) {
            for (String key in responseData["message"].keys) {
              message += responseData["message"][key][0].toString() + '\n';
            }
          } else {
            message = responseData["message"].toString();
          }
          return ResponseDataMap(status: false, message: message);
        }
      } else if (response.statusCode == 422) {
        var message = '';
        if (responseData["message"] is Map) {
          for (String key in responseData["message"].keys) {
            message += responseData["message"][key][0].toString() + '\n';
          }
        } else {
          message = responseData["message"].toString();
        }
        return ResponseDataMap(status: false, message: message);
      } else {
        return ResponseDataMap(
          status: false,
          message:
              "Gagal menambah user dengan code error ${response.statusCode}",
        );
      }
    } catch (e) {
      return ResponseDataMap(status: false, message: "Error: $e");
    }
  }

  Future<ResponseDataMap> loginUser(Map<String, dynamic> data) async {
    var uri = Uri.parse("${url.baseUrl}login");
    var response = await http.post(uri, body: data);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      if (responseData["status"] == true) {
        return ResponseDataMap(
          status: true,
          message: "Sukses login user",
          data: responseData,
        );
      } else {
        return ResponseDataMap(
          status: false,
          message: 'Username dan password salah',
        );
      }
    } else {
      var responseData = json.decode(response.body);

      return ResponseDataMap(
        status: false,
        message: responseData["message"],
      );
    }
  }

  Future<ResponseDataMap> getUserProfile() async {
    var uri = Uri.parse("${url.baseUrl}profil");
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print(responseData);
      if (responseData["status"] == true) {
        return ResponseDataMap(
          status: true,
          message: "Sukses mendapatkan data user",
          data: responseData,
        );
      } else {
        return ResponseDataMap(
          status: false,
          message: 'Gagal mendapatkan data user',
        );
      }
    } else {
      return ResponseDataMap(
        status: false,
        message:
            "Gagal mendapatkan data user dengan kode error ${response.statusCode}",
      );
    }
  }

  Future<ResponseDataMap> updateUserProfile(
    int id,
    Map<String, dynamic> data,
  ) async {
    var uri = Uri.parse(
      "${url.baseUrl}update/$id",
    );
    var response = await http.put(
      uri,
      body: data,
    );
    print(response.body);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      if (responseData["status"] == true) {
        return ResponseDataMap(
          status: true,
          message: "Berhasil memperbarui profil",
          data: responseData,
        );
      } else {
        return ResponseDataMap(
          status: false,
          message: responseData["message"] ?? "Gagal memperbarui profil",
        );
      }
    } else {
      return ResponseDataMap(
        status: false,
        message: "Gagal update profil dengan kode error ${response.statusCode}",
      );
    }
  }
}

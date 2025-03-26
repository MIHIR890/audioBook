import 'dart:convert';
import 'package:dashboard/model/audio_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiService {
 static var currentAudioName = ''.obs;
  static var currentAudioAuthor = ''.obs;
 static var currentAudioUrl = ''.obs;
  static const String baseUrl = 'http://192.168.43.11:3000/api';

  static Future<List<Audiobook>> fetchAudiobooks() async {
    final response = await http.get(Uri.parse('$baseUrl/audioBook'));
    print(response.body);


      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Audiobook.fromJson(json)).toList();

  }
  static void updateAudioData(String audioName, String audioAuthor, String audioUrl) {
    currentAudioName.value = audioName;
    currentAudioAuthor.value = audioAuthor;
    currentAudioUrl.value = audioUrl;
  }
}


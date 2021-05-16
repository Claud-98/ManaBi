import 'dart:io';
import 'package:manabi/utils/strings.dart' as strings;
import 'package:dio/dio.dart';
import 'package:manabi/models/kaku_kanji.dart';

class KakuKanjiApiProvider{
  final Dio _dio = Dio();

  Future<KakuKanji> getKakuKanji(String kanji) async {
    final String _url = "https://kanjialive-api.p.rapidapi.com/api/public/kanji/$kanji";
    try {
      _dio.options.headers['x-rapidapi-key'] = '057c93cee6msh93e335cd4c82ce4p171780jsn76642fe4c795';
      _dio.options.headers['x-rapidapi-host'] = 'kanjialive-api.p.rapidapi.com';
      Response response = await _dio.get(_url);

      return KakuKanji.fromJson(response.data);
    } catch (error) {
      if(Platform.localeName == 'it_IT')
        throw(strings.connectionErrorMessageIt);
      else
        throw(strings.connectionErrorMessageEn);
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:mobileapp/core/components/exporting_packages.dart';

class HotelService {
  static String baseUrl = 'https://ucharteam-tourism.herokuapp.com/v1/api';

  static Future createNewHotel(Hotel hotel) async {

   
    try {
      String token = await GetStorage().read('token');

      var headers = {'token': token};
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/hotel'));
      request.fields.addAll({
        'name': hotel.name,
        'city': hotel.city,
        'informUz': hotel.informUz,
        'informRu': hotel.informRu,
        'informEn': hotel.informEn,
        'karta': hotel.karta,
        'tell': hotel.tell.toString(),
        'categoryId': '1991edea-7d4a-49fb-b627-79b777cf54ae'
      });

      // FIXME: BIR NECHTA RASMLARNI JO'NATISH
      for (var photoPath in hotel.media) {
        final mimeTypeData =
            lookupMimeType(photoPath, headerBytes: [0xFF, 0xD8])?.split('/');

        //------------------
        request.files.add(await http.MultipartFile.fromPath(
          'media',
          photoPath,
          filename: photoPath.split('/').last,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
        ));
      }

      //  FIXME:  BITTA RASMNI JO'NATISH
      //  final mimeTypeData =
      //   lookupMimeType(filePath, headerBytes: [0xFF, 0xD8])?.split('/');
      // request.files.add(
      //   await http.MultipartFile.fromPath(
      //     'media',
      //     filePath,
      //     contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
      //   ).then(
      //     (value) {
      //       print(value.field);
      //       return value;
      //     },
      //   ),
      // );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        print(await response.stream.bytesToString());
        return response.stream.bytesToString();
      } else {
        print('else error: ' + response.reasonPhrase.toString());
        return response.reasonPhrase;
      }
    } catch (e) {
      print('catch error: ' + e.toString());
      return null;
    }
  }

  Future<List<Hotel>> fetchHotelsByCity(String cityName) async {
    try {
      var response = await http
          .get(Uri.parse("$baseUrl/hotel"), headers: {"city": cityName});
      if (response.statusCode == 200) {
        List<Hotel> hotelList = (jsonDecode(response.body)['data'] as List)
            .map((e) => Hotel.fromJson(e))
            .toList();
        return hotelList;
      } else {
        return jsonDecode(response.body)['message'];
      }
    } catch (e) {
      List<Hotel> h = [];
      return h;
    }
  }

  Future fetchHotelsByCategory(String categryId) async {
    try {
      var response = await http.get(Uri.parse("$baseUrl/hotel"),
          headers: {"category_id": categryId});
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else {
        return jsonDecode(response.body)['message'];
      }
    } catch (e) {
      return e;
    }
  }

  Future fetchCategoriesOfHotel() async {
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/hotels/categories"),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else {
        return jsonDecode(response.body)['message'];
      }
    } catch (e) {
      return e;
    }
  }

  Future fetchHotelComments({required String hotelId}) async {
    try {
      var response = await http
          .get(Uri.parse("$baseUrl/comment"), headers: {"hotel_id": hotelId});

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return e;
    }
  }

  Future addRatingToHotel(
      {required String hotelId, required String rate}) async {
    String token = //await GetStorage().read('token');
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJmMzIyYjkxNi01MjQ0LTQ5YTItOWY0Ni1jM2E3YTYzNjA0Y2IiLCJpYXQiOjE2NDUwOTUwNzEsImV4cCI6MTY2MjM3NTA3MX0.cX0A_pOKUn7K6iekxocSWK4K5WrtHph_2-WrOXPDyis';

    try {
      var response = await http.post(
        Uri.parse('$baseUrl/reyting'),
        body: jsonEncode({"value": rate, "hotelId": hotelId}),
        headers: {'token': token},
      );

      if (response.statusCode == 201) {
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print(response.statusCode);
        return jsonDecode(response.statusCode.toString());
      }
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future addCommentToHotel(
      {required String hotelId, required String commentText}) async {
    String token = //await GetStorage().read('token');
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJmMzIyYjkxNi01MjQ0LTQ5YTItOWY0Ni1jM2E3YTYzNjA0Y2IiLCJpYXQiOjE2NDUwOTUwNzEsImV4cCI6MTY2MjM3NTA3MX0.cX0A_pOKUn7K6iekxocSWK4K5WrtHph_2-WrOXPDyis';

    try {
      var response = await http.post(
        Uri.parse('$baseUrl/comment'),
        body: jsonEncode({"name": commentText, "hotelId": hotelId}),
        headers: {'token': token, 'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print(response.body);
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future deleteHotel({required String hotelId}) async {
    String token = //await GetStorage().read('token');
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJmMzIyYjkxNi01MjQ0LTQ5YTItOWY0Ni1jM2E3YTYzNjA0Y2IiLCJpYXQiOjE2NDUwOTUwNzEsImV4cCI6MTY2MjM3NTA3MX0.cX0A_pOKUn7K6iekxocSWK4K5WrtHph_2-WrOXPDyis';

    try {
      var response = await http.delete(
        Uri.parse("$baseUrl/hotel/$hotelId"),
        headers: {'token': token},
      );

      if (response.statusCode == 201) {
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print(response.body);
        return jsonDecode(response.body);
      }
    } catch (e) {
      return e;
    }
  }
}

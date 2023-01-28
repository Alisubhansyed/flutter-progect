import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weaterapp/main.dart';
import 'package:weaterapp/model.dart';

// Future<Position> determinePermission() async {
//   if (await Geolocator.isLocationServiceEnabled()) {
//     Position position = await Geolocator.getCurrentPosition();
//     Geolocator.getCurrentPosition().whenComplete(() => null);
//     return position;
//   } else {
//     await Geolocator.openLocationSettings();
//     if (await Geolocator.isLocationServiceEnabled()) {
//     Position position = await Geolocator.getCurrentPosition();
//     Geolocator.getCurrentPosition().whenComplete(() => null);
//     return position;
//   }

//   }
// }

Future<dynamic> apiCall(String city) async {
// import 'package:flutter/material.dart';
  String url =
      "https://api.weatherapi.com/v1/forecast.json?key=4955768fd419412985392830221612&q=$city&days=7";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body.toString());
    // print(data);
    return data;
  } else {
    throw Exception();
  }
}

// Future<Map<String, dynamic>> fetchData() async {
//   // final where = Uri.encodeQueryComponent(jsonEncode({
//   //   "country": {
//   //     "__type": "Pointer",
//   //     "className": "Continentscountriescities_Country",
//   //     "objectId": "Usa"
//   //   }
//   // }));
//   final response = await http.get(
//       Uri.parse(
//         'https://parseapi.back4app.com/classes/Continentscountriescities_City?limit=10',
//       ),
//       headers: {
//         "X-Parse-Application-Id":
//             "TCCR2oliqm854OjZaqrYGOQC3uRGigBoQss9qT2m", // This is your app's application id
//         "X-Parse-REST-API-Key":
//             "gYjX4gFM4Jhq96YbBxET6U10WXwmn18zhjrZeX5B" // This is your app's REST API key
//       });
//   if (response.statusCode == 200) {
//     print(response.body);
//     return json.decode(response.body);
//   } else {
//     throw Exception('Failed to fetch data');
//   }
// }

Future<List<String>> search(String val) async {
  List<String> city = [];
  String searchurl =
      "https://api.weatherapi.com/v1/search.json?key=4955768fd419412985392830221612&q=$val";
  final response = await http.get(Uri.parse(searchurl));

  if (response.statusCode == 200) {
    final datum = jsonDecode(response.body.toString());
    for (var data in datum) {
      city.add(data["name"]);
    }
    return city;
  } else {
    return [];
  }
}

//  final response = await http.get(
//     'https://parseapi.back4app.com/classes/Continentscountriescities_City?limit=1000000000000000000',
//     headers: {
//       "X-Parse-Application-Id": "TCCR2oliqm854OjZaqrYGOQC3uRGigBoQss9qT2m", // This is your app's application id
//       "X-Parse-REST-API-Key": "gYjX4gFM4Jhq96YbBxET6U10WXwmn18zhjrZeX5B" // This is your app's REST API key
//     }
//   );
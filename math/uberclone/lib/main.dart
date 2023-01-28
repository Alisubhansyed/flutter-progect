import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:  MyHome(),
    );
  }
}
class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
    options: MapOptions(
                center: LatLng(0.0, 0.0),
                
                        keepAlive: true,
                                rotation: 180.0,
                                        bounds: LatLngBounds(
            LatLng(51.74920, -0.56741),
            LatLng(51.25709, 0.34018),
        ),
        maxBounds: LatLngBounds(
            LatLng(-90, -180.0),
            LatLng(90.0, 180.0),
        ),
            zoom: 13.0,
        maxZoom: 19.0,
    ),
   
    children: [
        TileLayer(
            urlTemplate: 'https://api.mapbox.com/styles/v1/subhanali7865/cld1epfrf000r01lrhw7tzsts/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoic3ViaGFuYWxpNzg2NSIsImEiOiJjbGMzYXRvYnowaDQ2M3BwcDV0cHI5eHk4In0._BPkCaHnLGBLtFoR3C4VeQ',
            additionalOptions: {
              'accessToken':"pk.eyJ1Ijoic3ViaGFuYWxpNzg2NSIsImEiOiJjbGMzYXRvYnowaDQ2M3BwcDV0cHI5eHk4In0._BPkCaHnLGBLtFoR3C4VeQ",
              'id':'mapbox.mapbox-streets-v8'
            },
        ),
    ],
)
    );
  }
}

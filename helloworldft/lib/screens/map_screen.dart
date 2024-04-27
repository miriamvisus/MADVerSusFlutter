import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}
class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map View')),
      body: content(),
    );
  }
  Widget content(){
    return FlutterMap(
        options: MapOptions(
            initialCenter: LatLng(40.38923590951672, -3.627749768768932),
            initialZoom: 15,
            interactionOptions: const InteractionOptions(flags: InteractiveFlag.doubleTapZoom)
        ),
        children: [openStreetMapTileLayer,
          MarkerLayer(markers: [
            Marker(
                point: LatLng(40.38923590951672, -3.627749768768932),
                width: 80,
                height: 80,
                child: Stack(
                  children: [
                    Icon(
                      Icons.location_pin,
                      size: 60,
                      color: Colors.yellow,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.white,
                        child: Text(
                          'You are here!',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                )
            ),
            Marker(
                point: LatLng(40.38988743556828, -3.633014220376507),
                width: 60,
                height: 60,
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.location_pin,
                  size: 60,
                  color: Colors.red,
                )
            ),
            Marker(
                point: LatLng(40.39527505048739, -3.630359246796122),
                width: 60,
                height: 60,
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.location_pin,
                  size: 60,
                  color: Colors.green,
                )
            ),
            Marker(
                point: LatLng(40.39300371783269, -3.622394326054965),
                width: 60,
                height: 60,
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.location_pin,
                  size: 60,
                  color: Colors.blue,
                )
            ),
          ])]
    );
  }
}
TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
);
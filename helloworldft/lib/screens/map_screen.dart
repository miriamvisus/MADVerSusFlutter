import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '/db/database_helper.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> markers = [];
  List<LatLng> routeCoordinates = [];

  @override
  void initState() {
    super.initState();
    loadMarkers();
    loadRouteCoordinates();
  }
// Function to laod list of markers from database
  Future<void> loadMarkers() async {
    final dbMarkers = await DatabaseHelper.instance.getCoordinates();
    List<Marker> loadedMarkers = dbMarkers.map((record) {
      return Marker(
        point: LatLng(record['latitude'], record['longitude']),
        width: 80,
        height: 80,
        child: Icon(
          Icons.location_pin,
          size: 60,
          color: Colors.red,
        ),
      );
    }).toList();
    setState(() {
      markers = loadedMarkers;
    });
  }

  void loadRouteCoordinates() {
    // Load list of coordinates in the route
    routeCoordinates = [
      LatLng(40.41522618606088, -3.7082382465084205),
      LatLng(40.415215882676584, -3.708224713749277),
      LatLng(40.41514118309327, -3.7081874986616343),
      LatLng(40.41501925945729, -3.7081604331433486),
      LatLng(40.41502784563607, -3.708418683296992),
      LatLng(40.41478279537877, -3.7074455611863892),
      LatLng(40.41449687830483, -3.708166272267665),
      LatLng(40.414144534381, -3.708177651916317),
    ];
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('The Mesones Tour')),
      body: content(),
    );
  }
  Widget content() {
    return FlutterMap(
      options: MapOptions(
          initialCenter: LatLng(40.407621980242745, -3.517071770311644), // Centro inicial
          initialZoom: 15,
          interactionOptions: const InteractionOptions(flags: InteractiveFlag.all)),
      children: [
        openStreetMapTileLayer,
        MarkerLayer(markers: markers), // Marcadores cargados
        PolylineLayer(
          polylines: [
            Polyline(
              points: routeCoordinates,
              color: Colors.pink,
              strokeWidth: 8.0,
            ),
          ],
        ),
      ],
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
);
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'weather_screen.dart';
import '/db/database_helper.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  List<List<String>> _coordinates = [];
  List<List<String>> _dbCoordinates = []; // For coordinates from the database

  @override
  void initState() {
    super.initState();
    _loadCoordinates();
    _loadDbCoordinates();
  }

  Future<void> _loadCoordinates() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/gps_coordinates.csv');
    List<String> lines = await file.readAsLines();
    setState(() {
      _coordinates = lines.map((line) => line.split(';')).toList();
    });
  }

  Future<void> _loadDbCoordinates() async {
    List<Map<String, dynamic>> dbCoords = await DatabaseHelper.instance.getCoordinates();
    setState(() {
      _dbCoordinates = dbCoords.map((c) => [
        c['timestamp'].toString(), // Corrected
        c['latitude'].toString(), // Corrected
        c['longitude'].toString() // Corrected
      ]).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Locations'),
      ),
      body: ListView.builder(
        itemCount: _coordinates.length + _dbCoordinates.length, // Combined count
        itemBuilder: (context, index) {
          if (index < _coordinates.length) {
            var coord = _coordinates[index];
            var formattedDate = DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(int.parse(coord[0])));
            return ListTile(
              title: Text('Timestamp: $formattedDate'),
              subtitle: Text('Latitude: ${coord[1]}, Longitude: ${coord[2]}'),
            );
          } else {
            var dbIndex = index - _coordinates.length;
            var coord = _dbCoordinates[dbIndex];
            var formattedDate = DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(int.parse(coord[0])));
            return ListTile(
              title: Text('DB Timestamp: $formattedDate', style: TextStyle(color: Colors.blue)),
              subtitle: Text('Latitude: ${coord[1]}, Longitude: ${coord[2]}', style: TextStyle(color: Colors.blue)),
              onTap: () => _showDeleteDialog(coord[0]), // Passing timestamp to the delete dialog
              onLongPress: () => _showUpdateDialog(coord[0], coord[1], coord[2]),
            );
          }
        },
      ),
    );
  }

  void _showDeleteDialog(String timestamp) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm delete ${timestamp}"),
          content: Text("Do you want to delete this coordinate?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () async {
                await DatabaseHelper.instance.deleteCoordinate(timestamp);
                Navigator.of(context).pop(); // Dismiss the dialog
                _loadDbCoordinatesAndUpdate(); // Reload data and update UI
              },
            ),
            TextButton(
              child: Text("Weather"),
              onPressed: () {
                var coord = _dbCoordinates.firstWhere((element) => element[0] == timestamp);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeatherScreen(latitude: coord[1], longitude: coord[2])),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _loadDbCoordinatesAndUpdate() async {
    List<Map<String, dynamic>> dbCoords = await DatabaseHelper.instance.getCoordinates();
    setState(() {
      _dbCoordinates = dbCoords.map((c) => [
        c['timestamp'].toString(),
        c['latitude'].toString(),
        c['longitude'].toString()
      ]).toList();
    });
  }

  void _showUpdateDialog(String timestamp, String currentLat, String currentLong) {
    TextEditingController latController = TextEditingController(text: currentLat);
    TextEditingController longController = TextEditingController(text: currentLong);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update coordinates for ${timestamp}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: latController,
                decoration: InputDecoration(labelText: "Latitude"),
              ),
              TextField(
                controller: longController,
                decoration: InputDecoration(labelText: "Longitude"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Update"),
              onPressed: () async {
                Navigator.of(context).pop();
                await DatabaseHelper.instance.updateCoordinate(timestamp, latController.text, longController.text);
                _loadDbCoordinatesAndUpdate();
              },
            ),
            TextButton(
              child: Text("Weather"),
              onPressed: () {
                var coord = _dbCoordinates.firstWhere((element) => element[0] == timestamp);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeatherScreen(latitude: coord[1], longitude: coord[2])),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
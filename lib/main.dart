import 'package:flutter/material.dart';
import 'screens/homePage.dart';
import 'location.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final geoService = LocationService();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureProvider(
      create: (context) => geoService.getInitialPosition(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Consumer<Position>(
          builder: (context, position, widget) {
            return (position != null)
                ? HomeScreen(initialPosition: position)
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}

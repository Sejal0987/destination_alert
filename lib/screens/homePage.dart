import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../difference.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../constant.dart';

class HomeScreen extends StatefulWidget {
  final Position initialPosition;
  HomeScreen({this.initialPosition});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocationService geoService = LocationService();
  Completer<GoogleMapController> _completer = Completer();
  Map<MarkerId, Marker> markers = {};
  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  @override
  void initState() {
    geoService.getCurrentLocation().listen((position) {
      centerSceen(position);
      Diff diff = Diff(position);
      getPos(diff);
    });
    super.initState();
  }

  List<int> lst = [0];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
            child: GoogleMap(
              markers: Set<Marker>.of(markers.values),
              initialCameraPosition: CameraPosition(
                  target: LatLng(widget.initialPosition.latitude,
                      widget.initialPosition.longitude),
                  zoom: 18.0),
              mapType: MapType.normal,
              myLocationEnabled: true,
              tiltGesturesEnabled: true,
              compassEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  _completer.complete(controller);
                });
              },
            ),
          ),
          bottomNavigationBar: RawMaterialButton(
            fillColor: Colors.black,
            child: Text(
              'Distance- ${lst[0]}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )),
    );
  }

  Future<void> centerSceen(Position position) async {
    final GoogleMapController controller = await _completer.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 18.0)));
  }

  Future getPos(Diff diff) async {
    int dis = await diff.getDifference();
    print(dis);
    setState(() {
      lst.clear();
      lst.add(dis);
    });

    if (dis % 50 == 0) {
      Alert(
        context: context,
        type: AlertType.warning,
        title: "ALERT",
        desc: "Destination is ${dis} m away.",
        buttons: [
          DialogButton(
            child: Text(
              "Back",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }

    _addMarker(LatLng(l1.latitude, l1.longitude), "destination",
        BitmapDescriptor.defaultMarker);
  }
}

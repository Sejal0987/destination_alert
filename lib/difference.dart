import 'package:geodesy/geodesy.dart';
import 'package:geolocator/geolocator.dart';

class Diff {
  LatLng l2;
  Diff(Position position) {
    l2 = LatLng(position.latitude, position.longitude);
  }
  LatLng l1 = LatLng(22.690168712174096, 75.83777599885525);
  Future<int> getDifference() async {
    Geodesy geodesy = Geodesy();
    num distance = geodesy.distanceBetweenTwoGeoPoints(l1, l2);
    distance = distance.toInt();
    return distance;
  }
}

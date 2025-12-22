import 'package:geolocator/geolocator.dart';

class CurrentLocation{
  late Position position;
  Future<Position> getlocation() async{

    LocationPermission permission = await Geolocator.requestPermission();

      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

    print("POSITION on location is  :::: $position");
      return position;
  }
}
import 'package:parking_finder/service/location.dart';

class ParkingModel{
  Future<dynamic> getLocationWeather() async {
    Location location = new Location();
    await location.getCurrentLocation();

    //NetworkHelper networkHelper = NetworkHelper('?lat=${location.latitude}&lon=${location.longitude}');
    //var parkingData = await networkHelper.getData();
    return null;
  }
}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_finder/model/lat_lon.dart';
import 'package:parking_finder/ui/components/bottom_sheet_shape.dart';
import 'package:parking_finder/service/location.dart';
import 'location_view.dart';


enum SearchLocationType{myPosition,address,city}

class AppScreen extends StatefulWidget {
  @override
  _AppScreenState createState() => _AppScreenState();
}


class _AppScreenState extends State<AppScreen> {
  Completer<GoogleMapController> _controller = Completer();
  LatLon latLon;

  double zoom;
  CameraPosition _kCameraPosition = CameraPosition(
    target: LatLng(55.787519, 49.123687),
    zoom: 12,
  );

  void updateUI(dynamic locationData){
    setState(() {
      if(locationData==null){
        latLon = LatLon(lat: 55.787519, lon: 49.123687);
        return;
      }
      latLon =locationData;
    });
  }

  void updateLatLon(LatLon locationData){
    setState(() {
      if(locationData== null){
        return;
      }
      latLon =locationData;
    });
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 12,
            child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _kCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF29304a),
        onPressed:(){
          _openSignOutDrawer();
        },
        child: Icon(Icons.search,
            color: Colors.white),
      ),

      );
  }

  Future<void> searchPlace() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(latLon.lat, latLon.lon),
        tilt: 59.440717697143555,
        zoom: 16)
    ));
  }

  void _openSignOutDrawer() {
    showModalBottomSheet(
        shape: BottomSheetShape(),
        backgroundColor: Color(0xFF29304a),
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.only(
              top: 24,
              bottom: 16,
              left: 48,
              right: 48,
            ),
            height: 180,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "Где хотите искать свободные места?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: MaterialButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          Location location = Location();
                          await location.getCurrentLocation();
                          setState(() {
                            latLon = LatLon(lat: location.latitude, lon: location.longitude);
                          });
                          await searchPlace();
                        },
                        color: Color(0xFF23eacb),
                        child: Text(
                          "Рядом",
                          style: TextStyle(
                            color: Color(0xFF29304a),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: OutlineButton(
                        onPressed: () async{
                          Navigator.pop(context);
                          await Navigator.push(context, MaterialPageRoute(builder: (context){
                            return SearchLocationView(updateLocation: updateLatLon,);
                          }));
                          await searchPlace();
                        },
                        borderSide: BorderSide(
                          color: Color(0xFF23eacb),
                        ),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          "По адресу",
                          style: TextStyle(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

}




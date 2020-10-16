import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_finder/ui/components/bottom_sheet_shape.dart';
import 'package:parking_finder/service/location.dart';



class AppScreen extends StatefulWidget {
  @override
  _AppScreenState createState() => _AppScreenState();
}


class _AppScreenState extends State<AppScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(55.787519, 49.123687),
    zoom: 14.4746,
  );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 12,
            child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
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
          _openSignOutDrawer(context, _goToTheLake);
        },
        child: Icon(Icons.search,
            color: Colors.white),
      ),

      );
  }

  Future<void> _goToTheLake(double lat, double lon) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lat, lon),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414)
    ));
  }
}

void _openSignOutDrawer(BuildContext context, Function searchPlace) {
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
                        Location location = new Location();
                        await location.getCurrentLocation();
                        await searchPlace(location.latitude, location.longitude);
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
                      onPressed: () {},
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


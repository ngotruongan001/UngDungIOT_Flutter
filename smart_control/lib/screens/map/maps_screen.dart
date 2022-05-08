import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static LatLng _initialPosition = LatLng(16.032614, 108.221083);
  late Timer timer;
  bool _type = false;
  bool _remove = false;

  @override
  void initState() {
    super.initState();

    _getUserLocation();

  }
  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);

    });
    print('position: ${position.latitude}');
    print('position: ${position.longitude}');
    _addMarkerLongPressed(LatLng(position.latitude, position.longitude));

  }

  // LatLng _latlang = LatLng(16.032614, 108.221083);

  static CameraPosition _kGooglePlex = CameraPosition(
    target: _initialPosition,
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(16.028807, 108.215),
      tilt: 60,
      zoom: 19.151926040649414);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};



  Future<void> _goToMaker(LatLng latlang) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            bearing: 192.8334901395799,
            target: latlang,
            tilt: 60,
            zoom: 19.151926040649414)
    ));
  }

  Future<void> _removeMaker() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        _kGooglePlex
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          "Google Maps",
        ),
        actions: [
          if (_remove) Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: FlatButton(
              onPressed: (){
                setState(() {
                  _remove = false;
                  markers = <MarkerId, Marker>{};
                });
                _removeMaker();
              },
              child: Icon(
                Icons.remove_circle_outline,
                color: Colors.red,
                size: 24.0,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
            ),
          )else(
              FlatButton(
                onPressed: (){
                  _getUserLocation();
                },
                child: Text("location", style: TextStyle(color: Colors.white),),
              )
          )
        ],
      ),
      body: GoogleMap(
        mapType: _type ? MapType.hybrid : MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: markers.values.toSet(),
        onLongPress: (latlang) {
          print(latlang);
          _addMarkerLongPressed(latlang); //we will call this function when pressed on the map
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Row(
          children: [
            FloatingActionButton(
              onPressed: (){
                _getUserLocation();
                this.setState(() {
                  _type = !_type;
                });
              },
              child: _type ? Icon(Icons.add_photo_alternate_outlined) : Icon(Icons.add_photo_alternate),
            ),
            SizedBox(
              width: 20.0,
            ),
            FloatingActionButton.extended(
              onPressed: _goToTheLake,
              label: Text('To the Park!'),
              icon: Icon(Icons.directions_boat),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    setState(() {
      _remove = true;
    });
  }



  Future _addMarkerLongPressed(LatLng latlang) async {

    setState(() {
      final MarkerId markerId = MarkerId("RANDOM_ID");
      Marker marker = Marker(
        markerId: markerId,
        draggable: true,
        position: latlang, //With this parameter you automatically obtain latitude and longitude
        infoWindow: InfoWindow(
          title: "Here",
          snippet: 'This looks good',
        ),
        icon: BitmapDescriptor.defaultMarker,
        onTap: (){
          _goToMaker(latlang);
        },
      );
      markers[markerId] = marker;
      _remove = true;
    });

    //This is optional, it will zoom when the marker has been created
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(latlang, 17.0));
  }
}
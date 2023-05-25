import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../resourse/app_colors.dart';
import '../../../../../../resourse/images.dart';
import '../../../../../../resourse/strings.dart';

class MapScreen extends StatefulWidget {
  MapScreen({this.lat, this.long});
  double? lat;
  double? long;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _googleMapController;
  Marker? _origin;
  Marker? _destination;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.lat ?? 0, widget.long ?? 0),
              zoom: 11.5,
            ),
            onMapCreated: (controller) => _googleMapController = controller,
            markers: <Marker>{
              Marker(
                markerId: MarkerId('marker_1'),
                position: LatLng(widget.lat ?? 0, widget.long ?? 0),
              )
            },
            onLongPress: _addMarker,
          ),
          Positioned(
            right: 0.0,
            left: 0.0,
            child: Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                  Images.ic_close_in_circle,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),

          // address was show on map screen:
          // Positioned(
          //   bottom: 0.0,
          //   right: 0.0,
          //   left: 0.0,
          //   child: Padding(
          //     padding: const EdgeInsets.all(16.0),
          //     child: SizedBox(
          //       height: 100,
          //       width: 100,
          //       child: Card(
          //         child: Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Column(
          //             children: const [
          //               Text(
          //                 'Bedford hospital NHS trust',
          //                 style: TextStyle(
          //                   fontSize: 18.0,
          //                   fontWeight: FontWeight.w500,
          //                 ),
          //               ),
          //               SizedBox(
          //                 height: 8.0,
          //               ),
          //               Text(
          //                 '206, Shivalik 2, Between Shyamal to Shivranjni, near IOC Petrol Pump, Satellite, Ahmedabad, Gujarat 380015',
          //                 style: TextStyle(
          //                   fontSize: 12.0,
          //                   fontWeight: FontWeight.w400,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(widget.lat!, widget.long!),
            ),
          ),
        ),
        backgroundColor: AppColors.kDefaultPurpleColor,
        child: const Icon(Icons.center_focus_strong_outlined),
      ),
    );
  }

  void _addMarker(LatLng pos) {
    if (_origin == null || (_origin != null && _destination != null)) {
      //set origin
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        //Reset deatination
        _destination = Strings.text_null as Marker;
      });
    } else {
      // set destination
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });
    }
  }
}

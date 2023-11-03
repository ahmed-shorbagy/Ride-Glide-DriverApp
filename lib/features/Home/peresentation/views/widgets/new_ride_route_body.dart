import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_glide_driver_app/constants.dart';
import 'package:location/location.dart';
import 'package:ride_glide_driver_app/core/utils/App_images.dart';
import 'package:ride_glide_driver_app/core/utils/methods.dart';
import 'package:ride_glide_driver_app/features/Home/peresentation/manager/New_Ride_cubit/new_ride_cubit.dart';

class NewRideRouteBody extends StatefulWidget {
  const NewRideRouteBody({
    super.key,
  });

  @override
  State<NewRideRouteBody> createState() => _NewRideRouteBodyState();
}

class _NewRideRouteBodyState extends State<NewRideRouteBody> {
  final Location _locationController = Location();
  BitmapDescriptor locationMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationMarkerIcon = BitmapDescriptor.defaultMarker;

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  bool _isMounted = false;

  LatLng _currentP = const LatLng(30.0444, 31.2357);

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();

    _isMounted = true;

    getLocationUpdates().then((_) {
      if (_isMounted) {
        getPolylinePoints().then((coordinates) {
          if (_isMounted) {
            generatePolyLineFromPoints(coordinates);
          }
        });
      }
    });
    getBytesFromAsset(Assets.CarMarkerIcon, 100).then((onValue) {
      locationMarkerIcon = BitmapDescriptor.fromBytes(onValue);
    });
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: ((GoogleMapController controller) {
        if (Theme.of(context).brightness == Brightness.dark) {
          controller.setMapStyle(darkMapStyle);
        } else {
          controller.setMapStyle(lightMapStyle);
        }
        _mapController.complete(controller);
      }),
      initialCameraPosition: CameraPosition(
        target: _currentP,
        zoom: 13,
      ),
      markers: {
        Marker(
          markerId: const MarkerId("_currentLocation"),
          icon: locationMarkerIcon,
          position: _currentP,
        ),
        Marker(
            markerId: const MarkerId("_destionationLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: LatLng(NewRideCubit.ride!.lat!, NewRideCubit.ride!.lng!))
      },
      polylines: Set<Polyline>.of(polylines.values),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (_isMounted) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_currentP);
        });
      }
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      kGoogleRoutesKey,
      PointLatLng(_currentP.latitude, _currentP.longitude),
      PointLatLng(NewRideCubit.ride!.lat!, NewRideCubit.ride!.lng!),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {}
    return polylineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.amber,
        points: polylineCoordinates,
        width: 8);
    setState(() {
      polylines[id] = polyline;
    });
  }
}

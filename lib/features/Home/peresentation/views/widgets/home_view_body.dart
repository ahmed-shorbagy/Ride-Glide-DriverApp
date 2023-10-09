import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_glide_driver_app/core/utils/App_images.dart';
import 'package:ride_glide_driver_app/core/utils/methods.dart';
import 'package:ride_glide_driver_app/core/utils/size_config.dart';
import 'package:ride_glide_driver_app/features/Home/peresentation/views/widgets/Custom_bottomBar.dart';
import 'package:ride_glide_driver_app/features/auth/data/AuthRepo/authRepoImpl.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/manager/cubit/email_paswword_cubit.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/views/widgets/custom_button.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({Key? key}) : super(key: key);

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody>
    with WidgetsBindingObserver {
  GoogleMapController? mapController;
  LatLng currentPosition = const LatLng(30.0444, 31.2357);
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  AppLifecycleState appLifecycleState = AppLifecycleState.resumed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    determinePosition();

    getBytesFromAsset(Assets.MarkerIcon, 100).then((onValue) {
      markerIcon = BitmapDescriptor.fromBytes(onValue);
    });
    BlocProvider.of<EmailPaswwordCubit>(context)
        .updateDriverStatus(status: true);
    didChangeAppLifecycleState(appLifecycleState);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        AuthRepo.trackUserActivity();
      },
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
            initialCameraPosition: const CameraPosition(
                target: LatLng(30.0444, 31.2357), zoom: 14),
            markers: {
              Marker(
                  markerId: const MarkerId(
                    'current location',
                  ),
                  icon: markerIcon,
                  position: currentPosition,
                  infoWindow: const InfoWindow(
                    title: 'Current location',
                  ))
            },
            mapType: MapType.terrain,
            myLocationEnabled: true,
            compassEnabled: true,
          ),
          Positioned(
            bottom: SizeConfig.screenhieght! * 0.2,
            right: SizeConfig.screenhieght! * 0.06,
            child: SizedBox(
              height: 50,
              width: 50,
              child: FloatingActionButton(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                backgroundColor: Colors.white,
                onPressed: () async {
                  determinePosition().then((position) {
                    LatLng newLatLng =
                        LatLng(position.latitude, position.longitude);
                    setState(() {
                      currentPosition = newLatLng;
                    });

                    mapController?.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(target: newLatLng, zoom: 17),
                      ),
                    );
                  }).catchError((error) {
                    debugPrint('Error: $error');
                  });
                },
                child: Image.asset(
                  Assets.LocationIcon,
                  scale: 1.9,
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 0,
            child: CustomBottombar(),
          ),
          Positioned(
            top: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomButton(
                  backgroundColor: const Color(0xff8AD4B5),
                  onPressed: () {},
                  title: const Icon(
                    Icons.menu,
                    color: Colors.black,
                  )),
            ),
          ),
          Positioned(
            top: 60,
            right: 15,
            child: CustomButton(
                backgroundColor: Colors.white,
                onPressed: () {},
                title: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black,
                )),
          ),
        ],
      ),
    );
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size.fromRadius(24)),
      Assets.MarkerIcon,
    ).then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      appLifecycleState = state; // Store the current app lifecycle state
    });

    if (state == AppLifecycleState.resumed) {
      // App has come into the foreground

      AuthRepo.resetStatusUpdateTimer(); // Reset the inactivity timer
    } else {
      // App is in the background or closed
      AuthRepo.updateDriverStatus(status: false);
    }
  }
}
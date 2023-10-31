import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_glide_driver_app/core/utils/App_router.dart';
import 'package:ride_glide_driver_app/core/utils/size_config.dart';
import 'package:ride_glide_driver_app/features/Home/data/models/ride_model.dart';
import 'package:ride_glide_driver_app/features/Home/data/repos/Home_repo_implementation.dart';
import 'package:ride_glide_driver_app/features/Home/peresentation/manager/New_Ride_cubit/new_ride_cubit.dart';
import 'package:ride_glide_driver_app/features/Home/peresentation/views/widgets/custom_new_ride_card.dart';

class ListenForRides extends StatefulWidget {
  const ListenForRides({
    super.key,
  });

  @override
  _ListenForRidesState createState() => _ListenForRidesState();
}

class _ListenForRidesState extends State<ListenForRides> {
  List<RideModel> rideRequests = [];
  StreamSubscription<List<RideModel>>? _streamSubscription;
  @override
  void initState() {
    super.initState();
    _streamSubscription =
        HomeRepoImpl.rideRequestsStreamController.stream.listen((data) {
      setState(() {
        rideRequests = data;
      });
      AudioPlayer()
          .play(AssetSource('notifications-sound-127856.mp3'), volume: 100);
    });
  }

  @override
  void dispose() {
    _streamSubscription
        ?.cancel(); // Cancel the subscription when disposing the widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 150),
      child: SizedBox(
        height: SizeConfig.screenhieght! * 0.4,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: rideRequests.length,
          itemBuilder: (context, index) {
            NewRideCubit.ride = rideRequests[index];
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomNewRideCard(
                  ride: rideRequests[index],
                  onAccept: () async {
                    await HomeRepoImpl.updateRideStatus(
                      uID: rideRequests[index].userUId!,
                      status: true,
                    );
                    setState(() {
                      rideRequests.removeAt(index);
                    });
                    GoRouter.of(context).push(AppRouter.kNewRideRouteView);
                  },
                  onCancel: () async {
                    await HomeRepoImpl.updateRideStatus(
                      uID: rideRequests[index].userUId!,
                      status: false,
                    );
                    setState(() {
                      rideRequests.removeAt(index);
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

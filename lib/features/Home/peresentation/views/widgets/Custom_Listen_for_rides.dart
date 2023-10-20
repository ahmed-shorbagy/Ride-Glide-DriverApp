import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:ride_glide_driver_app/core/utils/size_config.dart';
import 'package:ride_glide_driver_app/features/Home/data/models/ride_model.dart';
import 'package:ride_glide_driver_app/features/Home/data/repos/Home_repo_implementation.dart';
import 'package:ride_glide_driver_app/features/Home/peresentation/views/widgets/custom_new_ride_card.dart';

class ListenForRides extends StatelessWidget {
  const ListenForRides({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RideModel>>(
      stream: HomeRepoImpl.rideRequestsStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            List<RideModel> rideRequests = snapshot.data!;
            AudioPlayer().play(AssetSource('notifications-sound-127856.mp3'),
                volume: 100);
            return Padding(
              padding: const EdgeInsets.only(top: 150),
              child: SizedBox(
                height: SizeConfig.screenhieght! * 0.4,
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: rideRequests.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomNewRideCard(
                            ride: rideRequests[index],
                            onAccept: () async {
                              await HomeRepoImpl.updateRideStatus(
                                  uID: rideRequests[index].userUId!,
                                  status: true);
                              await HomeRepoImpl.deleteTHeRide(
                                  uid: rideRequests[index].userUId!);
                              rideRequests.clear();
                            },
                            onCancel: () async {
                              await HomeRepoImpl.updateRideStatus(
                                  uID: rideRequests[index].userUId!,
                                  status: false);

                              await HomeRepoImpl.deleteTHeRide(
                                  uid: rideRequests[index].userUId!);
                              rideRequests.clear();
                            },
                          ),
                        ),
                      );
                    }),
              ),
            );
          } else {
            // Handle when there are no ride requests
            return const Text('No ride requests available.');
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          // Handle other connection states
          return const Text('Error: Unable to retrieve ride requests.');
        }
      },
    );
  }
}

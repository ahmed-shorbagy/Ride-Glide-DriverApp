import 'package:flutter/material.dart';
import 'package:ride_glide_driver_app/core/utils/size_config.dart';
import 'package:ride_glide_driver_app/features/Home/data/models/ride_model.dart';
import 'package:ride_glide_driver_app/features/Home/peresentation/views/widgets/custom_network_image.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/views/widgets/custom_button.dart';

class CustomNewRideCard extends StatelessWidget {
  const CustomNewRideCard({
    super.key,
    required this.ride,
    required this.onAccept,
    required this.onCancel,
  });
  final RideModel ride;
  final void Function() onAccept;
  final void Function() onCancel;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        color: const Color(0xff08B783).withOpacity(0.9),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('You Have a New Trip !',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Text(
                      '${ride.clientName}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: SizedBox(
                      width: SizeConfig.screenwidth! * 0.5,
                      height: SizeConfig.screenwidth! * 0.1,
                      child: Text(
                        '${ride.locationAddress}  ',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: SizedBox(
                      width: SizeConfig.screenwidth! * 0.5,
                      height: SizeConfig.screenwidth! * 0.1,
                      child: Text(
                        '${ride.destinationAddress}  ',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      children: [
                        Text('${ride.paymentMethod} ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: CustomNetworkImage(ride: ride),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            width: SizeConfig.screenwidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                      onPressed: onAccept,
                      title: const Text('Cancel'),
                      backgroundColor: Theme.of(context).primaryColor),
                  CustomButton(
                      onPressed: onCancel,
                      title: const Text('Accept'),
                      backgroundColor: Theme.of(context).primaryColor),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

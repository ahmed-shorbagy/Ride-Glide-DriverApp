import 'package:flutter/material.dart';
import 'package:ride_glide_driver_app/core/utils/App_images.dart';
import 'package:ride_glide_driver_app/core/utils/size_config.dart';
import 'package:ride_glide_driver_app/features/Home/data/models/place_model/place_model.dart';

class PlacesCustomListItem extends StatelessWidget {
  const PlacesCustomListItem({
    super.key,
    required this.place,
    required this.onTap,
  });
  final PlaceModel place;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                Assets.MarkerIcon,
                scale: 4,
              ),
              Text(
                place.structuredFormatting?.mainText ?? 'nullllllllllllll',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(
                width: 30,
              ),
              SizedBox(
                width: SizeConfig.screenwidth! * 0.84,
                child: Text(
                  place.description ?? 'error',
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

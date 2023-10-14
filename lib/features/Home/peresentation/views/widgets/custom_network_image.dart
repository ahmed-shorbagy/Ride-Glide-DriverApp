import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ride_glide_driver_app/features/Home/data/models/ride_model.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.ride,
  });

  final RideModel ride;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const ShapeDecoration(
        shape: OvalBorder(),
        color: Color(0xffD0D0D0),
      ),
      height: 80,
      width: 80,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(120),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: ride.clientImageUrl ?? '',
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}

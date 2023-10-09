import 'package:flutter/material.dart';
import 'package:ride_glide_driver_app/core/utils/App_images.dart';
import 'package:ride_glide_driver_app/core/utils/size_config.dart';
import 'package:ride_glide_driver_app/features/Home/peresentation/views/widgets/Custom_icon_wihtLabel.dart';
import 'package:ride_glide_driver_app/features/Home/peresentation/views/widgets/custom_hexagon_withLabel.dart';

class CustomBottombar extends StatelessWidget {
  const CustomBottombar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenwidth,
      height: 80,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
      ),
      child: SizedBox(
        width: SizeConfig.screenwidth,
        child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              const Row(
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: IconWithLabel(
                        imageName: Assets.HomeIcon,
                        label: 'Home',
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: IconWithLabel(
                        imageName: Assets.HeartIcon,
                        label: 'Favourite',
                      )),
                  SizedBox(
                    width: 50,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: IconWithLabel(
                        imageName: Assets.DicountIcon,
                        label: 'Offer',
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: IconWithLabel(
                        imageName: Assets.UserIcon,
                        label: 'Profile',
                      )),
                ],
              ),
              Positioned(
                  bottom: 19,
                  left: SizeConfig.screenwidth! * 0.38,
                  child: const CustomhexagonWithLabel()),
            ]),
      ),
    );
  }
}

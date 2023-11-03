import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ride_glide_driver_app/constants.dart';
import 'package:ride_glide_driver_app/core/utils/App_router.dart';
import 'package:ride_glide_driver_app/core/utils/methods.dart';
import 'package:ride_glide_driver_app/features/Home/peresentation/views/widgets/Custom_bottomBar.dart';
import 'package:ride_glide_driver_app/features/Home/peresentation/views/widgets/custom_profile_data.dart';
import 'package:ride_glide_driver_app/features/auth/data/AuthRepo/authRepoImpl.dart';
import 'package:ride_glide_driver_app/features/auth/data/models/driver_Model.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/views/widgets/custom_button.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    DriverModel user = Hive.box<DriverModel>(kDriverBox).values.first;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 26),
                        child: CustomProfileHeadLine(),
                      ),
                      CustomProfileData(user: user),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 32, horizontal: 16),
                        child: CustomButton(
                          onPressed: () async {
                            try {
                              await auth.signOut();
                              GoRouter.of(context)
                                  .pushReplacement(AppRouter.kSignInView);
                            } catch (e) {
                              snackBar(context, e.toString());
                            }
                          },
                          title: Text(
                            'Log Out',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Align(
              alignment: FractionalOffset.bottomCenter,
              child: CustomBottombar()),
        ],
      ),
    );
  }
}

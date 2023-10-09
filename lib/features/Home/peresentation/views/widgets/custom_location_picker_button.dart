import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_glide_driver_app/core/utils/size_config.dart';
import 'package:ride_glide_driver_app/features/Home/peresentation/manager/places_details_cubit/place_details_cubit.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/views/widgets/custom_button.dart';

class CustomLocationPickerButton extends StatelessWidget {
  const CustomLocationPickerButton({
    super.key,
    required this.onPressed,
  });
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 60),
      child: SizedBox(
        width: SizeConfig.screenwidth,
        child: BlocConsumer<PlaceDetailsCubit, PlaceDetailsState>(
            listener: (context, state) async {
          if (state is PlaceDetailsSuccess) {
            if (PlaceDetailsCubit.isFrom) {
              PlaceDetailsCubit.fromPLaceDetails = state.placeDetails;
            }
            if (PlaceDetailsCubit.isTO) {
              PlaceDetailsCubit.toPLaceDetails = state.placeDetails;
            }
            debugPrint(
                ' this is the fromm placee===  ${PlaceDetailsCubit.fromPLaceDetails}    and this is tyhe Toooo placee ==== ${PlaceDetailsCubit.toPLaceDetails}');
          }
        }, builder: (context, state) {
          if (state is PlaceDetailsSuccess) {
            return CustomButton(
              onPressed: onPressed,
              title:
                  Text('Done', style: Theme.of(context).textTheme.titleSmall),
              backgroundColor: Theme.of(context).primaryColor,
            );
          } else if (state is PlaceDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const SizedBox();
          }
        }),
      ),
    );
  }
}

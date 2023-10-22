import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ride_glide_driver_app/features/Home/data/models/ride_model.dart';

part 'new_ride_state.dart';

class NewRideCubit extends Cubit<NewRideState> {
  NewRideCubit() : super(NewRideInitial());
  static RideModel? ride;
}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ride_glide_driver_app/features/auth/data/models/driver_Model.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  static DriverModel driver = DriverModel(phone: '');
  UserCubit() : super(UserInitial());
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:ride_glide_driver_app/constants.dart';
import 'package:ride_glide_driver_app/core/utils/App_router.dart';
import 'package:ride_glide_driver_app/core/utils/methods.dart';
import 'package:ride_glide_driver_app/features/auth/data/AuthRepo/authRepoImpl.dart';
import 'package:ride_glide_driver_app/features/auth/data/models/driver_Model.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/manager/cubit/email_paswword_cubit.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/manager/cubit/get_userData_cubit/get_user_data_cubit.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/manager/cubit/user_cubit.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/views/widgets/custom_button.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/views/widgets/custom_text_search_field.dart';

class InputFieldsSectionForSignIn extends StatefulWidget {
  const InputFieldsSectionForSignIn({
    super.key,
  });

  @override
  State<InputFieldsSectionForSignIn> createState() =>
      _InputFieldsSectionForSignInState();
}

class _InputFieldsSectionForSignInState
    extends State<InputFieldsSectionForSignIn> {
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  String? email;

  String? password;

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: autoValidateMode,
      key: formKey,
      child: BlocListener<GetUserDataCubit, GetUserDataState>(
        listener: (context, state) {
          if (state is GetUserDataSuccess) {
            UserCubit.driver = state.driver;
            var newuserbox = Hive.box<DriverModel>(kDriverBox);
            newuserbox.clear();
            newuserbox.put('driver', UserCubit.driver);

            debugPrint(
                'THIS IS THE driver INFO   ${newuserbox.values.first.adress} ${newuserbox.values.first.city}     ${newuserbox.values.first.name}  ${newuserbox.values.first.email}  ${newuserbox.values.first.gender}  ${newuserbox.values.first.phone}  ${newuserbox.values.first.imageUrl}  ${newuserbox.values.first.uId}');
          } else if (state is GetUserDataFaluire) {
            snackBar(context, state.errMessage);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: CustomTextField(
                onChanged: (value) {
                  email = value;
                },
                hintText: ' Enter Your Email',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: CustomTextField(
                hintText: 'Enter Your Password',
                onChanged: (value) {
                  password = value;
                },
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            GestureDetector(
              onTap: () {
                GoRouter.of(context)
                    .pushReplacement(AppRouter.kverifyEmailView);
              },
              child: Text(
                'Forget password?',
                textAlign: TextAlign.right,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.red, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(
              height: 38,
            ),
            BlocConsumer<EmailPaswwordCubit, EmailPaswwordState>(
              listener: (context, state) async {
                if (state is EmailPaswwordSuccess) {
                  await BlocProvider.of<GetUserDataCubit>(context)
                      .getUserData(uId: auth.currentUser?.uid ?? "err");
                  GoRouter.of(context).pushReplacement(AppRouter.kHomeView);
                }
                if (state is EmailPaswwordFaluire) {
                  snackBar(context, state.errMessage);
                }
              },
              builder: (context, state) {
                return CustomButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        await BlocProvider.of<EmailPaswwordCubit>(context)
                            .signInUser(email: email!, password: password!);
                        await BlocProvider.of<EmailPaswwordCubit>(context)
                            .updateDriverStatus(status: true);
                      }
                    },
                    title: state is EmailPaswwordLoadin
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Text(
                            'Sign In as a Driver',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: Colors.white, fontSize: 16),
                          ),
                    backgroundColor: Theme.of(context).primaryColor);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UserModel {}

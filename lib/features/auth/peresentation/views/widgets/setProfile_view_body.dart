import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_glide_driver_app/constants.dart';
import 'package:ride_glide_driver_app/core/utils/App_router.dart';
import 'package:ride_glide_driver_app/core/utils/size_config.dart';
import 'package:ride_glide_driver_app/features/auth/data/AuthRepo/authRepoImpl.dart';
import 'package:ride_glide_driver_app/features/auth/data/models/driver_Model.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/manager/cubit/email_paswword_cubit.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/manager/cubit/update_image_cubit.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/manager/cubit/user_cubit.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/views/widgets/Custom_appBar.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/views/widgets/custom_button.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/views/widgets/custom_pickImage_button.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/views/widgets/custom_text_search_field.dart';

class SetProfileViewBody extends StatefulWidget {
  const SetProfileViewBody({super.key});

  @override
  State<SetProfileViewBody> createState() => _SetProfileViewBodyState();
}

class _SetProfileViewBodyState extends State<SetProfileViewBody> {
  File? selectedImage;
  String? selectedImagePath;
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60, bottom: 30),
              child: Row(
                children: [
                  const CustomAppBar(),
                  SizedBox(
                    width: SizeConfig.screenwidth! * 0.26,
                  ),
                  Text(
                    'Profile',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Center(
              child: CustomPickImageButton(
                child: selectedImage == null
                    ? null
                    : Image.file(selectedImage!, fit: BoxFit.fill),
                onTap: () async {
                  await pickImageFromGallery();
                  setState(() {
                    selectedImagePath = selectedImage?.path ?? '';
                  });
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: CustomTextField(
                  onChanged: (value) {
                    UserCubit.driver.carType = value;
                  },
                  hintText: 'Car Type'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: CustomTextField(
                  onChanged: (value) {
                    UserCubit.driver.adress = value;
                  },
                  hintText: 'Adress'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: CustomTextField(
                  onChanged: (value) {
                    UserCubit.driver.carColor = value;
                  },
                  hintText: 'Car Color'),
            ),
            SizedBox(
              height: SizeConfig.screenhieght! * 0.28,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CustomButton(
                          onPressed: () {},
                          title: Text(
                            'Cancel',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          backgroundColor: Colors.white),
                    ),
                    SizedBox(
                      width: SizeConfig.defaultSize! * 2,
                    ),
                    Expanded(
                      child: BlocListener<UpdateImageCubit, UpdateImageState>(
                        listener: (context, state) async {
                          if (state is UpdateImageSuccess) {
                            UserCubit.driver.imageUrl = state.imageUrl;
                            UserCubit.driver.status = true;
                            GoRouter.of(context)
                                .pushReplacement(AppRouter.kHomeView);

                            await BlocProvider.of<EmailPaswwordCubit>(context)
                                .addDriverToFireStore(driver: UserCubit.driver);
                          }
                        },
                        child: CustomButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();

                                await BlocProvider.of<UpdateImageCubit>(context)
                                    .uploadDriverImageToFirebase(
                                        imagePath: selectedImagePath ?? '');

                                var newuserbox =
                                    Hive.box<DriverModel>(kDriverBox);
                                if (newuserbox.isNotEmpty) {
                                  newuserbox.deleteAt(0);
                                }

                                await newuserbox.add(UserCubit.driver);
                                AuthRepo.updateDriverStatus(status: true);
                              }
                            },
                            title: const Text('Save'),
                            backgroundColor: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future pickImageFromGallery() async {
    final returnedIamge =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedIamge == null) return;
    setState(() {
      selectedImage = File(returnedIamge.path);
    });
  }
}

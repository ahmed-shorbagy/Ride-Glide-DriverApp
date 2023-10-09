import 'package:flutter/material.dart';
import 'package:ride_glide_driver_app/core/utils/App_images.dart';

class CustomMapTextField extends StatelessWidget {
  const CustomMapTextField(
      {super.key, required this.onChanged, required this.onTap});
  final void Function(String) onChanged;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onChanged: onChanged,
      onTap: onTap,
      decoration: InputDecoration(
          hintText: 'Where would you go?',
          hintStyle: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.grey),
          suffixIcon: Image.asset(
            Assets.HeartIcon,
            scale: 1.7,
          ),
          prefixIcon: Image.asset(
            Assets.SearchIcon,
            scale: 1.7,
          ),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          fillColor: const Color(0xffE2F5ED)),
    );
  }
}

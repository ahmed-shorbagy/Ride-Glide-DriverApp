import 'package:flutter/material.dart';
import 'package:ride_glide_driver_app/features/Home/peresentation/views/widgets/new_ride_route_body.dart';

class NewRideRouteView extends StatelessWidget {
  const NewRideRouteView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Screen'),
      ),
      body: const NewRideRouteBody(),
    );
  }
}

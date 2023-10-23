import 'package:flutter/material.dart';
import 'package:ride_glide_driver_app/features/Home/peresentation/views/widgets/Custom_nav_drawer.dart';

import 'widgets/home_view_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      key: scaffoldKey,
      body: const HomeViewBody(),
    );
  }
}

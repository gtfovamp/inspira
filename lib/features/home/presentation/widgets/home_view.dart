import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/app_background.dart';
import '../bloc/home_bloc.dart';
import 'home_app_bar.dart';
import 'home_gallery.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppBackground(),
          Column(
            children: [
              const HomeAppBar(),
              Expanded(
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    return HomeGallery(state: state);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
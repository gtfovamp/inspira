import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../bloc/home_bloc.dart';
import '../widgets/home_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  late HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = sl<HomeBloc>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Загружаем изображения при первом открытии
    _homeBloc.add(GetImagesEvent());
  }

  // Обновляем данные при возврате на экран
  void didPopNext() {
    if (mounted) {
      _homeBloc.add(RefreshImagesEvent());
    }
  }

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeBloc,
      child: const HomeView(),
    );
  }
}
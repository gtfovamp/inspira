import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

// Auth
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// Home
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_images_usecase.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';

// Image
import '../../features/image/data/datasources/image_remote_data_source.dart';
import '../../features/image/data/repositories/image_repository_impl.dart';
import '../../features/image/domain/repositories/image_repository.dart';
import '../../features/image/domain/usecases/image_usecases.dart';
import '../../features/image/presentation/bloc/image_bloc.dart';
import '../../shared/services/notification_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initAuth();
  await _initHome();
  await _initImage();
  await _initCore();
}

Future<void> _initAuth() async {
  sl.registerFactory(() => AuthBloc(authRepository: sl()));

  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(firebaseAuth: sl()),
  );
}

Future<void> _initHome() async {
  sl.registerFactory(() => HomeBloc(getImagesUseCase: sl()));

  sl.registerLazySingleton(() => GetImagesUseCase(sl()));

  sl.registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<HomeRemoteDataSource>(
        () => HomeRemoteDataSourceImpl(
      firestore: sl(),
      firebaseAuth: sl(),
    ),
  );
}

Future<void> _initImage() async {
  // BLoC
  sl.registerFactory(() => ImageBloc(
    saveImageUseCase: sl(),
    getImageUseCase: sl(),
    notificationService: sl(),
  ));

  // Use cases
  sl.registerLazySingleton(() => SaveImageUseCase(sl()));
  sl.registerLazySingleton(() => GetImageUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ImageRepository>(
        () => ImageRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ImageRemoteDataSource>(
        () => ImageRemoteDataSourceImpl(
      firestore: sl(),
      firebaseAuth: sl(),
    ),
  );
}

Future<void> _initCore() async {
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => NotificationService());
}
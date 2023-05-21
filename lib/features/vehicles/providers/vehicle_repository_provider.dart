// coverage:ignore-file
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_app/features/user/presentation/providers/user_repository_provider.dart';
import 'package:parking_app/features/vehicles/data/vehicles_repository.dart';
import 'package:parking_app/features/vehicles/data/vehicles_repository_impl.dart';
import 'package:parking_app/features/vehicles/domain/vehicles_interactor.dart';
import 'package:parking_app/features/vehicles/domain/vehicles_interactor_impl.dart';
import 'package:http/http.dart' as http;

final vehicleRepositoryProvider = Provider<VehiclesRepository>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return VehiclesRepositoryImpl(http.Client(), userRepository);
});

final vehicleInteractorProvider = Provider<VehiclesInteractor>((ref) {
  final repository = ref.watch(vehicleRepositoryProvider);
  final interactor = VehiclesInteractorImpl(repository);

  return interactor;
});

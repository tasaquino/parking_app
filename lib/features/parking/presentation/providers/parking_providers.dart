import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_app/features/parking/data/parking_repository.dart';
import 'package:parking_app/features/parking/data/parking_repository_impl.dart';
import 'package:http/http.dart' as http;
import 'package:parking_app/features/parking/domain/parking_interactor.dart';
import 'package:parking_app/features/parking/domain/parking_interactor_impl.dart';
import 'package:parking_app/features/parking/presentation/providers/parking_notifier.dart';
import 'package:parking_app/features/parking/presentation/providers/parking_state.dart';
import 'package:parking_app/features/user/presentation/providers/user_repository_provider.dart';
import 'package:parking_app/features/vehicles/providers/vehicle_repository_provider.dart';

final parkingRepositoryProvider = Provider<ParkingRepository>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return ParkingRepositoryImpl(http.Client(), userRepository);
});

final parkingInteractorProvider = Provider<ParkingInteractor>((ref) {
  final vehicleRepository = ref.watch(vehicleRepositoryProvider);
  final parkingRepository = ref.watch(parkingRepositoryProvider);
  final interactor =
      ParkingInteractorImpl(parkingRepository, vehicleRepository);

  return interactor;
});

final parkingNotifierProvider =
    StateNotifierProvider<ParkingNotifier, ParkingState>((ref) {
  final interactor = ref.watch(parkingInteractorProvider);

  return ParkingNotifier(interactor);
});

// coverage:ignore-file
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_app/features/vehicles/presentation/providers/detail/vehicle_detail_notifier.dart';
import 'package:parking_app/features/vehicles/presentation/providers/detail/vehicle_detail_states.dart';
import 'package:parking_app/features/vehicles/providers/vehicle_repository_provider.dart';

final vehicleDetailNotifierProvider =
    StateNotifierProvider<VehicleDetailNotifier, VehicleDetailState>((ref) {
  final interactor = ref.watch(vehicleInteractorProvider);
  return VehicleDetailNotifier(interactor);
});

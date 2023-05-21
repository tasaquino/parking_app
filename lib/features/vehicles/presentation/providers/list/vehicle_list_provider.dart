import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_app/features/vehicles/presentation/providers/list/vehicle_list_notifier.dart';
// coverage:ignore-file
import 'package:parking_app/features/vehicles/presentation/providers/list/vehicle_list_states.dart';
import 'package:parking_app/features/vehicles/providers/vehicle_repository_provider.dart';

final vehiclesNotifierProvider =
    StateNotifierProvider<VehicleListNotifier, VehicleListState>((ref) {
  final interactor = ref.watch(vehicleInteractorProvider);

  return VehicleListNotifier(interactor);
});
